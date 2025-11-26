note
	description: "Client for Ollama AI API (localhost:11434)"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_OLLAMA_CLIENT

inherit
	ANY
		redefine
			default_create
		end

create
	default_create,
	make_with_base_url

feature {NONE} -- Initialization

	default_create
			-- Create client with default localhost URL
		do
			base_url := Default_base_url
			create client.make
		end

	make_with_base_url (a_base_url: STRING)
			-- Create client with custom base URL
		require
			url_not_empty: not a_base_url.is_empty
		do
			base_url := a_base_url
			create client.make
		ensure
			url_set: base_url ~ a_base_url
		end

feature -- API Operations

	generate (a_model, a_prompt: STRING_32): SIMPLE_WEB_RESPONSE
			-- Generate completion with streaming disabled
		require
			model_not_empty: not a_model.is_empty
			prompt_not_empty: not a_prompt.is_empty
		local
			l_body: STRING_32
		do
			create l_body.make (256)
			l_body.append ("{%"model%":%"")
			l_body.append (a_model)
			l_body.append ("%",%"prompt%":%"")
			l_body.append (escape_json_string (a_prompt))
			l_body.append ("%",")
			l_body.append ("%"stream%":")
			l_body.append ("false}")

			print ("%N[DEBUG] JSON being sent:%N")
			print (l_body.to_string_8 + "%N%N")

			Result := client.post_json (base_url + "/api/generate", l_body.to_string_8)
		ensure
			result_attached: Result /= Void
		end

	chat (a_model: STRING_32; a_messages: ARRAY [TUPLE [role: STRING_32; content: STRING_32]]): SIMPLE_WEB_RESPONSE
			-- Send chat completion request
		require
			model_not_empty: not a_model.is_empty
			messages_not_empty: not a_messages.is_empty
		local
			l_body: STRING_32
			l_first: BOOLEAN
		do
			create l_body.make (512)
			l_body.append ("{%"model%":%"")
			l_body.append (a_model)
			l_body.append ("%",%"messages%":[")

			l_first := True
			across a_messages as ic loop
				if not l_first then
					l_body.append (",")
				end
				l_body.append ("{%"role%":%"")
				l_body.append (ic.role)
				l_body.append ("%",%"content%":%"")
				l_body.append (escape_json_string (ic.content))
				l_body.append ("%"}")
				l_first := False
			end

			l_body.append ("],")
			l_body.append ("%"stream%":")
			l_body.append ("false}")

			Result := client.post_json (base_url + "/api/chat", l_body.to_string_8)
		ensure
			result_attached: Result /= Void
		end

	list_models: SIMPLE_WEB_RESPONSE
			-- Get list of available models
		do
			Result := client.get (base_url + "/api/tags")
		ensure
			result_attached: Result /= Void
		end

feature -- Status

	base_url: STRING
			-- Base URL for Ollama API

feature {NONE} -- Implementation

	client: SIMPLE_WEB_HYBRID_CLIENT
			-- HTTP client

	escape_json_string (a_str: STRING_32): STRING_32
			-- Escape special characters for JSON
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_str.count + 20)
			from
				i := 1
			until
				i > a_str.count
			loop
				c := a_str [i]
				inspect c
				when '%"' then
					Result.append_character ('\')
					Result.append_character ('%"')
				when '\' then
					Result.append_character ('\')
					Result.append_character ('\')
				when '%N' then
					Result.append_character ('\')
					Result.append_character ('n')
				when '%R' then
					Result.append_character ('\')
					Result.append_character ('r')
				when '%T' then
					Result.append_character ('\')
					Result.append_character ('t')
				else
					Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Constants

	Default_base_url: STRING = "http://localhost:11434"
			-- Default Ollama API endpoint

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		Ollama API: https://github.com/ollama/ollama/blob/main/docs/api.md
	]"

end
