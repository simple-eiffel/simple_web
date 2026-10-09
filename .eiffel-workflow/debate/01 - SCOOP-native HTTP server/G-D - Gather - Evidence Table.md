# G-D Gather: pathway D (thread exemption)

Read-only. Targets read from ECF text, `extends` applied by hand, not compiled.

| claim | evidence | tier | P-level | version/as-of | path |
|---|---|---|---|---|---|
| simple_web root uses thread | `support="scoop" use="thread"`, no thread lib | H1 | P1-raw | 2026-10-08 | simple_web.ecf:15 |
| simple_web thread targets | simple_web_tests l.66; wms_api l.98; todo_api l.120; wms_api_tests and todo_api_tests inherit | H1 | P1-raw | 2026-10-08 | simple_web.ecf:66,98,120 |
| simple_web_scoop_tests | overrides with `use="scoop"` | H1 | P1-raw | 2026-10-08 | simple_web.ecf:85 |
| scholar root scoop | `support="scoop"` | H1 | P1-raw | 2026-10-08 | simple_scholar.ecf:11 |
| bible_htmx thread | `support="thread" use="thread"`; thread lib l.80 (only explicit thread lib in the 4 projects) | H1 | P1-raw | 2026-10-08 | simple_scholar.ecf:74,80 |
| showcase root thread | `support="scoop" use="thread"`, no thread lib; 4 targets extend root | H1 | P1-raw | 2026-10-08 | simple_showcase.ecf:12 |
| gui_designer root thread | `support="scoop" use="thread"`, no thread lib; 3 targets extend root | H1 | P1-raw | 2026-10-08 | simple_gui_designer.ecf:15 |
| SIMPLE_WEB_SERVER in clients | bible_htmx_app.e:118; htmx/server_thread.e:18,27; ssc_server.e:96; gui_designer_server.e:153; gds_shared_state.e:33 | H1 | P1-raw | 2026-10-08 | simple_scholar\htmx, simple_showcase\src\core, simple_gui_designer\src\server |
| SIMPLE_WEB_SERVER in simple_web apps | todo_web_api_server.e:121; wms_api_server.e:92 | H1 | P1-raw | 2026-10-08 | simple_web\src |
| Handler server in clients | grep SIMPLE_WEB_HANDLER_SERVER: no hits | H1 | P1-raw | 2026-10-08 | 3 client projects |
| CLAUDE.md SCOOP rule | "3. **SCOOP Compatible** - Concurrency-ready design" | H1 | P1-raw | 2026-10-08 | CLAUDE.md:294 |
| CLAUDE.md thread rule | none | H1 | P1-raw | 2026-10-08 | CLAUDE.md |
| BUILD_STANDARDS | only `<concurrency value="scoop" />` in lib_tests; no thread text | H1 | P1-raw | 2026-10-08 | BUILD_STANDARDS.md:102 |
| EXPERT_BRIEFING | no thread or SCOOP hits | H1 | P1-raw | 2026-10-08 | EIFFEL_EXPERT_BRIEFING.md |
| Existing thread exemption | none in the three files | H1 | P1-raw | 2026-10-08 | three rule files |
| CHANGELOG SCOOP entry | no "0.2.0" heading. l.76: "SCOOP mode. `SIMPLE_WEB_HANDLER_SERVER [H]` ... instantiated per request on the request's processor". Under "## [Unreleased]" l.71 | H1 | P1-raw | head 0.4.2 | CHANGELOG.md:71,76 |
| CHANGELOG thread move | l.79: `SIMPLE_WEB_SERVER` moved to `src/server/thread/`, compiled only for thread/none; also under Unreleased | H1 | P1-raw | head 0.4.2 | CHANGELOG.md:79 |

Discrepancy (fact): the Fork Register cites 0.2.0 (d10451f); CHANGELOG has no 0.2.0 entry.

K1 for D: fails by definition (thread in closure)
Affected targets: 14 thread-mode targets in 4 projects (simple_web 6, simple_scholar 1, simple_showcase 4, simple_gui_designer 3).
