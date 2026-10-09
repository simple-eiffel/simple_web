# G-A Gather: pathway A (SCOOP host object). Evidence table

ES 25.02.9.8732, win64, F_code, run 2026-10-08. Spike: `spikes/A/` (ECF, 8 .e, run.sh, 7 logs; build output deleted). Tier: T1 = executed this cycle, T2 = source read raw. P1-raw = read/run this cycle. Declaration: I asserted nothing before searching; no lean held.

## Open discovery pass (GR-20)

| Claim | Evidence | Tier | P | As-of | Path |
|---|---|---|---|---|---|
| D1. simple_web 0.2.0 ALREADY ships a SCOOP server: `SIMPLE_WEB_HANDLER_SERVER [H]`. EWF creates a fresh H per request on the request processor, H builds its routes and agents there. The register's "server only exists under thread/none" is stale. | Class read; commit d10451f; `simple_web.ecf` has target `simple_web_scoop_tests` (SCOOP_TEST_APP: 404, shared value, 2 slow overlap, SSE) | T2 | P1-raw | 2026-10-08 | `src/server/handler/simple_web_handler_server.e`, `testing/scoop/` |
| D2. That is structurally pathway B's shape; A has no code in the repo. | Same classes | T2 | P1-raw | 2026-10-08 | same |
| D3. The old thread classes refuse to compile under scoop: 4 x VFFD(8) "once PROCESS not of a separate type" (SIMPLE_WEB_SERVER_ROUTER.routes, .middleware_pipeline; SIMPLE_WEB_SERVER.router; SIMPLE_WEB_SERVER_EXECUTION.router). | `log2-compile.txt` | T1 | P1-raw | 2026-10-08 | `spikes/A/` |
| D4. `SIMPLE_WEB_SHARED` already carries state under SCOOP via `once("PROCESS")` of separate type. | Class read; my A_SHARED reused the form and compiled | T1+T2 | P1-raw | 2026-10-08 | `src/server/handler/simple_web_shared.e` |
| D5. Connector pool default 100 (`max_concurrent_connections`, `max_tcp_clients`). | Constants read | T2 | P1-raw | ES 25.02 | `ewf/httpd/configuration/httpd_constants.e:18-19` |
| P4 lead: oracle gotchas mention no SCOOP/web item. Nothing found is unverified. | `oracle-cli check`, grep | T2 | P1-raw | 2026-10-08 | oracle |

## Filed claims and criteria, as they bear on A

| Claim / criterion | Evidence (executed) | Verdict | Path |
|---|---|---|---|
| **K1** pure SCOOP, no thread lib. Closure = base, time, wsf, default_standalone, httpd, uri_template, simple_web (library). | Built F_code, `concurrency support="scoop" use="scoop"`. Generated `evisib.c` has no THREAD, MUTEX, THREAD_CONTROL or SEMAPHORE; HTTPD_REQUEST_HANDLER and CONCURRENT_POOL present (control). Exe 13.9 MB. | PASS (closure with WSF/httpd). Not PASS for existing `src/server/thread` classes (D3). | `log5-compile-v3-value-handlers.txt` |
| **Claim 2** host-processor agents callable from EWF workers, no separateness error. v1: `handle(req: SIMPLE_WEB_SERVER_REQUEST; res: ...)` called by the worker. | **VUAR(3)** x2 at `a_app.handle (a_req, a_res)`: formal must be separate when the actual is a reference. | DISPROVEN as worded (agents taking the existing REQUEST/RESPONSE). | `log3-compile-v1-plain-formals.txt` |
| Claim 2 v2: formals and agent type made `separate`. | **VUAR(3)** x3 inside the handlers: `res.send_text ("fast")` and `res.send_error (404, "nope")`. The formal `READABLE_STRING_8` is not separate, so every string-taking command of SIMPLE_WEB_SERVER_RESPONSE fails when the response is held across processors. | The existing request/response API cannot cross processors. | `log4-compile-v2-separate-formals.txt` |
| Claim 2 v3: handler agents (`FUNCTION [STRING_8]`) live on the host; the worker passes the path as a `separate STRING_8` argument and copies the result with `make_from_separate`; the worker writes the response itself. | Compiles and runs (below). | HOLDS only for value-in/value-out handlers. Handlers cannot touch request or response. | `src/a_app.e`, `src/a_execution.e` |
| **K2** GUI coexistence (root prints a tick every 200 ms, `separate` host, `host.start` asynchronous). | Both modes: 100 ticks printed to the end, 77 ticks when killed mid-run. T0, T3 and T4 returned 200 while the loop ran. | PASS. `start` returns at once. | `run-same2.ticks.txt`, `run-split.ticks.txt` |
| **K3 / claim 1** 20 parallel, fast under 100 ms beside a 2 s route. Config: one host processor owns the agents. Both layouts: host = server and app (`same`); app on a processor apart from the server (`split`). | 20 parallel `/fast`: all 20 returned 200 (both layouts). `/fast` fired 0.4 s after one `/slow`: **1.58 s** (needs <0.1 s; fast alone 3.5 ms). 5 slow + 5 fast in parallel: wall **10.1 s** (5 x 2 s serial); completions at 2.0, 4.0, 6.0, 8.0, 10.0 s. 2 s-handler routes fully serialized in both layouts. | Correctness PASS (20/20). The fast-under-100-ms test FAILS: **claim 1 DISPROVEN as worded** (serial on the host processor). Concurrency is the connector's, and the handler on the host kills it. | `run-same2.curl.txt`, `run-split.curl.txt` |
| **Claim 7** (A) root starts the server without blocking. | See K2. | PASS | same |
| K6 | 5 contrib libs listed above (wsf, default_standalone, httpd, uri_template, plus net via httpd) beyond base/time. | measured | `spike_a.ecf` |

Mechanism (T1 + T2): each SCOOP request worker's call into the host queues behind the host processor. Handler sleep time is held on that one processor. Request-per-processor handler objects (D1) avoid it.

## Spike notes

- Compile attempts: 7 (VTCT unknown classes: libs must be listed directly; VFFD; VUAR; VUAR; built; rebuild for 100 ticks). Run: `bash run.sh <scratch> same|split <logprefix>`.
- Confound disclosed: the first `run-same` and `run-split` logs show `000` (5 + 2 failures) because a first taskkill did not stop the earlier exe and two exes shared port 18081. `run-same2` (clean, `Stop-Process` on my own PID 31568 only, port 18081) is the record: 34/34 requests 200, T4 after burst 200 in 4 ms. Stray exes self-exited at tick 100; 0 `spike_a` processes remain.
- `Process` ordering sample (run-same2 T1): `slow: 200 2.009965s`, `fast-during-slow: 200 1.582882s`.
- Cleanup: EIFGENs and exe/obj/lib deleted in spikes/A and the scratchpad copy.
