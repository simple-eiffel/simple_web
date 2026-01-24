# 7S-01 SCOPE - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web
**Purpose**: High-level HTTP client and server library with fluent API

## Problem Domain

simple_web addresses the need for clean, simple HTTP communication in Eiffel applications. Both client-side requests and server-side API development require an ergonomic API that hides protocol complexity.

## Scope Boundaries

### In Scope
- HTTP client with fluent request builder
- HTTP server with clean routing
- Middleware pipeline support
- Request/response abstractions
- AI client integrations (Ollama, OpenAI, Claude)
- Resilience patterns (circuit breaker, bulkhead)
- JSON body handling
- CORS support
- Logging middleware
- Authentication middleware

### Out of Scope
- WebSocket (separate simple_websocket library)
- HTTP/2 or HTTP/3
- Server-side sessions
- Cookie management
- File uploads (multipart)
- Template rendering
- Static file serving

## Target Users

- Eiffel developers building REST APIs
- Eiffel developers consuming web services
- AI application developers using LLM APIs
- Microservice developers

## Success Criteria

1. Simple GET/POST/PUT/DELETE with minimal code
2. Clean server routing with pattern matching
3. Middleware support for cross-cutting concerns
4. Resilience for unreliable services
