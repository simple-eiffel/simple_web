note
	description: "Tests for SIMPLE_WEB_HYBRID_CLIENT"

class
	TEST_HYBRID_CLIENT

inherit
	TEST_SET_BASE

feature -- Test

	test_hybrid_post_ollama
			-- Test POST via hybrid client (uses curl.exe process)
		note
			testing: "execution/isolated"
		local
			l_client: SIMPLE_WEB_HYBRID_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
			l_body: STRING
			l_json: SIMPLE_JSON
			l_value: SIMPLE_JSON_VALUE
		do
			print ("%N=== HYBRID CLIENT POST ===%N")

			create l_client.make

			l_body := "{%"model%":%"llama3%",%"prompt%":%"Say exactly: HYBRID_TEST%",%"stream%":false}"

			l_response := l_client.post_json ("http://127.0.0.1:11434/api/generate", l_body)

			print ("Status: " + l_response.status_code.out + "%N")
			print ("Body: " + l_response.body.substring (1, l_response.body.count.min (200)) + "%N")

			assert ("post_success", l_response.is_success)

			create l_json
			l_value := l_json.parse (l_response.body)
			if attached l_value as al_value and then al_value.is_object then
				assert ("has_response_field", al_value.as_object.has_key ("response"))
			else
				assert ("valid_json", False)
			end
		end

	test_hybrid_get_ollama
			-- Test GET via hybrid client (uses libcurl)
		note
			testing: "execution/isolated"
		local
			l_client: SIMPLE_WEB_HYBRID_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
		do
			print ("%N=== HYBRID CLIENT GET ===%N")

			create l_client.make

			l_response := l_client.get ("http://127.0.0.1:11434/api/tags")

			print ("Status: " + l_response.status_code.out + "%N")
			print ("Body length: " + l_response.body.count.out + "%N")

			assert ("get_success", l_response.is_success)
			assert_string_contains ("has_models", l_response.body, "models")
		end

	test_hybrid_post_httpbin
			-- Test POST to external server
		note
			testing: "execution/isolated"
		local
			l_client: SIMPLE_WEB_HYBRID_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
			l_body: STRING
		do
			print ("%N=== HYBRID CLIENT HTTPBIN ===%N")

			create l_client.make

			l_body := "{%"test%":%"hybrid_client%"}"

			l_response := l_client.post_json ("https://httpbin.org/post", l_body)

			print ("Status: " + l_response.status_code.out + "%N")

			assert ("httpbin_success", l_response.is_success)
			assert_string_contains ("echoed_data", l_response.body, "hybrid_client")
		end

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"

end
