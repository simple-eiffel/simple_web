# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
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
[1.0.0]: https://github.com/simple-eiffel/simple_web/releases/tag/v1.0.0
