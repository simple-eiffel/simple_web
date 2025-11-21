note
	description: "[
		Project-wide named constants for SIMPLE_WEB library.
		Defines HTTP methods, status codes, headers, timeouts, and AI service endpoints.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_CONSTANTS

feature -- HTTP Methods

	Http_method_get: STRING_8 = "GET"
	Http_method_post: STRING_8 = "POST"
	Http_method_put: STRING_8 = "PUT"
	Http_method_delete: STRING_8 = "DELETE"
	Http_method_patch: STRING_8 = "PATCH"
	Http_method_head: STRING_8 = "HEAD"
	Http_method_options: STRING_8 = "OPTIONS"

feature -- HTTP Status Codes

	Status_ok: INTEGER = 200
	Status_created: INTEGER = 201
	Status_accepted: INTEGER = 202
	Status_no_content: INTEGER = 204
	
	Status_bad_request: INTEGER = 400
	Status_unauthorized: INTEGER = 401
	Status_forbidden: INTEGER = 403
	Status_not_found: INTEGER = 404
	Status_method_not_allowed: INTEGER = 405
	Status_request_timeout: INTEGER = 408
	Status_too_many_requests: INTEGER = 429
	
	Status_internal_server_error: INTEGER = 500
	Status_bad_gateway: INTEGER = 502
	Status_service_unavailable: INTEGER = 503
	Status_gateway_timeout: INTEGER = 504

feature -- Common Headers

	Header_content_type: STRING_8 = "Content-Type"
	Header_authorization: STRING_8 = "Authorization"
	Header_accept: STRING_8 = "Accept"
	Header_user_agent: STRING_8 = "User-Agent"
	Header_content_length: STRING_8 = "Content-Length"
	
	Content_type_json: STRING_8 = "application/json"
	Content_type_form: STRING_8 = "application/x-www-form-urlencoded"
	Content_type_text: STRING_8 = "text/plain"
	Content_type_html: STRING_8 = "text/html"

feature -- Authentication

	Auth_bearer_prefix: STRING_8 = "Bearer "
	Auth_api_key_prefix: STRING_8 = "x-api-key: "

feature -- AI Service Endpoints

	Claude_api_base_url: STRING_8 = "https://api.anthropic.com/v1"
	Claude_messages_endpoint: STRING_8 = "/messages"
	Claude_api_version_header: STRING_8 = "anthropic-version"
	Claude_api_version: STRING_8 = "2023-06-01"
	
	Openai_api_base_url: STRING_8 = "https://api.openai.com/v1"
	Openai_chat_endpoint: STRING_8 = "/chat/completions"
	Openai_completions_endpoint: STRING_8 = "/completions"
	
	Gemini_api_base_url: STRING_8 = "https://generativelanguage.googleapis.com/v1beta"
	Gemini_generate_endpoint: STRING_8 = "/models/gemini-pro:generateContent"
	
	Ollama_default_base_url: STRING_8 = "http://localhost:11434"
	Ollama_generate_endpoint: STRING_8 = "/api/generate"
	Ollama_chat_endpoint: STRING_8 = "/api/chat"

feature -- Timeouts (milliseconds)

	Default_timeout_ms: INTEGER = 30_000
			-- 30 seconds default timeout
			
	Ai_request_timeout_ms: INTEGER = 120_000
			-- 2 minutes for AI requests (can be slow)
			
	Connection_timeout_ms: INTEGER = 10_000
			-- 10 seconds for establishing connection

feature -- Limits

	Max_retries: INTEGER = 3
			-- Maximum retry attempts for failed requests
			
	Default_max_tokens: INTEGER = 4096
			-- Default maximum tokens for AI responses

feature -- User Agent

	Default_user_agent: STRING_8 = "SIMPLE_WEB/1.0.0 Eiffel"

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		https://github.com/ljr1981/simple_web
	]"

end
