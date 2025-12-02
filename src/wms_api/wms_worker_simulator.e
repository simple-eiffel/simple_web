note
	description: "[
		WMS Worker Simulator - Simulates a warehouse worker with a phone app.

		This class exercises SIMPLE_WEB's HTTP client by making realistic
		sequences of API calls that a warehouse worker would make during
		their work day.

		Simulates multiple days of work with various scenarios:
		- Day 1: Morning receiving, afternoon transfers
		- Day 2: Order picking with reservations
		- Day 3: Inventory reorganization
		- Day 4: Mixed operations (receiving, picking, cycle counts)
		- Day 5: End of week cleanup and low stock handling

		FRICTION LOG (document each pain point as discovered):

		[C1] LOCALHOST ISSUE - Must use hybrid client for POST/PUT
		     Current: Have to know to use SIMPLE_WEB_HYBRID_CLIENT
		     Desired: Regular client that just works

		[C2] JSON BUILDING - Lots of manual JSON string construction
		     Current: "{%"product_id%":" + id.out + ",...}"
		     Desired: Fluent JSON builder or automatic serialization

		[C3] ERROR HANDLING - No structured way to check response errors
		     Current: if response.status_code >= 400 then...
		     Desired: response.is_error, response.error_message

		[C4] NO RETRY LOGIC - Network failures require manual retry
		     Current: Must wrap every call in retry loop
		     Desired: client.with_retry (3).post (...)

		[C5] NO REQUEST LOGGING - Hard to debug what was sent
		     Current: Manual print before each request
		     Desired: Built-in request/response logging
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	WMS_WORKER_SIMULATOR

create
	make

