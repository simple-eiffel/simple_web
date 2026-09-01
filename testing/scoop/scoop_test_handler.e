note
	description: "[
		The request handler of the SCOOP proof: created per request on a
		request processor. /hello answers with a value the root put into the
		shared settings before the server started; /slow takes two seconds,
		so two of them show whether the connector's pool really runs
		requests concurrently.
	]"
	author: "Larry Rix"

class
	SCOOP_TEST_HANDLER

inherit
	SIMPLE_WEB_REQUEST_HANDLER

	SIMPLE_WEB_SHARED

create
	make

feature {NONE} -- Setup

	setup_routes
		do
			routes.on_get ("/hello", agent hello)
			routes.on_get ("/slow", agent slow)
			routes.on_get ("/peer", agent peer)
			routes.on_get ("/stream", agent stream)
		end

feature {NONE} -- Handlers

	hello (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
		do
			if attached shared_item ("greeting") as l_greeting then
				a_response.send_text (l_greeting)
			else
				a_response.send_error (500, "no greeting in the shared settings")
			end
		end

	slow (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
		local
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			l_env.sleep (2_000_000_000)
			a_response.send_text ("slow done")
		end

	peer (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
			-- The connection's peer address, end to end over the real socket.
		do
			a_response.send_text (a_request.remote_address)
		end

	stream (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
			-- A streamed head plus two chunks over the real socket.
		do
			a_response.send_stream_head (200, "text/event-stream")
			a_response.send_chunk (": stream-preamble%N%N")
			a_response.send_chunk ("id: 1%Nevent: message%Ndata: {%"n%":1}%N%N")
		end

end
