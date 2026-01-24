# S07 SPEC SUMMARY - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Executive Summary

simple_web is a comprehensive HTTP library providing both client and server capabilities with fluent APIs, middleware support, AI integrations, and resilience patterns.

## Key Specifications

### Classes by Category
| Category | Count | Key Classes |
|----------|-------|-------------|
| Core | 2 | Request, Response |
| Client | 2 | Client, HybridClient |
| Server | 8 | Server, Router, Routes, Middleware |
| AI | 3 | Ollama, OpenAI, Claude clients |
| Resilience | 4 | CircuitBreaker, Bulkhead |

### Features Summary
| Category | Count | Key Features |
|----------|-------|--------------|
| Client methods | 8 | get, post, put, delete, execute |
| Server routing | 6 | on_get, on_post, etc. |
| Middleware | 4 | logging, cors, auth, resilience |
| Request builder | 10 | with_header, with_body, etc. |
| Response queries | 8 | is_success, body_as_json, etc. |

### Contract Coverage
| Contract Type | Count |
|--------------|-------|
| Preconditions | 30+ |
| Postconditions | 25+ |
| Invariants | 5+ |

## Dependencies

### Required
- simple_json (JSON handling)
- http_client (cURL wrapper)
- EiffelWeb/WSF (server framework)

## Quality Metrics

| Metric | Value |
|--------|-------|
| Source lines | ~2800 |
| Classes | ~24 |
| Features | ~100+ |
| Test files | 15+ |

## API Summary

```eiffel
-- Client
client := create {SIMPLE_WEB_CLIENT}.make
response := client.get ("https://api.example.com/data")

-- Server
server := create {SIMPLE_WEB_SERVER}.make (8080)
server.use_logging
server.on_get ("/api/users", agent handle_users)
server.start
```

## Status

**Phase**: 4 (API Documentation)
**Stability**: Stable
**Production Ready**: Yes
