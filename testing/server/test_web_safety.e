note
	description: "[
		Safety tests (2026-11-22): the quick static file server refuses paths
		that leave its folder and listens on this machine by default; the
		hybrid client refuses URLs and headers that would become extra curl
		options, and quotes every argument by the Windows rules.
	]"
	author: "Larry Rix"

class
	TEST_WEB_SAFETY

inherit
	TEST_SET_BASE

feature -- Static paths

	test_static_path_accepts_ordinary_files
			-- Ordinary rooted paths are served.
		note
			testing: "covers/{SIMPLE_WEB_QUICK}.is_safe_static_path"
		local
			web: SIMPLE_WEB_QUICK
		do
			create web.make
			assert ("index", web.is_safe_static_path ("/index.html"))
			assert ("nested", web.is_safe_static_path ("/css/site.css"))
			assert ("dots inside a name", web.is_safe_static_path ("/js/app-1.2.3.min.js"))
			assert ("space inside a name", web.is_safe_static_path ("/img/a b.png"))
			assert ("unicode", web.is_safe_static_path ({STRING_32} "/caf%/233/.html"))
			assert ("not a device", web.is_safe_static_path ("/console.html"))
			assert ("COM10 is a file", web.is_safe_static_path ("/COM10"))
		end

	test_static_path_refuses_escapes
			-- Every way out of the folder is refused.
		note
			testing: "covers/{SIMPLE_WEB_QUICK}.is_safe_static_path"
		local
			web: SIMPLE_WEB_QUICK
		do
			create web.make
			assert_false ("parent", web.is_safe_static_path ("/../secret.txt"))
			assert_false ("deep parent", web.is_safe_static_path ("/a/../../b"))
			assert_false ("bare parent", web.is_safe_static_path ("/.."))
			assert_false ("three dots", web.is_safe_static_path ("/.../x"))
			assert_false ("current", web.is_safe_static_path ("/./x"))
			assert_false ("dot folder", web.is_safe_static_path ("/.git/config"))
			assert_false ("dot file", web.is_safe_static_path ("/.env"))
			assert_false ("backslash parent", web.is_safe_static_path ("/a\..\..\b"))
			assert_false ("drive letter", web.is_safe_static_path ("/C:/Windows/win.ini"))
			assert_false ("alternate stream", web.is_safe_static_path ("/a.txt::$DATA"))
			assert_false ("UNC style", web.is_safe_static_path ("//server/share"))
			assert_false ("empty segment", web.is_safe_static_path ("/a//b"))
			assert_false ("trailing slash", web.is_safe_static_path ("/dir/"))
			assert_false ("not rooted", web.is_safe_static_path ("x/y"))
			assert_false ("empty", web.is_safe_static_path (""))
			assert_false ("root only", web.is_safe_static_path ("/"))
			assert_false ("trailing dot alias", web.is_safe_static_path ("/file.txt."))
			assert_false ("trailing space alias", web.is_safe_static_path ("/file.txt "))
			assert_false ("control character", web.is_safe_static_path ("/a%Tb"))
			assert_false ("NUL", web.is_safe_static_path ("/a%Ub"))
		end

	test_static_path_refuses_device_names
			-- Windows device names read a device, not a file.
		note
			testing: "covers/{SIMPLE_WEB_QUICK}.is_safe_static_path"
		local
			web: SIMPLE_WEB_QUICK
		do
			create web.make
			assert_false ("CON", web.is_safe_static_path ("/CON"))
			assert_false ("con.txt", web.is_safe_static_path ("/con.txt"))
			assert_false ("NUL in a folder", web.is_safe_static_path ("/a/NUL"))
			assert_false ("aux", web.is_safe_static_path ("/aux"))
			assert_false ("COM1", web.is_safe_static_path ("/COM1"))
			assert_false ("lpt9.log", web.is_safe_static_path ("/lpt9.log"))
		end

	test_static_file_path_uses_platform_separator
			-- The file name joins folder and path with this platform's separator.
		note
			testing: "covers/{SIMPLE_WEB_QUICK}.static_file_path"
		local
			web: SIMPLE_WEB_QUICK
			s: STRING_32
		do
			create web.make
			create s.make_filled ({OPERATING_ENVIRONMENT}.directory_separator, 1)
			assert_strings_equal ("joined", ({STRING_32} "root" + s + "a" + s + "b.txt").to_string_8, web.static_file_path ("root", "/a/b.txt").to_string_8)
			assert_strings_equal ("folder slash dropped", ({STRING_32} "root" + s + "b.txt").to_string_8, web.static_file_path ("root/", "/b.txt").to_string_8)
		end

feature -- Listening address

	test_quick_listens_on_this_machine_by_default
			-- A quick server binds 127.0.0.1 unless told otherwise.
		note
			testing: "covers/{SIMPLE_WEB_QUICK}.make", "covers/{SIMPLE_WEB_QUICK}.json_api", "covers/{SIMPLE_WEB_SERVER}.set_bind_address"
		local
			web: SIMPLE_WEB_QUICK
		do
			create web.make
			assert ("loopback by default", attached web.bind_address as a and then a.same_string ("127.0.0.1"))
			web.json_api (18091)
			assert ("handed to the server", attached web.server as al_s and then attached al_s.bind_address as a and then a.same_string ("127.0.0.1"))
		end

	test_quick_every_interface_only_on_request
			-- Every interface is a deliberate choice.
		note
			testing: "covers/{SIMPLE_WEB_QUICK}.listen_on_every_interface"
		local
			web: SIMPLE_WEB_QUICK
		do
			create web.make
			web.listen_on_every_interface
			web.json_api (18092)
			assert ("no address: every interface", attached web.server as al_s and then al_s.bind_address = Void)
			create web.make
			web.set_bind_address ("192.168.1.10")
			web.json_api (18093)
			assert ("named address", attached web.server as al_s and then attached al_s.bind_address as a and then a.same_string ("192.168.1.10"))
		end

