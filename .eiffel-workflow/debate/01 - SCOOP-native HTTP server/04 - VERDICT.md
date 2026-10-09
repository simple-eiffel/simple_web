# 04 VERDICT: SCOOP-native HTTP server (simple_web, cycle 01)

Opus 5.5, 2026-10-08. **AWAITING GATE.**

## 0 Declarations

| Item | Ruling |
|---|---|
| ROE | General Research ROE **v1.0, Oct 6 2026** (read in full); application profile + Steps 7-8 of SKILL.md |
| Condition | **C3** without the proposal; **C2** with the executed-evidence *(proposal)* (claims 1-3, 7 and the logger crux rest on F_code runs). C1 after Larry's gate |
| Interest | None; no **-i** (no AI tooling at issue) |
| My provenance | P1-raw: logs A/run-same2, B/run1, B2/run1; `htmx_shared.e`, `simple_web_request_handler.e`, `simple_web_routes.e:87`, `simple_logger.e:656-668`, bible_htmx lib ECFs. Executed: **ADJ**. P4: memory "simple-first" (2026-10-07) |
| S6 | Declared B lean precedes me. ADJ was built to fail (VFFD, VUAR, torn lines, SQLite errors); none occurred |

**Spike ADJ** (`spikes/ADJ/`, ES 25.02.9.8732, F_code, 1 compile). `HTMX_SHARED` ported: `log` from `once ("PROCESS")` to per-processor `once` set up from a `SIMPLE_WEB_SHARED` path; DB path likewise; SQLite connection per request; handlers call `log.info`. Results: generated C has no THREAD/MUTEX/SEMAPHORE (controls present); 20 parallel `/hit` all 200 with `x=42`; the log has exactly 34 lines (1 root + 27 hit + 6 slow) and 0 malformed, n=1..20 all present; fast-during-slow 6.1 ms; 5 hit + 5 slow, wall 2166 ms; root ticks every 0.201-0.246 s while serving.

## 1 Procedural rulings

| # | Ruling |
|---|---|
| P1 | Ripe (GR-6): RED's 10 challenges got 5 conceded, 3 narrowed, 2 answered; B2 added new data |
| P2 | Erratum is a premise correction, not 16-D; K1-K8 unchanged. **B = shipped `SIMPLE_WEB_HANDLER_SERVER [H]`** |
| P3 | Splits (G1-G5): 2 → 2a/2b; 3 → K3, K5a config, K5b mutable objects; 4 → lines/port; 6 → cost/K1; 7 per pathway |
| P4 | RED-3b upheld: G-A disproves **A as filed** (all handlers on one host), not every variant. A per-request host *is* B's shape |
| P5 | RED-3a upheld: B1 is a chain; B2 and ADJ are replications, not strands |

**Pipeline log (GR-19).** Seats sequential per Larry ("A thru E in turn"): Haiku G-D, Sonnet others, Opus adjudicator. RED was trimmed by its author from 8.7 to 4.8 KB and all ten RED-n survived. G-A: the first logs clashed on a port with a stray exe; **run-same2 is the record** (raw-read: 1.58 s, 10136 ms). Errors: *pipeline*: A/B run.sh label "T2 20 parallel (5 fast, 5 slow)" sends 10 requests (label only); *pipeline*: the register's "only base and testing" overstates BUILD_STANDARDS:41 (G-C); *title*: "0.2.0" is a commit subject, and the CHANGELOG lists it as Unreleased. **Hygiene:** `find spikes -name EIFGENs` and a search for *.exe/obj/lib/dll in spikes/ and in my scratch both returned **empty**. I deleted ADJ's EIFGENs and `adj.rc`, stopped only my PID 29404, and no `adj` process remains.

## 2 External confrontation

| Kind | What |
|---|---|
| Executed | A run-same2; B run1/2; B2 run1; ADJ run1 |
| Read raw (H1) | EWF httpd; simple_web; simple_net 1.2.0; simple_process; simple_browser; bible_htmx; boot l.23/25 |
| Named humans | **None**; EWF maintainers unread; RFC 9112 unobtained (P3) |

