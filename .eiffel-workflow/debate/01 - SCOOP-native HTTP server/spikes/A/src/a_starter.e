class A_STARTER
create make
feature
	make do end
	start
		local l_s: A_SERVER
		do
			create l_s.make (18081)
			l_s.start
		end
end
