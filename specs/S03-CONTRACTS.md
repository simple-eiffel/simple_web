# S03 CONTRACTS - simple_web

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_web

## SIMPLE_WEB_REQUEST Contracts

### make_get / make_post / etc.
```eiffel
make_get (a_url: STRING)
    require
        url_attached: a_url /= Void
        url_not_empty: not a_url.is_empty
    ensure
        method_set: method ~ Http_method_get
        url_set: url ~ a_url
```

### with_header
```eiffel
with_header (a_name, a_value: STRING): SIMPLE_WEB_REQUEST
    require
        name_attached: a_name /= Void
        name_not_empty: not a_name.is_empty
        value_attached: a_value /= Void
    ensure
        returns_self: Result = Current
        header_added: headers.has (a_name)
```

### with_body
```eiffel
with_body (a_body: STRING): SIMPLE_WEB_REQUEST
    require
        body_attached: a_body /= Void
    ensure
        returns_self: Result = Current
        body_set: body = a_body
```

## SIMPLE_WEB_RESPONSE Contracts

### make
```eiffel
make (a_status_code: INTEGER)
    require
        valid_status: a_status_code > 0
    ensure
        status_set: status_code = a_status_code
```

### is_success
```eiffel
is_success: BOOLEAN
    ensure
        definition: Result = (status_code >= 200 and status_code < 300)
```

## SIMPLE_WEB_CLIENT Contracts

### get
```eiffel
get (a_url: STRING): SIMPLE_WEB_RESPONSE
    require
        url_attached: a_url /= Void
        url_not_empty: not a_url.is_empty
    ensure
        result_attached: Result /= Void
```

### execute
```eiffel
execute (a_request: SIMPLE_WEB_REQUEST): SIMPLE_WEB_RESPONSE
    require
        request_attached: a_request /= Void
    ensure
        result_attached: Result /= Void
```

## SIMPLE_WEB_SERVER Contracts

### make
```eiffel
make (a_port: INTEGER)
    require
        valid_port: a_port > 0 and a_port < 65536
    ensure
        port_set: port = a_port
```

### on_get / on_post / etc.
```eiffel
on_get (a_pattern: STRING; a_handler: PROCEDURE [...])
    require
        pattern_attached: a_pattern /= Void
        handler_attached: a_handler /= Void
```

## Class Invariants

### SIMPLE_WEB_REQUEST
```eiffel
invariant
    method_attached: method /= Void
    url_attached: url /= Void
    body_attached: body /= Void
    timeout_positive: timeout_ms > 0
```

### SIMPLE_WEB_RESPONSE
```eiffel
invariant
    status_positive: status_code > 0
    body_attached: body /= Void
```

### SIMPLE_WEB_SERVER
```eiffel
invariant
    port_valid: port > 0 and port < 65536
```
