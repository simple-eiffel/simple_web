class A_ROOT
inherit
	A_SHARED
	ARGUMENTS_32
create make
feature
	make
		local
			l_host: separate A_HOST_APP
			l_app: separate A_APP
			l_starter: separate A_STARTER
			i: INTEGER
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			if argument_count >= 1 and then argument (1).same_string ("split") then
				create l_app.make
				create l_starter.make
				register (registry, l_app)
				launch_starter (l_starter)
			else
				create l_host.make
				register (registry, l_host)
				launch_host (l_host)
			end
			from i := 1 until i > 100 loop
				print ("tick " + i.out + "%N")
				io.output.flush
				l_env.sleep (200_000_000)
				i := i + 1
			end
			io.output.flush
			c_exit (0)
		end
	register (a_reg: separate A_REGISTRY; a_app: separate A_APP)
		do
			a_reg.set_app (a_app)
		end
	launch_host (a_host: separate A_HOST_APP)
		do
			a_host.start
		end
	launch_starter (a_s: separate A_STARTER)
		do
			a_s.start
		end
	c_exit (a_code: INTEGER)
		external "C inline use <stdlib.h>" alias "_exit((int) $a_code);"
		end
end
