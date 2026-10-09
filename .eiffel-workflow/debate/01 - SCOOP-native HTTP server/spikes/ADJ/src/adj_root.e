class
	ADJ_ROOT

inherit
	ADJ_SHARED

create
	make

feature

	make
		local
			l_server: separate SIMPLE_WEB_HANDLER_SERVER [ADJ_HANDLER]
			l_env: EXECUTION_ENVIRONMENT
			l_db: SIMPLE_SQL_DATABASE
			l_t: TIME
			i: INTEGER
		do
			shared_put ("log", "C:/Users/LJR19/AppData/Local/Temp/claude/D--prod/8cee566e-b341-44e8-80e4-cd2fc3dda70b/scratchpad/adj/run/adj.log")
			shared_put ("db", "C:/Users/LJR19/AppData/Local/Temp/claude/D--prod/8cee566e-b341-44e8-80e4-cd2fc3dda70b/scratchpad/adj/run/adj.db")
			create l_db.make (shared_db_path)
			l_db.execute ("CREATE TABLE IF NOT EXISTS t (x INTEGER)")
			l_db.execute ("DELETE FROM t")
			l_db.execute ("INSERT INTO t VALUES (42)")
			l_db.close
			log.info ("root started")
			create l_server.make (18085)
			start_server (l_server)
			create l_env
			from i := 1 until i > 75 loop
				create l_t.make_now
				print ("tick " + i.out + " t=" + l_t.fine_second.out + "%N")
				io.output.flush
				l_env.sleep (200_000_000)
				i := i + 1
			end
			c_exit (0)
		end

	start_server (a_server: separate SIMPLE_WEB_HANDLER_SERVER [ADJ_HANDLER])
		do
			a_server.start
		end

	c_exit (a_code: INTEGER)
		external "C inline use <stdlib.h>"
		alias "_exit((int) $a_code);"
		end

end
