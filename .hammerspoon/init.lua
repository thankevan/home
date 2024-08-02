--hs.application.enableSpotlightForNameSearches(true)

--[[
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
  print("***** hello world")
end)

--[[
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)
]]--


local utils = require("utils")
local pinwindow = require("pinwindow")

-- Ctrl + Alt + Cmd + W: print focused window info
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "W", utils.printFocusedWindowInfo)

-- Ctrl + Alt + Cmd + P: Set focused window location
-- Ctrl + Alt + Cmd + R: Reset window location
pinwindow.setup()
