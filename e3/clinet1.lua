package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua;my/e3/?.lua"

if _VERSION ~= "Lua 5.3" then
	error "Use lua 5.3"
end

-- local socket = require "clientsocket"
-- 新版本
local socket = require "client.socket"

local fd = assert(socket.connect("192.168.1.103", 8888))
print( "socket.connect" )

-- 发送一条消息给服务器, 消息协议可自定义(官方推荐sproto协议,当然你也可以使用最熟悉的json)
socket.send(fd, "hello socket")