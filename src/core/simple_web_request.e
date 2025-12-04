note
	description: "[
		Fluent request builder for HTTP requests.
		Provides chainable methods for constructing requests.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_REQUEST

inherit
	SIMPLE_WEB_CONSTANTS

create
	make_get,
	make_post,
	make_put,
	make_delete

feature {NONE} -- Initialization

	make_get (a_url: STRING)
			-- Initialize GET request
		require
			url_attached: a_url /= Void
			url_not_empty: not a_url.is_empty
		do
			initialize (Http_method_get, a_url)
		ensure
			method_set: method ~ Http_method_get
			url_set: url ~ a_url
		end

	make_post (a_url: STRING)
			-- Initialize POST request
		require
			url_attached: a_url /= Void
			url_not_empty: not a_url.is_empty
		do
			initialize (Http_method_post, a_url)
		ensure
			method_set: method ~ Http_method_post
			url_set: url ~ a_url
		end

	make_put (a_url: STRING)
			-- Initialize PUT request
		require
			url_attached: a_url /= Void
			url_not_empty: not a_url.is_empty
		do
			initialize (Http_method_put, a_url)
		ensure
			method_set: method ~ Http_method_put
			url_set: url ~ a_url
		end

	make_delete (a_url: STRING)
			-- Initialize DELETE request
		require
			url_attached: a_url /= Void
			url_not_empty: not a_url.is_empty
		do
			initialize (Http_method_delete, a_url)
		ensure
			method_set: method ~ Http_method_delete
			url_set: url ~ a_url
		end

	initialize (a_method, a_url: STRING)
			-- Common initialization
		require
			method_attached: a_method /= Void
			url_attached: a_url /= Void
		do
			method := a_method
			url := a_url
			create body.make_empty
			create headers.make (10)
			timeout_ms := Default_timeout_ms
		ensure
			method_set: method = a_method
			url_set: url = a_url
			body_empty: body.is_empty
			headers_attached: headers /= Void
			timeout_set: timeout_ms = Default_timeout_ms
		end

feature -- Access

	method: STRING
			-- HTTP method (GET, POST, etc.)

	url: STRING
			-- Request URL

	body: STRING
			-- Request body content

	headers: STRING_TABLE [STRING]
			-- Request headers (name -> value)

	timeout_ms: INTEGER
			-- Request timeout in milliseconds

feature -- Element Change: Headers

	with_header (a_name, a_value: STRING): SIMPLE_WEB_REQUEST
			-- Add header (returns self for chaining)
		require
			name_attached: a_name /= Void
			name_not_empty: not a_name.is_empty
			value_attached: a_value /= Void
		do
			headers.force (a_value, a_name)
			Result := Current
		ensure
			returns_self: Result = Current
			header_added: headers.has (a_name)
		end

	with_content_type (a_content_type: STRING): SIMPLE_WEB_REQUEST
			-- Set Content-Type header
		require
			type_attached: a_content_type /= Void
		do
			Result := with_header (Header_content_type, a_content_type)
		ensure
			returns_self: Result = Current
			content_type_set: headers.has (Header_content_type)
		end

	with_json_content_type: SIMPLE_WEB_REQUEST
			-- Set Content-Type to application/json
		do
			Result := with_content_type (Content_type_json)
		ensure
			returns_self: Result = Current
			json_content_type_set: attached headers.item (Header_content_type) as v and then v.same_string (Content_type_json)
		end

	with_bearer_token (a_token: STRING): SIMPLE_WEB_REQUEST
			-- Set Authorization header with Bearer token
		require
			token_attached: a_token /= Void
			token_not_empty: not a_token.is_empty
		do
			Result := with_header (Header_authorization, Auth_bearer_prefix + a_token)
		ensure
			returns_self: Result = Current
			authorization_set: headers.has (Header_authorization)
		end

	with_api_key (a_key: STRING): SIMPLE_WEB_REQUEST
			-- Set x-api-key header
		require
			key_attached: a_key /= Void
			key_not_empty: not a_key.is_empty
		do
			Result := with_header ("x-api-key", a_key)
		ensure
			returns_self: Result = Current
			api_key_set: headers.has ("x-api-key")
		end

feature -- Element Change: Body

	with_body (a_body: STRING): SIMPLE_WEB_REQUEST
			-- Set request body (returns self for chaining)
		require
			body_attached: a_body /= Void
		do
			body := a_body
			Result := Current
		ensure
			returns_self: Result = Current
			body_set: body = a_body
		end

	with_json_body (a_json: STRING): SIMPLE_WEB_REQUEST
			-- Set JSON body and content type
		require
			json_attached: a_json /= Void
		do
			Result := with_body (a_json).with_json_content_type
		ensure
			returns_self: Result = Current
			body_set: body.same_string (a_json)
			json_content_type_set: headers.has (Header_content_type)
		end

feature -- Element Change: Timeout

	with_timeout (a_timeout_ms: INTEGER): SIMPLE_WEB_REQUEST
			-- Set request timeout
		require
			timeout_positive: a_timeout_ms > 0
		do
			timeout_ms := a_timeout_ms
			Result := Current
		ensure
			returns_self: Result = Current
			timeout_set: timeout_ms = a_timeout_ms
		end

invariant
	method_attached: method /= Void
	url_attached: url /= Void
	body_attached: body /= Void
	headers_attached: headers /= Void
	timeout_positive: timeout_ms > 0

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		https://github.com/ljr1981/simple_web
	]"

end
