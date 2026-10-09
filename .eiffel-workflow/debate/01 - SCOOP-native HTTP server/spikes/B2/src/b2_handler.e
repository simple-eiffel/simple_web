class B2_HANDLER
inherit
	SIMPLE_WEB_REQUEST_HANDLER
create make
feature {NONE}
	setup_routes
		local
			p: ARRAY [B2_PART]
			i, j: INTEGER
			l_part: B2_PART
		do
			create p.make_filled (create {B2_PART}.make (0), 1, 8)
			from i := 1 until i > 8 loop p.put (create {B2_PART}.make (i), i); i := i + 1 end
			routes.on_get ("/fast", agent fast)
			routes.on_get ("/slow", agent slow)
			from i := 1 until i > 20 loop
				j := (i - 1) - ((i - 1) // 8) * 8 + 1
				l_part := p.item (j)
				routes.on_get ("/r" + i.out, agent l_part.page)
				i := i + 1
			end
		end
	fast (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		do r.send_text ("fast") end
	slow (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		local l_env: EXECUTION_ENVIRONMENT
		do create l_env; l_env.sleep (2_000_000_000); r.send_text ("slow") end
end
