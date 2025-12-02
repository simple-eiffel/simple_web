note
	description: "[
		Input sanitization utilities for HTTP server security.

		Provides methods to sanitize user input and prevent common attacks:
		- HTML/XSS sanitization
		- SQL injection prevention (basic escaping)
		- Path traversal prevention
		- Header injection prevention

		Usage:
			sanitizer: SIMPLE_WEB_SANITIZER
			...
			l_safe_name := sanitizer.sanitize_html (user_input)
			l_safe_param := sanitizer.sanitize_path_parameter (raw_param)
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_SANITIZER

feature -- HTML Sanitization

	sanitize_html (a_input: READABLE_STRING_GENERAL): STRING_32
			-- Escape HTML special characters to prevent XSS.
			-- Converts: < > & " ' to HTML entities.
		require
			input_attached: a_input /= Void
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_input.count + 20)
			from i := 1 until i > a_input.count loop
				c := a_input.item (i)
				inspect c
				when '<' then
					Result.append ("&lt;")
				when '>' then
					Result.append ("&gt;")
				when '&' then
					Result.append ("&amp;")
				when '"' then
					Result.append ("&quot;")
				when '%'' then
					Result.append ("&#39;")
				else
					Result.append_character (c)
				end
				i := i + 1
			variant
				a_input.count - i + 1
			end
		ensure
			result_attached: Result /= Void
			no_html_tags: not Result.has ('<') and not Result.has ('>')
		end

	strip_html_tags (a_input: READABLE_STRING_GENERAL): STRING_32
			-- Remove all HTML tags from input.
			-- More aggressive than sanitize_html - strips rather than escapes.
		require
			input_attached: a_input /= Void
		local
			i: INTEGER
			c: CHARACTER_32
			l_in_tag: BOOLEAN
		do
			create Result.make (a_input.count)
			from i := 1 until i > a_input.count loop
				c := a_input.item (i)
				if c = '<' then
					l_in_tag := True
				elseif c = '>' then
					l_in_tag := False
				elseif not l_in_tag then
					Result.append_character (c)
				end
				i := i + 1
			variant
				a_input.count - i + 1
			end
		ensure
			result_attached: Result /= Void
			no_tags: not Result.has ('<') and not Result.has ('>')
		end

feature -- Path Parameter Sanitization

	sanitize_path_parameter (a_input: READABLE_STRING_GENERAL): STRING_32
			-- Sanitize path parameter to prevent path traversal attacks.
			-- Removes: .. / \ null bytes and other dangerous characters.
		require
			input_attached: a_input /= Void
		local
			l_temp: STRING_32
		do
			create l_temp.make_from_string (a_input.to_string_32)

			-- Remove path traversal sequences
			l_temp.replace_substring_all ("..", "")
			l_temp.replace_substring_all ("/", "")
			l_temp.replace_substring_all ("\", "")
			l_temp.replace_substring_all ("%U", "") -- null byte

			-- Remove other dangerous characters
			l_temp.replace_substring_all ("%N", "")
			l_temp.replace_substring_all ("%R", "")

			Result := l_temp
		ensure
			result_attached: Result /= Void
			no_traversal: not Result.has_substring ("..")
			no_slashes: not Result.has ('/') and not Result.has ('\')
		end

	is_safe_path_parameter (a_input: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_input' a safe path parameter (no dangerous characters)?
		require
			input_attached: a_input /= Void
		do
			Result := not a_input.has_substring ("..")
				and then not a_input.has ('/')
				and then not a_input.has ('\')
				and then not a_input.has ('%U')
		end

feature -- Header Sanitization

	sanitize_header_value (a_input: READABLE_STRING_GENERAL): STRING_8
			-- Sanitize header value to prevent header injection.
			-- Removes CR, LF, and null bytes.
		require
			input_attached: a_input /= Void
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_input.count)
			from i := 1 until i > a_input.count loop
				c := a_input.item (i)
				-- Skip CR, LF, null bytes
				if c /= '%R' and c /= '%N' and c /= '%U' then
					if c.is_character_8 then
						Result.append_character (c.to_character_8)
					end
				end
				i := i + 1
			variant
				a_input.count - i + 1
			end
		ensure
			result_attached: Result /= Void
			no_crlf: not Result.has ('%R') and not Result.has ('%N')
		end

	is_safe_header_value (a_input: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_input' safe for use as a header value?
		require
			input_attached: a_input /= Void
		do
			Result := not a_input.has ('%R')
				and then not a_input.has ('%N')
				and then not a_input.has ('%U')
		end

feature -- SQL Sanitization (Basic)

	escape_sql_string (a_input: READABLE_STRING_GENERAL): STRING_8
			-- Escape single quotes for SQL strings.
			-- NOTE: Prefer parameterized queries over string escaping.
		require
			input_attached: a_input /= Void
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_input.count + 10)
			from i := 1 until i > a_input.count loop
				c := a_input.item (i)
				if c = '%'' then
					Result.append ("''") -- Escape single quote by doubling
				elseif c.is_character_8 then
					Result.append_character (c.to_character_8)
				end
				i := i + 1
			variant
				a_input.count - i + 1
			end
		ensure
			result_attached: Result /= Void
		end

feature -- JSON Sanitization

	sanitize_json_string (a_input: READABLE_STRING_GENERAL): STRING_32
			-- Escape special characters for JSON string values.
		require
			input_attached: a_input /= Void
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_input.count + 20)
			from i := 1 until i > a_input.count loop
				c := a_input.item (i)
				inspect c
				when '"' then
					Result.append ("\%"")
				when '\' then
					Result.append ("\\")
				when '%N' then
					Result.append ("\n")
				when '%R' then
					Result.append ("\r")
				when '%T' then
					Result.append ("\t")
				else
					Result.append_character (c)
				end
				i := i + 1
			variant
				a_input.count - i + 1
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Length Validation

	truncate (a_input: READABLE_STRING_GENERAL; a_max_length: INTEGER): STRING_32
			-- Return `a_input' truncated to `a_max_length' characters.
		require
			input_attached: a_input /= Void
			positive_length: a_max_length > 0
		do
			if a_input.count <= a_max_length then
				Result := a_input.to_string_32
			else
				Result := a_input.to_string_32.substring (1, a_max_length)
			end
		ensure
			result_attached: Result /= Void
			length_limited: Result.count <= a_max_length
		end

	is_within_length (a_input: READABLE_STRING_GENERAL; a_max_length: INTEGER): BOOLEAN
			-- Is `a_input' within allowed length?
		require
			input_attached: a_input /= Void
			positive_length: a_max_length > 0
		do
			Result := a_input.count <= a_max_length
		end

feature -- Combined Sanitization

	sanitize_user_input (a_input: READABLE_STRING_GENERAL; a_max_length: INTEGER): STRING_32
			-- Apply common sanitization: HTML escape and length limit.
			-- Suitable for general text input from users.
		require
			input_attached: a_input /= Void
			positive_length: a_max_length > 0
		do
			Result := sanitize_html (truncate (a_input, a_max_length))
		ensure
			result_attached: Result /= Void
			length_limited: Result.count <= a_max_length + 20 -- Allow for entity expansion
		end

note
	copyright: "Copyright (c) 2025, Larry Rix"
	license: "MIT License"

end
