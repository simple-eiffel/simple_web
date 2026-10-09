# 03 BLUE Rebuttal (challenged items only)

**Spike B2, 2026-10-08** (`spikes/B2/`; live `simple_web.ecf`; ES 25.02.9.8732 F_code, exe fresh 22:00; 1 clean compile after 2 source slips; port 18084; own PID only; build dirs deleted). H builds 22 routes + 8 objects **per request**. Method as G-B.

| Measure | G-B (4 routes) | B2 (22 routes, 8 objects) |
|---|---|---|
| fast alone | 3.8 ms | 4.2-6.5 ms (x5); `/r20` 4.4 ms |
| 20 parallel fast | 20 x 200 | 20 x 200 |
| fast 0.4 s into slow | 3.5 ms | 4.0 ms |
| 5 slow + 5 fast wall | 2128 ms | 2144 ms (fast 4.6-6.9 ms) |

| RED | BLUE answer | Evidence | Status |
|---|---|---|---|
| 1 | D baseline for K3 was never run. On K2-K8 D wins K4, K7, K8 (0 change); B beats D only on K1. I do not rank B above D on K2-K8. K1 is the written oracle rule (boot l.23,25), so it is a rule-conformance question, measurable for B. | G-D; register | conceded (K2-K8) |
| 2 | Redeclared **chain**: one exe, one mechanism. B1 confidence 0.9 -> 0.8. B2 (new exe and H shape, same result) adds a replication, not independence. | G-B; B2 | conceded |
| 3 | Number given: at 22 routes + 8 objects per request, fast = 4.0 ms during slow, about 0.5-2 ms over the 4-route H, 25x under the 100 ms bar. Limits: dummy bodies, one run, no logger/DB. | B2 table | answered |
| 4 | Pool 100 stands (120 slow = 4.2 s). Grep of `htmx/*.e` for SSE, event-stream, poll, `every N` found no streaming route (P1-raw): bible_htmx is request-reply. SSE under the pool for other clients stays UNTESTED; deciding spike = 100 held `/stream` connections, then `/fast`. | grep 2026-10-08; G-B pool row | narrowed |
| 5 | G-A excludes only: all agents on one host processor (1.58 s; 10.1 s) and request/response across processors (VUAR). Several hosts or per-request hosts are untested, and the one that avoids the queue is B's shape. | G-A K3, claim 2 | answered (A as filed); variants untested |
| 6 | Connector source not re-read. "0 cost" retracted. End-to-end per-request cost (H creation, 22 routes, any processor reuse) is 4-6.5 ms; mechanism unattributed. | B2 table | conceded |
| 7 | Unmitigated. B uses the ISE contrib scoop `httpd`, as does A (K6: 5 libs); D's thread classes also use EWF. No version pin tested; only C removes it. | G-A log5; G-C | conceded |
| 8 | "Cost paid" is library side only: 0 lines, but 0 clients and unreleased. Logger as `separate` service UNTESTED; deciding spike = port `HTMX_SHARED.log`/`shared_db_path`, run bible_htmx. | G-B K4/K8; G-D | narrowed |
| 9 | Only run-same2 counts for A (10.1 s; 1.58 s). The first run-same/run-split logs are confounded; I do not rely on them. | G-A confound note | conceded |
| 10 | From the record: the rule is written and violated in 14 targets, which shows non-conformance, not lapse. Amend-or-enforce is policy and I take no technical position on it. Whether B conforms (K1) is technical and measured. | boot l.23,25; G-D | narrowed |

**Tally:** conceded 1, 2, 6, 7, 9 (5); narrowed 4, 8, 10 (3); answered 3, 5 (2). **Still open for B:** logger/DB port (8), SSE under pool (4), no field use.