feature {NONE} -- Initialization

	make (a_base_url: STRING)
			-- Create simulator targeting `a_base_url'.
		require
			url_not_empty: not a_base_url.is_empty
		do
			base_url := a_base_url
			create client.make
			worker_id := 1
			worker_name := "Bob"
			current_warehouse_id := 0
			operations_count := 0
			errors_count := 0
			create random.make
		ensure
			base_url_set: base_url = a_base_url
		end

feature -- Access

	base_url: STRING
			-- API server base URL.

	worker_id: INTEGER_64
			-- Current worker ID.

	worker_name: STRING
			-- Worker's name for logging.

	current_warehouse_id: INTEGER_64
			-- Currently selected warehouse.

	operations_count: INTEGER
			-- Total successful operations.

	errors_count: INTEGER
			-- Total failed operations.

feature -- Simulation Control

	run_full_week
			-- Run a full 5-day work week simulation.
		do
			print ("%N========================================%N")
			print ("  WMS WORKER SIMULATOR - FULL WEEK%N")
			print ("  Worker: " + worker_name + " (ID: " + worker_id.out + ")%N")
			print ("  API: " + base_url + "%N")
			print ("========================================%N%N")

			-- Initialize data first
			setup_test_data

			-- Run each day
			run_day_1_receiving
			run_day_2_order_picking
			run_day_3_reorganization
			run_day_4_mixed_operations
			run_day_5_cleanup

			-- Final summary
			print_summary
		end

	run_quick_simulation
			-- Run a quick simulation (useful for testing).
		do
			print ("%N=== QUICK SIMULATION ===%N")
			setup_test_data
			run_morning_shift
			print_summary
		end

feature -- Day Simulations

	run_day_1_receiving
			-- Day 1: Heavy receiving day - multiple shipments arrive.
		local
			l_po_num: INTEGER
		do
			print ("%N")
			print ("==============================%N")
			print ("  DAY 1: RECEIVING SHIPMENTS%N")
			print ("==============================%N")

			-- Clock in
			log_action ("Clocking in for Day 1 - Receiving shift")
			select_warehouse

			-- Morning: Receive PO-1001 (large shipment)
			log_action ("Morning: Processing large shipment PO-1001")
			receive_shipment ("PO-1001", <<
				[1, 1, 200],   -- 200x Widget A to location 1
				[2, 2, 150],   -- 150x Widget B to location 2
				[3, 3, 100],   -- 100x Gadget X to location 3
				[4, 4, 100],   -- 100x Gadget Y to location 4
				[5, 5, 300]    -- 300x Component Alpha to location 5
			>>)

			-- Break
			log_action ("Taking morning break")
			pause (500)

			-- Late morning: Receive PO-1002 (small shipment)
			log_action ("Late morning: Processing small shipment PO-1002")
			receive_shipment ("PO-1002", <<
				[6, 6, 50],    -- 50x Component Beta to location 6
				[7, 7, 25]     -- 25x Assembly Kit to location 7
			>>)

			-- Lunch
			log_action ("Lunch break")
			pause (1000)

			-- Afternoon: Receive multiple small POs
			log_action ("Afternoon: Processing multiple supplier deliveries")
			from l_po_num := 1003 until l_po_num > 1007 loop
				receive_shipment ("PO-" + l_po_num.out, <<
					[random_product_id, random_location_id (1, 60), random_quantity (20, 80)]
				>>)
				l_po_num := l_po_num + 1
			end

			-- End of day stock check
			log_action ("End of day: Checking stock levels")
			check_low_stock
			check_product_totals (<<1, 2, 3, 4, 5>>)

			log_action ("Clocking out - Day 1 complete")
		end

	run_day_2_order_picking
			-- Day 2: Order picking day - fulfill customer orders.
		local
			l_order_num: INTEGER
		do
			print ("%N")
			print ("==============================%N")
			print ("  DAY 2: ORDER PICKING%N")
			print ("==============================%N")

			log_action ("Clocking in for Day 2 - Picking shift")
			select_warehouse

			-- Morning: Pick orders ORD-2001 through ORD-2010
			log_action ("Morning: Processing priority orders")
			from l_order_num := 2001 until l_order_num > 2005 loop
				pick_order ("ORD-" + l_order_num.out, <<
					[random_product_id, random_quantity (5, 20)],
					[random_product_id, random_quantity (3, 15)]
				>>)
				l_order_num := l_order_num + 1
			end

			-- Break
			log_action ("Taking morning break")
			pause (500)

			-- Late morning: More picks
			log_action ("Late morning: Standard order processing")
			from l_order_num := 2006 until l_order_num > 2010 loop
				pick_order ("ORD-" + l_order_num.out, <<
					[random_product_id, random_quantity (1, 10)]
				>>)
				l_order_num := l_order_num + 1
			end

			-- Lunch
			log_action ("Lunch break")
			pause (1000)

			-- Afternoon: Bulk order
			log_action ("Afternoon: Processing bulk order ORD-2011")
			pick_order ("ORD-2011", <<
				[1, 50],   -- 50x Widget A
				[2, 50],   -- 50x Widget B
				[3, 30],   -- 30x Gadget X
				[4, 30],   -- 30x Gadget Y
				[5, 100]   -- 100x Component Alpha
			>>)

			-- Release any unused reservations from orders
			log_action ("Releasing any unused reservations")
			-- In real scenario would track reservation IDs

			-- Check stock after picking
			log_action ("End of day: Verifying stock after picks")
			check_product_totals (<<1, 2, 3, 4, 5>>)
			check_low_stock

			log_action ("Clocking out - Day 2 complete")
		end

	run_day_3_reorganization
			-- Day 3: Warehouse reorganization - moving stock for efficiency.
		local
			i: INTEGER
		do
			print ("%N")
			print ("==============================%N")
			print ("  DAY 3: REORGANIZATION%N")
			print ("==============================%N")

			log_action ("Clocking in for Day 3 - Reorganization shift")
			select_warehouse

			-- Morning: Consolidate Widget A stock to prime locations
			log_action ("Morning: Consolidating fast-moving items")
			consolidate_product (1, <<"A-1-1-1", "A-1-1-2">>)  -- Move Widget A to Aisle A

			-- Move slow movers to back
			log_action ("Moving slow-moving items to rear storage")
			from i := 6 until i > 10 loop
				transfer_to_location (i, random_location_id (180, 240))  -- Back locations
				i := i + 1
			end

			-- Break
			log_action ("Taking morning break")
			pause (500)

			-- Late morning: Organize by product family
			log_action ("Late morning: Organizing by product family")
			-- Transfer all gadgets near each other
			transfer_product_to_zone (3, "B")  -- Gadget X to aisle B
			transfer_product_to_zone (4, "B")  -- Gadget Y to aisle B

			-- Lunch
			log_action ("Lunch break")
			pause (1000)

			-- Afternoon: Make space for expected shipment
			log_action ("Afternoon: Preparing for tomorrow's large shipment")
			-- Clear locations C-1-x-x for incoming goods
			across 1 |..| 5 as loc loop
				transfer_from_location (loc.item + 120, random_location_id (60, 120))  -- Move to B aisle
			end

			-- End of day verification
			log_action ("End of day: Verifying reorganization")
			view_all_stock_levels

			log_action ("Clocking out - Day 3 complete")
		end

	run_day_4_mixed_operations
			-- Day 4: Mixed operations - receiving, picking, and cycle counts.
		local
			l_order_num: INTEGER
		do
			print ("%N")
			print ("==============================%N")
			print ("  DAY 4: MIXED OPERATIONS%N")
			print ("==============================%N")

			log_action ("Clocking in for Day 4 - Mixed operations shift")
			select_warehouse

			-- Early morning: Cycle count on high-value items
			log_action ("Early morning: Cycle count - Assembly Kits")
			check_stock_at_location (7)
			check_product_totals (<<7>>)

			-- Morning: Receive emergency restocking shipment
			log_action ("Morning: Processing emergency restock PO-4001")
			receive_shipment ("PO-4001", <<
				[1, 1, 500],   -- Restock Widget A (was running low)
				[5, 5, 200]    -- Restock Component Alpha
			>>)

			-- Process rush orders
			log_action ("Processing rush orders")
			from l_order_num := 4001 until l_order_num > 4003 loop
				pick_order ("RUSH-" + l_order_num.out, <<
					[random_product_id, random_quantity (10, 30)]
				>>)
				l_order_num := l_order_num + 1
			end

			-- Break
			log_action ("Taking morning break")
			pause (500)

			-- Late morning: Regular receiving
			log_action ("Late morning: Regular receiving PO-4002")
			receive_shipment ("PO-4002", <<
				[8, random_location_id (1, 60), 100],   -- Raw Material Z
				[9, random_location_id (1, 60), 75],    -- Spare Part Q
				[10, random_location_id (1, 60), 75]    -- Spare Part R
			>>)

			-- Lunch
			log_action ("Lunch break")
			pause (1000)

			-- Afternoon: Pick batch of orders
			log_action ("Afternoon: Batch picking")
			from l_order_num := 4010 until l_order_num > 4020 loop
				pick_order ("ORD-" + l_order_num.out, <<
					[random_product_id, random_quantity (2, 8)]
				>>)
				l_order_num := l_order_num + 1
			end

			-- Check alerts
			log_action ("End of day: Checking alerts")
			check_low_stock
			check_product_totals (<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>)

			log_action ("Clocking out - Day 4 complete")
		end

	run_day_5_cleanup
			-- Day 5: End of week - cleanup, expired reservations, inventory report.
		do
			print ("%N")
			print ("==============================%N")
			print ("  DAY 5: END OF WEEK CLEANUP%N")
			print ("==============================%N")

			log_action ("Clocking in for Day 5 - Cleanup shift")
			select_warehouse

			-- Morning: Full inventory check
			log_action ("Morning: Full inventory verification")
			view_all_stock_levels
			check_all_products_stock

			-- Check for any expired reservations (simulate by checking low stock)
			log_action ("Checking for stuck reservations")
			check_low_stock

			-- Break
			log_action ("Taking morning break")
			pause (500)

			-- Late morning: Process any pending receiving
			log_action ("Late morning: Processing remaining shipments")
			receive_shipment ("PO-5001", <<
				[random_product_id, random_location_id (1, 60), 50],
				[random_product_id, random_location_id (1, 60), 50]
			>>)

			-- Lunch
			log_action ("Lunch break")
			pause (1000)

			-- Afternoon: Final picks and cleanup
			log_action ("Afternoon: Final order processing")
			pick_order ("ORD-5001", <<
				[1, 10],
				[2, 10]
			>>)
			pick_order ("ORD-5002", <<
				[3, 5],
				[4, 5]
			>>)

			-- Generate end of week report
			log_action ("Generating end of week inventory report")
			print_inventory_report

			log_action ("Clocking out - Day 5 complete. Week finished!")
		end

feature -- Operations

	setup_test_data
			-- Initialize warehouse with test data.
		local
			l_response: SIMPLE_WEB_RESPONSE
		do
			log_action ("Setting up test warehouse data...")
			l_response := client.post_json (base_url + "/api/setup", "{}")
			if l_response.status_code = 201 then
				log_success ("Test data initialized")
				operations_count := operations_count + 1
			else
				log_error ("Failed to setup test data: " + l_response.body)
				errors_count := errors_count + 1
			end
		end

	select_warehouse
			-- Select warehouse to work in.
		local
			l_response: SIMPLE_WEB_RESPONSE
			l_json: SIMPLE_JSON
			l_array: detachable SIMPLE_JSON_ARRAY
		do
			l_response := client.get (base_url + "/api/warehouses")
			if l_response.status_code = 200 then
				create l_json
				if attached {SIMPLE_JSON_ARRAY} l_json.parse (l_response.body) as arr and then arr.count > 0 then
					if attached {SIMPLE_JSON_OBJECT} arr.item (1) as wh then
						current_warehouse_id := wh.integer_item ("id")
						if attached wh.string_item ("name") as l_name then
							log_success ("Selected warehouse: " + l_name.to_string_8 +
								" (ID: " + current_warehouse_id.out + ")")
						else
							log_success ("Selected warehouse ID: " + current_warehouse_id.out)
						end
					end
				end
			else
				log_error ("Failed to get warehouses")
				errors_count := errors_count + 1
			end
		end

	receive_shipment (a_po: STRING; a_items: ARRAY [TUPLE [product_id: INTEGER; location_id: INTEGER; quantity: INTEGER]])
			-- Receive multiple items from a purchase order.
		local
			l_body: STRING
			l_response: SIMPLE_WEB_RESPONSE
		do
			log_action ("Receiving shipment " + a_po + " (" + a_items.count.out + " items)")
			across a_items as item loop
				-- [C2] FRICTION: Building JSON manually is tedious
				create l_body.make (200)
				l_body.append ("{%"product_id%":")
				l_body.append (item.product_id.out)
				l_body.append (",%"location_id%":")
				l_body.append (item.location_id.out)
				l_body.append (",%"quantity%":")
				l_body.append (item.quantity.out)
				l_body.append (",%"reference%":%"")
				l_body.append (a_po)
				l_body.append ("%",%"user_id%":")
				l_body.append (worker_id.out)
				l_body.append ("}")

				l_response := client.post_json (base_url + "/api/receive", l_body)
				if l_response.status_code = 201 then
					log_success ("  Received " + item.quantity.out + "x product " +
						item.product_id.out + " to location " + item.location_id.out)
					operations_count := operations_count + 1
				else
					log_error ("  Failed to receive: " + l_response.body)
					errors_count := errors_count + 1
				end
				pause (100) -- Simulate scanning time
			end
		end

	pick_order (a_order: STRING; a_items: ARRAY [TUPLE [product_id: INTEGER; quantity: INTEGER]])
			-- Pick items for an order (reserve then release after "picking").
		local
			l_body: STRING
			l_response: SIMPLE_WEB_RESPONSE
			l_location_id: INTEGER_64
			l_json: SIMPLE_JSON
			l_reservation_id: INTEGER_64
		do
			log_action ("Picking order " + a_order)
			across a_items as item loop
				-- Find stock location for product
				l_location_id := find_stock_location (item.product_id.to_integer_64)

				if l_location_id > 0 then
					-- Reserve the stock
					create l_body.make (250)
					l_body.append ("{%"product_id%":")
					l_body.append (item.product_id.out)
					l_body.append (",%"location_id%":")
					l_body.append (l_location_id.out)
					l_body.append (",%"quantity%":")
					l_body.append (item.quantity.out)
					l_body.append (",%"order_reference%":%"")
					l_body.append (a_order)
					l_body.append ("%",%"user_id%":")
					l_body.append (worker_id.out)
					l_body.append (",%"expires_minutes%":30}")

					l_response := client.post_json (base_url + "/api/reserve", l_body)
					if l_response.status_code = 201 then
						-- Parse reservation ID
						create l_json
						if attached {SIMPLE_JSON_OBJECT} l_json.parse (l_response.body) as res_json then
							l_reservation_id := res_json.integer_item ("id")
							log_success ("  Reserved " + item.quantity.out + "x product " +
								item.product_id.out + " (reservation " + l_reservation_id.out + ")")
							operations_count := operations_count + 1

							-- Simulate walking to location and picking
							pause (200)

							-- Release reservation after "picking"
							l_response := client.delete (base_url + "/api/reserve/" + l_reservation_id.out)
							if l_response.status_code = 200 then
								log_success ("  Picked and released reservation " + l_reservation_id.out)
								operations_count := operations_count + 1
							else
								log_error ("  Failed to release reservation: " + l_response.body)
								errors_count := errors_count + 1
							end
						end
					else
						log_error ("  Failed to reserve: " + l_response.body)
						errors_count := errors_count + 1
					end
				else
					log_error ("  No stock found for product " + item.product_id.out)
					errors_count := errors_count + 1
				end
			end
		end

	transfer_stock (a_product_id, a_from_location, a_to_location: INTEGER_64; a_quantity: INTEGER; a_reference: STRING)
			-- Transfer stock between locations.
		local
			l_body: STRING
			l_response: SIMPLE_WEB_RESPONSE
		do
			create l_body.make (300)
			l_body.append ("{%"product_id%":")
			l_body.append (a_product_id.out)
			l_body.append (",%"from_location_id%":")
			l_body.append (a_from_location.out)
			l_body.append (",%"to_location_id%":")
			l_body.append (a_to_location.out)
			l_body.append (",%"quantity%":")
			l_body.append (a_quantity.out)
			l_body.append (",%"reference%":%"")
			l_body.append (a_reference)
			l_body.append ("%",%"user_id%":")
			l_body.append (worker_id.out)
			l_body.append ("}")

			l_response := client.post_json (base_url + "/api/transfer", l_body)
			if l_response.status_code = 200 then
				log_success ("Transferred " + a_quantity.out + "x product " + a_product_id.out +
					" from " + a_from_location.out + " to " + a_to_location.out)
				operations_count := operations_count + 1
			else
				log_error ("Transfer failed: " + l_response.body)
				errors_count := errors_count + 1
			end
		end

feature -- Stock Queries

	find_stock_location (a_product_id: INTEGER_64): INTEGER_64
			-- Find a location with stock for product. Returns 0 if none found.
		local
			l_response: SIMPLE_WEB_RESPONSE
			l_json: SIMPLE_JSON
		do
			l_response := client.get (base_url + "/api/stock/product/" + a_product_id.out)
			if l_response.status_code = 200 then
				-- Product has stock somewhere - need to find specific location
				-- For now, use a heuristic (product_id maps to initial location)
				Result := ((a_product_id - 1) \\ 60) + 1
			end
		end

	check_stock_at_location (a_location_id: INTEGER_64)
			-- Check and display stock at a location.
		local
			l_response: SIMPLE_WEB_RESPONSE
			l_json: SIMPLE_JSON
		do
			l_response := client.get (base_url + "/api/stock/" + a_location_id.out)
			if l_response.status_code = 200 then
				log_success ("Stock at location " + a_location_id.out + ": " + l_response.body)
			else
				log_error ("Failed to check stock at " + a_location_id.out)
			end
		end

	check_product_totals (a_product_ids: ARRAY [INTEGER])
			-- Check total stock for multiple products.
		local
			l_response: SIMPLE_WEB_RESPONSE
			l_json: SIMPLE_JSON
		do
			print ("  Product stock totals:%N")
			across a_product_ids as pid loop
				l_response := client.get (base_url + "/api/stock/product/" + pid.item.out)
				if l_response.status_code = 200 then
					create l_json
					if attached {SIMPLE_JSON_OBJECT} l_json.parse (l_response.body) as stock then
						print ("    Product " + pid.item.out + ": " +
							stock.integer_item ("total_quantity").out + " total, " +
							stock.integer_item ("available_quantity").out + " available%N")
					end
				end
			end
		end

	check_low_stock
			-- Check for products below minimum stock.
		local
			l_response: SIMPLE_WEB_RESPONSE
			l_json: SIMPLE_JSON
		do
			l_response := client.get (base_url + "/api/low-stock")
			if l_response.status_code = 200 then
				create l_json
				if attached {SIMPLE_JSON_ARRAY} l_json.parse (l_response.body) as arr then
					if arr.count > 0 then
						print ("  LOW STOCK ALERTS: " + arr.count.out + " products below minimum%N")
					else
						print ("  No low stock alerts%N")
					end
				end
			else
				log_error ("Failed to check low stock")
			end
		end

	check_all_products_stock
			-- Check stock for all products (1-10).
		do
			check_product_totals (<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>)
		end

	view_all_stock_levels
			-- View stock at all locations (summary).
		local
			l_response: SIMPLE_WEB_RESPONSE
			i: INTEGER
		do
			print ("  Viewing stock across locations...%N")
			from i := 1 until i > 10 loop
				l_response := client.get (base_url + "/api/stock/" + i.out)
				if l_response.status_code = 200 and then l_response.body.count > 2 then
					print ("    Location " + i.out + ": " + l_response.body.substring (1, (50).min (l_response.body.count)) + "...%N")
				end
				i := i + 1
			end
		end

feature -- Complex Operations

	consolidate_product (a_product_id: INTEGER; a_target_locations: ARRAY [STRING])
			-- Consolidate all stock of a product to target locations.
		do
			log_action ("Consolidating product " + a_product_id.out + " to " +
				a_target_locations.count.out + " locations")
			-- In a real implementation, would query all stock locations for this product
			-- and transfer to consolidation points
			pause (500) -- Simulate the work
		end

	transfer_to_location (a_product_id: INTEGER; a_target_location: INTEGER_64)
			-- Transfer a product to a specific location.
		local
			l_source: INTEGER_64
		do
			l_source := find_stock_location (a_product_id.to_integer_64)
			if l_source > 0 and l_source /= a_target_location then
				transfer_stock (a_product_id.to_integer_64, l_source, a_target_location, 10, "REORG")
			end
		end

	transfer_from_location (a_source_location: INTEGER; a_target_location: INTEGER_64)
			-- Transfer all stock from a location to another.
		do
			-- In real implementation, would query stock at source and transfer
			log_action ("Moving stock from location " + a_source_location.out + " to " + a_target_location.out)
			pause (200)
		end

	transfer_product_to_zone (a_product_id: INTEGER; a_aisle: STRING)
			-- Transfer all stock of product to a specific aisle zone.
		do
			log_action ("Moving product " + a_product_id.out + " to aisle " + a_aisle)
			-- Would find all stock locations and transfer to zone
			pause (300)
		end

feature -- Morning Shift (Quick Simulation)

	run_morning_shift
			-- Run a typical morning shift operations.
		do
			print ("%N=== MORNING SHIFT ===%N")
			select_warehouse

			-- Receive a shipment
			receive_shipment ("PO-TEST-001", <<
				[1, 1, 50],
				[2, 2, 30]
			>>)

			-- Pick an order
			pick_order ("ORD-TEST-001", <<
				[1, 10],
				[2, 5]
			>>)

			-- Check stock
			check_product_totals (<<1, 2>>)
		end

feature -- Reporting

	print_summary
			-- Print simulation summary.
		do
			print ("%N")
			print ("========================================%N")
			print ("  SIMULATION SUMMARY%N")
			print ("========================================%N")
			print ("  Worker: " + worker_name + "%N")
			print ("  Total Operations: " + operations_count.out + "%N")
			print ("  Errors: " + errors_count.out + "%N")
			print ("  Success Rate: " + ((operations_count * 100) // (operations_count + errors_count).max (1)).out + "%%%N")
			print ("========================================%N")
		end

	print_inventory_report
			-- Print end of week inventory report.
		do
			print ("%N--- END OF WEEK INVENTORY REPORT ---%N")
			check_all_products_stock
			check_low_stock
			print ("--- END REPORT ---%N")
		end

feature {NONE} -- Implementation

	client: SIMPLE_WEB_HYBRID_CLIENT
			-- HTTP client (using hybrid for localhost compatibility).
			-- [C1] FRICTION: Must use hybrid client for localhost

	random: RANDOM
			-- Random number generator for simulation variety.

	pause (a_milliseconds: INTEGER)
			-- Pause execution to simulate real work timing.
		local
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			l_env.sleep (a_milliseconds * 1_000_000) -- nanoseconds
		end

	log_action (a_message: STRING)
			-- Log an action.
		do
			print ("%N>> " + a_message + "%N")
		end

	log_success (a_message: STRING)
			-- Log a success.
		do
			print ("   [OK] " + a_message + "%N")
		end

	log_error (a_message: STRING)
			-- Log an error.
		do
			print ("   [ERROR] " + a_message + "%N")
		end

	random_product_id: INTEGER
			-- Return random product ID (1-10).
		do
			random.forth
			Result := (random.item \\ 10) + 1
		end

	random_location_id (a_min, a_max: INTEGER): INTEGER
			-- Return random location ID in range.
		do
			random.forth
			Result := (random.item \\ (a_max - a_min + 1)) + a_min
		end

	random_quantity (a_min, a_max: INTEGER): INTEGER
			-- Return random quantity in range.
		do
			random.forth
			Result := (random.item \\ (a_max - a_min + 1)) + a_min
		end

invariant
	base_url_not_empty: not base_url.is_empty
	client_attached: client /= Void

note
	copyright: "Copyright (c) 2024-2025, Larry Rix"
	license: "MIT License"

end
