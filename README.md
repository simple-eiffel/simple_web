<p align="center">
  <img src="docs/images/logo.svg" alt="simple_web logo" width="400">
</p>

# simple_web

**[Documentation](https://simple-eiffel.github.io/simple_web/)** | **[GitHub](https://github.com/simple-eiffel/simple_web)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

High-level HTTP client and server library for Eiffel applications.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**SCOOP-clean since 0.2.0** - `SIMPLE_WEB_HANDLER_SERVER [H]` serves under SCOOP (proof target `simple_web_scoop_tests`) and under threads.

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

## SCOOP mode (and the handler-class server)

`SIMPLE_WEB_SERVER` registers handler *agents*; under SCOOP those agents live on the root
processor, which a request processor can never call while the root is running the program.
So SCOOP builds get a different server, and it works under threads too:

```eiffel
class HELLO_HANDLER
inherit SIMPLE_WEB_REQUEST_HANDLER
create make
feature {NONE}
    setup_routes
        do
            routes.on_get ("/", agent hello)          -- agents on Current: same processor as the request
        end
    hello (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
        do
            res.send_text ("hi")
        end
end

-- the application
create server.make (8080)              -- SIMPLE_WEB_HANDLER_SERVER [HELLO_HANDLER]
server.set_max_concurrent_connections (32)
server.set_bind_address ("127.0.0.1")  -- optional: this machine only. Without it, EVERY interface
server.start                           -- blocking on the caller's processor
```

One `HELLO_HANDLER` is created per request on the request's processor; `setup_routes` builds
that request's `SIMPLE_WEB_ROUTES` (same `on_get` / `on_post` / `use` API, plus `dispatch`).
Process-wide strings the root wants handlers to see go through `SIMPLE_WEB_SHARED`
(`shared_put` before `start`, `shared_item` inside a handler); anything richer is an
application `once ("PROCESS")` function of *separate* type, which is what SCOOP requires of
process-wide onces. In a SCOOP program create the server `separate` and call `start` through a
separate command so the root keeps going (see `testing/scoop/scoop_test_app.e`, the proof:
a real socket, a shared value reaching a handler, a 404, and two 2-second requests served
concurrently).

`SIMPLE_WEB_SERVER` and `SIMPLE_WEB_QUICK` remain for thread-mode programs and are excluded from
SCOOP builds by the ECF (`src/server/thread`). Build the proof with
`ec.sh test -config simple_web.ecf -target simple_web_scoop_tests`.

### Which interface it listens on

`make (a_port)` alone binds **every interface on the machine** - `0.0.0.0`. That is EWF's
behavior and it is this library's default: `HTTPD_SERVER_I.new_listening_socket` calls
`make_server_by_port` when no address is configured, and `make_server_by_address_and_port`
when one is. It is the right default for a server that means to be reachable, and it is
stated here so that it is a choice rather than a surprise.

A server that means to be private must say so:

```eiffel
create server.make (8080)
server.set_bind_address ("127.0.0.1")   -- nothing off this machine can connect
server.start
```

`set_bind_address` records the address in `bind_address` (a query; `Void` means every
interface) and hands it to the connector as EWF's `server_name` service option, which
`WSF_STANDALONE_SERVICE_LAUNCHER` passes to `HTTPD_CONFIGURATION.set_http_server_name`. An
address the machine cannot resolve is a bind failure at `start`, not an error at the call.

`make`'s own behavior is unchanged, so every existing consumer keeps the interface it had.
Vector tests: `testing/server/test_bind_address.e` (the option really reaches the table the
launcher reads, and no address is offered when none was set).

## Streaming responses and the peer address

For Server-Sent Events and other long-lived responses, `SIMPLE_WEB_SERVER_RESPONSE` can
stream: send the head once, then chunks as they happen.

```eiffel
stream (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
    do
        res.send_stream_head (200, "text/event-stream")   -- status + Content-Type,
                                                           -- Cache-Control: no-cache, Connection: close
        res.send_chunk (": hello%N%N")                     -- written and flushed at once
        res.send_chunk ("id: 1%Nevent: message%Ndata: {}%N%N")
    end                                                    -- returning ends the stream (the connection closes)
```

The contract is honest about what EWF can and cannot tell you: `send_stream_head` may be called
once (`is_streaming` turns True), `send_chunk` only after it. No Content-Length is sent - the
connection's close delimits the body. If a connector reports a failed write with an exception,
`send_chunk` swallows it and `is_streaming` becomes False. EWF's standalone connector does NOT
report writes to a hung-up client (it swallows socket errors below the WSF surface), so a
disconnect is invisible: bound a stream's lifetime in the application. In mock mode chunks
append to `mock_body` and the head lands in `mock_headers`, so streams are testable in memory.

`SIMPLE_WEB_SERVER_REQUEST.remote_address` reports the connection's peer IP as the connector
supplies it (the CGI `REMOTE_ADDR` meta variable; empty when unavailable) - the honest input
for per-client rate limiting. Mock requests report `mock_remote_address`
(`set_mock_remote_address`). Real-socket proof for both: the `/peer` and `/stream` routes in
`testing/scoop/scoop_test_app.e`.

## Reading request headers

`SIMPLE_WEB_SERVER_REQUEST.header (a_name)` answers a request header by name. A connector does
not hand headers over under the names the client sent: CGI (RFC 3875 s.4.1.18) upper-cases the
name, turns every hyphen into an underscore and prefixes `HTTP_`, so `X-File-Name` arrives as
`HTTP_X_FILE_NAME`. `Content-Type` and `Content-Length` are the two exceptions - they arrive
as `CONTENT_TYPE` and `CONTENT_LENGTH`, with no prefix.

`header` makes that translation for you, which means case and the choice of hyphen or
underscore do not matter:

```eiffel
upload (req: SIMPLE_WEB_SERVER_REQUEST; res: SIMPLE_WEB_SERVER_RESPONSE)
    do
        if attached req.header ("X-File-Name") as l_name then   -- so does "x-file-name",
            ...                                                  -- and so does "X_File_Name"
        end
    end
```

`meta_name ("X-File-Name")` gives `X_FILE_NAME` and `meta_variable_name ("X-File-Name")` gives
`HTTP_X_FILE_NAME`, if you ever need to name the variable yourself.

**Fixed in 0.3.1:** before that release the hyphens were left alone, so `header` asked for
`HTTP_X-FILE-NAME` and *no hyphenated header could ever be read* - `X-Forwarded-For`,
`X-Real-IP`, `User-Agent`, `Referer`, `X-API-Key` and every custom one silently answered
`Void`. `Authorization`, having no hyphen, worked, which is why the bug went unseen. If your
code carries a workaround that asks for the meta spelling directly, it still works; you can
now drop it.

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
