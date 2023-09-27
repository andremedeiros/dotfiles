local moonlight = require("moonlight")
local reloader = require("reloader")
local windows = require("windows")

local leader = {"shift", "cmd"}

-- reloading
reloader.setup(leader, "r")

-- window management
local sizes = {left=5/8, right=3/8, up=1/2, down=1/2, center=2/3}
windows.setup(leader, "m", sizes)

-- moonlight
moonlight.setup()
