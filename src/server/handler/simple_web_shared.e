note
	description: "[
		Process-wide settings for request handlers, legal under SCOOP: one
		SIMPLE_WEB_SETTINGS on its own processor, reached through a
		once ("PROCESS") function of separate type (the form SCOOP requires
		of process-wide onces). The root puts strings in before starting the
		server; handlers created on request processors read them. Inherit
		from this class, or create it, wherever that is needed.

		Under threads the same code runs unchanged: `separate' is inert and
		the copies are ordinary copies.
	]"
	author: "Larry Rix"

class
	SIMPLE_WEB_SHARED

feature -- Access

	shared_settings: separate SIMPLE_WEB_SETTINGS
			-- The one settings table of this process.
		once ("PROCESS")
			create Result.make
		end

	shared_item (a_key: READABLE_STRING_8): detachable STRING_8
			-- The value stored under `a_key', copied to this processor; Void when absent.
		require
			key_given: not a_key.is_empty
		do
			Result := item_of (shared_settings, a_key)
		ensure
			consistent: (Result /= Void) = shared_has (a_key)
		end

	shared_has (a_key: READABLE_STRING_8): BOOLEAN
		require
			key_given: not a_key.is_empty
		do
			Result := has_in (shared_settings, a_key)
		end

feature -- Element change

	shared_put (a_key, a_value: READABLE_STRING_8)
			-- Store `a_value' under `a_key' for every processor to read.
		require
			key_given: not a_key.is_empty
		do
			put_into (shared_settings, a_key, a_value)
		ensure
			stored: shared_has (a_key)
			readable: attached shared_item (a_key) as v and then v.same_string (a_value)
		end

feature {NONE} -- Implementation (the separate calls, each with the settings locked)

	item_of (a_settings: separate SIMPLE_WEB_SETTINGS; a_key: READABLE_STRING_8): detachable STRING_8
		do
			if attached a_settings.item (a_key) as l_value then
				create Result.make_from_separate (l_value)
			end
		end

	has_in (a_settings: separate SIMPLE_WEB_SETTINGS; a_key: READABLE_STRING_8): BOOLEAN
		do
			Result := a_settings.has (a_key)
		end

	put_into (a_settings: separate SIMPLE_WEB_SETTINGS; a_key, a_value: READABLE_STRING_8)
		do
			a_settings.put (a_key, a_value)
		end

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
