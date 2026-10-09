# Spike: simple_net connection hand-off to worker processors (2026-10-09)

Question: can simple_net (1.2.0) serve HTTP under SCOOP with per-connection workers, the way
EWF's SCOOP pool does (listener accepts, a worker processor owns the connection)?

Override (2 classes, `override/`): `SERVER_SOCKET.accept_handle` returns the raw accepted handle;
`CONNECTION.make_accepted` exported so a worker adopts that handle on its own processor. Only
expanded values (handle, port) cross processors, so dispatch stays asynchronous.

Result (F_code, loopback, same tests as debate 01 spike B on EWF):

| Test | simple_net hand-off | EWF (spike B) |
|---|---|---|
| fast alone | 1.1 ms | ~3.5 ms |
| 20 parallel fast | 20/20 | 20/20 |
| fast while /slow (2 s) in flight | 0.9 ms | 3.5 ms |
| 5 slow + 5 fast, wall | 2157 ms | 2130 ms |
| 120 parallel slow | 120/120 in 3080 ms | 120 in 4200 ms (pool 100) |
| root keeps running | ticked throughout | yes |

Answer: YES. The gap is two small simple_net additions (raw accept + public adoption), plus
the known terminal-accept-timeout (worked around with a 3600 s timeout). No pool, parser
limits or keep-alive here: this settles transport feasibility only.
