local skynet = require "skynet"

skynet.start(function()
	print("=======Skynet Start=========")
	local service = skynet.newservice("service")
	skynet.call(service, "lua", "say", "hello world")

	skynet.exit()
end)