## 3 Scored ledger (confidence / rootedness, never merged)

| Pathway | Status | Conf | Root | Basis |
|---|---|---|---|---|
| **A** host object, as filed | DISPROVEN | 0.05 | 0.85 | K3 fails (1.58 s vs a 0.1 s bar; 5+5 took 10.1 s); req/resp cannot cross processors (VUAR) |
| **B** per-request handler class | **PREFERRED** | 0.80 | 0.85 | K1-K3, K5 met in 3 runs; K8 0 added; port not run |
| **C** simple_net server | UNTESTED | 0.30 | 0.65 | K1/K6 met on the ECF only; K2/K3 not run; Hazards 1-2 |
| **D** thread exemption | DISPROVEN (K1, by definition) | 0.10 | 0.90 | Cheapest on K4/K7/K8; fails K1 and boot l.23/25 |
| **E** out of process | UNSUPPORTED as a design | 0.20 | 0.80 | Not a server (E1); orphaned child (E3); fixed port (E5) |

| Claim | Status | Conf | Root |
|---|---|---|---|
| 1 A concurrent with host handlers | DISPROVEN | 0.05 | 0.90 |
| 2a host agents take req/resp from workers | DISPROVEN | 0.05 | 0.90 |
| 2b value-in/value-out host agents | ESTABLISHED (serial) | 0.85 | 0.90 |
| 3-K3 B concurrent (fast 3.5-6.1 ms beside 2 s; 22 routes + 8 objects per request: 4.0 ms) | ESTABLISHED | 0.85 | 0.90 |
| 3-K5a config state (logger, DB path, per-request SQLite) with no `separate` in client code | ESTABLISHED at spike scale (ADJ) | 0.80 | 0.85 |
| 3-K5b shared mutable objects with no `separate` ("always") | DISPROVEN as worded | 0.10 | 0.90 |
| 4a 22 one-line registrations; handler signatures unchanged (`PROCEDURE [SIMPLE_WEB_SERVER_REQUEST, SIMPLE_WEB_SERVER_RESPONSE]`) | ESTABLISHED (read) | 0.85 | 0.90 |
| 4b port about 100-150 lines | PREFERRED (estimate) | 0.60 | 0.70 |
| 5 C meets K1-K3 with 0 contrib | UNTESTED | 0.30 | 0.60 |
| 6 D costs 0 lines and breaks no client | ESTABLISHED | 0.90 | 0.90 |
| 7 non-blocking start (A, B) | ESTABLISHED on a tick loop | 0.80 | 0.85 |

## 4 Deployment lines

| Claim | Rely on | Do not rely on |
|---|---|---|
| 2 | value-in/out calls to a separate host | host-held handlers touching req/resp, or concurrent |
| 3 | K3 via per-request H; config through `SIMPLE_WEB_SHARED` plus per-processor `once` | `separate`-free shared *mutable* objects (they need a separate service plus a wrapper, G-B) |
| 4 | 22 registration lines; handler bodies unchanged | 100-150 lines as a measured figure |
| 5 | C at 0 contrib (ECF) | C's K2/K3 or its parser cost |
| 6 | D = 0 lines today | thread mode shown safe (never searched; GR-22) |
| 7 | start returns at once | a real WebView2 loop (tick loop only) |

## 5 THE DECISION

**Pathway B: `SIMPLE_WEB_HANDLER_SERVER [H]` on EWF's scoop connector is simple_web's SCOOP server. Status: PREFERRED. Confidence 0.80, rootedness 0.85.**

Grounds: only B meets K1, K2, K3 and K5 in executed F_code runs; A fails K3; D fails K1 (boot l.23/25); E is not a server. PREFERRED, not ESTABLISHED: C is untested, not shown to fail. **Coexistence (GR-8):** C fits as a later *connector* under B's client API. The API survives; the REQUEST/RESPONSE internals that wrap WSF are rewritten (`simple_web_server_request.e:137`, T2).

