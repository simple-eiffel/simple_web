class
	ADJ_HANDLER

inherit
	SIMPLE_WEB_REQUEST_HANDLER
	ADJ_SHARED

create
	make

feature {NONE} -- Setup

	setup_routes
		do
			routes.on_get ("/fast", agent fast)
			routes.on_get ("/slow", agent slow)
			routes.on_get ("/hit", agent hit)
		end

feature {NONE} -- Handlers (bodies call log.info exactly as bible_htmx handlers do)

	fast (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		do
			r.send_text ("fast")
		end

	slow (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		local
			l_env: EXECUTION_ENVIRONMENT
		do
			log.info ("slow begin")
			create l_env
			l_env.sleep (2_000_000_000)
			r.send_text ("slow")
		end

	hit (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		local
			l_n: STRING_8
		do
			if attached q.query_parameter ("n") as l_v then
				l_n := l_v.to_string_8
			else
				l_n := "?"
			end
			log.info ("hit n=" + l_n)
			r.send_text ("n=" + l_n + " x=" + query_value.out)
		end

end
