<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# simple_web

**[Documentation](https://simple-eiffel.github.io/simple_web/)** | **[GitHub](https://github.com/simple-eiffel/simple_web)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

High-level HTTP client and server library for Eiffel applications.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Production** - HTTP client and server both working

## Overview

SIMPLE_WEB provides clean APIs for HTTP client operations and HTTP server development. Includes ready-to-use clients for Ollama, Claude, OpenAI, and Grok AI services.

## Quick Start (Zero-Configuration)

Use `SIMPLE_WEB_QUICK` for the simplest possible web server:

```eiffel
local
    web: SIMPLE_WEB_QUICK
do
    create web.make

    -- Serve static files from folder (one-liner!)
    web.serve_files ("C:\my_website", 8080)
end
```

Or create a JSON API:

```eiffel
local
    web: SIMPLE_WEB_QUICK
do
    create web.make

    -- Create JSON API server
    web.json_api (8080)
    web.get ("/api/hello", agent handle_hello)
    web.post ("/api/users", agent handle_create_user)
    web.put ("/api/users", agent handle_update_user)
    web.delete ("/api/users", agent handle_delete_user)
    web.start

feature {NONE} -- Handlers

    handle_hello (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
        local
            json: SIMPLE_JSON_OBJECT
        do
            create json.make_empty
            json.put_string ("Hello from Eiffel!", "message")
            web.send_json (res, json)
        end
end
```

Response helpers:

```eiffel
-- JSON response
web.send_json (res, my_json_object)

-- Plain text
web.send_text (res, "Hello!")

-- HTML
web.send_html (res, "<h1>Welcome</h1>")

-- Error response (sets status code + JSON error body)
web.send_error (res, 404, "User not found")
```

## Standard API (Full Control)

```eiffel
local
    client: SIMPLE_WEB_CLIENT
    response: SIMPLE_WEB_RESPONSE
do
    create client.make
    response := client.get ("https://api.example.com/data")
    if response.is_success then
        print (response.body)
    end
end
```

## Features

- **HTTP Client** - GET, POST, PUT, DELETE with fluent builder
- **HTTP Server** - Agent-based routing with path parameters
- **JSON Support** - Easy JSON request/response handling
- **AI Clients** - Ollama, Claude, OpenAI, Grok integrations
- **Hybrid Client** - Workaround for localhost POST issues
- **Resilience Patterns** - Circuit breaker, bulkhead, retry with backoff, timeout, fallback

## Installation

1. Set environment variable (one-time setup for all simple_* libraries):
```bash
export SIMPLE_EIFFEL=/d/prod
```

2. Add to ECF:
```xml
<library name="simple_web" location="$SIMPLE_EIFFEL/simple_web/simple_web.ecf"/>
```

## Dependencies

- simple_json
- simple_process
- simple_datetime
- EWF libraries (included with EiffelStudio)

## License

MIT License
