class A_SERVER
inherit WSF_DEFAULT_SERVICE [A_EXECUTION]
create make
feature
	make (a_port: INTEGER)
		do
			initialize
			set_service_option ("port", a_port)
		end
	start
		do
			launch (service_options)
		end
end
