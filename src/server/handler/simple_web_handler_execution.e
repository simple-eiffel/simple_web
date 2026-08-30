note
	description: "[
		The WSF execution behind SIMPLE_WEB_HANDLER_SERVER: for each request
		EWF creates one of these on the request's processor; it wraps the
		request and response and hands them to a fresh handler of type H,
		created right here so that the handler, its routes and its agents
		all live on this processor.
	]"
	author: "Larry Rix"

class
	SIMPLE_WEB_HANDLER_EXECUTION [H -> SIMPLE_WEB_REQUEST_HANDLER create make end]

inherit
	WSF_EXECUTION

create
	make

feature -- Execution

	execute
			-- Serve the request with a new H.
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
			l_response: SIMPLE_WEB_SERVER_RESPONSE
			l_handler: H
		do
			create l_request.make (request)
			create l_response.make (response)
			create l_handler.make
			l_handler.handle (l_request, l_response)
		end

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
