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

	max_concurrent_connections: INTEGER
			-- The connector's pool size (processors under SCOOP, threads otherwise); 0 = EWF's default.

	is_verbose: BOOLEAN

feature -- Configuration

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
