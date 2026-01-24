# S04 FEATURE SPECS - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## SIMPLE_WEB_REQUEST Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make_get | (STRING) | Create GET request |
| make_post | (STRING) | Create POST request |
| make_put | (STRING) | Create PUT request |
| make_delete | (STRING) | Create DELETE request |
| with_header | (STRING, STRING): Self | Add header |
| with_body | (STRING): Self | Set body |
| with_json_body | (STRING): Self | Set JSON body |
| with_bearer_token | (STRING): Self | Set auth token |
| with_timeout | (INTEGER): Self | Set timeout |
| method | STRING | HTTP method |
| url | STRING | Request URL |
| body | STRING | Request body |
| headers | STRING_TABLE | All headers |

## SIMPLE_WEB_RESPONSE Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| status_code | INTEGER | HTTP status |
| body | STRING | Response body |
| headers | STRING_TABLE | Response headers |
| is_success | BOOLEAN | 2xx status? |
| is_ok | BOOLEAN | 200? |
| is_client_error | BOOLEAN | 4xx? |
| is_server_error | BOOLEAN | 5xx? |
| body_as_json | SIMPLE_JSON_VALUE | Parse body |
| header | (STRING): STRING | Get header |

## SIMPLE_WEB_CLIENT Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| get | (STRING): RESPONSE | GET request |
| post | (STRING, STRING): RESPONSE | POST request |
| post_json | (STRING, STRING): RESPONSE | POST JSON |
| put | (STRING, STRING): RESPONSE | PUT request |
| delete | (STRING): RESPONSE | DELETE request |
| execute | (REQUEST): RESPONSE | Execute request |
| new_request_get | (STRING): REQUEST | Create GET builder |
| new_request_post | (STRING): REQUEST | Create POST builder |

## SIMPLE_WEB_SERVER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | (INTEGER) | Create on port |
| on_get | (STRING, PROCEDURE) | Register GET |
| on_post | (STRING, PROCEDURE) | Register POST |
| on_put | (STRING, PROCEDURE) | Register PUT |
| on_delete | (STRING, PROCEDURE) | Register DELETE |
| on_patch | (STRING, PROCEDURE) | Register PATCH |
| on | (STRING, STRING, PROCEDURE) | Register any |
| use_middleware | (MIDDLEWARE) | Add middleware |
| use_logging | | Add logging |
| use_cors | | Add CORS |
| start | | Start server |
| port | INTEGER | Server port |

## SIMPLE_WEB_CONSTANTS Features

| Constant | Value | Description |
|----------|-------|-------------|
| Http_method_get | "GET" | GET method |
| Http_method_post | "POST" | POST method |
| Status_ok | 200 | OK |
| Status_created | 201 | Created |
| Status_not_found | 404 | Not Found |
| Status_internal_error | 500 | Server Error |
| Content_type_json | "application/json" | JSON MIME |
| Header_authorization | "Authorization" | Auth header |
