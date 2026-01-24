# S06 BOUNDARIES - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## System Boundaries

```
+--------------------------------------------------+
|                    Client Code                    |
+--------------------------------------------------+
       |                                |
       v                                v
+----------------+            +------------------+
| SIMPLE_WEB     |            | SIMPLE_WEB       |
| CLIENT         |            | SERVER           |
+----------------+            +------------------+
       |                                |
       v                                v
+----------------+            +------------------+
| http_client    |            | EiffelWeb/WSF    |
| (cURL)         |            | Framework        |
+----------------+            +------------------+
       |                                |
       v                                v
+--------------------------------------------------+
|                    Network                        |
+--------------------------------------------------+
```

## Interface Boundaries

### Client Public Interface
- SIMPLE_WEB_CLIENT: Main client class
- SIMPLE_WEB_REQUEST: Request builder
- SIMPLE_WEB_RESPONSE: Response wrapper

### Server Public Interface
- SIMPLE_WEB_SERVER: Main server class
- SIMPLE_WEB_SERVER_REQUEST: Server request
- SIMPLE_WEB_SERVER_RESPONSE: Server response
- SIMPLE_WEB_MIDDLEWARE: Middleware base

### AI Public Interface
- SIMPLE_WEB_OLLAMA_CLIENT
- SIMPLE_WEB_OPENAI_CLIENT
- SIMPLE_WEB_CLAUDE_CLIENT

### Resilience Public Interface
- SIMPLE_CIRCUIT_BREAKER
- SIMPLE_BULKHEAD

## Data Boundaries

### Input Data (Client)
| Data | Source | Validation |
|------|--------|------------|
| URL | Client | Not empty |
| Headers | Client | Name not empty |
| Body | Client | Optional |

### Input Data (Server)
| Data | Source | Validation |
|------|--------|------------|
| Request | Network | WSF parses |
| Route params | URL | Pattern matching |
| Body | Request | Application validates |

### Output Data
| Data | Destination | Format |
|------|-------------|--------|
| Response | Client/Network | HTTP |
| JSON | Body | simple_json |

## Trust Boundaries

| Zone | Trust Level | Validation |
|------|-------------|------------|
| Client code | Trusted | Contracts |
| Server handlers | Trusted | Application |
| Network data | Untrusted | Sanitize |
| External APIs | Semi-trusted | Resilience |
