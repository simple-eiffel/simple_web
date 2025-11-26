note
	description: "Example: Using Ollama for local AI completions"

class
	EXAMPLE_OLLAMA

create
	make

feature {NONE} -- Initialization

	make
			-- Run Ollama examples
		local
			l_client: SIMPLE_WEB_OLLAMA_CLIENT
			l_response: SIMPLE_WEB_RESPONSE
			l_json: detachable SIMPLE_JSON_VALUE
		do
			create l_client

			-- Example 1: List available models
			print ("%N=== Available Models ===%N")
			l_response := l_client.list_models
			if l_response.is_success then
				print (l_response.body)
				print ("%N")
			else
				print ("Error: " + l_response.status_code.out + "%N")
				print ("Is Ollama running? Start with: ollama serve%N")
			end

			-- Example 2: Simple generation
			print ("%N=== Simple Generation ===%N")
			print ("Prompt: Why is the sky blue?%N")
			l_response := l_client.generate ({STRING_32} "llama3", "Why is the sky blue?")
			if l_response.is_success then
				l_json := l_response.body_as_json
				if attached l_json as al_json and then al_json.is_object then
					if attached al_json.as_object.string ("response") as l_text then
						print ("Response: " + l_text + "%N")
					end
				end
			else
				print ("Error: " + l_response.status_code.out + "%N")
			end

			-- Example 3: Chat with context
			print ("%N=== Chat with Context ===%N")
			l_response := l_client.chat ({STRING_32} "llama3", <<
				[{STRING_32} "system", {STRING_32} "You are a helpful assistant."],
				[{STRING_32} "user", {STRING_32} "What is Eiffel programming language?"]
			>>)
			if l_response.is_success then
				l_json := l_response.body_as_json
				if attached l_json as al_json and then al_json.is_object then
					if attached al_json.as_object.object ("message") as l_msg then
						if attached l_msg.string ("content") as l_text then
							print ("Response: " + l_text + "%N")
						end
					end
				end
			else
				print ("Error: " + l_response.status_code.out + "%N")
			end
		end

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"
	source: "[
		SIMPLE_WEB - High-level Web API Library
		
		Prerequisites:
		1. Install Ollama: https://ollama.com
		2. Pull a model: ollama pull llama2
		3. Start server: ollama serve
		4. Run this example
	]"

end
