local skynet = require "skynet"

local command = {}

function command.say( str )
	print("========== say Start ==========")
	print( str )
end

skynet.start(function( ... )
	print("========== Service Start ==========")
	skynet.dispatch("lua", function(session, address, cmd, ...)
		print("========== dispatch Start ==========")
		local f = command[cmd]
		if f then
			skynet.retpack(f(...))
		end
	end)
end)