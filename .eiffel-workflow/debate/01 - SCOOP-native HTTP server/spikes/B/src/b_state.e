class B_STATE
feature
	counter: separate B_COUNTER
			-- Shared service object: one per process, own processor.
		once ("PROCESS")
			create Result.make
		end
	bump_and_read (a_counter: separate B_COUNTER): INTEGER
		do
			a_counter.bump
			Result := a_counter.hits
		end
end
