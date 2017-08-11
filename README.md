# lua-resty-elasticsearch

base on [lua-resty-http](https://github.com/pintsized/lua-resty-http)

# Status
test

# Features



# API

* [new](#new)
* [index](#index)
* [type](#type)
* [timeout](#timeout)


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
