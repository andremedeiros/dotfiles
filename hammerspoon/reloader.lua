local _M = {}

local CONFIG_DIR = os.getenv("HOME") .. "/.hammerspoon/"

function _M.setup(leader, key)
  hs.hotkey.bind(leader, key, nil, hs.reload)
  hs.pathwatcher.new(CONFIG_DIR, hs.reload):start()
end

return _M
