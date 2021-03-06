local skynet = require "skynet"
local netpack = require "skynet.netpack"
local gateserver = require "snax.gateserver"

local socket = require "skynet.socket"
local proto = require "proto"
local sproto = require "sproto"

local host

local connection = {}	-- fd -> connection : { fd, ip }
local handler = {}

local agentlist = {}

-- 当一个完整的包被切分好后，message 方法被调用。这里msg是一个C指针、 sz是一个数字，表示包的长度（C指针指向的内存块的长度）。
function handler.message(fd, msg, sz)
	print("==========gate handler.message==========="..fd)
	local c = connection[fd]
	local agent = agentlist[fd]
	if agent then
		-- skynet.redirect(agent, c.client, "client", 1, msg, sz)
		print("接收到客户端消息，传给agent服务处理")
		local str = netpack.tostring( msg, sz )
		host = sproto.new(proto.c2s):host "package"
		local type, str2, str3, str4 = host:dispatch(str)
		print(type, str2, str3, str4)
		if type == "REQUEST" then
			print( str3 )
		end
	else
		print("没有agent处理该消息")
	end
end

function handler.connect(fd, addr)
	print("=============gate handler.connect============"..fd)
	local c = {
		fd = fd,
		ip = addr,
	}
	-- 保存客户端信息
	connection[fd] = c
	-- 马上允许fd接收消息（由于下面交给service1处理消息，所以可以在service1准备好再调用）
	-- 这样可能导致客户端发来的消息丢失，因为service1未准备好的情况下，无法处理消息
	gateserver.openclient(fd)

	agentlist[fd] = skynet.newservice("service1")
	--skynet.call(agentlist[fd], "lua", "start", {fd = fd, addr = addr})
end

function handler.disconnect(fd)
	print(fd.."断开连接")
end

function handler.error(fd, msg)
	print("异常错误")
end

gateserver.start(handler)
