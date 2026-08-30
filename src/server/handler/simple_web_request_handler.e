note
	description: "[
		What an application supplies to SIMPLE_WEB_HANDLER_SERVER: a class,
		not an object. One instance is created per request on the processor
		that serves the request; `make' builds that request's route table
		by calling `setup_routes', and `handle' dispatches. Nothing the
		application registers ever crosses a processor boundary, which is
		the whole reason this exists: under SCOOP an agent created on the
		root processor cannot be called from a request processor while the
		root is busy running the program - and it always is.

		Process-wide state reaches a handler through SIMPLE_WEB_SHARED
		(strings the root put there before starting) or through the
		application's own once ("PROCESS") functions of separate type.
	]"
	author: "Larry Rix"

deferred class
	SIMPLE_WEB_REQUEST_HANDLER

feature {NONE} -- Initialization

	make
			-- Build this request's route table.
		do
			create routes.make
			setup_routes
		ensure
			routes_attached: routes /= Void
		end

feature -- Access

	routes: SIMPLE_WEB_ROUTES
			-- This request's routes and middleware.

feature {NONE} -- Setup

	setup_routes
			-- Register routes and middleware on `routes' (agents on Current are fine here).
		deferred
		end

feature -- Handling

	handle (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
			-- Answer `a_request' through `routes'.
		do
			routes.dispatch (a_request, a_response)
		ensure
			dispatched: routes.dispatched = old routes.dispatched + 1
		end

invariant
	routes_attached: routes /= Void

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
