note
	description: "[
		Vector tests for SIMPLE_WEB_SERVER_REQUEST.header, over the mock mode.

		The header the caller names and the CGI meta variable a connector
		actually fills are spelled differently: RFC 3875 s.4.1.18 upper-cases
		the header name, turns every hyphen into an underscore, and prefixes
		HTTP_ - so `X-File-Name' arrives as HTTP_X_FILE_NAME, and Content-Type
		and Content-Length arrive as CONTENT_TYPE and CONTENT_LENGTH with no
		prefix at all. Before 0.3.1 the accessor upper-cased the name and left
		the hyphens alone, so no hyphenated header could ever be read.

		The end-to-end proof over a real socket and a real connector lives in
		the SCOOP suite (/headers).
	]"
	author: "Larry Rix"

class
	TEST_REQUEST_HEADERS

inherit
	TEST_SET_BASE

feature -- Header lookup

	test_hyphenated_header_reads_back
			-- The regression: a hyphenated header answers its own name.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.header"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("POST", "/upload")
			l_request.set_mock_header ("X-File-Name", "caption.png")
			l_request.set_mock_header ("X-Caption", "hello")
			assert ("X-File-Name answers", attached l_request.header ("X-File-Name") as al_name and then al_name.same_string ("caption.png"))
			assert ("X-Caption answers", attached l_request.header ("X-Caption") as al_cap and then al_cap.same_string ("hello"))
		end

	test_header_name_spellings_agree
			-- Hyphen, underscore and case are the same name: all four spellings
			-- reach the one header the client sent as `X-File-Name'.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.header"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("POST", "/upload")
			l_request.set_mock_header ("X-File-Name", "caption.png")
			assert ("as sent", attached l_request.header ("X-File-Name") as al_a and then al_a.same_string ("caption.png"))
			assert ("lower case", attached l_request.header ("x-file-name") as al_b and then al_b.same_string ("caption.png"))
			assert ("upper case", attached l_request.header ("X-FILE-NAME") as al_c and then al_c.same_string ("caption.png"))
			assert ("meta spelling", attached l_request.header ("X_File_Name") as al_d and then al_d.same_string ("caption.png"))
		end

	test_underscore_name_reads_hyphenated_header
			-- The workaround simple_chat had to carry (asking for "X_File_Name"
			-- because "X-File-Name" could not match) keeps working.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.header"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("POST", "/upload")
			l_request.set_mock_header ("X_File_Name", "caption.png")
			assert ("underscore in, hyphen out", attached l_request.header ("X-File-Name") as al_v and then al_v.same_string ("caption.png"))
		end

	test_authorization_unchanged
			-- The one header that ever worked still works, in both cases.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.header"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("GET", "/messages")
			l_request.set_mock_header ("Authorization", "Bearer deadbeef")
			assert ("as sent", attached l_request.header ("Authorization") as al_a and then al_a.same_string ("Bearer deadbeef"))
			assert ("lower case", attached l_request.header ("authorization") as al_b and then al_b.same_string ("Bearer deadbeef"))
		end

	test_absent_header_is_void
			-- A header the request does not carry answers Void, not an empty string.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.header"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("GET", "/messages")
			l_request.set_mock_header ("X-File-Name", "caption.png")
			assert ("absent is Void", l_request.header ("X-Caption") = Void)
		end

feature -- Meta variable names

	test_meta_name_is_the_cgi_spelling
			-- Upper case, hyphens gone; already-underscored names unchanged.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.meta_name"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("GET", "/")
			assert ("hyphens become underscores", l_request.meta_name ("X-File-Name").same_string ("X_FILE_NAME"))
			assert ("lower case is raised", l_request.meta_name ("content-type").same_string ("CONTENT_TYPE"))
			assert ("underscores survive", l_request.meta_name ("X_File_Name").same_string ("X_FILE_NAME"))
			assert ("a plain name is only raised", l_request.meta_name ("Authorization").same_string ("AUTHORIZATION"))
		end

	test_meta_variable_name_prefixes_all_but_the_content_pair
			-- The rule EWF's standalone connector uses (RFC 3875 s.4.1.18):
			-- HTTP_ in front of everything but CONTENT_TYPE and CONTENT_LENGTH.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.meta_variable_name"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("GET", "/")
			assert ("hyphenated header", l_request.meta_variable_name ("X-File-Name").same_string ("HTTP_X_FILE_NAME"))
			assert ("Authorization", l_request.meta_variable_name ("Authorization").same_string ("HTTP_AUTHORIZATION"))
			assert ("Content-Type takes no prefix", l_request.meta_variable_name ("Content-Type").same_string ("CONTENT_TYPE"))
			assert ("Content-Length takes no prefix", l_request.meta_variable_name ("Content-Length").same_string ("CONTENT_LENGTH"))
			assert ("a look-alike still takes the prefix", l_request.meta_variable_name ("Content-Encoding").same_string ("HTTP_CONTENT_ENCODING"))
		end

feature -- Content-Type and Content-Length

	test_content_type_reads_through_header
			-- Content-Type reaches both its own accessor and `header'.
			-- (CGI gives it the bare name CONTENT_TYPE, with no HTTP_ prefix.)
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.content_type"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("POST", "/upload")
			l_request.set_mock_header ("Content-Type", "image/png")
			assert ("content_type accessor", attached l_request.content_type as al_a and then al_a.same_string ("image/png"))
			assert ("through header", attached l_request.header ("Content-Type") as al_b and then al_b.same_string ("image/png"))
		end

	test_content_length_reports_mock_body
			-- In mock mode Content-Length is the body's own length.
		note
			testing: "covers/{SIMPLE_WEB_SERVER_REQUEST}.content_length"
		local
			l_request: SIMPLE_WEB_SERVER_REQUEST
		do
			create l_request.make_mock ("POST", "/upload")
			l_request.set_mock_body ("0123456789")
			assert_naturals_equal ("ten bytes", {NATURAL_64} 10, l_request.content_length)
		end

end
