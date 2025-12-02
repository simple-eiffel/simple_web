note
	description: "[
		WMS REST API Server - Exposes warehouse operations via HTTP.

		This mock application exercises the SIMPLE_WEB server capabilities by
		wrapping the WMS_APP from simple_sql with a REST API.

		FRICTION LOG (document each pain point as discovered):

		[F1] JSON BODY PARSING - Every POST handler repeats body_as_json parsing
		     Current: if attached req.body_as_json as l_json then ... else error
		     Desired: Middleware that auto-parses and validates JSON bodies

		[F2] ERROR RESPONSE BOILERPLATE - Every error needs JSON structure
		     Current: res.set_bad_request; res.send_json ("{%"error%":...}")
		     Desired: res.send_error (400, "message") that formats JSON

		[F3] ROUTE GROUPS - All routes have /api prefix repeated
		     Current: server.on_get ("/api/warehouses", ...)
		     Desired: server.group ("/api", agent setup_api_routes)

		[F4] REQUEST VALIDATION - Manual checking of required fields
		     Current: if not l_json.has ("product_id") then error end
		     Desired: Declarative validation schema

		[F5] LOGGING - No built-in request/response logging
		     Current: Manual print statements
		     Desired: Middleware logging with timestamps

		[F6] AUTHENTICATION - No middleware pattern for auth
		     Current: Manual header check in each handler
		     Desired: Middleware that validates tokens before handlers

		Endpoints:
			GET  /api/warehouses           - List all warehouses
			GET  /api/products             - List all products
			GET  /api/products/{sku}       - Get product by SKU
			GET  /api/locations/{wh_id}    - Locations in warehouse
			GET  /api/stock/{loc_id}       - Stock at location
			GET  /api/stock/product/{id}   - Total stock for product
			POST /api/receive              - Receive stock
			POST /api/transfer             - Transfer stock between locations
			POST /api/reserve              - Reserve stock for order
			DELETE /api/reserve/{id}       - Release reservation
			GET  /api/movements/{prod_id}  - Movement history
			GET  /api/low-stock            - Products below minimum
			POST /api/setup                - Initialize test data
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	WMS_API_SERVER

inherit
	ANY
		redefine
			default_create
		end

