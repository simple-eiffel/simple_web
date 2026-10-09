# 01 - SCOOP-native HTTP server: Fork Register

Project: D:\prod\simple_web | Opened 2026-10-08 (Larry: "open the debate on simple_web") | Mode: code-lite
Rules: General Research ROE v1.0 (gated 2026-10-06); ROE-CARD v1.0 (gated 2026-10-07): versions agree, card valid.

## The decision

How does simple_web serve HTTP under `concurrency=scoop`, so no simple_* client needs the ISE thread library?

Today (read raw 2026-10-08):
- **The server only exists under thread or none concurrency.** `SIMPLE_WEB_SERVER` and its router and execution classes sit in `src/server/thread/`, which `simple_web.ecf:50-57` compiles only when concurrency is thread or none. simple_web's own target is `support="scoop" use="thread"`.
- **The router is shared process-wide, and the handlers come from the client.** The router is `once ("PROCESS")` (`simple_web_server.e:160-166`), and handlers are `PROCEDURE [REQUEST, RESPONSE]` agents the client creates.
- **First client: simple_scholar `bible_htmx`.** It has 22 routes. `htmx/server_thread.e` inherits ISE `THREAD` and runs `server.start` (blocking) in the background while the root thread drives the SIMPLE_BROWSER WebView2 window. Shared state: a `once ("PROCESS")` logger and DB path, and per-thread DB connections.
- **Other clients:** simple_gui_designer, simple_showcase, and simple_web's own `wms_api` and `todo_api` targets.
- **Connector fact:** ISE EWF `httpd` (ES 25.02) has a `concurrency_scoop` cluster (`contrib/.../ewf/httpd/httpd.ecf:54`, read raw). Under SCOOP it pulls in no thread library. Whether it serves requests concurrently under SCOOP is not yet executed.

## Erratum (declared 2026-10-08 after G-A; premise correction, criteria unchanged)

The "Today" paragraph was incomplete. simple_web **0.2.0 (d10451f)** already ships a SCOOP server, `SIMPLE_WEB_HANDLER_SERVER [H -> SIMPLE_WEB_REQUEST_HANDLER create make end]` (`src/server/handler/`), with one H per request created by EWF on the request's processor. There is also a `simple_web_scoop_tests` target. Only the agent-routed `SIMPLE_WEB_SERVER` is thread-only. None of the three client projects uses the handler server (grep, 2026-10-08).

**Consequences for the pathways:**
- **B is no longer hypothetical.** It is the existing 0.2.0 design. B's gather tests that design against K2-K5 and the cost of porting bible_htmx.
- **A as filed:** G-A's spike found that handlers held on a host processor serialize, and that the agent-routed request/response API does not cross processors (VUAR). See G-A.

**Orchestrator facts added after G-D (read raw 2026-10-08, P1-raw):**
- **Where the thread rule lives.** It is in the oracle's boot packet (`oracle-cli boot`, injected at every session start), not in the three briefing files G-D searched. Line 23: "ALL simple_* libraries MUST be SCOOP-compatible (concurrency=scoop)". Line 25: "NEVER use \"thread\" concurrency - ALWAYS \"scoop\"". CLAUDE.md:294 says only "SCOOP Compatible - Concurrency-ready design". So D's exemption would amend the oracle packet's rule, and that rule is written down.
- **The "0.2.0" citation.** It comes from commit d10451f's subject line ("simple_web 0.2.0: SCOOP mode - ..."). CHANGELOG.md still files that entry under `## [Unreleased]` (G-D), so the version is unreleased in the changelog.

The criteria K1-K8 and the filed claims stand as filed. Their scoring now applies to the existing B where relevant.

## Pathways

| ID | Pathway | One line |
|---|---|---|
| A | **SCOOP host object** | simple_web compiles `SIMPLE_WEB_SERVER` under SCOOP on EWF httpd's scoop connector. The client creates a `separate` host object that builds its handlers and routes on its own processor, and calls `host.start` asynchronously. Agents and the router stay as they are, scoped to the host's processor. |
| B | **Per-worker router from a route class** | The client gives the server a route-table class (deferred `SIMPLE_WEB_APP.register_routes (router)`). Each request's EWF execution builds or reuses its own router on its worker processor. Handlers are features of app classes, not agents captured on the root processor. Shared app state is reached only through `separate` service objects or immutable values. |
| C | **simple_* native server on simple_net** | A small HTTP/1.1 server built on simple_net's sockets (1.2.0), SCOOP from the start: an acceptor processor plus a worker processor per connection or a pool. It drops the EWF/ISE contrib dependency (the simple_*-only rule allows only base and testing). |
| D | **Status quo with a declared exemption (the simplest thing)** | Keep the thread-mode server and write the exemption into the ecosystem rules: HTTP server targets may use thread. bible_htmx is unchanged. |
| E | **Server out of process** | The GUI app (SCOOP) launches the server as a separate executable through simple_process and talks to it over HTTP. The server itself still needs A, B, C or D. **This is a deployment choice, not a server design.** Filed so it can be argued or ruled out. |

