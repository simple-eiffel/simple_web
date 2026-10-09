note
	description: "[
		Hand-off spike: serves ONE connection on its own processor. It receives
		only expanded values (the raw socket handle and the peer port), adopts
		the handle as a simple_net CONNECTION here, reads one request, answers,
		and closes. /slow sleeps 2 s first.
	]"

class
	HO_WORKER

feature -- Basic operations

	serve (a_handle: POINTER; a_port: INTEGER)
			-- Adopt `a_handle', answer one HTTP request, close.
		local
			l_conn: CONNECTION
			l_request, l_path, l_body: STRING
			l_sent: BOOLEAN
			l_first, l_second: INTEGER
		do
			create l_conn.make_accepted (a_handle, create {ADDRESS}.make_for_host_port ("127.0.0.1", a_port), 10.0)
			create l_request.make (512)
			from
			until
				l_conn.is_closed or l_conn.is_error or l_conn.is_at_eof
				or l_request.has_substring ("%R%N%R%N") or l_request.count > 8192
			loop
				across l_conn.receive (4096) as ic loop
					l_request.append_character (ic.to_character_8)
				end
			end
			l_path := "/"
			l_first := l_request.index_of (' ', 1)
			if l_first > 0 then
				l_second := l_request.index_of (' ', l_first + 1)
				if l_second > l_first then
					l_path := l_request.substring (l_first + 1, l_second - 1)
				end
			end
			if l_path.same_string ("/slow") then
				(create {EXECUTION_ENVIRONMENT}).sleep (2_000_000_000)
				l_body := "slow"
			elseif l_path.same_string ("/fast") then
				l_body := "fast"
			else
				l_body := "not found"
			end
			if not l_conn.is_closed and not l_conn.is_error then
				l_sent := l_conn.send_string ("HTTP/1.1 200 OK%R%NContent-Type: text/plain%R%NContent-Length: "
					+ l_body.count.out + "%R%NConnection: close%R%N%R%N" + l_body)
			end
			l_conn.close
		end

end
