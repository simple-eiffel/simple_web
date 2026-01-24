# S02 CLASS CATALOG - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Class Categories

### Core Classes

**SIMPLE_WEB_REQUEST**: Fluent HTTP request builder
- Build requests with chained methods
- Set headers, body, timeout
- Supports all HTTP methods

**SIMPLE_WEB_RESPONSE**: HTTP response wrapper
- Access status, headers, body
- Status classification (success, client error, server error)
- JSON body parsing

### Client Classes

**SIMPLE_WEB_CLIENT**: High-level HTTP client
- Execute HTTP requests
- Convenience methods (get, post, put, delete)
- Factory methods for request builders

**SIMPLE_WEB_HYBRID_CLIENT**: Extended client
- Additional features for complex scenarios

### Server Classes

**SIMPLE_WEB_SERVER**: HTTP server with routing
- Route registration (on_get, on_post, etc.)
- Middleware pipeline
- Built-in logging and CORS middleware

**SIMPLE_WEB_SERVER_ROUTER**: Request router
- Route matching with patterns
- Path parameter extraction
- Middleware execution

**SIMPLE_WEB_SERVER_ROUTE**: Single route definition
- Method, pattern, handler

**SIMPLE_WEB_SANITIZER**: Input/output sanitization
- HTML entity encoding
- Path traversal prevention

### Middleware Classes

**SIMPLE_WEB_MIDDLEWARE**: Base middleware
**SIMPLE_WEB_AUTH_MIDDLEWARE**: Bearer token auth
**SIMPLE_WEB_CORS_MIDDLEWARE**: CORS headers
**SIMPLE_WEB_LOGGING_MIDDLEWARE**: Request logging

### AI Clients

**SIMPLE_WEB_OLLAMA_CLIENT**: Local LLM via Ollama
**SIMPLE_WEB_OPENAI_CLIENT**: OpenAI API client
**SIMPLE_WEB_CLAUDE_CLIENT**: Anthropic Claude client

### Resilience Classes

**SIMPLE_CIRCUIT_BREAKER**: Fail-fast pattern
**SIMPLE_BULKHEAD**: Isolation pattern
**SIMPLE_RESILIENCE_POLICY**: Policy configuration
