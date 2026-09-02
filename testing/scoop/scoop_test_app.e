note
	description: "[
		SCOOP-mode proof for simple_web. A SIMPLE_WEB_HANDLER_SERVER is
		created `separate' and started through a separate command, so it
		listens on its own processor while the root goes on; the root then
		speaks HTTP to it over a plain socket and checks:
		  1. a value put into SIMPLE_WEB_SHARED by the root reaches a
		     handler created on a request processor (200 + the greeting);
		  2. an unknown path answers 404;
		  3. two two-second requests overlap - the connector's SCOOP pool
		     serves them concurrently (well under four seconds in total).
		Exit status: the root returns, which ends the process and with it
		the server's processor.
	]"
	author: "Larry Rix"

class
	SCOOP_TEST_APP

inherit
	SIMPLE_WEB_SHARED

create
	make

feature {NONE} -- Initialization

	make
		local
			l_server: separate SIMPLE_WEB_HANDLER_SERVER [SCOOP_TEST_HANDLER]
			l_body: STRING_8
			l_started, l_elapsed: INTEGER
		do
			print ("simple_web SCOOP-mode proof (port " + Port.out + ")%N%N")
			shared_put ("greeting", "hello from scoop")
			create l_server.make (Port)
			start_server (l_server)
			if wait_until_listening then
				l_body := get ("/hello")
				check_true ("200 with the greeting the root shared", l_body.has_substring ("200") and l_body.has_substring ("hello from scoop"))
				l_body := get ("/nowhere")
				check_true ("404 for an unknown path", l_body.has_substring ("404"))
				l_body := get ("/peer")
				check_true ("peer address is the loopback client", l_body.has_substring ("127.0.0.1"))
				l_body := get ("/stream")
				check_true ("streamed head and both chunks arrive", l_body.has_substring ("text/event-stream")
					and l_body.has_substring (": stream-preamble") and l_body.has_substring ("data: {%"n%":1}"))
				check_hyphenated_headers
				l_started := seconds_of_day
				two_slow_requests
				l_elapsed := seconds_of_day - l_started
				check_true ("two 2 s requests overlap (took " + l_elapsed.out + " s; serial would be >= 4)", l_elapsed >= 0 and l_elapsed < 4)
			else
				check_true ("server listens within 10 s", False)
			end
			print ("%NResults: " + passed.out + " passed, " + failed.out + " failed%N")
			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
			io.output.flush
			finish
		end

	finish
			-- End the process with a status a caller can read.
			-- The root returning is not enough: the server runs on its own
			-- processor and never stops listening, so a SCOOP process whose
			-- root has returned keeps running (and, with a redirected stdout,
			-- keeps the whole report sitting unflushed in the buffer). Dying
			-- deliberately is what makes this suite runnable unattended.
			--
			-- Not {EXCEPTIONS}.die: `esdie' unwinds the Eiffel runtime, and
			-- with the server's processor still inside its accept loop that
			-- unwinding segfaults (the report is already printed by then, so
			-- the crash costs no evidence - only the exit status, which is
			-- exactly what a caller needs). `_exit' ends the process where it
			-- stands, after `io.output.flush' has already emptied the buffer.
		do
			if failed > 0 then
				c_exit (1)
			else
				c_exit (0)
			end
		end

	c_exit (a_code: INTEGER)
			-- End the process at once with status `a_code'.
		external
			"C inline use <stdlib.h>"
		alias
			"_exit((int) $a_code);"
		end

feature {NONE} -- The server's processor

	start_server (a_server: separate SIMPLE_WEB_HANDLER_SERVER [SCOOP_TEST_HANDLER])
			-- Asynchronous: `start' runs on the server's processor; this returns at once.
		do
			a_server.set_max_concurrent_connections (4)
			a_server.start
		end

