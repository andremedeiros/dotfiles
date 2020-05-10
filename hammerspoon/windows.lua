local _M = {}

function _M.moveWindowToUnitRect(win, uf)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + max.w * uf.x
  f.y = max.y + max.h * uf.y
  f.w = max.w * uf.w
  f.h = max.h * uf.h

  -- avoids redrawing, particularly in cases like
  -- iterm2 which doesn't exactly fit the frame
  if f == win:frame() then
    return
  end

  win:setFrame(f, 0)
end

function _M.maximize(win)
  win:maximize(0)
end

function _M.moveLeft(win, size)
  _M.moveWindowToUnitRect(win, {x=0, y=0, w=size, h=1})
end

function _M.moveDown(win, size)
  _M.moveWindowToUnitRect(win, {x=0, y=(1-size), w=1, h=size})
end

function _M.moveUp(win, size)
  _M.moveWindowToUnitRect(win, {x=0, y=0, w=1, h=size})
end

function _M.moveRight(win, size)
  _M.moveWindowToUnitRect(win, {x=(1-size), y=0, w=size, h=1})
end

function _M.moveCenter(win, size)
  margin = (1-size)/2
  _M.moveWindowToUnitRect(win, {x=margin, y=margin, w=size, h=size})
end

function _M.moveScreenLeft(win)
  win:moveOneScreenWest(false, true, 0)
end

function _M.moveScreenRight(win)
  win:moveOneScreenEast(false, true, 0)
end

function _M.setup(leader, key, sizes)
  local win = nil
  local wm = hs.hotkey.modal.new(leader, key)

  function wm:entered()
    win = hs.window.focusedWindow()
  end

  wm:bind("cmd",   "h",      function() _M.moveScreenLeft(win);           wm:exit() end)
  wm:bind("cmd",   "l",      function() _M.moveScreenRight(win);          wm:exit() end)
  wm:bind("",      "space",  function() _M.maximize(win);                 wm:exit() end)
  wm:bind("shift", "h",      function() _M.moveLeft(win, 1/2);            wm:exit() end)
  wm:bind("shift", "l",      function() _M.moveRight(win, 1/2);           wm:exit() end)
  wm:bind("",      "h",      function() _M.moveLeft(win, sizes.left);     wm:exit() end)
  wm:bind("",      "j",      function() _M.moveDown(win, sizes.down);     wm:exit() end)
  wm:bind("",      "k",      function() _M.moveUp(win, sizes.up);         wm:exit() end)
  wm:bind("",      "l",      function() _M.moveRight(win, sizes.right);   wm:exit() end)
  wm:bind("",      "tab",    function() _M.moveCenter(win, sizes.center); wm:exit() end)
  wm:bind("",      "escape", function()                                   wm:exit() end)
end

return _M