create
	make,
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create with default port.
		do
			make (8080)
		end

	make (a_port: INTEGER)
			-- Create WMS API server on `a_port'.
		require
			valid_port: a_port > 0 and a_port < 65536
		do
			port := a_port
			create wms.make
			create server.make (a_port)
			setup_routes
		ensure
			port_set: port = a_port
		end

feature -- Access

	port: INTEGER
			-- Server port.

	server: SIMPLE_WEB_SERVER
			-- HTTP server instance.

	wms: WMS_APP
			-- WMS application instance.

feature -- Server Control

	start
			-- Start the server (blocking).
		do
			print ("WMS API Server starting on port " + port.out + "...%N")
			print ("Endpoints:%N")
			print ("  GET  /api/warehouses%N")
			print ("  GET  /api/products%N")
			print ("  GET  /api/products/{sku}%N")
			print ("  GET  /api/locations/{warehouse_id}%N")
			print ("  GET  /api/stock/{location_id}%N")
			print ("  GET  /api/stock/product/{product_id}%N")
			print ("  POST /api/receive%N")
			print ("  POST /api/transfer%N")
			print ("  POST /api/reserve%N")
			print ("  DELETE /api/reserve/{id}%N")
			print ("  GET  /api/movements/{product_id}%N")
			print ("  GET  /api/low-stock%N")
			print ("  POST /api/setup%N")
			print ("%N")
			server.start
		end

feature {NONE} -- Route Setup

	setup_routes
			-- Configure all API routes.
			-- [F3] FRICTION: Repeating /api prefix on every route
		do
			-- Health check
			server.on_get ("/health", agent handle_health)

			-- Warehouse routes
			server.on_get ("/api/warehouses", agent handle_get_warehouses)

			-- Product routes
			server.on_get ("/api/products", agent handle_get_products)
			server.on_get ("/api/products/{sku}", agent handle_get_product_by_sku)

			-- Location routes
			server.on_get ("/api/locations/{warehouse_id}", agent handle_get_locations)

			-- Stock routes
			server.on_get ("/api/stock/{location_id}", agent handle_get_stock_at_location)
			server.on_get ("/api/stock/product/{product_id}", agent handle_get_stock_for_product)

			-- Operations
			server.on_post ("/api/receive", agent handle_receive_stock)
			server.on_post ("/api/transfer", agent handle_transfer_stock)
			server.on_post ("/api/reserve", agent handle_reserve_stock)
			server.on_delete ("/api/reserve/{id}", agent handle_release_reservation)

			-- Movement history
			server.on_get ("/api/movements/{product_id}", agent handle_get_movements)

			-- Alerts
			server.on_get ("/api/low-stock", agent handle_get_low_stock)

			-- Setup (for testing)
			server.on_post ("/api/setup", agent handle_setup_test_data)
		end

feature {NONE} -- Handlers: Health

	handle_health (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- Health check endpoint.
		local
			l_json: SIMPLE_JSON_OBJECT
		do
			create l_json.make
			l_json.put_string ("ok", "status").do_nothing
			l_json.put_string ("wms-api", "service").do_nothing
			l_json.put_integer (port.to_integer_64, "port").do_nothing
			res.send_json_object (l_json)
		end

feature {NONE} -- Handlers: Warehouses

	handle_get_warehouses (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/warehouses - List all warehouses.
		local
			l_array: SIMPLE_JSON_ARRAY
			l_warehouses: ARRAYED_LIST [WMS_WAREHOUSE]
		do
			log_request (req)
			l_warehouses := wms.all_warehouses
			create l_array.make
			across l_warehouses as wh loop
				l_array.add_object (warehouse_to_json (wh)).do_nothing
			end
			res.send_json_array (l_array)
		end

feature {NONE} -- Handlers: Products

	handle_get_products (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/products - List all products.
		local
			l_array: SIMPLE_JSON_ARRAY
			l_result: SIMPLE_SQL_RESULT
		do
			log_request (req)
			l_result := wms.database.query ("SELECT * FROM products WHERE deleted_at IS NULL ORDER BY sku;")
			create l_array.make
			across l_result.rows as row loop
				l_array.add_object (product_row_to_json (row)).do_nothing
			end
			res.send_json_array (l_array)
		end

	handle_get_product_by_sku (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/products/{sku} - Get product by SKU.
		local
			l_sku: detachable STRING_32
		do
			log_request (req)
			l_sku := req.path_parameter ("sku")
			if attached l_sku as sku then
				if attached wms.find_product_by_sku (sku.to_string_8) as l_product then
					res.send_json_object (product_to_json (l_product))
				else
					send_error (res, 404, "Product not found: " + sku.to_string_8)
				end
			else
				send_error (res, 400, "Missing SKU parameter")
			end
		end

feature {NONE} -- Handlers: Locations

	handle_get_locations (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/locations/{warehouse_id} - Get locations in warehouse.
		local
			l_wh_id: detachable STRING_32
			l_array: SIMPLE_JSON_ARRAY
			l_locations: ARRAYED_LIST [WMS_LOCATION]
		do
			log_request (req)
			l_wh_id := req.path_parameter ("warehouse_id")
			if attached l_wh_id as wh_id and then wh_id.is_integer_64 then
				l_locations := wms.warehouse_locations (wh_id.to_integer_64)
				create l_array.make
				across l_locations as loc loop
					l_array.add_object (location_to_json (loc)).do_nothing
				end
				res.send_json_array (l_array)
			else
				send_error (res, 400, "Invalid warehouse_id")
			end
		end

feature {NONE} -- Handlers: Stock

	handle_get_stock_at_location (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/stock/{location_id} - Get stock at location.
		local
			l_loc_id: detachable STRING_32
			l_array: SIMPLE_JSON_ARRAY
			l_stock_list: ARRAYED_LIST [WMS_STOCK]
		do
			log_request (req)
			l_loc_id := req.path_parameter ("location_id")
			if attached l_loc_id as loc_id and then loc_id.is_integer_64 then
				l_stock_list := wms.stock_at_location (loc_id.to_integer_64)
				create l_array.make
				across l_stock_list as s loop
					l_array.add_object (stock_to_json (s)).do_nothing
				end
				res.send_json_array (l_array)
			else
				send_error (res, 400, "Invalid location_id")
			end
		end

	handle_get_stock_for_product (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/stock/product/{product_id} - Get total and available stock.
		local
			l_prod_id: detachable STRING_32
			l_json: SIMPLE_JSON_OBJECT
			l_total, l_available: INTEGER
		do
			log_request (req)
			l_prod_id := req.path_parameter ("product_id")
			if attached l_prod_id as prod_id and then prod_id.is_integer_64 then
				l_total := wms.total_stock_for_product (prod_id.to_integer_64)
				l_available := wms.available_stock_for_product (prod_id.to_integer_64)
				create l_json.make
				l_json.put_integer (prod_id.to_integer_64, "product_id").do_nothing
				l_json.put_integer (l_total.to_integer_64, "total_quantity").do_nothing
				l_json.put_integer (l_available.to_integer_64, "available_quantity").do_nothing
				l_json.put_integer ((l_total - l_available).to_integer_64, "reserved_quantity").do_nothing
				res.send_json_object (l_json)
			else
				send_error (res, 400, "Invalid product_id")
			end
		end

feature {NONE} -- Handlers: Operations

	handle_receive_stock (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- POST /api/receive - Receive stock at location.
			-- Body: {"product_id": 1, "location_id": 1, "quantity": 100, "reference": "PO-123", "user_id": 1}
		local
			l_json: detachable SIMPLE_JSON_OBJECT
			l_product_id, l_location_id, l_user_id: INTEGER_64
			l_quantity: INTEGER
			l_reference: STRING_8
			l_success: BOOLEAN
			l_response: SIMPLE_JSON_OBJECT
		do
			log_request (req)
			l_json := req.body_as_json

			if attached l_json as json then
				if json.has_key ("product_id") and json.has_key ("location_id") and
				   json.has_key ("quantity") and json.has_key ("user_id") then
					l_product_id := json.integer_item ("product_id")
					l_location_id := json.integer_item ("location_id")
					l_quantity := json.integer_item ("quantity").to_integer_32
					l_user_id := json.integer_item ("user_id")

					if json.has_key ("reference") and then attached json.string_item ("reference") as l_ref then
						l_reference := l_ref.to_string_8
					else
						l_reference := ""
					end

					if l_quantity > 0 then
						l_success := wms.receive_stock (l_product_id, l_location_id, l_quantity, l_reference, l_user_id)
						if l_success then
							create l_response.make
							l_response.put_boolean (True, "success").do_nothing
							l_response.put_string ("Stock received", "message").do_nothing
							l_response.put_integer (l_product_id, "product_id").do_nothing
							l_response.put_integer (l_location_id, "location_id").do_nothing
							l_response.put_integer (l_quantity.to_integer_64, "quantity").do_nothing
							res.set_created
							res.send_json_object (l_response)
						else
							send_error (res, 500, "Failed to receive stock")
						end
					else
						send_error (res, 400, "Quantity must be positive")
					end
				else
					send_error (res, 400, "Missing required fields: product_id, location_id, quantity, user_id")
				end
			else
				send_error (res, 400, "Invalid JSON body")
			end
		end

	handle_transfer_stock (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- POST /api/transfer - Transfer stock between locations.
		local
			l_json: detachable SIMPLE_JSON_OBJECT
			l_product_id, l_from_loc, l_to_loc, l_user_id: INTEGER_64
			l_quantity: INTEGER
			l_reference: STRING_8
			l_success: BOOLEAN
			l_response: SIMPLE_JSON_OBJECT
		do
			log_request (req)
			l_json := req.body_as_json

			if attached l_json as json then
				if json.has_key ("product_id") and json.has_key ("from_location_id") and
				   json.has_key ("to_location_id") and json.has_key ("quantity") and json.has_key ("user_id") then
					l_product_id := json.integer_item ("product_id")
					l_from_loc := json.integer_item ("from_location_id")
					l_to_loc := json.integer_item ("to_location_id")
					l_quantity := json.integer_item ("quantity").to_integer_32
					l_user_id := json.integer_item ("user_id")

					if json.has_key ("reference") and then attached json.string_item ("reference") as l_ref then
						l_reference := l_ref.to_string_8
					else
						l_reference := ""
					end

					if l_quantity > 0 then
						if l_from_loc /= l_to_loc then
							l_success := wms.transfer_stock (l_product_id, l_from_loc, l_to_loc, l_quantity, l_reference, l_user_id)
							if l_success then
								create l_response.make
								l_response.put_boolean (True, "success").do_nothing
								l_response.put_string ("Stock transferred", "message").do_nothing
								l_response.put_integer (l_product_id, "product_id").do_nothing
								l_response.put_integer (l_from_loc, "from_location_id").do_nothing
								l_response.put_integer (l_to_loc, "to_location_id").do_nothing
								l_response.put_integer (l_quantity.to_integer_64, "quantity").do_nothing
								res.send_json_object (l_response)
							else
								send_error (res, 409, "Transfer failed - insufficient stock or conflict")
							end
						else
							send_error (res, 400, "from_location_id and to_location_id must be different")
						end
					else
						send_error (res, 400, "Quantity must be positive")
					end
				else
					send_error (res, 400, "Missing required fields: product_id, from_location_id, to_location_id, quantity, user_id")
				end
			else
				send_error (res, 400, "Invalid JSON body")
			end
		end

	handle_reserve_stock (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- POST /api/reserve - Reserve stock for an order.
		local
			l_json: detachable SIMPLE_JSON_OBJECT
			l_product_id, l_location_id, l_user_id: INTEGER_64
			l_quantity, l_expires: INTEGER
			l_order_ref: STRING_8
			l_reservation: detachable WMS_RESERVATION
		do
			log_request (req)
			l_json := req.body_as_json

			if attached l_json as json then
				if json.has_key ("product_id") and json.has_key ("location_id") and
				   json.has_key ("quantity") and json.has_key ("order_reference") and json.has_key ("user_id") then
					l_product_id := json.integer_item ("product_id")
					l_location_id := json.integer_item ("location_id")
					l_quantity := json.integer_item ("quantity").to_integer_32
					if attached json.string_item ("order_reference") as l_ord_ref then
						l_order_ref := l_ord_ref.to_string_8
					else
						l_order_ref := ""
					end
					l_user_id := json.integer_item ("user_id")

					if json.has_key ("expires_minutes") then
						l_expires := json.integer_item ("expires_minutes").to_integer_32
					else
						l_expires := 30
					end

					if l_quantity > 0 and l_expires > 0 then
						l_reservation := wms.reserve_stock (l_product_id, l_location_id, l_quantity, l_order_ref, l_user_id, l_expires)
						if attached l_reservation as r then
							res.set_created
							res.send_json_object (reservation_to_json (r))
						else
							send_error (res, 409, "Reservation failed - insufficient available stock")
						end
					else
						send_error (res, 400, "Quantity and expires_minutes must be positive")
					end
				else
					send_error (res, 400, "Missing required fields: product_id, location_id, quantity, order_reference, user_id")
				end
			else
				send_error (res, 400, "Invalid JSON body")
			end
		end

	handle_release_reservation (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- DELETE /api/reserve/{id} - Release a reservation.
		local
			l_id: detachable STRING_32
			l_success: BOOLEAN
			l_response: SIMPLE_JSON_OBJECT
		do
			log_request (req)
			l_id := req.path_parameter ("id")
			if attached l_id as id and then id.is_integer_64 then
				l_success := wms.release_reservation (id.to_integer_64)
				if l_success then
					create l_response.make
					l_response.put_boolean (True, "success").do_nothing
					l_response.put_string ("Reservation released", "message").do_nothing
					l_response.put_integer (id.to_integer_64, "reservation_id").do_nothing
					res.send_json_object (l_response)
				else
					send_error (res, 404, "Reservation not found")
				end
			else
				send_error (res, 400, "Invalid reservation id")
			end
		end

feature {NONE} -- Handlers: Movements

	handle_get_movements (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/movements/{product_id}?limit=50 - Get movement history.
		local
			l_prod_id: detachable STRING_32
			l_limit_param: detachable STRING_32
			l_limit: INTEGER
			l_movements: ARRAYED_LIST [WMS_MOVEMENT]
			l_array: SIMPLE_JSON_ARRAY
		do
			log_request (req)
			l_prod_id := req.path_parameter ("product_id")
			l_limit_param := req.query_parameter ("limit")

			if attached l_limit_param as lp and then lp.is_integer then
				l_limit := lp.to_integer.min (100).max (1)
			else
				l_limit := 50
			end

			if attached l_prod_id as prod_id and then prod_id.is_integer_64 then
				l_movements := wms.movements_for_product (prod_id.to_integer_64, l_limit)
				create l_array.make
				across l_movements as m loop
					l_array.add_object (movement_to_json (m)).do_nothing
				end
				res.send_json_array (l_array)
			else
				send_error (res, 400, "Invalid product_id")
			end
		end

feature {NONE} -- Handlers: Alerts

	handle_get_low_stock (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- GET /api/low-stock - Products below minimum stock level.
		local
			l_alerts: ARRAYED_LIST [TUPLE [product: WMS_PRODUCT; total: INTEGER; min: INTEGER]]
			l_array: SIMPLE_JSON_ARRAY
			l_item: SIMPLE_JSON_OBJECT
		do
			log_request (req)
			l_alerts := wms.products_below_min_stock
			create l_array.make
			across l_alerts as alert loop
				create l_item.make
				l_item.put_object (product_to_json (alert.product), "product").do_nothing
				l_item.put_integer (alert.total.to_integer_64, "current_stock").do_nothing
				l_item.put_integer (alert.min.to_integer_64, "minimum_required").do_nothing
				l_item.put_integer ((alert.min - alert.total).to_integer_64, "shortage").do_nothing
				l_array.add_object (l_item).do_nothing
			end
			res.send_json_array (l_array)
		end

feature {NONE} -- Handlers: Setup

	handle_setup_test_data (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
			-- POST /api/setup - Initialize test data for simulation.
		local
			l_wh: WMS_WAREHOUSE
			l_response: SIMPLE_JSON_OBJECT
			i: INTEGER
		do
			log_request (req)

			-- Create warehouse
			l_wh := wms.create_warehouse ("WH-001", "Main Warehouse")

			-- Create locations (storage grid: A-D aisles, 1-5 racks, 1-3 shelves, 1-4 bins)
			across <<"A", "B", "C", "D">> as aisle loop
				across 1 |..| 5 as rack loop
					across 1 |..| 3 as shelf loop
						across 1 |..| 4 as bin loop
							wms.create_location (l_wh.id, aisle, rack.out, shelf.out, bin.out).do_nothing
						end
					end
				end
			end

			-- Create products
			wms.create_product ("SKU-001", "Widget A", "EA").do_nothing
			wms.create_product ("SKU-002", "Widget B", "EA").do_nothing
			wms.create_product ("SKU-003", "Gadget X", "EA").do_nothing
			wms.create_product ("SKU-004", "Gadget Y", "EA").do_nothing
			wms.create_product ("SKU-005", "Component Alpha", "PK").do_nothing
			wms.create_product ("SKU-006", "Component Beta", "PK").do_nothing
			wms.create_product ("SKU-007", "Assembly Kit", "KT").do_nothing
			wms.create_product ("SKU-008", "Raw Material Z", "KG").do_nothing
			wms.create_product ("SKU-009", "Spare Part Q", "EA").do_nothing
			wms.create_product ("SKU-010", "Spare Part R", "EA").do_nothing

			-- Receive initial stock (spread across locations)
			from i := 1 until i > 10 loop
				wms.receive_stock (i, ((i - 1) \\ 60) + 1, 100 + (i * 10), "INIT-STOCK", 1).do_nothing
				i := i + 1
			end

			create l_response.make
			l_response.put_boolean (True, "success").do_nothing
			l_response.put_string ("Test data initialized", "message").do_nothing
			l_response.put_integer (1, "warehouses_created").do_nothing
			l_response.put_integer (240, "locations_created").do_nothing
			l_response.put_integer (10, "products_created").do_nothing
			l_response.put_integer (10, "initial_stock_records").do_nothing
			res.set_created
			res.send_json_object (l_response)
		end

feature {NONE} -- JSON Conversion

	warehouse_to_json (a_wh: WMS_WAREHOUSE): SIMPLE_JSON_OBJECT
			-- Convert warehouse to JSON object.
		do
			create Result.make
			Result.put_integer (a_wh.id, "id").do_nothing
			Result.put_string (a_wh.code, "code").do_nothing
			Result.put_string (a_wh.name, "name").do_nothing
			Result.put_string (a_wh.address, "address").do_nothing
			Result.put_boolean (a_wh.is_active, "is_active").do_nothing
			Result.put_string (a_wh.created_at, "created_at").do_nothing
		end

	product_to_json (a_prod: WMS_PRODUCT): SIMPLE_JSON_OBJECT
			-- Convert product to JSON object.
		do
			create Result.make
			Result.put_integer (a_prod.id, "id").do_nothing
			Result.put_string (a_prod.sku, "sku").do_nothing
			Result.put_string (a_prod.name, "name").do_nothing
			Result.put_string (a_prod.description, "description").do_nothing
			Result.put_string (a_prod.unit_of_measure, "unit_of_measure").do_nothing
			Result.put_integer (a_prod.min_stock_level.to_integer_64, "min_stock_level").do_nothing
			if attached a_prod.deleted_at as da then
				Result.put_string (da, "deleted_at").do_nothing
			end
		end

	product_row_to_json (a_row: SIMPLE_SQL_ROW): SIMPLE_JSON_OBJECT
			-- Convert product row to JSON object.
		do
			create Result.make
			Result.put_integer (a_row.integer_64_value ("id"), "id").do_nothing
			Result.put_string (a_row.string_value ("sku").to_string_8, "sku").do_nothing
			Result.put_string (a_row.string_value ("name").to_string_8, "name").do_nothing
			Result.put_string (a_row.string_value ("description").to_string_8, "description").do_nothing
			Result.put_string (a_row.string_value ("unit_of_measure").to_string_8, "unit_of_measure").do_nothing
			Result.put_integer (a_row.integer_value ("min_stock_level").to_integer_64, "min_stock_level").do_nothing
		end

	location_to_json (a_loc: WMS_LOCATION): SIMPLE_JSON_OBJECT
			-- Convert location to JSON object.
		do
			create Result.make
			Result.put_integer (a_loc.id, "id").do_nothing
			Result.put_integer (a_loc.warehouse_id, "warehouse_id").do_nothing
			Result.put_string (a_loc.code, "code").do_nothing
			Result.put_string (a_loc.aisle, "aisle").do_nothing
			Result.put_string (a_loc.rack, "rack").do_nothing
			Result.put_string (a_loc.shelf, "shelf").do_nothing
			Result.put_string (a_loc.bin, "bin").do_nothing
			Result.put_boolean (a_loc.is_active, "is_active").do_nothing
		end

	stock_to_json (a_stock: WMS_STOCK): SIMPLE_JSON_OBJECT
			-- Convert stock to JSON object.
		do
			create Result.make
			Result.put_integer (a_stock.id, "id").do_nothing
			Result.put_integer (a_stock.product_id, "product_id").do_nothing
			Result.put_integer (a_stock.location_id, "location_id").do_nothing
			Result.put_integer (a_stock.quantity.to_integer_64, "quantity").do_nothing
			Result.put_integer (a_stock.reserved_quantity.to_integer_64, "reserved_quantity").do_nothing
			Result.put_integer (a_stock.available_quantity.to_integer_64, "available_quantity").do_nothing
			Result.put_integer (a_stock.version, "version").do_nothing
			Result.put_string (a_stock.updated_at, "updated_at").do_nothing
		end

	reservation_to_json (a_res: WMS_RESERVATION): SIMPLE_JSON_OBJECT
			-- Convert reservation to JSON object.
		do
			create Result.make
			Result.put_integer (a_res.id, "id").do_nothing
			Result.put_integer (a_res.product_id, "product_id").do_nothing
			Result.put_integer (a_res.location_id, "location_id").do_nothing
			Result.put_integer (a_res.quantity.to_integer_64, "quantity").do_nothing
			Result.put_string (a_res.order_reference, "order_reference").do_nothing
			Result.put_integer (a_res.reserved_by, "reserved_by").do_nothing
			Result.put_string (a_res.expires_at, "expires_at").do_nothing
			Result.put_string (a_res.created_at, "created_at").do_nothing
		end

	movement_to_json (a_mov: WMS_MOVEMENT): SIMPLE_JSON_OBJECT
			-- Convert movement to JSON object.
		do
			create Result.make
			Result.put_integer (a_mov.id, "id").do_nothing
			Result.put_integer (a_mov.product_id, "product_id").do_nothing
			Result.put_integer (a_mov.from_location_id, "from_location_id").do_nothing
			Result.put_integer (a_mov.to_location_id, "to_location_id").do_nothing
			Result.put_integer (a_mov.quantity.to_integer_64, "quantity").do_nothing
			Result.put_string (a_mov.movement_type, "movement_type").do_nothing
			Result.put_string (a_mov.movement_reference, "reference").do_nothing
			Result.put_integer (a_mov.performed_by, "performed_by").do_nothing
			Result.put_string (a_mov.created_at, "created_at").do_nothing
		end

feature {NONE} -- Helper

	send_error (res: SIMPLE_WEB_SERVER_RESPONSE; a_status: INTEGER; a_message: STRING)
			-- Send error response.
		local
			l_json: SIMPLE_JSON_OBJECT
		do
			create l_json.make
			l_json.put_boolean (False, "success").do_nothing
			l_json.put_string (a_message, "error").do_nothing
			l_json.put_integer (a_status.to_integer_64, "status").do_nothing
			res.set_status (a_status)
			res.send_json_object (l_json)
		end

	log_request (req: SIMPLE_WEB_SERVER_REQUEST)
			-- Log request for debugging.
		do
			print ("[" + req.method + "] " + req.path.to_string_8 + "%N")
		end

invariant
	server_attached: server /= Void
	wms_attached: wms /= Void

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"

end
