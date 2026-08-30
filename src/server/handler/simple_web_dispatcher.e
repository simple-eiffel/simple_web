note
	description: "[
		Export marker: the classes allowed to set a request's path
		parameters are exactly the dispatchers - SIMPLE_WEB_ROUTES (both
		modes) and SIMPLE_WEB_SERVER_EXECUTION (thread mode). Exporting to
		this deferred ancestor lets SIMPLE_WEB_SERVER_REQUEST name one class
		that exists in every build instead of a thread-only one.
	]"
	author: "Larry Rix"

deferred class
	SIMPLE_WEB_DISPATCHER

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