feature {NONE} -- HTTP over a socket

	Port: INTEGER = 18077

	wait_until_listening: BOOLEAN
			-- Up to ~10 s of connection attempts, 100 ms apart.
		local
			i: INTEGER
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			from
				i := 1
			until
				i > 100 or Result
			loop
				if attached connected_socket as l_socket then
					Result := True
					l_socket.close
				else
					l_env.sleep (100_000_000)
				end
				i := i + 1
			end
		end

	connected_socket: detachable NETWORK_STREAM_SOCKET
			-- A socket connected to the server, or Void when it refuses.
		local
			l_socket: NETWORK_STREAM_SOCKET
			l_failed: BOOLEAN
		do
			if not l_failed then
				create l_socket.make_client_by_port (Port, "127.0.0.1")
				l_socket.connect
				Result := l_socket
			end
		rescue
			l_failed := True
			retry
		end

	get (a_path: STRING_8): STRING_8
			-- The raw HTTP/1.0 response for GET `a_path' (status line included).
		do
			if attached connected_socket as l_socket then
				send_get (l_socket, a_path)
				Result := read_all (l_socket)
				l_socket.close
			else
				Result := "(no connection)"
			end
		end

	send_get (a_socket: NETWORK_STREAM_SOCKET; a_path: STRING_8)
		do
			a_socket.put_string ("GET " + a_path + " HTTP/1.0%R%NHost: 127.0.0.1%R%NConnection: close%R%N%R%N")
		end

	get_with_extra_headers (a_path, a_extra: STRING_8): STRING_8
			-- The raw response for GET `a_path' with `a_extra' (already
			-- CRLF-terminated header lines) added to the request head.
		do
			if attached connected_socket as l_socket then
				l_socket.put_string ("GET " + a_path + " HTTP/1.0%R%NHost: 127.0.0.1%R%NConnection: close%R%N" + a_extra + "%R%N")
				Result := read_all (l_socket)
				l_socket.close
			else
				Result := "(no connection)"
			end
		end

	check_hyphenated_headers
			-- A real request carrying hyphenated headers, read back through
			-- SIMPLE_WEB_SERVER_REQUEST.header over the real connector. This is
			-- the 0.3.1 regression: `X-File-Name' has to reach the handler.
		local
			l_body: STRING_8
		do
			l_body := get_with_extra_headers ("/headers",
				"X-File-Name: caption.png%R%N" +
				"X-Caption: hello%R%N" +
				"Authorization: Bearer scoop-token%R%N" +
				"Content-Type: text/plain%R%N" +
				"Content-Length: 0%R%N")
			check_true ("X-File-Name reaches the handler", l_body.has_substring ("file=[caption.png]"))
			check_true ("the same header answers a lower-case name", l_body.has_substring ("lower=[caption.png]"))
			check_true ("the same header answers its meta spelling", l_body.has_substring ("under=[caption.png]"))
			check_true ("a second hyphenated header reaches the handler", l_body.has_substring ("caption=[hello]"))
			check_true ("Authorization still reaches the handler", l_body.has_substring ("auth=[Bearer scoop-token]"))
			check_true ("Content-Type reaches `header' (CGI drops the HTTP_ prefix)", l_body.has_substring ("ctype=[text/plain]"))
			check_true ("Content-Length reaches `header'", l_body.has_substring ("clen=[0]"))
			check_true ("the content_type accessor agrees", l_body.has_substring ("ctype_accessor=[text/plain]"))
			check_true ("the meta name is the one CGI spells", l_body.has_substring ("meta=[HTTP_X_FILE_NAME]"))
		end

	read_all (a_socket: NETWORK_STREAM_SOCKET): STRING_8
			-- Everything the server sends before closing.
		local
			i: INTEGER
			l_failed: BOOLEAN
		do
			create Result.make (1024)
			if not l_failed then
				from
					i := 1
				until
					i > 500
				loop
					a_socket.read_stream (4096)
					if a_socket.last_string.is_empty then
						i := 501
					else
						Result.append (a_socket.last_string)
						i := i + 1
					end
				end
			end
		rescue
			l_failed := True
			retry
		end

	two_slow_requests
			-- Open two connections, ask both for /slow, then read both.
		local
			l_a, l_b: detachable NETWORK_STREAM_SOCKET
			l_body_a, l_body_b: STRING_8
		do
			l_a := connected_socket
			l_b := connected_socket
			if attached l_a as a and then attached l_b as b then
				send_get (a, "/slow")
				send_get (b, "/slow")
				l_body_a := read_all (a)
				l_body_b := read_all (b)
				a.close
				b.close
				check_true ("both slow requests answered", l_body_a.has_substring ("slow done") and l_body_b.has_substring ("slow done"))
			else
				check_true ("two connections open at once", False)
			end
		end

	seconds_of_day: INTEGER
		local
			l_time: TIME
		do
			create l_time.make_now
			Result := l_time.hour * 3600 + l_time.minute * 60 + l_time.second
		end

feature {NONE} -- Reporting

	passed, failed: INTEGER

	check_true (a_name: STRING_8; a_condition: BOOLEAN)
		do
			if a_condition then
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			else
				print ("  FAIL: " + a_name + "%N")
				failed := failed + 1
			end
			io.output.flush
		end

end
