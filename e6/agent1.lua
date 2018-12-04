local skynet = require "skynet"
local socket = require "skynet.socket"

local proto = require "proto"
local sproto = require "sproto"

local fd = ...
fd = tonumber(fd)

local host

local function echo(id)
	socket.start(id)

	host = sproto.new(proto.c2s):host "package"

	while true do
		local str = socket.read(id)
		if str then
			local type, str2, str3, str4 = host:dispatch(str)
			print("client say:"..str3.msg)
			-- socket.write(id, str)
		else
			socket.close(id)
			return
		end
	end
end

skynet.start(function()
	skynet.fork(function()
		echo(fd)
		skynet.exit()
	end)
end)