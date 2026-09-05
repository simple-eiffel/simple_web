note
	description: "[
		The smallest possible SIMPLE_WEB_REQUEST_HANDLER: enough to give
		TEST_BIND_ADDRESS a concrete actual generic parameter for
		SIMPLE_WEB_HANDLER_SERVER [H]. No socket is ever opened in those
		tests - they read the service options the server built - so this
		handler answers one route and is never dispatched.
	]"
	author: "Larry Rix"

class
	BIND_TEST_HANDLER

inherit
	SIMPLE_WEB_REQUEST_HANDLER

create
	make

feature {NONE} -- Setup

	setup_routes
		do
			routes.on_get ("/", agent root)
		end

feature {NONE} -- Handlers

	root (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
		do
			a_response.send_text ("ok")
		end

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