## Criteria (fixed before any evidence; no additions without a declared 16-D re-specification)

| # | Criterion | Measure |
|---|---|---|
| K1 | Pure SCOOP | The client system compiles with `concurrency=scoop` and no `thread` library anywhere in its closure (ECF closure inspected, `ec.sh check` output) |
| K2 | GUI coexistence | The root processor runs a message loop. Server start returns at once; a request is served while the loop stays responsive (spike: the loop ticks while curl gets 200) |
| K3 | Concurrent requests | 20 parallel requests all correct. A fast route answers in under 100 ms while a 2 s route is in flight (measured, F_code) |
| K4 | Client API cost | Registering a route stays one line, and the handler is the app's own feature. bible_htmx's 22 routes port mechanically (count of lines changed) |
| K5 | Shared state | Handlers reach app state (DB path, CSS/JS text, logger) without SCOOP violations. Per-request or per-worker DB connection, no cross-processor sqlite handle |
| K6 | Dependency rule | Count of ISE contrib libraries in the server's closure (fewer is better; simple_* first) |
| K7 | Existing clients | The thread-mode clients (gui_designer, showcase, wms_api, todo_api) keep compiling, or have a stated migration (count affected) |
| K8 | Cost | Lines added or changed in simple_web, and the maintenance surface (classes owned) |

## Filed claims (quantity and modality fixed at filing)

1. **A:** EWF httpd's scoop connector serves concurrent requests (K3) with handlers held on a host processor. Always, at 20 parallel requests.
2. **A:** Agents created on the host processor can be called from EWF's scoop request workers without a separateness error (K5). Always.
3. **B:** A per-worker router built from a route class meets K3 and K5 with no `separate` in client handler code. Always.
4. **B:** bible_htmx ports with 22 one-line registrations plus one route class (K4).
5. **C:** A simple_net-based server meets K1-K3 with zero ISE contrib libraries (K6), at the cost of HTTP parsing code owned by simple_web (K8). At this scale (local app servers, not internet-facing).
6. **D:** The thread exemption costs nothing today and breaks no client (K7). It fails K1 by definition.
7. **All except D:** A GUI root can start the server without blocking (K2). Always.

## S6 / GR-20 declaration (assert-before-retrieve)

The orchestrator (Opus session) leans toward **B**: EWF already has a SCOOP connector, and EWF's own design builds an execution per request, which suggests per-worker routing. Every search for B is therefore confirmation-seeking by sequence. Research also noticed C's appeal under the simple_*-only rule before any evidence. Both leanings are declared.

## Spike-first triage (Budget rule 2)

The load-bearing claims 1, 2 and 7 (does the EWF scoop connector serve concurrent requests while a root loop runs, and can host-processor agents be called from its workers?) **can be settled by one run.** The gather seat runs that spike first, in `spikes/`, following Spike hygiene: a minimal ECF using the live EWF libraries, built on the scratchpad, build output deleted afterwards.

What a run cannot settle, and the cycle argues: the API shape (A vs B), owning HTTP parsing (C) vs the EWF dependency, and the migration of the existing clients.

## Budget plan (Budget rules 1, 3, 4, 5; amended by Larry 2026-10-08)

Larry, 2026-10-08: "A thru E in turn, one at a time, using the model rules from Haiku to Sonnet to Opus to Fable."

| Order | Seat | Agent type / model | Cap |
|---|---|---|---|
| 1 | G-A gather + spike (EWF scoop connector, host object) | debate-seat / Sonnet 5.5 | 5 KB + spike log |
| 2 | G-B gather + spike (per-worker router) | debate-seat / Sonnet 5.5 | 5 KB + spike log |
| 3 | G-C gather (+ spike if cheap: simple_net server) | debate-seat / Sonnet 5.5 | 5 KB |
| 4 | G-D gather (closures, client counts, exemption cost) | general-purpose / Haiku 5.5 (mechanical) | 3 KB |
| 5 | G-E gather (out-of-process server) | debate-seat / Sonnet 5.5 | 3 KB |
| 6 | 01 BLUE opening | debate-seat / Sonnet 5.5 | 6 KB |
| 7 | 02 RED (3 lenses + rival champions) | debate-seat / Sonnet 5.5 | 6 KB |
| 8 | 03 BLUE rebuttal | debate-seat / Sonnet 5.5 | 4 KB |
| 9 | 04 VERDICT | debate-adjudicator / Opus 5.5, high | 10 KB |
| (10) | Escalation only, if the adjudicator names a crux the record cannot settle | Fable 5.1 | 4 KB |

Strictly sequential: each seat starts after the previous one returns, so there is only one compile at a time. That makes 9 agents (10 if escalated), code-lite seats with per-pathway gathers, condition C3. Estimate ~350-450k tokens. Session model: Opus 5.5; orchestration passes paths only.

**Status: GO given by Larry 2026-10-08. Gathering.**
