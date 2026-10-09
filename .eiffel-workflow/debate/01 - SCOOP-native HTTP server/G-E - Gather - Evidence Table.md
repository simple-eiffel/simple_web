# G-E Gather: pathway E (out-of-process). Source reads only, 2026-10-08, T2/P1-raw, no compile.

| Claim | Evidence | Path |
|---|---|---|
| E1. Not a server design: the child is A, B, C or D (nearest: shipped B, 0.2.0 d10451f). E cleans only the GUI exe's K1; with D the child still has `thread` and the oracle rule (boot lines 23,25) is still amended. | Register:39,25; G-A K1; G-D | Fork Register |
| E2. Non-blocking launch exists: `launch`/`launch_in`; piped/async child has `process_id`, `kill` (TerminateProcess, no wait). `close` does not kill. Parent can stop only a child it holds. (simple_process 1.1.0) | `simple_process.e:179,195`; `simple_piped_process.e:238-243,492-505`; `simple_async_process.e:84,302` | /d/prod/simple_process/src |
| E3. NO job object: grep Job in Clib+src is empty; CreateProcessW flags are CREATE_NO_WINDOW + extended startup only. A GUI crash ORPHANS the child. Needs parent-watch, stdin-close, or a job object added to simple_process. | `Clib/*.h:245-288` | /d/prod/simple_process/Clib |
| E4. Prior art: `PYTHON_TEST_SERVER` parses "READY <pid>", `is_running` stays False on launch failure (port busy), `stop` = `taskkill /F /T /PID` own pid only. Caveat: `start` uses blocking `execute` and the launcher daemonizes, so not a K2 pattern as written. | `python_test_server.e:4-5,60-70,76-87,92-100` | /d/prod/simple_python/test |
| E5. K2/K5: bible_htmx now sleeps then assumes "Server should be ready", hardcodes port 5500 (collision serves another app silently), navigates `http://localhost:5500`. DB path set in-process (`resolve_db_path`, once-PROCESS). E needs argv/env db path, READY poll, separate log, CSS/JS compiled into child; 22 routes move wholesale. | `bible_htmx_app.e:30-47,69,76-92,142` | /d/prod/simple_scholar/htmx |
| E6. K7/K8: second exe per client to build, ship, version-lock; additive to A-D, not a substitute. | E1, E5 | - |
| E7. FINDING, no-server variant: simple_browser wraps webview/webview and exposes only navigate, set_html, init, eval, bind/unbind/return. No virtual-host mapping or WebResourceRequested wrapper in Eiffel/Clib; they exist only in the vendored SDK header (WebView2.h:2074-2085). In-process serving needs new C wrapper work. `set_html` cannot serve 22 htmx routes. UNTESTED (no run). | `webview_engine.e:95-102,306-430`; `browser_engine.e:56` | /d/prod/simple_browser/src/core |

Verdict: E = A-D + deployment layer. E-specific risks: orphan child (E3), fixed-port collision (E5).
