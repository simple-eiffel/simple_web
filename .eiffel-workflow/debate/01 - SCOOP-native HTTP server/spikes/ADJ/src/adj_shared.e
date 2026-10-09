note
	description: "Adjudicator spike: HTMX_SHARED ported to SCOOP. Logger and DB path per processor, configured from SIMPLE_WEB_SHARED strings."

class
	ADJ_SHARED

inherit
	SIMPLE_WEB_SHARED

feature -- Shared logger (was once ("PROCESS"), now one per processor)

	log: SIMPLE_LOGGER
			-- This processor's logger, writing to the shared log file.
		once
			create Result.make
			if attached shared_item ("log") as l_path and then not l_path.is_empty then
				Result.add_file_output (l_path)
			end
		end

feature -- Database access

	shared_db_path: STRING_8
			-- Path to the database, copied to this processor.
		once
			if attached shared_item ("db") as l_path then
				Result := l_path
			else
				create Result.make_empty
			end
		end

	query_value: INTEGER
			-- Open a connection on this processor (as HTMX_SHARED.scholar does), read t.x, close.
		local
			l_db: SIMPLE_SQL_DATABASE
			l_res: SIMPLE_SQL_RESULT
		do
			create l_db.make (shared_db_path)
			l_res := l_db.query ("SELECT x FROM t")
			if not l_res.is_empty then
				Result := l_res.first.integer_value ("x")
			end
			l_db.close
		end

end
