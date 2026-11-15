note
	description: "[
		Runs the tests in simple_web's AutoTest test sets that TEST_APP did not call
		(port-coordination #17: 17 of them ran in no gate). Each goes through AutoTest's own
		EQA_TEST_EVALUATOR: a fresh test set (on_prepare), the test, then clean (on_clean),
		as AutoTest runs it. A failing test prints "FAIL:" with its tag and is counted.
	]"

class
	AUTOTEST_SETS_RUNNER

feature -- Counts

	passed, failed: INTEGER
			-- Tests run here.

feature -- Running

	run_all
			-- Every test below, 17 in all.
		do
			run_test_simple_web_request
			run_test_simple_web_response
		end

feature {NONE} -- Test sets

	run_test_simple_web_request
		local
			l_evaluator: EQA_TEST_EVALUATOR [TEST_SIMPLE_WEB_REQUEST]
		do
			create l_evaluator
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_make_get), "TEST_SIMPLE_WEB_REQUEST.test_make_get")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_make_post), "TEST_SIMPLE_WEB_REQUEST.test_make_post")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_with_header), "TEST_SIMPLE_WEB_REQUEST.test_with_header")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_with_json_content_type), "TEST_SIMPLE_WEB_REQUEST.test_with_json_content_type")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_with_bearer_token), "TEST_SIMPLE_WEB_REQUEST.test_with_bearer_token")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_with_body), "TEST_SIMPLE_WEB_REQUEST.test_with_body")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_with_json_body), "TEST_SIMPLE_WEB_REQUEST.test_with_json_body")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_with_timeout), "TEST_SIMPLE_WEB_REQUEST.test_with_timeout")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_REQUEST}.test_fluent_chaining), "TEST_SIMPLE_WEB_REQUEST.test_fluent_chaining")
		end

	run_test_simple_web_response
		local
			l_evaluator: EQA_TEST_EVALUATOR [TEST_SIMPLE_WEB_RESPONSE]
		do
			create l_evaluator
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_make), "TEST_SIMPLE_WEB_RESPONSE.test_make")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_make_with_body), "TEST_SIMPLE_WEB_RESPONSE.test_make_with_body")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_is_success), "TEST_SIMPLE_WEB_RESPONSE.test_is_success")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_is_ok), "TEST_SIMPLE_WEB_RESPONSE.test_is_ok")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_is_client_error), "TEST_SIMPLE_WEB_RESPONSE.test_is_client_error")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_is_server_error), "TEST_SIMPLE_WEB_RESPONSE.test_is_server_error")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_add_header), "TEST_SIMPLE_WEB_RESPONSE.test_add_header")
			report (l_evaluator.execute (agent {TEST_SIMPLE_WEB_RESPONSE}.test_body_as_json), "TEST_SIMPLE_WEB_RESPONSE.test_body_as_json")
		end

feature {NONE} -- Implementation

	report (a_result: EQA_PARTIAL_RESULT; a_name: STRING)
			-- Count and print `a_result' of test `a_name'.
		do
			if a_result.is_pass then
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			else
				print ("  FAIL: " + a_name + " [" + {UTF_CONVERTER}.string_32_to_utf_8_string_8 (a_result.tag) + "]%N")
				failed := failed + 1
			end
		end

end
