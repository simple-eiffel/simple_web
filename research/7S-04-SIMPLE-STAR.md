# 7S-04 SIMPLE-STAR - simple_web


**Date**: 2026-01-23

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## Ecosystem Dependencies

### Required Libraries
| Library | Purpose | Usage |
|---------|---------|-------|
| simple_json | JSON handling | Request/response bodies |

### EiffelStudio Libraries
| Component | Purpose |
|-----------|---------|
| http_client | cURL wrapper for client |
| wsf (EiffelWeb) | Web service framework |

### Standard Library
| Component | Purpose |
|-----------|---------|
| STRING_TABLE | Headers storage |
| ARRAYED_LIST | Middleware list |

## Integration Points

### Client Usage
```eiffel
create client.make
response := client.get ("https://api.example.com/users")
if response.is_success then
    json := response.body_as_json
end

-- Fluent builder
response := client.execute (
    client.new_request_post ("https://api.example.com/users")
        .with_json_body (user_json)
        .with_bearer_token (token)
)
```

### Server Usage
```eiffel
create server.make (8080)
server.use_logging
server.use_cors
server.on_get ("/users", agent handle_list_users)
server.on_get ("/users/{id}", agent handle_get_user)
server.on_post ("/users", agent handle_create_user)
server.start
```

## Ecosystem Position

simple_web is central to:
- REST API development
- External service integration
- AI/LLM client access
- Microservice communication
