# lua-resty-elasticsearch

* base on [lua-resty-http](https://github.com/pintsized/lua-resty-http)
* [openresty](https://openresty.org)

# Status
develop

# Features



# API

* [new](#new)
* [index](#index)
* [type](#type)
* [timeout](#timeout)
* [create](#create)
* [drop](#drop)
* [delete](#delete)
* [count](#count)
* [update](#update)
* [search](#search)
* [query](#query)

## new

```
local el = elastic:new({
  { host = "192.168.0.2", port = 9200 },
  { host = "192.168.0.1", port = 9200 }
})
```

## index

```
el:index('log_2017-8')
```

## type

```
el:type('log')
```


## timeout

```
el:timeout(500)
```


## create

```

local cjson = require "cjson"
local elastic = require "resty.elasticsearch.client"


local log_json = {}
log_json["uri"]=ngx.var.uri
log_json["args"]=ngx.var.args  
log_json["host"]=ngx.var.host  
log_json["request_body"]=ngx.var.request_body  
log_json["remote_addr"] = ngx.var.remote_addr  
log_json["remote_user"] = ngx.var.remote_user  
log_json["time_local"] = ngx.var.time_local  
log_json["status"] = ngx.var.status  
log_json["body_bytes_sent"] = ngx.var.body_bytes_sent  
log_json["http_referer"] = ngx.var.http_referer  
log_json["http_user_agent"] = ngx.var.http_user_agent  
log_json["http_x_forwarded_for"] = ngx.var.http_x_forwarded_for
log_json["upstream_response_time"] = ngx.var.upstream_response_time
log_json["request_time"] = ngx.var.request_time

local message = cjson.encode(log_json)

local ok, err = el:create(log_json)
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end
```


## drop

```
local ok, err = el:drop()
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end

```

## delete

```
local ok, err = el:delete('AV3Lgivmycrvlts2ikBt')
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end
```

## count

```
local ok, err = el:count()
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end
```

## update

```
local ok, err = el:update('AV3Lgin5ycrvlts2ikBs',log_json)
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end

```

## search

```
local ok, err = el:search({
   query = {
      term = {
      host = "127.0.0.1"
    }
  }
})
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end
```

## query

```
local ok, err = el:query("time_local:2017")
if ok then
  ngx.say(ok)
else 
  ngx.say(err)
end
```