note
	description: "[
		Hand-off spike root: starts the listener on its own processor, then keeps
		running (a tick every 200 ms, standing in for a GUI loop) for 30 s and
		ends the process.
	]"

class
	HO_ROOT

create
	make

feature {NONE} -- Initialization

	make
		local
			l_listener: separate HO_LISTENER
			l_env: EXECUTION_ENVIRONMENT
			i: INTEGER
		do
			create l_listener.make (18090)
			start (l_listener)
			create l_env
			from i := 1 until i > 150 loop
				print ("tick " + i.out + "%N")
				io.output.flush
				l_env.sleep (200_000_000)
				i := i + 1
			end
			c_exit (0)
		end

	start (a_listener: separate HO_LISTENER)
			-- Asynchronous: `run' loops on the listener's processor.
		do
			a_listener.run
		end

	c_exit (a_code: INTEGER)
		external
			"C inline use <stdlib.h>"
		alias
			"_exit((int) $a_code);"
		end

end
