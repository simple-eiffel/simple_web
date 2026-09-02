note
	description: "[
		A string-to-string table that is safe to reach from any processor:
		every argument is accepted as `separate' and copied on the way in,
		every result is a fresh string the caller copies on the way out.
		SIMPLE_WEB_SHARED keeps the one instance the whole process uses.
	]"
	author: "Larry Rix"

class
	SIMPLE_WEB_SETTINGS

create
	make

feature {NONE} -- Initialization

	make
		do
			create table.make (16)
		ensure
			empty: count = 0
		end

feature -- Access

	count: INTEGER
		do
			Result := table.count
		end

	has (a_key: separate READABLE_STRING_8): BOOLEAN
		do
			Result := table.has (local_copy (a_key))
		end

	item (a_key: separate READABLE_STRING_8): detachable STRING_8
			-- The value stored under `a_key', or Void.
		do
			Result := table [local_copy (a_key)]
		ensure
			consistent: (Result /= Void) = has (a_key)
		end

feature -- Element change

	put (a_key, a_value: separate READABLE_STRING_8)
			-- Store `a_value' under `a_key', replacing any previous value.
		require
			key_given: not a_key.is_empty
		do
			table.force (local_copy (a_value), local_copy (a_key))
		ensure
			stored: has (a_key)
			value_kept: attached item (a_key) as v and then v.same_string (local_copy (a_value))
			bounded_growth: count <= old count + 1
		end

feature {NONE} -- Implementation

	table: HASH_TABLE [STRING_8, STRING_8]

	local_copy (a_text: separate READABLE_STRING_8): STRING_8
			-- `a_text' on this processor.
		do
			create Result.make_from_separate (a_text)
		ensure
			same_length: Result.count = a_text.count
		end

invariant
	table_attached: table /= Void

note
	copyright: "Copyright (c) 2026, Larry Rix"
	license: "MIT License"

end
