# G-B Gather: pathway B (per-request handler class = shipped SIMPLE_WEB_HANDLER_SERVER [H])

ES 25.02.9.8732, win64, F_code, 2026-10-08, simple_web 0.2.0 (d10451f). Spike `spikes/B/`: live `simple_web.ecf` included directly, no copies, no override. T1 = executed, T2 = source read raw; all P1-raw. No lean held; nothing asserted before searching. Port 18082 free before runs.

| Claim / criterion | Evidence | Tier | Verdict | Path |
|---|---|---|---|---|
| **K2 / claim 7** non-blocking start | Root creates `separate SIMPLE_WEB_HANDLER_SERVER [B_HANDLER]`, `start` via a separate-formal routine, ticks every 200 ms. 60 ticks printed while 60+ requests served; gap min 0.200 s, max 0.225 s. | T1 | PASS | `run2.ticks.txt` |
| **K3** 20 parallel | `20 200` | T1 | PASS | `run1.curl.txt` |
| **K3** fast beside 2 s route | `/fast` 0.4 s into a `/slow`: **3.5 ms** (run1), 3.4 ms (run2); alone 3.8 ms. A failed this at 1.58 s. | T1 | PASS | `run1/2.curl.txt` |
| **K3** 5 slow + 5 fast | Wall **2128 ms** / 2122 ms; slow 2.005-2.011 s, fast 3.8-4.8 ms. G-A host layout: 10.1 s. | T1 | PASS, concurrent | same |
| K3 pool ceiling | 120 parallel `/slow`, default pool: 120 x 200, wall **4222 ms** (two 2 s waves) = EWF default 100 (G-A D5). `set_max_concurrent_connections` exists (`simple_web_handler_server.e:96`). | T1+T2 | A setting, not a defect | `run2.curl.txt` |
| Why B is concurrent, A was not | `SIMPLE_WEB_HANDLER_EXECUTION.execute` makes `H` per request on the request's processor (`simple_web_handler_execution.e:25-37`); sleep blocks one worker. In A all workers queued on the host processor. | T2+T1 | Consistent with both runs | `src/server/handler/` |
| **K5 (i)** immutable value | Root `shared_put ("db", ...)`; H `shared_item ("db")` returned `db=D:/data/bible.db`. No `separate` in H code: it is inside the library (`simple_web_shared.e:30-47`). Strings only. | T1 | PASS | `run1.curl.txt` |
| **K5 (ii)** shared service object | `counter: separate B_COUNTER` as `once ("PROCESS")` compiled. H calls `bump_and_read (counter)`, a routine with a separate formal. 3 sequential hits = 1,2,3; plus 20 parallel ended at 23, none lost. | T1 | PASS. Cost: `separate` declaration plus one wrapper routine per service; each access queues on the service's processor. | `src/b_state.e` |
| **K5** plain `once ("PROCESS")` from H | `VFFD(8) once function with once key "PROCESS" is not of a separate type` (B_STATE.plain_path). | T1 | Not usable under SCOOP (same as G-A D3) | `log2-compile-plain-once-process.txt` |
| **Claim 3** "K3 and K5, no `separate` in client handler code. Always." | K3 holds. K5 holds without `separate` only for strings via SIMPLE_WEB_SHARED. Objects need `separate` plus a wrapper (row above). | T1 | As worded **DISPROVEN** (K5 half). K3 half stands. **Deployment line:** rely on K3 and string state; do not assume `separate`-free objects. | spike B |
| **Claim 4** "22 one-line registrations plus one route class" | 22 `server.on_get (..., agent X.handle_y)` at `bible_htmx_app.e:142-181` (5 on the app class, 17 on 8 HTMX_* classes). H uses the same shape: `routes.on_get (pattern, agent f)` (`simple_web_routes.e:87`, `simple_web_request_handler.e:42`). | T2 | Registration line count holds. "One route class" understates the port (next row). | `bible_htmx_app.e` |
| **K4 port cost** (read, not ported) | (a) `HTMX_SHARED.log` and `shared_db_path` are non-separate `once ("PROCESS")` (`htmx_shared.e:12,20`): VFFD(8). All 8 handler classes inherit it. (b) `log` appears 97 times across 10 files (word count; upper bound). (c) `css_content`, `htmx_js_content`, `alpine_js_content`, `page` are app fields read by 4 handlers; they would move to SIMPLE_WEB_SHARED strings. (d) `SIMPLE_BROWSER.run` blocks the root, so the server must be started as in the spike. (e) `server_thread.e` (38 lines) deleted. Estimate: 22 route lines, one H class of ~40 lines, ~30 lines to rework the logger and DB path, start-up edits. Handler bodies untouched unless the logger API changes. | T2 | Estimate: ~100-150 lines in 3 files; the logger is the unknown | `/d/prod/simple_scholar/htmx/*.e` |
| K4 unknown | Whether SIMPLE_LOGGER can be a `separate` service is not read. Per-request cost of building 22 routes + 8 handler objects not measured (spike built 4). | - | UNTESTED | - |
| **K1** | Same ECF shape as G-A's built closure (no THREAD in generated C; G-A log5). `spike_b.ecf` built F_code. Thread classes excluded under SCOOP by `simple_web.ecf:50-57`. | T1 | PASS | `log1-compile.txt` |
| **K6** | wsf, default_standalone, httpd, uri_template (+ net via httpd): same as A. | T2 | No B/A difference | `spike_b.ecf` |
| **K7** | No client uses the handler server (register erratum). `SIMPLE_WEB_SERVER` unchanged. Moving a client costs a port. I did not read gui_designer, showcase, wms_api or todo_api. | T2 | Keep-compiling PASS; migration per client | register |
| **K8** | B is shipped: 650 lines, 7 classes in `src/server/handler/` (`wc -l`), plus `simple_web_scoop_tests`. Added for B: 0. | T1 | Cost already paid | `src/server/handler/` |
| Untested | Behaviour at pool exhaustion beyond 120 requests; SSE under the pool; bind address (default 0.0.0.0 per class note). | - | UNTESTED | - |

## Spike log excerpt (run1 unless noted; `bash run.sh <scratch> x run1`)

```
T3 20 parallel fast         20 200
T1 fast during slow         fast-during-slow: 200 0.003477s  slow: 200 2.008199s
T2 5 fast + 5 slow          wall: 2128 ms
K5                          db=D:/data/bible.db  hits=1 hits=2 hits=3 (+20 parallel up to 23)
T5 (run2) 120 slow          120 200   wall5: 4222 ms
log2                        Error code: VFFD(8) Class: B_STATE Feature name: plain_path
```

Compile attempts: 4 (syntax slip, success, VFFD probe, rebuild with T5). Exe timestamps fresh (21:47:23, 21:48:11). Run 2 T4 `000` is the root's 60-tick `_exit` at 12 s, not a server fault. Only my own PID stopped; 0 `spike_b` processes remain. EIFGENs, exes and the scratchpad copy deleted.
