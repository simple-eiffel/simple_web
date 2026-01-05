note
	description: "[
		Zero-configuration web server facade for beginners.

		One-liner web server setup - no middleware or config required.
		For full control, use SIMPLE_WEB_SERVER directly.

		Quick Start Examples:
			create web.make

			-- Serve static files from folder
			web.serve_files ("C:\my_website", 8080)

			-- Or create a JSON API
			web.json_api (8080)
			web.get ("/api/hello", agent handle_hello)
			web.post ("/api/users", agent handle_create_user)
			web.start

		Handler examples:
			handle_hello (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
				do
					res.send_json (create {JSON_OBJECT}.make_from_string ("{%"message%":%"Hello!%"}"))
				end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_WEB_QUICK

create
	make

feature {NONE} -- Initialization

	make
			-- Create quick web facade.
		do
			create logger.make
			port := 8080
		end

feature -- Quick Server Setup

	serve_files (a_folder: STRING; a_port: INTEGER)
			-- Serve static files from folder.
			-- Blocks until server is stopped.
		require
			folder_not_empty: not a_folder.is_empty
			valid_port: a_port > 0 and a_port < 65536
		do
			logger.info ("Serving files from " + a_folder + " on port " + a_port.out)
			port := a_port
			static_folder := a_folder
			create server.make (a_port)
			if attached server as s then
				s.on_get ("/*", agent handle_static_file)
				logger.info ("Starting static file server...")
				s.start
			end
		end

	json_api (a_port: INTEGER)
			-- Create JSON API server.
			-- Add routes with get/post, then call start.
		require
			valid_port: a_port > 0 and a_port < 65536
		do
			logger.info ("Creating JSON API server on port " + a_port.out)
			port := a_port
			create server.make (a_port)
			is_api_mode := True
		ensure
			server_created: server /= Void
			api_mode: is_api_mode
		end

feature -- Route Registration

	get (a_path: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register GET route handler.
		require
			server_created: server /= Void
			path_not_empty: not a_path.is_empty
			handler_not_void: a_handler /= Void
		do
			logger.debug_log ("Registering GET " + a_path)
			if attached server as s then
				s.on_get (a_path, a_handler)
			end
		end

	post (a_path: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register POST route handler.
		require
			server_created: server /= Void
			path_not_empty: not a_path.is_empty
			handler_not_void: a_handler /= Void
		do
			logger.debug_log ("Registering POST " + a_path)
			if attached server as s then
				s.on_post (a_path, a_handler)
			end
		end

	put (a_path: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register PUT route handler.
		require
			server_created: server /= Void
			path_not_empty: not a_path.is_empty
			handler_not_void: a_handler /= Void
		do
			logger.debug_log ("Registering PUT " + a_path)
			if attached server as s then
				s.on_put (a_path, a_handler)
			end
		end

	delete (a_path: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register DELETE route handler.
		require
			server_created: server /= Void
			path_not_empty: not a_path.is_empty
			handler_not_void: a_handler /= Void
		do
			logger.debug_log ("Registering DELETE " + a_path)
			if attached server as s then
				s.on_delete (a_path, a_handler)
			end
		end

feature -- Server Control

	start
			-- Start the server.
			-- Blocks until server is stopped.
		require
			server_created: server /= Void
		do
			logger.info ("Starting server on port " + port.out)
			if attached server as s then
				s.start
			end
		end

feature -- Response Helpers

	quick_send_json (a_response: SIMPLE_WEB_SERVER_RESPONSE; a_json: SIMPLE_JSON_VALUE)
			-- Send JSON response with proper content type.
		require
			response_not_void: a_response /= Void
			json_not_void: a_json /= Void
		do
			a_response.send_json (a_json.to_json_string.to_string_8)
		end

	quick_send_text (a_response: SIMPLE_WEB_SERVER_RESPONSE; a_text: STRING)
			-- Send plain text response.
		require
			response_not_void: a_response /= Void
		do
			a_response.send_text (a_text)
		end

	quick_send_html (a_response: SIMPLE_WEB_SERVER_RESPONSE; a_html: STRING)
			-- Send HTML response.
		require
			response_not_void: a_response /= Void
		do
			a_response.send_html (a_html)
		end

	quick_send_error (a_response: SIMPLE_WEB_SERVER_RESPONSE; a_code: INTEGER; a_message: STRING)
			-- Send error response.
		require
			response_not_void: a_response /= Void
			valid_code: a_code >= 400
		do
			a_response.send_error (a_code, a_message)
		end

feature -- Status

	port: INTEGER
			-- Server port number.

	is_api_mode: BOOLEAN
			-- Is server in API mode?

feature -- Advanced Access

	server: detachable SIMPLE_WEB_SERVER
			-- Access underlying web server for advanced operations.

feature {NONE} -- Implementation

	logger: SIMPLE_LOGGER
			-- Logger for debugging.

	static_folder: detachable STRING
			-- Folder for static file serving.

	handle_static_file (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Handle request for static file.
		local
			l_path, l_full_path: STRING
			l_file: RAW_FILE
			l_content: STRING
			l_ext: STRING
		do
			l_path := req.path
			if l_path.same_string ("/") then
				l_path := "/index.html"
			end

			if attached static_folder as folder then
				l_full_path := folder + l_path.twin
				l_full_path.replace_substring_all ("/", "\")

				create l_file.make_with_name (l_full_path)
				if l_file.exists and then l_file.is_readable then
					l_file.open_read
					create l_content.make (l_file.count)
					l_file.read_stream (l_file.count)
					l_content := l_file.last_string
					l_file.close

					-- Set content type based on extension
					l_ext := l_path.substring (l_path.last_index_of ('.', l_path.count) + 1, l_path.count)
					res.send_binary (l_content, mime_type_for (l_ext))
					logger.debug_log ("Served: " + l_path)
				else
					res.send_not_found ("Not Found: " + l_path)
					logger.debug_log ("Not found: " + l_path)
				end
			end
		end

	mime_type_for (a_extension: STRING): STRING
			-- Get MIME type for file extension.
		local
			l_ext: STRING
		do
			l_ext := a_extension.as_lower
			if l_ext.same_string ("html") or l_ext.same_string ("htm") then
				Result := "text/html"
			elseif l_ext.same_string ("css") then
				Result := "text/css"
			elseif l_ext.same_string ("js") then
				Result := "application/javascript"
			elseif l_ext.same_string ("json") then
				Result := "application/json"
			elseif l_ext.same_string ("png") then
				Result := "image/png"
			elseif l_ext.same_string ("jpg") or l_ext.same_string ("jpeg") then
				Result := "image/jpeg"
			elseif l_ext.same_string ("gif") then
				Result := "image/gif"
			elseif l_ext.same_string ("svg") then
				Result := "image/svg+xml"
			elseif l_ext.same_string ("ico") then
				Result := "image/x-icon"
			elseif l_ext.same_string ("txt") then
				Result := "text/plain"
			elseif l_ext.same_string ("xml") then
				Result := "application/xml"
			elseif l_ext.same_string ("pdf") then
				Result := "application/pdf"
			else
				Result := "application/octet-stream"
			end
		end

invariant
	logger_exists: logger /= Void
	valid_port: port > 0 and port < 65536

end
