note
	description: "[
		Hybrid HTTP client that works around curl_http_client library issues.
		Uses a curl process for POST/PUT (broken in libcurl for localhost).
		Uses libcurl for GET/DELETE (works fine).

		SAFETY (2026-11-22). simple_process starts curl directly, with no
		shell, so the danger is argument injection: a URL or header holding a
		space or a quote used to become extra curl options (-o writes a file,
		--upload-file sends one). Now:
		  - the URL must pass `is_safe_url' and travels as `--url "<url>"',
		    so it can never be read as an option;
		  - header names and values must pass `is_safe_header';
		  - every argument is quoted by the Windows rules (`quoted_argument'),
		    which simple_process also uses to split command lines elsewhere;
		  - the body goes to curl on stdin (`--data-binary @-'), byte for
		    byte, so it is never on the command line at all (the old escaping
		    also doubled every backslash, corrupting JSON escapes like \n).
		An unsafe request is refused at run time in every build, with status
		400 and no process started.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_HYBRID_CLIENT

inherit
	SIMPLE_WEB_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize hybrid client
		do
			create libcurl_client.make
		end

feature -- Basic Operations

	get (a_url: STRING): SIMPLE_WEB_RESPONSE
			-- Execute GET request (uses libcurl - works fine)
		require
			url_not_empty: not a_url.is_empty
		do
			Result := libcurl_client.get (a_url)
		ensure
			result_attached: Result /= Void
		end

	post_json (a_url, a_json_body: STRING): SIMPLE_WEB_RESPONSE
			-- Execute POST with JSON body (uses a curl process)
		require
			url_not_empty: not a_url.is_empty
			body_attached: a_json_body /= Void
		do
			Result := execute_curl_process ("POST", a_url, a_json_body, Void)
		ensure
			result_attached: Result /= Void
			refused_when_unsafe: not is_safe_url (a_url) implies Result.status_code = Status_bad_request
		end

	put_json (a_url, a_json_body: STRING): SIMPLE_WEB_RESPONSE
			-- Execute PUT with JSON body (uses a curl process)
		require
			url_not_empty: not a_url.is_empty
			body_attached: a_json_body /= Void
		do
			Result := execute_curl_process ("PUT", a_url, a_json_body, Void)
		ensure
			result_attached: Result /= Void
			refused_when_unsafe: not is_safe_url (a_url) implies Result.status_code = Status_bad_request
		end

	delete (a_url: STRING): SIMPLE_WEB_RESPONSE
			-- Execute DELETE request (uses libcurl)
		require
			url_not_empty: not a_url.is_empty
		do
			Result := libcurl_client.delete (a_url)
		ensure
			result_attached: Result /= Void
		end

feature -- Advanced Operations

	post_json_with_headers (a_url, a_json_body: STRING; a_headers: STRING_TABLE [STRING]): SIMPLE_WEB_RESPONSE
			-- Execute POST with JSON body and custom headers
		require
			url_not_empty: not a_url.is_empty
			body_attached: a_json_body /= Void
		do
			Result := execute_curl_process ("POST", a_url, a_json_body, a_headers)
		ensure
			result_attached: Result /= Void
			refused_when_unsafe: not (is_safe_url (a_url) and are_safe_headers (a_headers)) implies Result.status_code = Status_bad_request
		end

feature -- Safety

	is_safe_url (a_url: READABLE_STRING_8): BOOLEAN
			-- Is `a_url' an http or https address holding no space, quote,
			-- control character or DEL, so it travels as one curl argument?
		local
			i: INTEGER
			c: CHARACTER_8
		do
			if a_url.starts_with ("http://") or a_url.starts_with ("https://") then
				Result := True
				from i := 1 until not Result or i > a_url.count loop
					c := a_url [i]
					Result := c.natural_32_code > 32 and c.natural_32_code /= 127 and c /= '"'
					i := i + 1
				end
			end
		ensure
			web_scheme: Result implies (a_url.starts_with ("http://") or a_url.starts_with ("https://"))
			one_argument: Result implies not (a_url.has (' ') or a_url.has ('"') or a_url.has ('%T'))
		end

	is_safe_header (a_name, a_value: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_name' a header token (RFC 9110: letters, digits and
			-- !#$%&'*+-.^_`|~) and `a_value' free of CR, LF and NUL, both 8-bit?
		local
			i: INTEGER
			c: CHARACTER_32
		do
			if not a_name.is_empty and a_name.is_valid_as_string_8 and a_value.is_valid_as_string_8 then
				Result := True
				from i := 1 until not Result or i > a_name.count loop
					c := a_name.item (i)
					Result := c.is_alpha_numeric or else Header_token_marks.has (c.to_character_8)
					i := i + 1
				end
				Result := Result and not (a_value.has ('%R') or a_value.has ('%N') or a_value.has ('%U'))
			end
		ensure
			no_line_break: Result implies not (a_value.has ('%R') or a_value.has ('%N'))
		end

	are_safe_headers (a_headers: detachable STRING_TABLE [STRING]): BOOLEAN
			-- Does every entry of `a_headers' (if any) pass `is_safe_header'?
		do
			Result := True
			if attached a_headers as al_headers then
				across al_headers as ic until not Result loop
					Result := is_safe_header (@ic.key, ic)
				end
			end
		end

	quoted_argument (a_text: READABLE_STRING_8): STRING_8
			-- `a_text' as one double-quoted command-line argument by the
			-- Windows rules (CommandLineToArgvW): backslashes are literal
			-- unless they precede a quote, so the backslashes before a quote,
			-- and before the closing quote, are doubled, and each quote is
			-- escaped with one more backslash.
		local
			i, l_backslashes: INTEGER
			c: CHARACTER_8
		do
			create Result.make (a_text.count + 8)
			Result.append_character ('"')
			from i := 1 until i > a_text.count loop
				c := a_text [i]
				if c = '\' then
					l_backslashes := l_backslashes + 1
				elseif c = '"' then
					Result.append (create {STRING_8}.make_filled ('\', l_backslashes * 2 + 1))
					Result.append_character ('"')
					l_backslashes := 0
				else
					Result.append (create {STRING_8}.make_filled ('\', l_backslashes))
					Result.append_character (c)
					l_backslashes := 0
				end
				i := i + 1
			end
			Result.append (create {STRING_8}.make_filled ('\', l_backslashes * 2))
			Result.append_character ('"')
		ensure
			quoted: Result.count >= 2 and Result [1] = '"' and Result [Result.count] = '"'
			plain_text_unchanged: not (a_text.has ('\') or a_text.has ('"')) implies Result.same_string ("%"" + a_text + "%"")
		end

	curl_command (a_method, a_url: READABLE_STRING_8; a_headers: detachable STRING_TABLE [STRING]): STRING_8
			-- The curl command line for `a_method' to `a_url', reading the
			-- body from stdin.
		require
			method_is_token: is_safe_header (a_method, "")
			url_safe: is_safe_url (a_url)
			headers_safe: are_safe_headers (a_headers)
		do
			create Result.make (256)
			Result.append ("curl -s -X ")
			Result.append (quoted_argument (a_method))
			Result.append (" --url ")
			Result.append (quoted_argument (a_url))
			Result.append (" -H ")
			Result.append (quoted_argument ("Content-Type: application/json"))
			if attached a_headers as al_headers then
				across al_headers as ic loop
					Result.append (" -H ")
					Result.append (quoted_argument (@ic.key.to_string_8 + ": " + ic))
				end
			end
			Result.append (" -w ")
			Result.append (quoted_argument (Status_delimiter + "%%{http_code}"))
			Result.append (" --data-binary @-")
		ensure
			url_is_not_an_option: Result.has_substring (" --url " + quoted_argument (a_url))
			body_from_stdin: Result.ends_with (" --data-binary @-")
		end

feature -- Conversion

	output_bytes (a_text: READABLE_STRING_32): STRING_8
			-- The process output as UTF-8 bytes: simple_process (1.1.0) decodes
			-- the child's UTF-8 output, so encode it back for the curl parser.
		do
			Result := {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (a_text)
		end

feature {NONE} -- Implementation

	execute_curl_process (a_method, a_url, a_body: STRING; a_headers: detachable STRING_TABLE [STRING]): SIMPLE_WEB_RESPONSE
			-- Run curl for `a_method' to `a_url' with `a_body' (bytes) on its
			-- stdin; refuse, with no process started, an unsafe URL or header.
		local
			l_process: SIMPLE_PROCESS
		do
			if not is_safe_url (a_url) then
				create Result.make_with_body (Status_bad_request, "Refused: the URL must be http or https with no spaces, quotes or control characters")
			elseif not are_safe_headers (a_headers) then
				create Result.make_with_body (Status_bad_request, "Refused: a header name is not a token, or a header value holds a line break")
			else
				create l_process.make
				l_process.execute_with_input_bytes (curl_command (a_method, a_url, a_headers), a_body)
				if attached l_process.last_output_bytes as al_output then
					Result := parse_curl_output (al_output)
				else
					Result := parse_curl_output ("")
				end
			end
		ensure
			refused_when_unsafe: not (is_safe_url (a_url) and are_safe_headers (a_headers)) implies Result.status_code = Status_bad_request
		end

	parse_curl_output (a_output: STRING): SIMPLE_WEB_RESPONSE
			-- Parse curl output into response object
		local
			l_delimiter_pos: INTEGER
			l_body: STRING
			l_status_str: STRING
			l_status: INTEGER
		do
			l_delimiter_pos := a_output.substring_index (Status_delimiter, 1)

			if l_delimiter_pos > 0 then
				l_body := a_output.substring (1, l_delimiter_pos - 1)
				l_status_str := a_output.substring (l_delimiter_pos + Status_delimiter.count, a_output.count)
				l_status_str.right_adjust
				l_status_str.left_adjust
				if l_status_str.is_integer and then l_status_str.to_integer > 0 then
					l_status := l_status_str.to_integer
				else
					-- curl writes "000" when it gets no HTTP answer at all
					-- (nothing listening, DNS failure, TLS failure).
					l_status := Status_service_unavailable
					if l_body.is_empty then
						l_body := No_answer_message
					end
				end
			else
				-- No delimiter found - assume failure
				l_body := a_output
				l_status := Status_service_unavailable
			end

			create Result.make_with_body (l_status, l_body)
		end

feature {NONE} -- Implementation Attributes

	libcurl_client: SIMPLE_WEB_CLIENT
			-- Libcurl-based client for GET/DELETE

feature {NONE} -- Constants

	Status_delimiter: STRING = "|||HTTP_STATUS|||"
			-- Delimiter between body and status code in curl output

	No_answer_message: STRING = "No HTTP answer: curl could not connect to the server"
			-- Body when curl reports HTTP code 000.

	Header_token_marks: STRING = "!#$%%&'*+-.^_`|~"
			-- The punctuation a header name may hold (RFC 9110 token).

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		Hybrid client working around curl_http_client POST issues
	]"

end
