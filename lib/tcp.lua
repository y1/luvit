local UV = require('uv')
local user_meta = require('utils').user_meta
local stream_meta = require('stream').meta
local TCP = {}

local tcp_prototype = {}
setmetatable(tcp_prototype, stream_meta)

function TCP.new()
  local tcp = {
    userdata = UV.new_tcp(),
    prototype = tcp_prototype
  }
  setmetatable(tcp, user_meta)
  return tcp
end

function TCP.create_server(ip, port, on_connection)
  local server = TCP.new()
  server:bind("0.0.0.0", 8080)

  server:listen(function (err, status)
    if (err) then
      return server:emit("error", err)
    end
    local client = TCP.new()
    server:accept(client)
    client:read_start()
    on_connection(client)
  end)

  return server
end

return TCP