# 7S-06 SIZING - simple_web


**Date**: 2026-01-23

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Codebase Metrics

### Source Files (Approximate)
| Directory | Files | Lines | Description |
|-----------|-------|-------|-------------|
| core/ | 2 | ~400 | Request/Response |
| client/ | 2 | ~300 | HTTP client |
| server/ | 8 | ~800 | Server, router, routes |
| middleware/ | 4 | ~350 | Middleware pipeline |
| ai/ | 3 | ~450 | AI client integrations |
| resilience/ | 4 | ~400 | Circuit breaker, bulkhead |
| constants/ | 1 | ~100 | HTTP constants |
| **Total** | ~24 | ~2800 | |

### Class Count
- ~24 production classes
- ~15+ test classes

## Complexity Analysis

### SIMPLE_WEB_SERVER
- Features: ~15
- Cyclomatic complexity: Medium
- Route registration and middleware

### SIMPLE_WEB_CLIENT
- Features: ~12
- Cyclomatic complexity: Low
- Wrapper over http_client

### SIMPLE_WEB_ROUTER
- Features: ~10
- Cyclomatic complexity: Medium
- Pattern matching logic

## Memory Footprint

| Component | Typical Size |
|-----------|-------------|
| Client | ~100 bytes |
| Server | ~500 bytes + routes |
| Request | ~200 bytes + body |
| Response | ~200 bytes + body |
| Route | ~100 bytes |

## Performance Characteristics

| Operation | Expected Time |
|-----------|--------------|
| Client request | Network dependent |
| Route matching | O(routes) |
| Middleware chain | O(middleware) |
| JSON parsing | Body size dependent |
