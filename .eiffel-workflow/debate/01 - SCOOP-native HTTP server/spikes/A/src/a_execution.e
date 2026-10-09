class A_EXECUTION
inherit
	WSF_EXECUTION
	A_SHARED
create make
feature
	execute
		local
			l_req: SIMPLE_WEB_SERVER_REQUEST
			l_res: SIMPLE_WEB_SERVER_RESPONSE
			l_body: STRING_8
		do
			create l_req.make (request)
			create l_res.make (response)
			l_body := via_registry (registry, l_req.path.to_string_8)
			if l_body.is_empty then
				l_res.send_error (404, "nope")
			else
				l_res.send_text (l_body)
			end
		end
	via_registry (a_reg: separate A_REGISTRY; a_path: STRING_8): STRING_8
		do
			create Result.make_empty
			if attached a_reg.app as l_app then
				Result := call_app (l_app, a_path)
			end
		end
	call_app (a_app: separate A_APP; a_path: STRING_8): STRING_8
		do
			create Result.make_from_separate (a_app.reply (a_path))
		end
end
