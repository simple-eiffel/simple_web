class A_APP
create make
feature
	table: HASH_TABLE [FUNCTION [STRING_8], STRING_8]
			-- Handler agents, created on THIS object's processor.
	make
		do
			create table.make (8)
			table.force (agent fast, "/fast")
			table.force (agent slow, "/slow")
		end
	reply (a_path: separate STRING_8): STRING_8
			-- Body for `a_path'; Void-free; "" when no route.
		local l_p: STRING_8
		do
			create l_p.make_from_separate (a_path)
			if attached table.item (l_p) as l_h then
				Result := l_h.item ([])
			else
				create Result.make_empty
			end
		end
	fast: STRING_8
		do
			Result := "fast"
		end
	slow: STRING_8
		local l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			l_env.sleep (2_000_000_000)
			Result := "slow"
		end
end
