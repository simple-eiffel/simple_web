# 7S-05 SECURITY - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Security Considerations

### Client Security

#### TLS/HTTPS
- **Risk**: Man-in-the-middle attacks
- **Mitigation**: cURL handles TLS verification
- **Status**: Secure by default (via http_client)

#### Credential Handling
- **Risk**: Token exposure in logs
- **Mitigation**: Logging middleware should filter
- **Recommendation**: Document credential safety

### Server Security

#### Input Sanitization
- **Status**: SIMPLE_WEB_SANITIZER class exists
- **Coverage**: HTML entity encoding, path traversal prevention

#### Route Injection
- **Risk**: Malicious route patterns
- **Mitigation**: Patterns are server-defined
- **Status**: Safe (server controls routes)

#### Authentication
- **Status**: SIMPLE_WEB_AUTH_MIDDLEWARE exists
- **Coverage**: Bearer token validation

### Cross-Origin

#### CORS
- **Status**: SIMPLE_WEB_CORS_MIDDLEWARE exists
- **Options**: Allow all or specific origins

## Security Boundaries

| Boundary | Protection |
|----------|------------|
| HTTPS | cURL TLS verification |
| Headers | String sanitization available |
| Body | JSON parsing (simple_json) |
| Routes | Server-defined patterns |
| Auth | Bearer token middleware |

## Threat Model

1. **Injection**: Sanitizer available for input
2. **CSRF**: Not addressed (no sessions)
3. **XSS**: Sanitizer available for output
4. **Auth bypass**: Middleware validates tokens
