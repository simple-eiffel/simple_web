class A_HOST_APP
inherit A_APP
create make
feature
	server: detachable A_SERVER
	start
		local l_s: A_SERVER
		do
			create l_s.make (18081)
			server := l_s
			l_s.start
		end
end
