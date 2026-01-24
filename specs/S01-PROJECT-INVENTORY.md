# S01 PROJECT INVENTORY - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Project Structure

```
simple_web/
  simple_web.ecf              # Eiffel configuration file
  src/
    constants/
      simple_web_constants.e  # HTTP constants
    core/
      simple_web_request.e    # Request builder
      simple_web_response.e   # Response wrapper
    client/
      simple_web_client.e     # HTTP client
      simple_web_hybrid_client.e # Hybrid client
    server/
      simple_web_server.e     # HTTP server
      simple_web_server_execution.e
      simple_web_server_request.e
      simple_web_server_response.e
      simple_web_server_route.e
      simple_web_server_router.e
      simple_web_sanitizer.e
      simple_web_quick.e
      middleware/
        simple_web_middleware.e
        simple_web_middleware_pipeline.e
        simple_web_auth_middleware.e
        simple_web_cors_middleware.e
        simple_web_logging_middleware.e
    ai/
      simple_web_ollama_client.e
      simple_web_openai_client.e
      simple_web_claude_client.e
    resilience/
      simple_circuit_breaker.e
      simple_bulkhead.e
      simple_resilience_policy.e
      simple_web_resilience_middleware.e
    todo_api/                 # Example API
    wms_api/                  # Example API
  examples/
    example_ollama.e
  testing/
    (15+ test files)
```

## Source Files Summary

| Directory | Files | Purpose |
|-----------|-------|---------|
| constants | 1 | HTTP constants |
| core | 2 | Request/response |
| client | 2 | HTTP client |
| server | 8 | Server framework |
| middleware | 5 | Middleware system |
| ai | 3 | AI integrations |
| resilience | 4 | Resilience patterns |

## Dependencies

### Internal
- simple_json (JSON handling)

### EiffelStudio
- http_client (cURL wrapper)
- wsf (EiffelWeb)
