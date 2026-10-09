class B_COUNTER
create make
feature
	make do end
	hits: INTEGER
	bump do hits := hits + 1 end
end
