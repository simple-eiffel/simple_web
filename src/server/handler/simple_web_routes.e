note
	description: "[
		A route table built for one request, on the processor that serves
		it. Handlers are agents whose targets live on that same processor,
		so nothing crosses a processor boundary: that is what makes routing
		legal under SCOOP, and it is just as sound under threads. The first
		registered route whose method and pattern fit wins; a middleware
		pipeline runs around the dispatch exactly as SIMPLE_WEB_SERVER's did.
		Cheap to build (a few objects), so building one per request costs
		nothing measurable.
	]"
	author: "Larry Rix"

class
	SIMPLE_WEB_ROUTES

inherit
	SIMPLE_WEB_DISPATCHER

create
	make

feature {NONE} -- Initialization

	make
		do
			create routes.make (16)
			create pipeline.make
		ensure
			empty: count = 0
			no_middleware: middleware_count = 0
			nothing_dispatched: dispatched = 0 and not_found = 0
		end

feature -- Access

	count: INTEGER
			-- Registered routes.
		do
			Result := routes.count
		end

	middleware_count: INTEGER
		do
			Result := pipeline.count
		end

	dispatched: INTEGER
			-- Requests dispatched so far, matched or not.

	not_found: INTEGER
			-- Requests that matched no route.

	find_route (a_method: STRING; a_path: STRING_32): detachable SIMPLE_WEB_SERVER_ROUTE
			-- The first registered route matching `a_method' and `a_path'.
		require
			method_given: not a_method.is_empty
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > routes.count or Result /= Void
			loop
				if routes [i].matches (a_method, a_path) then
					Result := routes [i]
				end
				i := i + 1
			end
		ensure
			found_matches: attached Result as r implies r.matches (a_method, a_path)
		end

	has_route (a_method: STRING; a_path: STRING_32): BOOLEAN
			-- Would `a_method' `a_path' be dispatched to a handler?
		require
			method_given: not a_method.is_empty
		do
			Result := find_route (a_method, a_path) /= Void
		ensure
			definition: Result = (find_route (a_method, a_path) /= Void)
		end

feature -- Registration

	on_get (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
		require
			pattern_rooted: a_pattern.starts_with ("/")
		do
			on ("GET", a_pattern, a_handler)
		ensure
			one_more: count = old count + 1
		end

	on_post (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
		require
			pattern_rooted: a_pattern.starts_with ("/")
		do
			on ("POST", a_pattern, a_handler)
		ensure
			one_more: count = old count + 1
		end

	on_put (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
		require
			pattern_rooted: a_pattern.starts_with ("/")
		do
			on ("PUT", a_pattern, a_handler)
		ensure
			one_more: count = old count + 1
		end

	on_delete (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
		require
			pattern_rooted: a_pattern.starts_with ("/")
		do
			on ("DELETE", a_pattern, a_handler)
		ensure
			one_more: count = old count + 1
		end

	on_patch (a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
		require
			pattern_rooted: a_pattern.starts_with ("/")
		do
			on ("PATCH", a_pattern, a_handler)
		ensure
			one_more: count = old count + 1
		end

	on (a_method, a_pattern: STRING; a_handler: PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE])
			-- Register `a_handler' for `a_method' requests matching `a_pattern'
			-- (segments in braces, "/users/{id}", match any one segment).
		require
			method_given: not a_method.is_empty
			pattern_rooted: a_pattern.starts_with ("/")
		local
			l_route: SIMPLE_WEB_SERVER_ROUTE
		do
			create l_route.make (a_method, a_pattern, a_handler)
			routes.extend (l_route)
		ensure
			one_more: count = old count + 1
			reachable: has_route (a_method, a_pattern.to_string_32)
		end

	use (a_middleware: SIMPLE_WEB_MIDDLEWARE)
			-- Run `a_middleware' around every dispatch, after those already registered.
		do
			pipeline.use (a_middleware)
		ensure
			one_more: middleware_count = old middleware_count + 1
			routes_unchanged: count = old count
		end

feature -- Dispatch

	dispatch (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
			-- Run the middleware pipeline around the matching handler; 404 when none matches.
		do
			dispatched := dispatched + 1
			pipeline.execute (a_request, a_response, agent dispatch_to_route (a_request, a_response))
		ensure
			counted: dispatched = old dispatched + 1
			routes_unchanged: count = old count
		end

feature {NONE} -- Implementation

	routes: ARRAYED_LIST [SIMPLE_WEB_SERVER_ROUTE]

	pipeline: SIMPLE_WEB_MIDDLEWARE_PIPELINE

	dispatch_to_route (a_request: SIMPLE_WEB_SERVER_REQUEST; a_response: SIMPLE_WEB_SERVER_RESPONSE)
			-- The end of the pipeline: path parameters, then the handler, else 404.
		local
			l_path: STRING_32
			l_params: HASH_TABLE [STRING_32, STRING_32]
		do
			l_path := a_request.path
			if attached find_route (a_request.method, l_path) as l_route then
				l_params := l_route.extract_path_parameters (l_path)
				across l_params as ic loop
					a_request.set_path_parameter (@ic.key, ic)
				end
				l_route.handler.call ([a_request, a_response])
			else
				not_found := not_found + 1
				a_response.set_not_found
				a_response.send_json ("{%"error%":%"Not Found%",%"path%":%"" + json_escaped (l_path) + "%"}")
			end
		end

	json_escaped (a_text: READABLE_STRING_32): STRING_8
			-- `a_text' as the content of a JSON string: quote and backslash escaped,
			-- controls replaced, the rest as UTF-8.
		local
			l_out: STRING_32
			i: INTEGER
			c: CHARACTER_32
		do
			create l_out.make (a_text.count + 8)
			from
				i := 1
			until
				i > a_text.count
			loop
				c := a_text [i]
				if c = '%"' then
					l_out.append_string_general ("\%"")
				elseif c = '\' then
					l_out.append_string_general ("\\")
				elseif c.natural_32_code < 32 then
					l_out.append_character (' ')
				else
					l_out.append_character (c)
				end
				i := i + 1
			end
			Result := {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (l_out)
		ensure
			no_raw_quote: not Result.has ('"') or else Result.occurrences ('"') = Result.occurrences ('\')
			no_controls: across Result as ch all ch.code >= 32 end
		end

invariant
	counts_non_negative: dispatched >= 0 and not_found >= 0
	not_found_within_dispatched: not_found <= dispatched

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
