note
	description: "Tests for {SIMPLE_WEB_OLLAMA_CLIENT}"
	testing: "type/manual"

class
	TEST_SIMPLE_WEB_OLLAMA

inherit
	TEST_SET_BASE

feature -- Test routines

	test_curl_directly
			--
		note
			testing: "execution/isolated"
		local
			l_process: FW_PROCESS_HELPER
			l_output: STRING
			l_response_text: STRING_32
			l_value: SIMPLE_JSON_VALUE
			l_json: SIMPLE_JSON
			l_obj: SIMPLE_JSON_OBJECT
		do
			create l_process
			l_output := l_process.output_of_command (curl_cmd, Void)

			create l_json
			l_value := l_json.parse (l_output)

			if attached l_value as al_value and then al_value.is_object then
			    l_obj := al_value.as_object
			    if attached l_obj.string_item ("response") as al_response then
			    	print ("response:%N%N" + al_response)
			    	assert_string_contains ("preamble", al_response, "We the People")
			    end
			end
		end

	curl_cmd: STRING = "[
curl.exe -s -X POST http://127.0.0.1:11434/api/generate -H "Content-Type: application/json" -d "{\"model\":\"llama3\",\"prompt\":\"PRECISE First three words of the US Constitution Preamble\",\"stream\":false}"
]"


	test_ollama_server_running
			-- Verify Ollama server is accessible and returning models
		note
			testing: "execution/isolated"
		local
			l_client: SIMPLE_WEB_OLLAMA_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
		do
			create l_client

			print ("%N=== Ollama Server Check ===%N")
			l_response := l_client.list_models

			print ("Status: " + l_response.status_code.out + "%N")
			print ("Body: " + l_response.body + "%N%N")

			assert_true ("server_running", l_response.is_success)
			assert_string_contains ("has_models_key", l_response.body, "%"models%"")
			assert_strings_equal_diff ("ollama_default_base_url", "http://localhost:11434", l_response.ollama_default_base_url)
			assert_strings_equal_diff ("model_list", expected_models_list, l_response.body)
		end

	expected_models_list: STRING = "[
{"models":[{"name":"gpt-oss:20b","model":"gpt-oss:20b","modified_at":"2025-09-22T16:04:41.289551321-04:00","size":13780173724,"digest":"aa4295ac10c3afb60e6d711289fc6896f5aef82258997b9efdaed6d0cc4cd8b8","details":{"parent_model":"","format":"gguf","family":"gptoss","families":["gptoss"],"parameter_size":"20.9B","quantization_level":"MXFP4"}},{"name":"qwen3:8b","model":"qwen3:8b","modified_at":"2025-09-22T15:28:03.818603254-04:00","size":5225388164,"digest":"500a1f067a9f782620b40bee6f7b0c89e17ae61f686b92c24933e4ca4b2b8b41","details":{"parent_model":"","format":"gguf","family":"qwen3","families":["qwen3"],"parameter_size":"8.2B","quantization_level":"Q4_K_M"}},{"name":"qwen3:4b","model":"qwen3:4b","modified_at":"2025-09-16T10:03:34.184735601-04:00","size":2497293918,"digest":"e55aed6fe643f9368b2f48f8aaa56ec787b75765da69f794c0a0c23bfe7c64b2","details":{"parent_model":"","format":"gguf","family":"qwen3","families":["qwen3"],"parameter_size":"4.0B","quantization_level":"Q4_K_M"}},{"name":"qwen2.5-coder:latest","model":"qwen2.5-coder:latest","modified_at":"2025-09-13T08:50:29.492799587-04:00","size":4683087561,"digest":"dae161e27b0e90dd1856c8bb3209201fd6736d8eb66298e75ed87571486f4364","details":{"parent_model":"","format":"gguf","family":"qwen2","families":["qwen2"],"parameter_size":"7.6B","quantization_level":"Q4_K_M"}},{"name":"llama3:latest","model":"llama3:latest","modified_at":"2025-09-13T08:46:56.015904975-04:00","size":4661224676,"digest":"365c0bd3c000a25d28ddbf732fe1c6add414de7275464c4e4d1c3b5fcb5d8ad1","details":{"parent_model":"","format":"gguf","family":"llama","families":["llama"],"parameter_size":"8.0B","quantization_level":"Q4_0"}}]}
]"


	test_ollama_echo_response
			-- Test that Ollama actually responds with expected content
		note
			testing: "execution/isolated"
		local
			l_client: SIMPLE_WEB_OLLAMA_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
		do
			create l_client

			print ("%N=== Ollama Echo Test ===%N")
			print ("Prompt: Repeat this exactly: EIFFEL_TEST_MARKER%N")

			l_response := l_client.generate ({STRING_32} "llama3",
				"Repeat this exactly: EIFFEL_TEST_MARKER")

			print ("Status: " + l_response.status_code.out + "%N")
			print ("Body: " + l_response.body + "%N%N")

			if l_response.is_success then
				assert_string_contains ("has_marker", l_response.body, "EIFFEL_TEST_MARKER")
			else
				print ("Ollama not running (status " + l_response.status_code.out + ")%N")
			end
		end

	test_ollama_generate
			-- Test basic generate endpoint (requires Ollama running)
		note
			testing: "execution/isolated", "covers/{SIMPLE_WEB_OLLAMA_CLIENT}.generate"
		local
			l_client: SIMPLE_WEB_OLLAMA_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
		do
			create l_client
			l_response := l_client.generate ({STRING_32} "llama3", "Why is the sky blue?")

			print ("%NGenerate Status: " + l_response.status_code.out + "%N")
			print ("Generate Body: " + l_response.body + "%N")

			if l_response.is_success then
				assert_true ("has_response", not l_response.body.is_empty)
				assert_string_contains ("has_model", l_response.body, "model")
			else
				-- Show what we actually got
				print ("FAILED - Status: " + l_response.status_code.out + "%N")
			end
		end

	test_ollama_list_models
			-- Test list models endpoint
		note
			testing: "execution/isolated", "covers/{SIMPLE_WEB_OLLAMA_CLIENT}.list_models"
		local
			l_client: SIMPLE_WEB_OLLAMA_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
		do
			create l_client
			l_response := l_client.list_models

			if l_response.is_success then
				assert_true ("has_response", not l_response.body.is_empty)
			else
				assert_true ("network_failure_or_not_running", l_response.status_code = 503 or l_response.status_code = 0)
			end
		end

	test_ollama_chat
			-- Test chat endpoint
		note
			testing: "execution/isolated", "covers/{SIMPLE_WEB_OLLAMA_CLIENT}.chat"
		local
			l_client: SIMPLE_WEB_OLLAMA_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
			l_messages: ARRAY [TUPLE [role: STRING_32; content: STRING_32]]
			l_msg: TUPLE [role: STRING_32; content: STRING_32]
		do
			create l_client
			l_msg := [{STRING_32} "user", {STRING_32} "Hello"]
			create l_messages.make_filled (l_msg, 1, 1)

			l_response := l_client.chat ({STRING_32} "llama3", l_messages)

			print ("%NChat Status: " + l_response.status_code.out + "%N")
			print ("Chat Body: " + l_response.body + "%N")

			if l_response.is_success then
				assert_true ("has_response", not l_response.body.is_empty)
			else
				print ("FAILED - Status: " + l_response.status_code.out + "%N")
			end
		end

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		Tests require Ollama running: ollama serve
	]"

end
