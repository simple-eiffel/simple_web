# 02 RED (code-lite). Lens: simplicity-first, then provenance. Sources: G-A..G-E, 01 BLUE, 2 raw greps 2026-10-08 (P1-raw). No compile.

## RED-1 Deflationary

| Point | Evidence | Bearing |
|---|---|---|
| Thread rule already not load-bearing: simple_web root, showcase, gui_designer roots `use="thread"`; bible_htmx thread. 14 targets, 4 projects, against oracle "NEVER use thread". | G-D l.7-13 | D writes down existing practice. No thread-server failure cited. |
| B's win is over a baseline never measured: 0 clients on handler server. | G-D, BLUE C6 | BLUE compares B to A, not D. |
| Smaller B: port bible_htmx only (the one GUI-root client). | G-D l.11 | B8 needs no general migration. |
| B pays: logger/DB rework (97 `log` uses, 10 files), per-request routes, `separate` wrappers. | G-B K4 | ~100-150 lines (reading, conf 0.5) vs D = 0 lines + rule edit. |
| K1 is the only criterion D fails, by definition. | G-D | B's technical case buys K1 only; whether K1 is wanted is a value fork. |

## RED-2 Acceleration (10x)

| Axis | Record | RED reading |
|---|---|---|
| Per-request H | Execution makes request, response, H per request (`simple_web_handler_execution.e:29-31`). Spike built 4 routes. BLUE C7: UNTESTED. | O(routes) per request; no number. 3.5 ms is a 4-route H. |
| Processor creation per request | Not in any table. | Unmeasured; pool warmth may hide it (~60-120 requests). |
| Pool 100 | 120 slow = 4222 ms. Shipped test: short finite `/stream` only (`scoop_test_handler.e:59-63`), never run by gather. | 100 held SSE/long-poll connections starve all routes. UNTESTED. |
| 22 routes, more clients | State only via strings or `separate` wrapper. | Linear port cost per client. |
| EWF version move | `HTTPD_REQUEST_HANDLER`/`CONCURRENT_POOL` ISE contrib, ES 25.02 (G-A log5). | UNTESTED; B couples to connector internals, D and C do not. |

## RED-3 Provenance audit

| # | Row | Finding |
|---|---|---|
| a | B1 "three independent" K3 runs | One exe, one mechanism (handler sleeps in worker). A chain, not a rope; 0.9 overstates. |
| b | A-vs-B "same test" | Different ports (18081/18082), handler shape (A forced by VUAR), roots. Variable is handler processor. G-A disproves host-held handlers, not every A (pipeline: register compressed A). |
| c | G-A confound | First run-same/run-split logs `000` (port clash); record is run-same2. "Both layouts" 10.1 s: only run-same2 is clean. |
| d | G-B run2 T4 `000` | Root `_exit` at 12 s; run1 holds the record. Disclosed. |
| e | B2 mechanism | T2 reading agrees with runs. ok. |
| f | B5 "0 added" | `wc -l` 650 is P1; "cost paid" ignores unreleased status (C4), no field use. |
| g | G-B K4 estimate | Facts P1, line count a guess; BLUE marks 0.5. ok. |
| h | G-C RFC 9112 | P3, unobtained, excluded. ok. |
| i | G-D, K3 on D | No thread-failure search; K3 never run on D. Unverified gaps. |
| j | Register "0.2.0" | Commit label; CHANGELOG Unreleased (title error). |

## Champions

| Path | Case for | Conceded |
|---|---|---|
| A | G-A killed one layout (all handlers on one host). K1, K2 pass; SIMPLE_WEB_SHARED carries state (D1). Variants (several hosts, per-request) untested: a gap. | Claims 1 and 2 DISPROVEN as worded (1.58 s; VUAR). No code. |
| C | K6 = 0 contrib (ECF); no EWF version risk; fits simple_* rule once it exists. | K2/K3 untested; Hazard 2 likely needs simple_net change; parser unmeasured. |
| D | Strongest. 0 lines, 0 of 14 targets migrated, no measured defect; rule already contradicted. | Fails K1; oracle packet edit; no evidence thread is fine under GUI + server. |
| E | Cleans GUI exe K1; isolates GUI from server. | Not a server design (E1); orphan (E3); port 5500 (E5); second exe. |

## CHALLENGED items for BLUE

| # | Challenge | BLUE must show |
|---|---|---|
| RED-1 | B8/ledger never compare B to D on K2-K8. | A D baseline on K3, or say the choice is policy (K1). |
| RED-2 | B1 rope shares one mechanism and exe. | Independence, or redeclare chain and confidence. |
| RED-3 | 3.5 ms was a 4-route H; H creation per request. | Number at 22 routes / 8 objects, or retire K3 at that scale. |
| RED-4 | Pool 100 plus held connections (SSE, long-poll). | Spike or grep of bible_htmx streaming routes. |
| RED-5 | G-A is one layout. | Which A variants the data excludes. |
| RED-6 | EWF processor creation / pool reuse per request unmeasured. | Connector reading, or retract "0 cost". |
| RED-7 | B depends on ISE contrib scoop connector (ES 25.02). | Pin, or state unmitigated. |
| RED-8 | B5 "cost paid": 0 users, unreleased; K4 if logger cannot be `separate`. | Logger spike before ranking B above D. |
| RED-9 | The 10.1 s A figure: which run? | Cite run-same2 only. |
| RED-10 | K1 purpose when rule is broken in 14 targets. | Rule purpose; policy, held as value fork for Larry's gate. |
