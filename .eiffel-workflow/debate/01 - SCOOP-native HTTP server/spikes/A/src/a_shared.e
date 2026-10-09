class A_SHARED
feature
	registry: separate A_REGISTRY
		once ("PROCESS")
			create Result.make
		end
end
