# S05 CONSTRAINTS - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Technical Constraints

### Platform
- **Target OS**: Cross-platform (via cURL/EiffelWeb)
- **Compiler**: EiffelStudio 25.02+
- **Void Safety**: Required

### Protocol
- HTTP/1.1 only
- HTTPS supported (cURL handles TLS)
- No HTTP/2 or HTTP/3

### Dependencies
- http_client library (cURL binding)
- EiffelWeb/WSF for server
- simple_json for JSON handling

## Client Constraints

### Request
- URL must be non-empty
- Timeout must be positive (default 30s)
- Body can be empty for GET/DELETE

### Response
- Status code always positive
- Body may be empty
- JSON parsing optional

## Server Constraints

### Port
- Range: 1-65535
- Privileged ports (< 1024) may require admin

### Routes
- Patterns support {param} placeholders
- First matching route wins
- No regex patterns (simple matching)

### Middleware
- Executed in registration order
- Can short-circuit request handling
- Must call next or respond

## Performance Constraints

| Aspect | Limit |
|--------|-------|
| Default timeout | 30000ms |
| Max routes | Unlimited (memory) |
| Max middleware | Unlimited (memory) |
| Concurrent requests | WSF dependent |

## Resilience Constraints

### Circuit Breaker
- Failure threshold configurable
- Reset timeout configurable
- States: Closed, Open, Half-Open

### Bulkhead
- Max concurrent requests configurable
- Rejects when full
