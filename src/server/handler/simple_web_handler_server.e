note
	description: "[
		An HTTP server whose request handling is a CLASS the application
		supplies (H), instantiated per request on the request's processor.
		Works under SCOOP and under threads alike, and is the only simple_web
		server available in a SCOOP build: SIMPLE_WEB_SERVER's agent
		registration keeps handler agents on the root processor, which SCOOP
		cannot call while the root runs the program.

		Example:
			class HELLO_HANDLER inherit SIMPLE_WEB_REQUEST_HANDLER create make
			feature {NONE} setup_routes do routes.on_get ("/", agent hello) end
			                hello (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE) do res.send_text ("hi") end
			end
			...
			create server.make (8080)
			server.start          -- blocking, on the caller's processor
		Under SCOOP, create the server as `separate' and call `start' through a
		separate command so the root keeps running (see SCOOP_TEST_APP).

		WHICH INTERFACE IT LISTENS ON. `make' alone binds EVERY interface on
		the machine - 0.0.0.0 - because EWF's standalone connector creates its
		listening socket with `make_server_by_port' when no address is
		configured (HTTPD_SERVER_I.new_listening_socket) and with
		`make_server_by_address_and_port' when one is. That default is this
		library's default too, and it is a deliberate choice rather than an
		accident: a server that means to be reachable from the network needs
		nothing extra. A server that means to be private must SAY so:

			create server.make (8080)
			server.set_bind_address ("127.0.0.1")   -- this machine only
			server.start
	]"
	author: "Larry Rix"

class
	SIMPLE_WEB_HANDLER_SERVER [H -> SIMPLE_WEB_REQUEST_HANDLER create make end]

inherit
	WSF_DEFAULT_SERVICE [SIMPLE_WEB_HANDLER_EXECUTION [H]]

create
	make

feature {NONE} -- Initialization

	make (a_port: INTEGER)
			-- A server that will listen on `a_port'.
		require
			valid_port: a_port > 0 and a_port < 65536
		do
			port := a_port
			initialize
			set_service_option ("port", a_port)
		ensure
			port_set: port = a_port
			default_pool: max_concurrent_connections = 0
		end

feature -- Access

	port: INTEGER
			-- The listening port.

	bind_address: detachable IMMUTABLE_STRING_8
			-- The one address `start' will listen on; Void when the server
			-- listens on EVERY interface (0.0.0.0), which is what `make'
			-- alone leaves behind. See the class note.

	max_concurrent_connections: INTEGER
			-- The connector's pool size (processors under SCOOP, threads otherwise); 0 = EWF's default.

	is_verbose: BOOLEAN

feature -- Configuration

	set_bind_address (a_host: READABLE_STRING_8)
			-- Listen on `a_host' and on nothing else.
			--
			-- Without this call the connector binds every interface on the
			-- machine, so an application that means "this machine only" must
			-- name the loopback address here: a value held in the
			-- application's own configuration is not a bound socket until it
			-- reaches the transport, and a contract on that value proves
			-- nothing about the listener.
			--
			-- `a_host' travels as EWF's "server_name" service option, which
			-- WSF_STANDALONE_SERVICE_LAUNCHER hands to
			-- HTTPD_CONFIGURATION.set_http_server_name; HTTPD_SERVER_I then
			-- resolves it through INET_ADDRESS_FACTORY and binds that address
			-- alone. A name the machine cannot resolve is therefore a bind
			-- failure at `start', not an error here.
		require
			host_given: not a_host.is_empty
		do
			create bind_address.make_from_string (a_host)
			set_service_option ("server_name", bind_address)
		ensure
			set: attached bind_address as al_address and then al_address.same_string (a_host)
			handed_to_the_connector: attached service_options as al_options and then al_options.option ("server_name") = bind_address
		end

	set_max_concurrent_connections (a_count: INTEGER)
			-- Serve up to `a_count' connections at once. Size it for the
			-- connections that stay open (long-polls, streams), not for the rate.
		require
			positive: a_count > 0
		do
			max_concurrent_connections := a_count
			set_service_option ("max_concurrent_connections", a_count)
		ensure
			set: max_concurrent_connections = a_count
		end

	set_verbose (a_verbose: BOOLEAN)
		do
			is_verbose := a_verbose
			set_service_option ("verbose", a_verbose)
		ensure
			set: is_verbose = a_verbose
		end

feature -- Server Control

	start
			-- Listen and serve until the process ends (blocking on the caller's processor).
			-- On `bind_address' alone when one was set; on every interface otherwise.
		do
			launch (service_options)
		end

invariant
	port_valid: port > 0 and port < 65536
	pool_non_negative: max_concurrent_connections >= 0

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
