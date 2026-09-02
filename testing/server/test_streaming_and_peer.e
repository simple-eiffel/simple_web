note
	description: "[
		Tests for the streaming response API and the request's peer address
		(SIMPLE_WEB_SERVER_RESPONSE.send_stream_head / send_chunk,
		SIMPLE_WEB_SERVER_REQUEST.remote_address), over the mock modes.
		The real-socket proof lives in the SCOOP suite (/peer and /stream).
	]"
	author: "Larry Rix"

class
	TEST_STREAMING_AND_PEER

inherit
	TEST_SET_BASE

feature -- Peer address

	test_remote_address_empty_by_default
			-- A mock request with no peer set reports an empty (never Void) address.
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("GET", "/peer")
			assert ("empty when unknown", l_request.remote_address.is_empty)
		end

	test_remote_address_reports_mock_peer
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("GET", "/peer")
			l_request.set_mock_remote_address ("203.0.113.9")
			assert ("peer reported", l_request.remote_address.same_string ("203.0.113.9"))
		end

feature -- Streaming response

	test_stream_head_sets_status_type_and_streaming
		local
			l_response: SIMPLE_WEB_SERVER_RESPONSE
		do
			create l_response.make_mock
			assert ("not streaming before head", not l_response.is_streaming)
			l_response.send_stream_head (200, "text/event-stream")
			assert ("streaming", l_response.is_streaming)
			assert ("status", l_response.status_code = 200)
			assert ("content type recorded", attached l_response.mock_headers.item ("Content-Type") as al_type and then al_type.same_string ("text/event-stream"))
			assert ("no-cache recorded", attached l_response.mock_headers.item ("Cache-Control") as al_cache and then al_cache.same_string ("no-cache"))
			assert ("connection close recorded", attached l_response.mock_headers.item ("Connection") as al_conn and then al_conn.same_string ("close"))
		end

	test_chunks_append_in_order_and_stream_stays_open
		local
			l_response: SIMPLE_WEB_SERVER_RESPONSE
		do
			create l_response.make_mock
			l_response.send_stream_head (200, "text/event-stream")
			l_response.send_chunk (": hello%N%N")
			l_response.send_chunk ("id: 1%Nevent: message%Ndata: {}%N%N")
			assert ("both chunks in order", l_response.mock_body.same_string (": hello%N%Nid: 1%Nevent: message%Ndata: {}%N%N"))
			assert ("still streaming", l_response.is_streaming)
		end

	test_empty_chunk_changes_nothing
		local
			l_response: SIMPLE_WEB_SERVER_RESPONSE
		do
			create l_response.make_mock
			l_response.send_stream_head (200, "application/x-ndjson")
			l_response.send_chunk ("")
			assert ("nothing recorded", l_response.mock_body.is_empty)
			assert ("still streaming", l_response.is_streaming)
		end

end