| Overturn trigger (GR-23) | Effect |
|---|---|
| V1 bible_htmx port changes >150 lines, or needs handler-body edits beyond `log`/state calls | Reweigh B vs D on K4 at Larry's policy gate |
| In ported bible_htmx (F_code), a fast route takes >=100 ms during a 2 s route, or 20 parallel are not all 200 | 3-K3 DISPROVEN at client scale |
| A C spike passes 20/20, fast <100 ms beside 2 s, and 5+5 wall <2.5 s with 0 contrib | C becomes B's connector |
| An ES/EWF upgrade breaks the compile or the K3 rerun | Promote C |
| Larry exempts HTTP servers in boot l.23/25 | D becomes admissible for existing clients |
| 100 held streams with the pool raised starve `/fast` (>100 ms) | B weakened for streaming clients |

## 6 Do not assume

| Statement | Reason |
|---|---|
| Root- or host-created agents can serve request processors | VUAR (G-A logs 3-4) |
| A shared host processor gives concurrency | 1.58 s; 10.1 s (run-same2) |
| A non-separate `once ("PROCESS")` compiles under SCOOP | VFFD(8) (G-A D3, G-B) |
| A per-processor `once` shares state | One instance per processor; it suits the logger only because writes are append-and-close (`simple_logger.e:656-668`) |
| The log interleaves cleanly under heavy load | 1 run, 34 lines |
| B is released | CHANGELOG lists it as Unreleased |
| >100 concurrent connections | Pool default 100 (120 took 4222 ms) |
| C meets K2/K3 | Not run; accept timeout is terminal; CONNECTION cannot move to another processor |

## 7 Verification queue

| # | Spike / source |
|---|---|
| V1 | **Deciding:** port bible_htmx on a branch; scoop, no thread lib; run with the real SIMPLE_BROWSER loop; count changed lines; rerun K3 |
| V2 | 100 held `/stream` connections, then `/fast` (only for streaming clients; bible_htmx has none) |
| V3 | C: worker-side accept/hand-off in simple_net; K3 as G-B ran it |
| V4 | Logger under 500 parallel writes, malformed lines = 0 |
| V5 | Rerun B's K3 on the next ES release |
| V6 | EWF maintainers on `concurrency_scoop` (unobtained) |

## 8 Consequences for spec and implementation

| Item | Consequence |
|---|---|
| API | Client H class: `setup_routes` with `routes.on_get (p, agent f)`. State: `SIMPLE_WEB_SHARED` strings; per-processor `once` for stateless services; `separate` service + wrapper for mutable objects; per-request DB connection |
| bible_htmx port | Target `support/use=scoop`; drop `thread.ecf` (no other thread lib in its closure; `logging.ecf` is base+time only); delete `server_thread.e`. In `HTMX_SHARED`, `log` and `shared_db_path` become per-processor `once` set up from shared keys (`log`, level, `db`). css/htmx_js/alpine_js/page become shared strings. Root: `shared_put`, then a separate-formal `start`, then `SIMPLE_BROWSER.run`. Fixed port 5500 is a risk (E5) |
| simple_web | Cut a release with the handler server before a client depends on it. Set `set_max_concurrent_connections` explicitly. Deprecate `SIMPLE_WEB_SERVER` (thread) but **keep it compiling until the last client migrates** (K7) |
| 14 thread targets (G-D count) | Migrate in order: bible_htmx (1) → simple_web wms_api/todo_api (+tests) and simple_web_tests (6) → showcase (4) → gui_designer (3). Each gated by its own run; until then, recorded non-conformances |
| Risks | EWF coupling (RED-7, unmitigated); pool 100; log append atomicity; WebView2 loop |

## 9 Open items for Larry

| # | Item |
|---|---|
| **1** | **Policy:** does boot l.23/25 ("NEVER use thread") stand for HTTP servers? If yes, migrate the 14 targets under B. If you exempt them, D covers the existing clients and B is optional |
| 2 | Policy: does "fill gaps, never fall back to ISE" (2026-10-07) reach simple_web's existing EWF dependency (5 contrib)? If yes, commission C as B's connector (V3) |
| 3 | *(proposal)* applied: executed evidence counts as external confrontation (C2 vs C3) |
| 4 | Adoption: adopt B as adjudicated? Cut a simple_web release first? |
