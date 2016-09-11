require 'os'

-- Sample:
-- print(sh.execute('ls -la'))
function execute(cmd)
    local file = io.popen(cmd)
    local output = file:read("*a") or " "
    file:close()
    return output:sub(1, -2)
end

-- Sample:
-- local ls = sh.command('ls -l')
-- print(ls('-a'))
function command(cmd)
    return function(args)
        return execute(cmd .. " " .. (args or ""))
    end
end

-- export command() function and configurable temporary "input" file
local M = {}
M.command = command
M.execute = execute

-- allow to call sh to run shell commands
setmetatable(M, {
	__call = function(_, cmd, ...)
		return execute(cmd, ...)
	end
})

return M

-- print(execute("echo hello"))
-- print(command("echo")("hello"))
--
-- local cores = 1 + tonumber(execute("lscpu --parse=cpu | tail -n 1"))
-- local ubuntuVersion = execute("lsb_release -sd")
-- local ubuntuRelease = execute("lsb_release -sc")
--
-- print("Cores: " .. cores)
-- print("Ubuntu: " .. ubuntuVersion .. " " .. ubuntuRelease)
