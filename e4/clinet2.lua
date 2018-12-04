package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua;my/e3/?.lua"

if _VERSION ~= "Lua 5.3" then
	error "Use lua 5.3"
end

-- local socket = require "clientsocket"
-- 新版本
local socket = require "client.socket"

local szAddress = "127.0.0.1"
local fd = assert(socket.connect(szAddress, 8888))
print( "socket.connect : "..szAddress )

-- 发送一条消息给服务器, 消息协议可自定义(官方推荐sproto协议,当然你也可以使用最熟悉的json)
socket.send(fd, "hello 服务器")

while true do
	-- 接收服务器返回消息
	local str = socket.recv(fd)
	if str ~= nil and str ~= "" then
		print("server says: ".. str)
		--socket.close(fd)
		--break
	end

	-- 读取用户输入消息
	local readstr = socket.readstdin()
	if readstr then
		if readstr == "quit" then
			socket.close(fd)
			break
		else
			-- 把用户输入消息发送给服务器
			socket.send(fd, readstr)
		end
	else
		socket.usleep(100)
	end
end