# 7S-03 SOLUTIONS - simple_web


**Date**: 2026-01-23

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Alternative Approaches Considered

### Client Side

#### 1. Direct Socket Programming
**Decision**: Rejected - too low-level

#### 2. EiffelNet HTTP Client
**Decision**: Rejected - limited features

#### 3. Wrap cURL (Selected)
**Description**: Use EiffelStudio's http_client wrapping cURL
**Pros**: Mature, full-featured, handles TLS
**Decision**: Selected for SIMPLE_WEB_CLIENT

### Server Side

#### 1. Raw Socket Server
**Decision**: Rejected - reinventing the wheel

#### 2. EiffelWeb/WSF (Selected)
**Description**: Build on EiffelWeb Service Framework
**Pros**: Production-tested, async support
**Decision**: Selected for SIMPLE_WEB_SERVER

#### 3. External Web Server (nginx/etc.)
**Decision**: Rejected - added complexity

## Implementation Strategy

1. **Client**: Fluent builder pattern over http_client
2. **Server**: Clean routing API over WSF
3. **Middleware**: Pipeline pattern for cross-cutting concerns
4. **Resilience**: Circuit breaker and bulkhead patterns

## Technology Stack

- **http_client**: EiffelStudio cURL wrapper
- **EiffelWeb/WSF**: Web service framework
- **simple_json**: JSON handling
- **Gobo regexp**: Route pattern matching