feature -- Hybrid client

	test_quoted_argument_follows_windows_rules
			-- Backslashes double only before a quote; quotes get one more.
		note
			testing: "covers/{SIMPLE_WEB_HYBRID_CLIENT}.quoted_argument"
		local
			client: SIMPLE_WEB_HYBRID_CLIENT
		do
			create client.make
			assert_strings_equal ("plain", "%"abc%"", client.quoted_argument ("abc"))
			assert_strings_equal ("empty", "%"%"", client.quoted_argument (""))
			assert_strings_equal ("quote", "%"a\%"b%"", client.quoted_argument ("a%"b"))
			assert_strings_equal ("lone backslash", "%"a\b%"", client.quoted_argument ("a\b"))
			assert_strings_equal ("backslash then quote", "%"a\\\%"b%"", client.quoted_argument ("a\%"b"))
			assert_strings_equal ("trailing backslash", "%"end\\%"", client.quoted_argument ("end\"))
			assert_strings_equal ("json escape kept", "%"{\%"t\%":\%"a\nb\%"}%"", client.quoted_argument ("{%"t%":%"a\nb%"}"))
		end

	test_hybrid_refuses_unsafe_urls
			-- A URL that would become curl options is refused with 400.
		note
			testing: "covers/{SIMPLE_WEB_HYBRID_CLIENT}.post_json", "covers/{SIMPLE_WEB_HYBRID_CLIENT}.is_safe_url"
		local
			client: SIMPLE_WEB_HYBRID_CLIENT
			r: SIMPLE_WEB_RESPONSE
		do
			create client.make
			r := client.post_json ("http://127.0.0.1:1/ -o C:\evil.txt", "{}")
			assert_integers_equal ("space refused", 400, r.status_code)
			assert ("says why", r.body.starts_with ("Refused"))
			r := client.put_json ("http://127.0.0.1:1/%" --upload-file %"C:\secret", "{}")
			assert_integers_equal ("quote refused", 400, r.status_code)
			assert_false ("file scheme", client.is_safe_url ("file:///etc/passwd"))
			assert_false ("option as URL", client.is_safe_url ("-K/tmp/config"))
			assert_false ("tab", client.is_safe_url ("http://a%Tb"))
			assert ("ordinary", client.is_safe_url ("https://api.example.com/v1/x?a=1&b=2"))
		end

	test_hybrid_refuses_unsafe_headers
			-- Header names must be tokens; values must hold no line break.
		note
			testing: "covers/{SIMPLE_WEB_HYBRID_CLIENT}.post_json_with_headers", "covers/{SIMPLE_WEB_HYBRID_CLIENT}.is_safe_header"
		local
			client: SIMPLE_WEB_HYBRID_CLIENT
			h: STRING_TABLE [STRING]
		do
			create client.make
			create h.make (1)
			h.put ("t%R%NX-Evil: 1", "Authorization")
			assert_integers_equal ("line break refused", 400, client.post_json_with_headers ("http://127.0.0.1:1/", "{}", h).status_code)
			create h.make (1)
			h.put ("v", "Bad Name")
			assert_integers_equal ("space in name refused", 400, client.post_json_with_headers ("http://127.0.0.1:1/", "{}", h).status_code)
			assert ("ordinary", client.is_safe_header ("X-Api-Key", "abc %"quoted%" value"))
		end

	test_curl_command_shape
			-- URL after --url, every argument quoted, body from stdin.
		note
			testing: "covers/{SIMPLE_WEB_HYBRID_CLIENT}.curl_command"
		local
			client: SIMPLE_WEB_HYBRID_CLIENT
			h: STRING_TABLE [STRING]
			l_cmd: STRING_8
		do
			create client.make
			create h.make (1)
			h.put ("Bearer t%"q", "Authorization")
			l_cmd := client.curl_command ("POST", "http://127.0.0.1:1/x?a=b&c=d", h)
			assert ("program and method", l_cmd.starts_with ("curl -s -X %"POST%""))
			assert ("url is not an option", l_cmd.has_substring (" --url %"http://127.0.0.1:1/x?a=b&c=d%""))
			assert ("header name and value", l_cmd.has_substring (" -H %"Authorization: Bearer t\%"q%""))
			assert ("body from stdin", l_cmd.ends_with (" --data-binary @-"))
		end

	test_hybrid_safe_request_runs_curl
			-- A safe request starts curl: with nothing listening, curl reports
			-- HTTP code 000, which becomes 503 with the "No HTTP answer" body
			-- (not the 400 refusal, and no longer a precondition failure).
		note
			testing: "covers/{SIMPLE_WEB_HYBRID_CLIENT}.post_json"
		local
			client: SIMPLE_WEB_HYBRID_CLIENT
			r: SIMPLE_WEB_RESPONSE
		do
			create client.make
			r := client.post_json ("http://127.0.0.1:1/", "{%"a%":%"x\ny%"}")
			assert_integers_equal ("curl ran and could not connect", 503, r.status_code)
			assert ("curl's own answer", r.body.starts_with ("No HTTP answer"))
		end

end
