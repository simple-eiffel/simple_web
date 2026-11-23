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
			-- Create quick web facade, listening on this machine only
			-- (127.0.0.1) until `listen_on_every_interface' says otherwise.
		do
			create logger.make
			port := 8080
			bind_address := Loopback_address
		ensure
			this_machine_only: attached bind_address as al_address and then al_address.same_string (Loopback_address)
		end

feature -- Configuration

	set_bind_address (a_host: READABLE_STRING_8)
			-- Listen on `a_host' only.
		require
			host_given: not a_host.is_empty
		do
			bind_address := a_host.to_string_8
		ensure
			set: attached bind_address as al_address and then al_address.same_string (a_host)
		end

	listen_on_every_interface
			-- Listen on every interface (0.0.0.0): reachable from the network.
			-- A quick server is a beginner's tool, so this is never the default.
		do
			bind_address := Void
		ensure
			every_interface: bind_address = Void
		end

	bind_address: detachable STRING_8
			-- The one address the server listens on; Void means every interface.

	Loopback_address: STRING_8 = "127.0.0.1"
			-- This machine only.

feature -- Quick Server Setup

	serve_files (a_folder: STRING; a_port: INTEGER)
			-- Serve static files from folder.
			-- Only paths that pass `is_safe_static_path' are served.
			-- Blocks until server is stopped.
		require
			folder_not_empty: not a_folder.is_empty
			valid_port: a_port > 0 and a_port < 65536
		do
			logger.info ("Serving files from " + a_folder + " on port " + a_port.out)
			port := a_port
			static_folder := a_folder
			create server.make (a_port)
			if attached server as al_s then
				apply_bind_address (al_s)
				al_s.on_get ("/*", agent handle_static_file)
				logger.info ("Starting static file server...")
				al_s.start
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
			if attached server as al_s then
				apply_bind_address (al_s)
			end
			is_api_mode := True
		ensure
			server_created: server /= Void
			api_mode: is_api_mode
		end

feature -- Static file safety

	is_safe_static_path (a_path: READABLE_STRING_GENERAL): BOOLEAN
			-- May the request path `a_path' be served from the static folder?
			-- It must start with '/', and every segment between slashes must be
			-- non-empty and must not: start with '.' (no "..", no ".git" or
			-- ".env"), end with '.' or ' ' (Windows drops those, making aliases),
			-- hold '\', ':', a control character, or be a Windows device name
			-- (CON, NUL, COM1 ...). The rule is the same on every platform.
			-- Checked at run time in every build: the path comes from the network.
		local
			l_text: STRING_32
			l_segments: LIST [STRING_32]
			l_segment: STRING_32
			c: CHARACTER_32
			i: INTEGER
		do
			if a_path.count >= 2 and then a_path.item (1) = '/' then
				Result := True
				create l_text.make_from_string_general (a_path.substring (2, a_path.count))
				l_segments := l_text.split ('/')
				across l_segments as ic_segment until not Result loop
					l_segment := ic_segment
					if l_segment.is_empty or else l_segment.item (1) = '.' then
						Result := False
					else
						c := l_segment.item (l_segment.count)
						Result := c /= '.' and c /= ' ' and not is_device_name (l_segment)
						from i := 1 until not Result or i > l_segment.count loop
							c := l_segment.item (i)
							Result := c.natural_32_code >= 32 and c /= '\' and c /= ':' and c.natural_32_code /= 127
							i := i + 1
						end
					end
				end
			end
		ensure
			rooted: Result implies a_path.item (1) = '/'
			no_parent: Result implies not a_path.has_substring ("/.")
			no_backslash: Result implies not a_path.has ('\')
			no_drive_or_stream: Result implies not a_path.has (':')
		end

	static_file_path (a_folder, a_path: READABLE_STRING_GENERAL): STRING_32
			-- File for request path `a_path' inside `a_folder', using this
			-- platform's directory separator.
		require
			folder_given: not a_folder.is_empty
			safe: is_safe_static_path (a_path)
		do
			create Result.make (a_folder.count + a_path.count)
			Result.append_string_general (a_folder)
			if Result.item (Result.count) = '/' or Result.item (Result.count) = '\' then
				Result.remove_tail (1)
			end
			Result.append_string_general (a_path)
			Result.replace_substring_all ({STRING_32} "/", create {STRING_32}.make_filled ({OPERATING_ENVIRONMENT}.directory_separator, 1))
		ensure
			path_appended: Result.count >= a_path.count + a_folder.count - 1
		end

	is_device_name (a_segment: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_segment' (with or without an extension) a Windows device
			-- name? Opening "CON" or "COM1" reads a device, not a file.
		local
			l_base: STRING_32
			l_dot: INTEGER
		do
			create l_base.make_from_string_general (a_segment)
			l_dot := l_base.index_of ('.', 1)
			if l_dot > 0 then
				l_base.keep_head (l_dot - 1)
			end
			l_base.right_adjust
			l_base.to_upper
			if l_base.count = 3 then
				Result := across Device_names as ic some l_base.same_string_general (ic) end
			elseif l_base.count = 4 and then (l_base.starts_with ({STRING_32} "COM") or l_base.starts_with ({STRING_32} "LPT")) then
				Result := l_base.item (4).is_digit
			end
		end

	Device_names: ARRAY [STRING_8]
			-- Three-letter Windows device names.
		once
			Result := <<"CON", "PRN", "AUX", "NUL">>
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
			if attached server as al_s then
				al_s.on_get (a_path, a_handler)
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
			if attached server as al_s then
				al_s.on_post (a_path, a_handler)
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
			if attached server as al_s then
				al_s.on_put (a_path, a_handler)
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
			if attached server as al_s then
				al_s.on_delete (a_path, a_handler)
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
			if attached server as al_s then
				al_s.start
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

	apply_bind_address (a_server: SIMPLE_WEB_SERVER)
			-- Hand `bind_address' to `a_server' (Void leaves every interface).
		do
			if attached bind_address as al_address then
				a_server.set_bind_address (al_address)
			end
		end

	handle_static_file (a_req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Handle request for static file. A path that fails
			-- `is_safe_static_path' gets the same 404 as a missing file, and
			-- the request path is never echoed back.
		local
			l_path: STRING_32
			l_file: detachable RAW_FILE
			l_content: STRING
			l_ext: STRING_32
		do
			l_path := a_req.path
			if l_path.same_string ({STRING_32} "/") then
				l_path := {STRING_32} "/index.html"
			end

			if attached static_folder as al_folder then
				if is_safe_static_path (l_path) then
					create l_file.make_with_name (static_file_path (al_folder, l_path))
				end
				if attached l_file and then l_file.exists and then l_file.is_plain and then l_file.is_readable then
					l_file.open_read
					create l_content.make (l_file.count)
					l_file.read_stream (l_file.count)
					l_content := l_file.last_string
					l_file.close

					-- Set content type based on extension
					l_ext := l_path.substring (l_path.last_index_of ('.', l_path.count) + 1, l_path.count)
					if l_ext.is_valid_as_string_8 then
						res.send_binary (l_content, mime_type_for (l_ext.to_string_8))
					else
						res.send_binary (l_content, "application/octet-stream")
					end
					logger.debug_log ("Served: " + {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (l_path))
				else
					res.send_not_found ("Not Found")
					logger.debug_log ("Not found or refused: " + {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (l_path))
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
