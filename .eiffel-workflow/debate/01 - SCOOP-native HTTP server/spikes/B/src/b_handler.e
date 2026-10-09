class B_HANDLER
inherit
	SIMPLE_WEB_REQUEST_HANDLER
	SIMPLE_WEB_SHARED
	B_STATE
create make
feature {NONE}
	setup_routes
		do
			routes.on_get ("/fast", agent fast)
			routes.on_get ("/slow", agent slow)
			routes.on_get ("/db", agent db)
			routes.on_get ("/hits", agent hits)
		end
	fast (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		do r.send_text ("fast") end
	slow (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		local l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			l_env.sleep (2_000_000_000)
			r.send_text ("slow")
		end
	db (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		do
			if attached shared_item ("db") as l_p then r.send_text ("db=" + l_p) else r.send_text ("db=VOID") end
		end
	hits (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		do r.send_text ("hits=" + bump_and_read (counter).out) end
end
