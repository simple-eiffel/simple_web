note
	description: "[
		Client for OpenAI API (ChatGPT).
		Provides clean interface for ChatGPT interactions.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_OPENAI_CLIENT

inherit
	SIMPLE_WEB_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_api_key: STRING)
			-- Initialize with API key
		require
			key_attached: a_api_key /= Void
			key_not_empty: not a_api_key.is_empty
		do
			api_key := a_api_key
			create client.make
			model := "gpt-4"
			max_tokens := Default_max_tokens
		ensure
			key_set: api_key = a_api_key
			client_attached: client /= Void
		end

feature -- Access

	api_key: STRING
			-- OpenAI API key

	model: STRING
			-- Model to use (gpt-4, gpt-3.5-turbo, etc.)

	max_tokens: INTEGER
			-- Maximum tokens in response

feature -- Settings

	set_model (a_model: STRING)
			-- Set model
		require
			model_attached: a_model /= Void
			model_not_empty: not a_model.is_empty
		do
			model := a_model
		ensure
			model_set: model = a_model
		end

	set_max_tokens (a_max: INTEGER)
			-- Set maximum tokens
		require
			max_positive: a_max > 0
		do
			max_tokens := a_max
		ensure
			max_set: max_tokens = a_max
		end

feature -- Operations

	send_message (a_user_message: STRING): detachable STRING
			-- Send message and return response
		require
			message_attached: a_user_message /= Void
			message_not_empty: not a_user_message.is_empty
		local
			l_request_json, l_url: STRING
			l_request: SIMPLE_WEB_REQUEST
			l_response: SIMPLE_WEB_RESPONSE
			l_json_response: detachable SIMPLE_JSON_VALUE
		do
			-- Build request JSON
			l_request_json := build_chat_request (a_user_message)
			
			-- Build URL
			l_url := Openai_api_base_url + Openai_chat_endpoint
			
			-- Create and configure request
			create l_request.make_post (l_url)
			l_request.with_bearer_token (api_key).do_nothing
			l_request.with_json_body (l_request_json).do_nothing
			l_request.with_timeout (Ai_request_timeout_ms).do_nothing
			
			-- Execute request
			l_response := client.execute (l_request)
			
			-- Parse response
			if l_response.is_success then
				l_json_response := l_response.body_as_json
				if attached l_json_response as al_json then
					Result := extract_message_content (al_json)
				end
			end
		end

feature {NONE} -- Implementation

	client: SIMPLE_WEB_CLIENT
			-- HTTP client

	build_chat_request (a_message: STRING): STRING
			-- Build JSON request for chat completion
		local
			l_obj: SIMPLE_JSON_OBJECT
		do
			create l_obj.make
			l_obj.put_string (model, "model").do_nothing
			l_obj.put_integer (max_tokens, "max_tokens").do_nothing
			
			-- Add messages array
			create Result.make_from_string (l_obj.as_json)
			Result.insert_string ("%"messages%":[{%"role%":%"user%",%"content%":%"" + escape_json (a_message) + "%"}],", Result.count - 1)
		ensure
			result_attached: Result /= Void
		end

	extract_message_content (a_json: SIMPLE_JSON_VALUE): detachable STRING
			-- Extract message content from OpenAI response
		do
			if a_json.is_object and then attached a_json.as_object as al_obj and then
			   al_obj.has_key ("choices") and then
			   attached al_obj.item ("choices") as al_choices and then
			   al_choices.is_array and then attached al_choices.as_array as al_array and then
			   al_array.count > 0 and then attached al_array.item (1) as al_first and then
			   al_first.is_object and then attached al_first.as_object as al_choice and then
			   al_choice.has_key ("message") and then
			   attached al_choice.item ("message") as al_message and then
			   al_message.is_object and then attached al_message.as_object as al_msg_obj and then
			   al_msg_obj.has_key ("content") and then
			   attached al_msg_obj.item ("content") as al_content and then
			   al_content.is_string
			then
				Result := al_content.as_string_32
			end
		end

	escape_json (a_string: STRING): STRING
			-- Escape JSON special characters
		do
			create Result.make_from_string (a_string)
			Result.replace_substring_all ("\", "\\")
			Result.replace_substring_all ("%"", "\%"")
			Result.replace_substring_all ("%N", "\n")
		ensure
			result_attached: Result /= Void
		end

invariant
	api_key_attached: api_key /= Void
	client_attached: client /= Void
	model_attached: model /= Void

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		https://github.com/ljr1981/simple_web
	]"

end
