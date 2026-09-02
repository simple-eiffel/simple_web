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
			routes.on_get ("/headers", agent headers)
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

	headers (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
			-- Echo what `header' can actually see of a real request, over a real
			-- connector. The hyphenated names are the point: RFC 3875 spells
			-- `X-File-Name' as the meta variable HTTP_X_FILE_NAME, and until
			-- 0.3.1 the accessor never made that substitution, so every one of
			-- these but Authorization came back Void.
		local
			l_out: STRING_8
		do
			create l_out.make (256)
			l_out.append ("file=[" + shown (a_request.header ("X-File-Name")) + "]%N")
			l_out.append ("lower=[" + shown (a_request.header ("x-file-name")) + "]%N")
			l_out.append ("under=[" + shown (a_request.header ("X_File_Name")) + "]%N")
			l_out.append ("caption=[" + shown (a_request.header ("X-Caption")) + "]%N")
			l_out.append ("auth=[" + shown (a_request.header ("Authorization")) + "]%N")
			l_out.append ("ctype=[" + shown (a_request.header ("Content-Type")) + "]%N")
			l_out.append ("clen=[" + shown (a_request.header ("Content-Length")) + "]%N")
			l_out.append ("ctype_accessor=[" + shown (a_request.content_type) + "]%N")
			l_out.append ("meta=[" + a_request.meta_variable_name ("X-File-Name") + "]%N")
			a_response.send_text (l_out)
		end

feature {NONE} -- Implementation

	shown (a_value: detachable STRING_8): STRING_8
			-- `a_value', or the word "VOID" when the header could not be read.
		do
			if attached a_value as al_value then
				Result := al_value
			else
				Result := "VOID"
			end
		ensure
			result_attached: Result /= Void
		end

end
