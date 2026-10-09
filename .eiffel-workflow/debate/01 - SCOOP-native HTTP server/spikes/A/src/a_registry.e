class A_REGISTRY
create make
feature
	make do end
	app: detachable separate A_APP
	set_app (a_app: separate A_APP)
		do
			app := a_app
		end
end
