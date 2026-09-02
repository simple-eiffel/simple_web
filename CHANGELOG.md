# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2026-09-02

### Fixed

- **`SIMPLE_WEB_SERVER_REQUEST.header` could never read a hyphenated header.** It built the CGI meta-variable name as `"HTTP_" + a_name.as_upper` and left the hyphens alone, so `header ("X-File-Name")` asked the connector for `HTTP_X-FILE-NAME` - a variable no connector sets. RFC 3875 s.4.1.18 spells that header `HTTP_X_FILE_NAME`, and EWF's standalone connector (`WGI_HTTPD_REQUEST_HANDLER`) builds its meta variables by exactly that rule. Every hyphenated header therefore came back `Void`: `X-Forwarded-For`, `X-Real-IP`, `User-Agent`, `Referer`, `X-API-Key` and any custom one. The bug has been present since `header` was written and stayed invisible because `Authorization` - the only header the library itself read through it - has no hyphen. Found on 2026-09-02 by Larry Rix while closing simple_chat's image upload, which had to work around it by asking for the meta spelling `"X_File_Name"` directly.

  The name is now normalized in one place, `meta_name`, used by every lookup: upper case, every hyphen an underscore. `header ("X-File-Name")`, `header ("x-file-name")` and `header ("X_File_Name")` all name the one header, so the simple_chat workaround keeps working and correct spellings start working. In-library consumers repaired by the same change: `SIMPLE_WEB_AUTH_MIDDLEWARE`'s API-key mode (`make_api_key ("X-API-Key", ...)` matched nothing, so every API key was rejected).

- **`header ("Content-Type")` and `header ("Content-Length")` were unreachable.** CGI gives those two meta variables no `HTTP_` prefix, and the accessor prefixed everything, so both always answered `Void`. `meta_variable_name` now applies the prefix to every header except `CONTENT_TYPE` and `CONTENT_LENGTH`. The dedicated `content_type` and `content_length` accessors were never affected - they go through WSF's own queries - so this changes nothing that previously worked.

### Added

- `SIMPLE_WEB_SERVER_REQUEST.meta_name` and `meta_variable_name`: the header-name-to-CGI-meta-variable mapping, now a named, contracted, testable query rather than an inline string concatenation.
- Vector tests. `TEST_REQUEST_HEADERS` (in the `simple_web_tests` target) covers the hyphenated header, the four spellings of one name, the underscore workaround, `Authorization` unchanged, an absent header answering `Void`, `Content-Type` through `header`, and both meta-name rules. The end-to-end proof over a real socket and EWF's real connector is the `/headers` route in the SCOOP suite, which sends `X-File-Name`, `X-Caption`, `Authorization`, `Content-Type` and `Content-Length` on the wire and checks what the handler can see. Both were RED before the fix and GREEN after.

### Changed

- `SIMPLE_WEB_SERVER_REQUEST.set_mock_header` now stores under the meta spelling, so a mock request answers a hyphenated name exactly as a real one does; its postcondition asserts the value reads back through `header`. Mock header keys are consequently spelled `X_FILE_NAME` rather than `X-FILE-NAME`; nothing in the ecosystem reads `mock_headers` directly.
- The SCOOP proof (`testing/scoop/scoop_test_app.e`) now flushes after every check and ends the process itself. Previously the root returned but the server's processor kept listening, so the process never exited and - with stdout redirected - the whole report stayed in an unflushed buffer. The suite is now runnable unattended and returns 0 or 1.

## [Unreleased]

### Added
- Streaming responses: `SIMPLE_WEB_SERVER_RESPONSE.send_stream_head` (status + Content-Type + Cache-Control: no-cache + Connection: close, no Content-Length), `send_chunk` (write + flush, exceptions from a raising connector swallowed into `is_streaming := False`), `is_streaming`. Head once, chunks only after the head - contracted. Mock mode records the head in `mock_headers` and appends chunks to `mock_body`. Documented honestly: EWF's standalone connector never reports a hung-up client (socket errors are swallowed below WSF), so applications must bound a stream's lifetime.
- `SIMPLE_WEB_SERVER_REQUEST.remote_address`: the connection's peer IP (CGI `REMOTE_ADDR` meta variable), empty when the connector does not supply one; `mock_remote_address` + `set_mock_remote_address` for tests. Real-socket proof: `/peer` and `/stream` routes in the SCOOP suite.
- SCOOP mode. `SIMPLE_WEB_HANDLER_SERVER [H]` + `SIMPLE_WEB_REQUEST_HANDLER` + `SIMPLE_WEB_ROUTES`: the application supplies a handler *class*, instantiated per request on the request's processor, so no agent ever crosses a processor. `SIMPLE_WEB_SHARED` / `SIMPLE_WEB_SETTINGS`: process-wide strings through a `once ("PROCESS")` of separate type. Proof target `simple_web_scoop_tests` (`use="scoop"`): a real socket client, a shared value reaching a handler, a 404, two 2-second requests served concurrently by EWF's SCOOP connector pool.

### Changed
- `SIMPLE_WEB_SERVER`, `SIMPLE_WEB_SERVER_EXECUTION`, `SIMPLE_WEB_SERVER_ROUTER` and `SIMPLE_WEB_QUICK` moved to `src/server/thread/`, a cluster compiled only for `concurrency` thread/none: their `once ("PROCESS")` singletons of non-separate type are illegal under SCOOP (VFFD(8)) and their agent registration could not work there anyway. Thread-mode behaviour is unchanged.

### Fixed
- Compile fixes: object-test local names in the resilience middleware and static-file serving (`al_cb`, `al_p`, `al_bh`, `al_folder` were referenced by their un-prefixed names), a self-assignment in the middleware constructors that left the policy void, and `SIMPLE_WEB_SERVER_REQUEST.request_method` converting the WSF value with `to_string_8` (silences the obsolete `as_string_8` warning for every consumer)

### Changed
- Testing config updates, AutoTest fixes, .gitignore cleanup
- Add SCOOP concurrency capability
- Migrate to simple_testing library
- Add send_binary method for serving static files
- Remove redundant result_not_void postconditions
- Add comprehensive postconditions to core HTTP classes
- Add form data parsing and body caching to request class
- Add Todo API mock demonstrating simple_json friction fixes
- Add input sanitization and security improvements
- Add middleware docs to README, update AI productivity report

## [1.0.0] - 2025-12-08

### Added
- Initial release
- Core functionality implemented
- Test suite with comprehensive coverage
- Documentation and examples

[Unreleased]: https://github.com/simple-eiffel/simple_web/compare/v1.0.0...HEAD
[0.3.1]: https://github.com/simple-eiffel/simple_web/compare/v0.3.0...v0.3.1
[1.0.0]: https://github.com/simple-eiffel/simple_web/releases/tag/v1.0.0
