# 7S-02 STANDARDS - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Applicable Standards

### HTTP Standards
- **RFC 7230-7235**: HTTP/1.1 protocol
- **RFC 7231**: HTTP semantics and content
- **RFC 6585**: Additional HTTP status codes
- **RFC 6750**: Bearer token authentication

### Content Standards
- **RFC 8259**: JSON format
- **RFC 6838**: Media types (MIME)

### CORS Standards
- **W3C CORS**: Cross-Origin Resource Sharing

### Eiffel Standards
- **ECMA-367**: Eiffel language standard
- **Void Safety**: Full void-safe implementation
- **DBC**: Design by Contract throughout

## HTTP Status Codes

| Code | Constant | Description |
|------|----------|-------------|
| 200 | Status_ok | OK |
| 201 | Status_created | Created |
| 204 | Status_no_content | No Content |
| 400 | Status_bad_request | Bad Request |
| 401 | Status_unauthorized | Unauthorized |
| 403 | Status_forbidden | Forbidden |
| 404 | Status_not_found | Not Found |
| 500 | Status_internal_error | Internal Server Error |
| 503 | Status_service_unavailable | Service Unavailable |

## HTTP Methods

| Method | Constant | Idempotent | Safe |
|--------|----------|------------|------|
| GET | Http_method_get | Yes | Yes |
| POST | Http_method_post | No | No |
| PUT | Http_method_put | Yes | No |
| DELETE | Http_method_delete | Yes | No |
| PATCH | Http_method_patch | No | No |
