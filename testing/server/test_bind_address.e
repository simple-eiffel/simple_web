note
	description: "[
		Vector tests for SIMPLE_WEB_HANDLER_SERVER.set_bind_address.

		What is proved here is the one thing that was missing before: the
		address a caller states really reaches the CONNECTOR. EWF's standalone
		launcher reads the service option "server_name"
		(WSF_STANDALONE_SERVICE_LAUNCHER, which passes it to
		HTTPD_CONFIGURATION.set_http_server_name), and HTTPD_SERVER_I then
		binds that address alone instead of every interface. So the option
		table is the seam, and these tests read it back through
		`service_options' - the very table `start' hands to `launch'.

		The default is proved too, and it is the honest half: a server built
		with `make' alone names no address, so the connector calls
		`make_server_by_port' and listens on 0.0.0.0.

		The end-to-end proof over a real socket - a listener whose LocalAddress
		is 127.0.0.1 and not 0.0.0.0, and a refused connection on the machine's
		LAN address - lives in the consuming application's assault
		(simple_chat, BIND_ASSAULT), because that is where a real server exe
		can be booted and killed.
	]"
	author: "Larry Rix"

class
	TEST_BIND_ADDRESS

inherit
	TEST_SET_BASE

feature -- The address reaches the connector

	test_bind_address_is_handed_to_the_connector
			-- `set_bind_address' records the address AND puts it in the option
			-- table under the name EWF's standalone launcher reads.
		note
			testing: "covers/{SIMPLE_WEB_HANDLER_SERVER}.set_bind_address"
		local
			l_server: SIMPLE_WEB_HANDLER_SERVER [BIND_TEST_HANDLER]
		do
			create l_server.make (18099)
			l_server.set_bind_address ("127.0.0.1")
			assert ("the address is remembered", attached l_server.bind_address as al_address and then al_address.same_string ("127.0.0.1"))
			assert ("the option table exists", attached l_server.service_options)
			assert ("server_name carries the address",
				attached l_server.service_options as al_options and then
				attached {READABLE_STRING_GENERAL} al_options.option ("server_name") as al_name and then
				al_name.to_string_8.same_string ("127.0.0.1"))
		end

	test_no_bind_address_leaves_every_interface
			-- `make' alone names no address, so the connector binds 0.0.0.0.
			-- The library's default, stated rather than assumed.
		note
			testing: "covers/{SIMPLE_WEB_HANDLER_SERVER}.bind_address"
		local
			l_server: SIMPLE_WEB_HANDLER_SERVER [BIND_TEST_HANDLER]
		do
			create l_server.make (18099)
			assert ("no address is remembered", l_server.bind_address = Void)
			assert ("and none is offered to the connector",
				not attached l_server.service_options as al_options or else al_options.option ("server_name") = Void)
		end

	test_the_port_option_still_stands_beside_the_address
			-- Naming an address does not disturb what `make' and
			-- `set_max_concurrent_connections' already put in the table.
		note
			testing: "covers/{SIMPLE_WEB_HANDLER_SERVER}.set_bind_address"
		local
			l_server: SIMPLE_WEB_HANDLER_SERVER [BIND_TEST_HANDLER]
		do
			create l_server.make (18099)
			l_server.set_max_concurrent_connections (64)
			l_server.set_bind_address ("127.0.0.1")
			assert ("port unchanged", l_server.port = 18099)
			assert ("pool unchanged", l_server.max_concurrent_connections = 64)
			assert ("port is still in the table",
				attached l_server.service_options as al_options and then
				al_options.option_integer_value ("port", 0) = 18099)
			assert ("the pool is still in the table",
				attached l_server.service_options as al_options and then
				al_options.option_integer_value ("max_concurrent_connections", 0) = 64)
			assert ("and the address is there too",
				attached l_server.service_options as al_options and then
				attached {READABLE_STRING_GENERAL} al_options.option ("server_name") as al_name and then
				al_name.to_string_8.same_string ("127.0.0.1"))
		end

	test_a_later_address_replaces_the_earlier_one
			-- One server has one bind address; the last call wins, in the
			-- attribute and in the table alike.
		note
			testing: "covers/{SIMPLE_WEB_HANDLER_SERVER}.set_bind_address"
		local
			l_server: SIMPLE_WEB_HANDLER_SERVER [BIND_TEST_HANDLER]
		do
			create l_server.make (18099)
			l_server.set_bind_address ("0.0.0.0")
			l_server.set_bind_address ("127.0.0.1")
			assert ("the last address is remembered", attached l_server.bind_address as al_address and then al_address.same_string ("127.0.0.1"))
			assert ("and it is the one in the table",
				attached l_server.service_options as al_options and then
				attached {READABLE_STRING_GENERAL} al_options.option ("server_name") as al_name and then
				al_name.to_string_8.same_string ("127.0.0.1"))
		end

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
