local _M = {}

local STREAMING_APPS = {"Moonlight", "Steam Link", "streaming_client"}

function _M.setup()
  hs.application.watcher.new(toggle_airdrop):start()
end

function toggle_airdrop(name, event, app)
  local logger = hs.logger.new("moonlight", "debug")
  if not hs.fnutils.contains(STREAMING_APPS, name) then
    return
  end

  logger.i("toggling airdrop for " .. name)
  if event == hs.application.watcher.deactivated then
    logger.i("enabling airdrop")
    hs.execute("/sbin/ifconfig awdl0 up && /sbin/ifconfig llw0 up")
  elseif event == hs.application.watcher.activated then
    logger.i("disabling airdrop")
    hs.execute("/sbin/ifconfig awdl0 down && /sbin/ifconfig llw0 down")
  end
end

return _M
