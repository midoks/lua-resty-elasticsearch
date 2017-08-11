-- Copyright (C) by Midoks(midoks@163.com)
-- https://www.elastic.co/guide/en/elasticsearch/client/index.html
-- https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html


local cjson = require "cjson"
local http = require "resty.elasticsearch.http"

local setmetatable = setmetatable
local _M = { _VERSION = '0.01' }
local mt = { __index = _M }

function _M.new(self, opt)

    -- ngx.say("new:",cjson.encode(opt))
    local p = setmetatable({
        list       = opt,
        timeout    = 3000,
        eindex     = 'mlog',
        etype      = 'mlog'
    }, mt)

    -- ngx.say("p:",cjson.encode(p))
    return p
end

-- index name
function _M.index(self, index)
    self.eindex = index
end

-- type name
function _M.type(self, type)
    self.etype = type
end

--- timeout
function _M.timeout(self, timeout)
    self.timeout = type
end


function  _M.call(self, etype, http_req)
    math.randomseed(os.time())
    local num = table.getn(self.list)
    local rand = math.random(1, num)

    local httpc = http.new()
    httpc:set_timeout(500)
    httpc:connect(self.list[rand]["host"], self.list[rand]["port"])


    -- ngx.say( cjson.encode(http_req) )

    if nil == http_req["path"] then

        local epath = "/"  ..self.eindex
        if etype then
            epath = "/"  ..self.eindex .. "/" .. etype
        end

        http_req["path"] = epath
    end

    -- ngx.say( cjson.encode(http_req) )

    local res, err = httpc:request(http_req)
    if not res then
        ngx.say("failed to request: ", err)
        -- local err_s  = string.fr
        return nil, err
    end

    local reader = res.body_reader
    local data = ""

    repeat
        local chunk, err = reader(8192)
        if err then
          ngx.log(ngx.ERR, err)
          break
        end

        if chunk then
            data = data..chunk
        end
    until not chunk

    local ok, err = httpc:set_keepalive()
    if not ok then
        ngx.say("failed to set keepalive: ", err)
        return
    end

    return data
end


-- create index
function  _M.create(self , data)

    local json_data = cjson.encode(data)

    local ok, err = self:call(self.etype,{
        method = "POST",
        body = json_data,
        headers = {["Content-Type"] = "application/x-www-form-urlencoded",}
    })

    return ok, err
end

-- drop index
function _M.drop(self)
    local ok, err = self:call(nil, {method = "DELETE",})
    return ok, err
end

-- delete
function _M.delete(self, id)
    local ok, err = self:call(self.etype..'/'.. id, {method = "DELETE"})

    return ok, err
end

-- count
function _M.count(self)
    local ok, err = self:call(self.etype..'/_count', {})
    return ok, err
end

-- update
function _M.update( self, id, data )
    local json_data = cjson.encode(data)

    local ok, err = self:call(self.etype..'/'.. id,{
        method = "POST",
        body = json_data,
        headers = {["Content-Type"] = "application/x-www-form-urlencoded",}
    })

    return ok, err
end

function _M.query( self , q)
    local ok, err = self:call(self.etype..'/_search?q=' .. q, {method = "GET",})
    return ok, err
end

-- search
function _M.search(self, data)

    local json_data = cjson.encode(data)

    local ok, err = self:call(self.etype..'/_search',{
        method = "GET",
        body = json_data,
        headers = {["Content-Type"] = "application/x-www-form-urlencoded",}
    })
    return ok, err
end

-- test
function _M.t( self )
    ngx.say('t')
end


return _M

