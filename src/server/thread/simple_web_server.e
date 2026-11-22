note
	description: "[
		Simple HTTP server with clean routing API.

		Example usage:
			create server.make (8080)
			server.on_get ("/", agent handle_root)
			server.on_get ("/api/users", agent handle_users)
			server.on_get ("/api/users/{id}", agent handle_user)
			server.on_post ("/api/users", agent create_user)
			server.start
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_SERVER

inherit
	WSF_DEFAULT_SERVICE [SIMPLE_WEB_SERVER_EXECUTION]
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	make (a_port: INTEGER)
			-- Create server listening on `a_port'.
		require
			valid_port: a_port > 0 and a_port < 65536
		do
			port := a_port
			initialize
			set_service_option ("port", a_port)
		ensure
			port_set: port = a_port
		end

	initialize
			-- Initialize server options.
		do
			Precursor
		end

feature -- Access

	port: INTEGER
			-- Port number server listens on.

feature -- Route Registration

	on_get (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register GET handler for `a_pattern'.
		require
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		do
			add_route ("GET", a_pattern, a_handler)
		end

	on_post (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register POST handler for `a_pattern'.
		require
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		do
			add_route ("POST", a_pattern, a_handler)
		end

	on_put (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register PUT handler for `a_pattern'.
		require
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		do
			add_route ("PUT", a_pattern, a_handler)
		end

	on_delete (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register DELETE handler for `a_pattern'.
		require
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		do
			add_route ("DELETE", a_pattern, a_handler)
		end

	on_patch (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register PATCH handler for `a_pattern'.
		require
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		do
			add_route ("PATCH", a_pattern, a_handler)
		end

	on (a_method, a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register handler for any HTTP method.
		require
			method_attached: a_method /= Void
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		do
			add_route (a_method, a_pattern, a_handler)
		end

feature -- Middleware

	use_middleware (a_middleware: SIMPLE_WEB_MIDDLEWARE)
			-- Add middleware to the processing pipeline.
			-- Middleware runs in registration order before route handlers.
		require
			middleware_attached: a_middleware /= Void
		do
			router.add_middleware (a_middleware)
		end

	use_logging
			-- Add logging middleware (convenience method).
		do
			use_middleware (create {SIMPLE_WEB_LOGGING_MIDDLEWARE}.make)
		end

	use_cors
			-- Add CORS middleware allowing all origins (convenience method).
		do
			use_middleware (create {SIMPLE_WEB_CORS_MIDDLEWARE}.make)
		end

	use_cors_for (a_origins: ARRAY [STRING])
			-- Add CORS middleware for specific origins.
		require
			origins_attached: a_origins /= Void
			origins_not_empty: a_origins.count > 0
		do
			use_middleware (create {SIMPLE_WEB_CORS_MIDDLEWARE}.make_with_origins (a_origins))
		end

feature -- Server Control

	start
			-- Start the server (blocking).
		do
			print ("Starting server on port " + port.out + "...%N")
			launch (service_options)
		end

	set_verbose (a_verbose: BOOLEAN)
			-- Set verbose mode for debugging.
		do
			set_service_option ("verbose", a_verbose)
		end

	set_bind_address (a_host: separate READABLE_STRING_8)
			-- Listen on `a_host' and on nothing else. Without this call EWF's
			-- connector binds every interface (0.0.0.0). Same mechanism as
			-- SIMPLE_WEB_HANDLER_SERVER.set_bind_address: EWF's "server_name"
			-- option, which HTTPD_SERVER_I resolves and binds alone.
		require
			host_given: not a_host.is_empty
		do
			create bind_address.make_from_separate (a_host)
			set_service_option ("server_name", bind_address)
		ensure
			set: attached bind_address as al_address and then al_address.same_string (create {STRING_8}.make_from_separate (a_host))
		end

	bind_address: detachable IMMUTABLE_STRING_8
			-- The one address `start' listens on; Void means every interface.

feature {NONE} -- Implementation

	router: SIMPLE_WEB_SERVER_ROUTER
			-- Shared router singleton (process-wide).
		once ("PROCESS")
			create Result
		ensure
			result_attached: Result /= Void
		end

	add_route (a_method, a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Add route to router.
		require
			method_attached: a_method /= Void
			pattern_attached: a_pattern /= Void
			handler_attached: a_handler /= Void
		local
			l_route: SIMPLE_WEB_SERVER_ROUTE
		do
			create l_route.make (a_method, a_pattern, a_handler)
			router.add_route (l_route)
			print ("  Registered: " + a_method + " " + a_pattern + " (total: " + router.routes.count.out + ")%N")
		end

invariant
	port_valid: port > 0 and port < 65536

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"

end
