note
	description: "Tests for SIMPLE_WEB_SANITIZER."
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_SANITIZER

inherit
	TEST_SET_BASE

feature -- HTML Sanitization Tests

	test_sanitize_html_basic
			-- Basic HTML escaping.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert_strings_equal ("less than", "&lt;", l_sanitizer.sanitize_html ("<").to_string_8)
			assert_strings_equal ("greater than", "&gt;", l_sanitizer.sanitize_html (">").to_string_8)
			assert_strings_equal ("ampersand", "&amp;", l_sanitizer.sanitize_html ("&").to_string_8)
			assert_strings_equal ("quote", "&quot;", l_sanitizer.sanitize_html ("%"").to_string_8)
		end

	test_sanitize_html_script_tag
			-- Sanitize XSS attempt.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
			l_result: STRING_32
		do
			create l_sanitizer
			l_result := l_sanitizer.sanitize_html ("<script>alert('xss')</script>")
			assert ("no less than", not l_result.has ('<'))
			assert ("no greater than", not l_result.has ('>'))
			assert ("contains escaped", l_result.has_substring ("&lt;script&gt;"))
		end

	test_strip_html_tags
			-- Strip all tags.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert_strings_equal ("stripped", "Hello World", l_sanitizer.strip_html_tags ("<b>Hello</b> <i>World</i>").to_string_8)
			assert_strings_equal ("nested stripped", "Content", l_sanitizer.strip_html_tags ("<div><p>Content</p></div>").to_string_8)
		end

feature -- Path Parameter Tests

	test_sanitize_path_traversal
			-- Block path traversal attempts.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
			l_result: STRING_32
		do
			create l_sanitizer
			l_result := l_sanitizer.sanitize_path_parameter ("../../../etc/passwd")
			assert ("no dots", not l_result.has_substring (".."))
			assert ("no slashes", not l_result.has ('/'))
		end

	test_sanitize_path_backslash
			-- Block backslash traversal.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
			l_result: STRING_32
		do
			create l_sanitizer
			l_result := l_sanitizer.sanitize_path_parameter ("..\..\..\windows\system32")
			assert ("no backslash", not l_result.has ('\'))
			assert ("no dots", not l_result.has_substring (".."))
		end

	test_is_safe_path_parameter
			-- Check safe parameter detection.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert ("safe id", l_sanitizer.is_safe_path_parameter ("12345"))
			assert ("safe name", l_sanitizer.is_safe_path_parameter ("john_doe"))
			assert ("unsafe traversal", not l_sanitizer.is_safe_path_parameter ("../etc"))
			assert ("unsafe slash", not l_sanitizer.is_safe_path_parameter ("foo/bar"))
		end

feature -- Header Sanitization Tests

	test_sanitize_header_crlf
			-- Block header injection via CRLF.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
			l_result: STRING_8
		do
			create l_sanitizer
			l_result := l_sanitizer.sanitize_header_value ("value%R%NEvil-Header: injected")
			assert ("no CR", not l_result.has ('%R'))
			assert ("no LF", not l_result.has ('%N'))
		end

	test_is_safe_header
			-- Check safe header detection.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert ("safe value", l_sanitizer.is_safe_header_value ("application/json"))
			assert ("unsafe crlf", not l_sanitizer.is_safe_header_value ("value%R%Nevil"))
		end

feature -- SQL Sanitization Tests

	test_escape_sql_quotes
			-- Escape single quotes.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert_strings_equal ("escaped", "O''Brien", l_sanitizer.escape_sql_string ("O'Brien"))
			assert_strings_equal ("double escaped", "It''''s", l_sanitizer.escape_sql_string ("It''s"))
		end

feature -- JSON Sanitization Tests

	test_sanitize_json_string
			-- Escape JSON special characters.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
			l_result: STRING_32
		do
			create l_sanitizer
			l_result := l_sanitizer.sanitize_json_string ("Hello%NWorld")
			assert ("has escaped newline", l_result.has_substring ("\n"))

			l_result := l_sanitizer.sanitize_json_string ("Say %"Hello%"")
			assert ("has escaped quote", l_result.has_substring ("\%""))
		end

feature -- Length Validation Tests

	test_truncate
			-- Truncate long strings.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert_strings_equal ("truncated", "Hello", l_sanitizer.truncate ("Hello World", 5).to_string_8)
			assert_strings_equal ("short ok", "Hi", l_sanitizer.truncate ("Hi", 10).to_string_8)
		end

	test_is_within_length
			-- Check length limits.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
		do
			create l_sanitizer
			assert ("within", l_sanitizer.is_within_length ("Hello", 10))
			assert ("exact", l_sanitizer.is_within_length ("Hello", 5))
			assert ("over", not l_sanitizer.is_within_length ("Hello World", 5))
		end

feature -- Combined Sanitization Tests

	test_sanitize_user_input
			-- Combined HTML escape and length limit.
		local
			l_sanitizer: SIMPLE_WEB_SANITIZER
			l_result: STRING_32
		do
			create l_sanitizer
			l_result := l_sanitizer.sanitize_user_input ("<script>alert('xss')</script>", 50)
			assert ("escaped", l_result.has_substring ("&lt;"))
			assert ("no raw tag", not l_result.has ('<'))
		end

note
	copyright: "Copyright (c) 2025, Larry Rix"
	license: "MIT License"

end
