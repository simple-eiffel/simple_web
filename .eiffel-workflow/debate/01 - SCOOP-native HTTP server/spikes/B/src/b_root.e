class B_ROOT
inherit SIMPLE_WEB_SHARED
create make
feature
	make
		local
			l_server: separate SIMPLE_WEB_HANDLER_SERVER [B_HANDLER]
			l_env: EXECUTION_ENVIRONMENT
			l_t: TIME
			i: INTEGER
		do
			shared_put ("db", "D:/data/bible.db")
			create l_server.make (18082)
			start_server (l_server)
			create l_env
			from i := 1 until i > 60 loop
				create l_t.make_now
				print ("tick " + i.out + " t=" + l_t.fine_second.out + "%N")
				io.output.flush
				l_env.sleep (200_000_000)
				i := i + 1
			end
			c_exit (0)
		end
	start_server (a_server: separate SIMPLE_WEB_HANDLER_SERVER [B_HANDLER])
		do a_server.start end
	c_exit (a_code: INTEGER)
		external "C inline use <stdlib.h>"
		alias "_exit((int) $a_code);"
		end
end
