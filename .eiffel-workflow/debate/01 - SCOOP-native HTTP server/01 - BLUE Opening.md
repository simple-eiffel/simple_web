# 01 BLUE Opening: pathway B (SIMPLE_WEB_HANDLER_SERVER [H])

**Lens (GR-7):** ecosystem-reuse + SCOOP-correctness. **Provenance (S1):** every row below is P1-raw from G-A..G-E (T1 executed ES 25.02.9.8732 F_code 2026-10-08, or T2 source read). No P3 used. I asserted nothing before reading the five tables; the register's Opus lean to B is declared (S6).

## Arguments (each split per G1-G5; structure declared)

| # | Claim (one claim each) | Structure and defense | Rows | Conf / rootedness |
|---|---|---|---|---|
| B1 | B passes K3: 20/20 correct; fast route 3.5 ms beside a 2 s route; 5 slow + 5 fast in 2.13 s | **Rope**: three independent measurements (20-parallel, fast-beside-slow, mixed wall), each could have failed; the same test failed A (1.58 s, 10.1 s). | G-B K3 rows; G-A K3 | 0.9 / 0.9 |
| B2 | Mechanism: EWF builds H per request on the request's processor, so sleep blocks one worker only | **Chain** (source read -> run agrees). Weakest link: mechanism is T2 inference, but A's serial result is the control | G-B row "Why B"; `simple_web_handler_execution.e:25-37` | 0.85 / 0.9 |
| B3 | B passes K1 and K2: no THREAD in generated C; root ticks 60x (gap 0.200-0.225 s) while 60+ requests served | **Rope**: K1 (compile/C inspection) and K2 (run) are independent. SHARED with A on K1 | G-B K2, K1; G-A K1 | 0.9 / 0.9 |
| B4 | B passes K5 for strings, and for objects via `separate` service + wrapper routine | **Hybrid**, two strands: (i) SIMPLE_WEB_SHARED strings (T1 pass), (ii) separate counter, 23/23 no lost update (T1 pass). Not "separate-free" (conceded below) | G-B K5 (i),(ii) | 0.85 / 0.85 |
| B5 | B costs nothing new in simple_web: 650 lines, 7 classes, scoop test target already shipped | **Chain**: wc -l -> shipped -> 0 added. Weakest link: shipped is not released (concession C4) | G-B K8; G-A D1 | 0.9 / 0.9 |
| B6 | Registration shape is unchanged in kind: `routes.on_get (pattern, agent f)`; the 22 current lines are `server.on_get (..., agent X.handle_y)` | **Chain**, T2 reading only. Separate from port cost (B7) | G-B claim 4 row | 0.8 / 0.9 |
| B7 | Porting bible_htmx is ~100-150 lines in 3 files | **Chain**, reading estimate, logger unknown. **Deployment line:** rely on route lines (B6); do NOT rely on 100-150 as measured | G-B K4 row | 0.5 / 0.6 |
| B8 | Only B and the ECF-only parts of C are K1-pure with a measured server; C and E do not displace B | **Rope**: C untested (G-C), E is deployment layered on A-D (G-E E1), A fails K3 (G-A) | G-C, G-E, G-A | 0.75 / 0.8 |

## Concessions (GR-2; numbers changed)

| # | Datum that stands | Effect |
|---|---|---|
| C1 | Filed claim 3 "no `separate` in client handler code, always" is **DISPROVEN as worded** (G-B). Plain `once("PROCESS")` fails VFFD(8); object state needs `separate` + wrapper | B4 claims only strings and wrapped services. Claim 3 K3 half stands |
| C2 | Logger as a `separate` service is **UNTESTED**; `HTMX_SHARED.log` (97 uses, 10 files) and `shared_db_path` are non-separate once-PROCESS in all 8 handler classes (G-B K4a-b) | The port is not "mechanical" until a spike shows it. B7 conf 0.5 |
| C3 | Port cost 100-150 lines is a reading estimate; "one route class" understates (G-B) | Filed claim 4 holds for 22 lines, not for "plus one class" |
| C4 | CHANGELOG files the SCOOP entry under `## [Unreleased]`, no 0.2.0 heading (G-D). "0.2.0" is a commit-subject label | B is shipped in a commit, unreleased. Not a stable release |
| C5 | Pool ceiling 100 (120 slow = 4.2 s); SSE under pool, bind address 0.0.0.0, pool exhaustion: UNTESTED | A setting (`set_max_concurrent_connections`), not a B defect, but SSE is open |
| C6 | Zero clients use the handler server (G-D). 14 thread-mode targets, 4 projects | B has no field use; K7 is migration per client |
| C7 | Per-request cost of building 22 routes + 8 handler objects not measured (spike built 4) | K3 latency at bible_htmx scale UNTESTED |
| C8 | K6: B and A both have 5 ISE contrib libs. C has 0 (G-C) | B loses K6 to C. Not a B/A difference |
| C9 | Oracle packet lines 23,25 forbid thread; D's exemption amends them (register fact). D is not B's concern, but D wins K7 outright (0 migration) | |

## ALIGNMENT LEDGER

| K | Evidence | B | Comparison |
|---|---|---|---|
| K1 | G-B log1, G-A log5 | **Met** (shared with A) | A met; C met by ECF only; D fails by definition; E cleans GUI exe only (E1) |
| K2 | G-B ticks | **Met** | A met; C, untested; E needs READY poll, orphan risk (E3,E5) |
| K3 | G-B 3 rows; G-A | **Met** at 20; pool 100 | A **not met** (1.58 s; 10.1 s); C untested (accept hazards 1,2); D/E inherit their server |
| K4 | G-B K4, claim 4 | **Partly**: 22 lines yes; logger/DB state untested | A needs value-in/value-out handlers, no request/response (VUAR); C needs own router; D 0; E moves 22 routes wholesale |
| K5 | G-B K5, VFFD log | **Partly**: strings met, objects need `separate`+wrapper | A VFFD(8) same; C same limit; D 0 change |
| K6 | G-C | **Partly**: 5 contrib | A 5; C 0 (best); D thread in closure; E depends on child |
| K7 | G-B K7, G-D | **Partly**: thread clients still compile; each migration is a port | A same; C same; **D best (0)**; E additive |
| K8 | G-B K8, G-C | **Met**: 0 added, 7 classes owned | A has no code; C owns the HTTP parser (size unmeasured); D 0; E second exe per client |

## What B must still prove (overturn triggers I accept)

| Spike | B is overturned or weakened if |
|---|---|
| Port bible_htmx logger and DB path onto SIMPLE_WEB_SHARED or a separate service in a scoop build | Needs more than ~150 lines, or any handler body edit beyond the logger call (C2, C3) |
| Per-request build of all 22 routes + 8 handlers: fast-route latency | Fast route >= 100 ms at bible_htmx scale (C7) |
| SSE route under the 100-connection pool | SSE starves the pool or fails under `separate` (C5) |
| C spike: worker-side accept/hand-off in simple_net, K3 as G-B ran it | C passes K1-K3 at 0 contrib and the parser cost is small: B loses K6, B stays on K4/K8 |
| Release 0.2.0 / API freeze | Any interface change to `SIMPLE_WEB_REQUEST_HANDLER` that breaks B6 (C4) |
