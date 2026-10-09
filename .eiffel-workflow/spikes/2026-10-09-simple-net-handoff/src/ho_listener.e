note
	description: "[
		Hand-off spike: the accepting processor. Accepts on 127.0.0.1 with
		simple_net, creates a fresh worker processor per connection and hands it
		the raw handle. Only expanded values cross, so `dispatch' stays
		asynchronous: a reference to an object of this processor would make the
		call synchronous (lock passing) and serialize every connection.
	]"

class
	HO_LISTENER

create
	make

feature {NONE} -- Initialization

	make (a_port: INTEGER)
		do
			port := a_port
		end

feature -- Access

	port: INTEGER

	accepted: INTEGER
			-- Connections handed off so far.

feature -- Basic operations

	run
			-- Listen and hand off forever.
		local
			l_server: SERVER_SOCKET
			l_handle: POINTER
			l_worker: separate HO_WORKER
		do
			create l_server.make_for_address (create {ADDRESS}.make_for_host_port ("127.0.0.1", port))
			l_server.set_timeout (3600.0) -- an accept timeout is terminal in simple_net 1.2.0
			if l_server.listen (128) then
				print ("listening on 127.0.0.1:" + port.out + "%N")
				io.output.flush
				from until l_server.is_error loop
					l_handle := l_server.accept_handle
					if l_handle /= default_pointer then
						create l_worker
						dispatch (l_worker, l_handle, l_server.last_accepted_port)
						accepted := accepted + 1
					end
				end
				print ("listener stopped: error " + l_server.last_error_code.out + "%N")
			else
				print ("listen failed: " + l_server.last_error_code.out + "%N")
			end
			io.output.flush
		end

feature {NONE} -- Implementation

	dispatch (a_worker: separate HO_WORKER; a_handle: POINTER; a_port: INTEGER)
			-- Asynchronous: `serve' runs on the worker's processor.
		do
			a_worker.serve (a_handle, a_port)
		end

end
