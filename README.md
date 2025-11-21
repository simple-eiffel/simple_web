# SIMPLE_WEB

**High-Level World-Class Web API Library for Eiffel**

[![Status](https://img.shields.io/badge/status-Stable-brightgreen)](https://github.com/ljr1981/simple_web)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/ljr1981/simple_web)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Clean, fluent API for HTTP client/server operations and AI service integrations.

---

## 🎯 Purpose

SIMPLE_WEB provides a world-class high-level API for:
1. **HTTP Client Operations** - Clean interface for web requests with HTTPS support
2. **AI Service Integration** - Claude, ChatGPT support (Gemini, Ollama coming)
3. **Fluent Request Building** - Chainable methods for readable code

Built with Design-by-Contract principles and 100% void-safe code.

---

## 📦 Architecture

```
src/
├── client/              # HTTP client for API calls
│   └── simple_web_client.e
├── ai/                  # AI service integrations
│   ├── simple_web_claude_client.e
│   └── simple_web_openai_client.e
├── core/                # Core abstractions
│   ├── simple_web_request.e
│   └── simple_web_response.e
└── constants/           # Project constants
    └── simple_web_constants.e

testing/
├── client/              # Client integration tests
│   └── test_simple_web_client_integration.e
└── core/                # Core unit tests
    ├── test_simple_web_request.e
    └── test_simple_web_response.e
```

---

## 🚀 Quick Start

### HTTP Client

```eiffel
-- Simple GET request
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

### Fluent Request Builder

```eiffel
-- Build custom request with chaining
local
    client: SIMPLE_WEB_CLIENT
    request: SIMPLE_WEB_REQUEST
    response: SIMPLE_WEB_RESPONSE
do
    create client.make
    create request.make_post ("https://api.example.com/data")
    
    request.with_bearer_token ("your-token")
        .with_json_body ("{%"name%":%"test%"}")
        .with_timeout (60000)
        .do_nothing
    
    response := client.execute (request)
end
```

### Claude AI Integration

```eiffel
-- Send message to Claude
local
    claude: SIMPLE_WEB_CLAUDE_CLIENT
    response: detachable STRING
do
    create claude.make ("your-api-key")
    claude.set_model ("claude-sonnet-4-20250514")
    
    response := claude.send_message ("What is Design by Contract?")
    
    if attached response as al_response then
        print (al_response)
    end
end
```

### ChatGPT Integration

```eiffel
-- Send message to ChatGPT
local
    openai: SIMPLE_WEB_OPENAI_CLIENT
    response: detachable STRING
do
    create openai.make ("your-api-key")
    openai.set_model ("gpt-4")
    
    response := openai.send_message ("Explain Eiffel programming")
    
    if attached response as al_response then
        print (al_response)
    end
end
```

---

## 📚 Core Classes

### SIMPLE_WEB_CLIENT

Main HTTP client for making web requests with full HTTPS support.

**Key Features:**
- Simple methods: `get()`, `post()`, `put()`, `delete()`
- Custom request execution via `execute()`
- Clean request/response abstraction
- Automatic header management
- Production-tested with httpbin.org

**Implementation Notes:**
- Uses `CURL_HTTP_CLIENT_SESSION` under the hood
- Proper STRING_TABLE iteration using `current_keys`
- All headers passed via `HTTP_CLIENT_REQUEST_CONTEXT`

### SIMPLE_WEB_REQUEST

Fluent request builder with chainable methods.

**Key Features:**
- Method-specific factories: `make_get()`, `make_post()`, etc.
- Fluent header setting: `with_header()`, `with_bearer_token()`
- Body management: `with_body()`, `with_json_body()`
- Timeout configuration: `with_timeout()`
- Returns self for method chaining
- Uses `STRING_TABLE` for efficient header storage

### SIMPLE_WEB_RESPONSE

Clean wrapper for HTTP responses.

**Key Features:**
- Status code access and checking
- Header management
- Body content access
- JSON parsing: `body_as_json()`
- Boolean queries: `is_success()`, `is_ok()`, `is_client_error()`, `is_server_error()`

### SIMPLE_WEB_CLAUDE_CLIENT

High-level client for Anthropic Claude API.

**Key Features:**
- Simple message sending: `send_message()`
- System prompt support: `send_message_with_system()`
- Model configuration: `set_model()`
- Token limit setting: `set_max_tokens()`
- Automatic JSON request/response handling

### SIMPLE_WEB_OPENAI_CLIENT

High-level client for OpenAI API (ChatGPT).

**Key Features:**
- Simple message sending: `send_message()`
- Model configuration: `set_model()`
- Supports all OpenAI chat models
- Clean response extraction

### SIMPLE_WEB_CONSTANTS

Project-wide constants for HTTP operations.

**Includes:**
- HTTP methods (GET, POST, PUT, DELETE, etc.)
- Status codes (200, 404, 500, etc.)
- Common headers (Content-Type, Authorization, etc.)
- AI service endpoints (Claude, OpenAI, Gemini, Ollama)
- Timeout defaults

---

## 🧪 Testing

Comprehensive test suite using EiffelStudio's AutoTest framework.

### Running Tests

```bash
# Run all tests
estudio simple_web.ecf -target simple_web_tests
# In EiffelStudio: Testing > AutoTest > Execute All Tests
```

### Test Coverage

**Unit Tests:**
- ✅ `TEST_SIMPLE_WEB_REQUEST` - Request builder and fluent API
- ✅ `TEST_SIMPLE_WEB_RESPONSE` - Response wrapper and status checking

**Integration Tests** (using httpbin.org):
- ✅ `test_get_httpbin` - Basic GET requests
- ✅ `test_get_with_query_params` - Query parameter handling
- ✅ `test_post_json_httpbin` - JSON POST requests
- ✅ `test_post_with_fluent_api` - Fluent builder with custom headers
- ✅ `test_bearer_auth_httpbin` - Bearer token authentication
- ✅ `test_status_404_httpbin` - 404 error handling
- ✅ `test_status_500_httpbin` - 500 error handling
- ✅ `test_custom_headers` - Custom header setting and echoing
- ✅ `test_json_response_parsing` - JSON response parsing
- ✅ `test_timeout_handling` - Timeout configuration

**All tests passing** ✅

---

## 🎨 Design Principles

1. **Fluent API** - Chainable methods for readable code
2. **Design by Contract** - Comprehensive preconditions/postconditions
3. **Void Safety** - 100% void-safe implementation
4. **Named Constants** - No magic values
5. **Command-Query Separation** - Clear separation of commands and queries
6. **Minimal Dependencies** - Clean, focused abstractions
7. **Production Quality** - Real integration tests, proven patterns

---

## 📋 Key Implementation Details

### STRING_TABLE Iteration Pattern

**Critical Pattern** - Proper iteration over STRING_TABLE headers:

```eiffel
-- ✅ CORRECT - Use current_keys directly
across a_request.headers.current_keys as ic loop
    if attached a_request.headers.item (ic) as l_value then
        l_ctx.headers.force (l_value, ic.out)
    end
end

-- ❌ WRONG - Don't use .item on cursor
across a_request.headers as ic loop
    l_ctx.headers.force (ic.item, ic.key)  -- ERROR!
end
```

**Key Insight:** When iterating `current_keys`, the cursor `ic` IS the key itself, not a structure with `.item` and `.key` properties. Use `ic.out` to get the string representation.

---

## 📝 Examples

### Error Handling

```eiffel
local
    client: SIMPLE_WEB_CLIENT
    response: SIMPLE_WEB_RESPONSE
do
    create client.make
    response := client.get ("https://api.example.com/data")
    
    if response.is_success then
        print ("Success: " + response.body)
    elseif response.is_client_error then
        print ("Client error: " + response.status_code.out)
    elseif response.is_server_error then
        print ("Server error: " + response.status_code.out)
    end
end
```

### Custom Headers

```eiffel
local
    request: SIMPLE_WEB_REQUEST
do
    create request.make_get ("https://api.example.com/data")
    
    request.with_header ("X-Custom-Header", "value")
        .with_header ("User-Agent", "MyApp/1.0")
        .with_bearer_token ("api-key-123")
        .do_nothing
end
```

### JSON Response Parsing

```eiffel
local
    response: SIMPLE_WEB_RESPONSE
    json: detachable SIMPLE_JSON_VALUE
do
    response := client.get ("https://api.example.com/json")
    
    if response.is_success then
        json := response.body_as_json
        
        if attached json as al_json and then al_json.is_object then
            if attached al_json.as_object as al_obj and then
               al_obj.has_key ("status") then
                print (al_obj.item ("status").as_string_32)
            end
        end
    end
end
```

---

## 🔧 Dependencies

**Required Libraries:**
- `base` - EiffelBase library
- `curl_http_client` - HTTP client operations (CURL_HTTP_CLIENT_SESSION)
- `http_network` - HTTP protocol support
- `http_authorization` - Authentication support
- `encoder` - URL/HTML encoding
- `uri` - URI parsing
- `simple_json` - JSON handling

---

## 📜 License

MIT License - Copyright (c) 2024-2025 Larry Rix

---

## 🙏 Acknowledgments

- **EiffelStudio Team** - HTTP client libraries and curl integration
- **SIMPLE_JSON** - JSON handling foundation  
- **Claude Sonnet 4.5** - AI development partner
- **httpbin.org** - Integration testing service

---

## 📊 Project Status

**Status:** 🟢 Stable - Production Ready  
**Version:** 1.0.0  
**Last Updated:** November 21, 2025

### ✅ Completed
- Core HTTP client with GET/POST/PUT/DELETE
- Fluent request builder API
- Response wrapper with status checking
- Bearer token authentication
- Custom header support
- JSON request/response handling
- Claude AI client integration
- ChatGPT client integration
- Comprehensive integration tests (10 tests passing)
- Unit tests for core classes

### 🔜 Roadmap (v1.1+)
- [ ] Gemini client (Google)
- [ ] Ollama client (local)
- [ ] Server wrapper (SIMPLE_WEB_SERVER)
- [ ] Rate limiting
- [ ] Retry logic with exponential backoff
- [ ] Response caching
- [ ] Streaming support for AI responses

---

*Built with ❤️ using AI-assisted development achieving 44-66x productivity gains.*  
*World-class API, Eiffel style.*