class B2_PART
create make
feature
	id: INTEGER
	make (a_id: INTEGER) do id := a_id end
	page (q: SIMPLE_WEB_SERVER_REQUEST; r: SIMPLE_WEB_SERVER_RESPONSE)
		do r.send_text ("part" + id.out) end
end
