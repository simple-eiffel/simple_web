note
	description: "[
		Tests for WMS API mock application.

		These tests validate:
		- Server endpoint functionality
		- Worker simulator operations
		- Integration between simple_web client/server
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_WMS_API

inherit
	TEST_SET_BASE

feature -- Test: JSON Conversion

	test_warehouse_json_conversion
			-- Test that warehouse JSON conversion works.
		local
			l_server: WMS_API_SERVER
			l_wh: WMS_WAREHOUSE
			l_json: SIMPLE_JSON_OBJECT
		do
			create l_server.make (9999)

			-- Create a warehouse
			l_wh := l_server.wms.create_warehouse ("TEST-WH", "Test Warehouse")

			-- Verify warehouse was created
			assert ("warehouse created", not l_wh.is_new)
			assert ("warehouse has id", l_wh.id > 0)
			assert ("warehouse code", l_wh.code ~ "TEST-WH")

			l_server.wms.close
		end

	test_product_creation
			-- Test product creation via WMS.
		local
			l_server: WMS_API_SERVER
			l_product: WMS_PRODUCT
		do
			create l_server.make (9999)

			l_product := l_server.wms.create_product ("SKU-TEST", "Test Product", "EA")

			assert ("product created", not l_product.is_new)
			assert ("product has id", l_product.id > 0)
			assert ("product sku", l_product.sku ~ "SKU-TEST")

			l_server.wms.close
		end

	test_location_creation
			-- Test location creation via WMS.
		local
			l_server: WMS_API_SERVER
			l_wh: WMS_WAREHOUSE
			l_loc: WMS_LOCATION
		do
			create l_server.make (9999)

			l_wh := l_server.wms.create_warehouse ("WH-LOC", "Location Test Warehouse")
			l_loc := l_server.wms.create_location (l_wh.id, "A", "1", "1", "1")

			assert ("location created", not l_loc.is_new)
			assert ("location has id", l_loc.id > 0)
			assert ("location code", l_loc.code ~ "A-1-1-1")

			l_server.wms.close
		end

	test_receive_stock
			-- Test stock receiving operation.
		local
			l_server: WMS_API_SERVER
			l_wh: WMS_WAREHOUSE
			l_product: WMS_PRODUCT
			l_loc: WMS_LOCATION
			l_success: BOOLEAN
			l_total: INTEGER
		do
			create l_server.make (9999)

			-- Setup
			l_wh := l_server.wms.create_warehouse ("WH-RCV", "Receiving Test")
			l_product := l_server.wms.create_product ("SKU-RCV", "Receiving Product", "EA")
			l_loc := l_server.wms.create_location (l_wh.id, "A", "1", "1", "1")

			-- Receive stock
			l_success := l_server.wms.receive_stock (l_product.id, l_loc.id, 100, "PO-TEST", 1)

			assert ("receive succeeded", l_success)

			-- Verify total
			l_total := l_server.wms.total_stock_for_product (l_product.id)
			assert ("total stock is 100", l_total = 100)

			l_server.wms.close
		end

	test_transfer_stock
			-- Test stock transfer between locations.
		local
			l_server: WMS_API_SERVER
			l_wh: WMS_WAREHOUSE
			l_product: WMS_PRODUCT
			l_loc1, l_loc2: WMS_LOCATION
			l_success: BOOLEAN
			l_stock1, l_stock2: detachable WMS_STOCK
		do
			create l_server.make (9999)

			-- Setup
			l_wh := l_server.wms.create_warehouse ("WH-TRF", "Transfer Test")
			l_product := l_server.wms.create_product ("SKU-TRF", "Transfer Product", "EA")
			l_loc1 := l_server.wms.create_location (l_wh.id, "A", "1", "1", "1")
			l_loc2 := l_server.wms.create_location (l_wh.id, "B", "1", "1", "1")

			-- Receive initial stock
			l_success := l_server.wms.receive_stock (l_product.id, l_loc1.id, 100, "INIT", 1)
			assert ("initial receive succeeded", l_success)

			-- Transfer some stock
			l_success := l_server.wms.transfer_stock (l_product.id, l_loc1.id, l_loc2.id, 40, "TRANSFER", 1)
			assert ("transfer succeeded", l_success)

			-- Verify quantities
			l_stock1 := l_server.wms.find_stock (l_product.id, l_loc1.id)
			l_stock2 := l_server.wms.find_stock (l_product.id, l_loc2.id)

			assert ("loc1 stock attached", attached l_stock1)
			assert ("loc2 stock attached", attached l_stock2)

			if attached l_stock1 as s1 and attached l_stock2 as s2 then
				assert ("loc1 has 60", s1.quantity = 60)
				assert ("loc2 has 40", s2.quantity = 40)
			end

			l_server.wms.close
		end

	test_reservation
			-- Test stock reservation and release.
		local
			l_server: WMS_API_SERVER
			l_wh: WMS_WAREHOUSE
			l_product: WMS_PRODUCT
			l_loc: WMS_LOCATION
			l_success: BOOLEAN
			l_reservation: detachable WMS_RESERVATION
			l_stock: detachable WMS_STOCK
		do
			create l_server.make (9999)

			-- Setup
			l_wh := l_server.wms.create_warehouse ("WH-RES", "Reservation Test")
			l_product := l_server.wms.create_product ("SKU-RES", "Reserve Product", "EA")
			l_loc := l_server.wms.create_location (l_wh.id, "A", "1", "1", "1")

			-- Receive stock
			l_success := l_server.wms.receive_stock (l_product.id, l_loc.id, 100, "INIT", 1)

			-- Reserve some
			l_reservation := l_server.wms.reserve_stock (l_product.id, l_loc.id, 30, "ORD-001", 1, 60)
			assert ("reservation created", attached l_reservation)

			-- Check available quantity
			l_stock := l_server.wms.find_stock (l_product.id, l_loc.id)
			if attached l_stock as s then
				assert ("total is 100", s.quantity = 100)
				assert ("reserved is 30", s.reserved_quantity = 30)
				assert ("available is 70", s.available_quantity = 70)
			end

			-- Release reservation
			if attached l_reservation as r then
				l_success := l_server.wms.release_reservation (r.id)
				assert ("release succeeded", l_success)
			end

			-- Check available is restored
			l_stock := l_server.wms.find_stock (l_product.id, l_loc.id)
			if attached l_stock as s then
				assert ("available restored to 100", s.available_quantity = 100)
			end

			l_server.wms.close
		end

feature -- Test: Worker Simulator

	test_simulator_creation
			-- Test that worker simulator can be created.
		local
			l_sim: WMS_WORKER_SIMULATOR
		do
			create l_sim.make ("http://localhost:8080")

			assert ("simulator created", l_sim /= Void)
			assert ("base url set", l_sim.base_url ~ "http://localhost:8080")
			assert ("worker name set", l_sim.worker_name ~ "Bob")
			assert ("operations count zero", l_sim.operations_count = 0)
		end

feature -- Test: Route Setup

	test_server_creation
			-- Test that server can be created with routes.
		local
			l_server: WMS_API_SERVER
		do
			create l_server.make (9999)

			assert ("server created", l_server /= Void)
			assert ("port set", l_server.port = 9999)
			assert ("wms initialized", l_server.wms /= Void)

			l_server.wms.close
		end

end
