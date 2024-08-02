
-- brew install luarocks
-- luarocks install luasocket
-- local socket = require 'socket'


--[[
    This script will help keep windows in position.
    Particularly the zoom polls window likes to jump around.

    Goal:
        CMD-OPT-CTRL-P pins the current window, it stays were currently placed

    Current:
        CMD-OPT-CTRL-P pins the current window
        CMD-OPT-CTRL-R resets the window location

    Current state:
        I have not been able to keep loops running or waiting properly.
        Move sleep/loop functions to utils once working
]]

local pinwindow = {}
pinwindow.win = nil
pinwindow.frame = nil
pinwindow.id = nil

function pinwindow.setWindow()
    print("setWindow")
    pinwindow.win = hs.window.focusedWindow()
    pinwindow.id = pinwindow.win:id()
    pinwindow.frame = pinwindow.win:frame()
    print(string.format(
        "Application: [%s]\nWindow Title: [%s]\nWindow ID: [%s]\nFrame: [%s]",
        pinwindow.win:application():name(), pinwindow.win:title(), pinwindow.id, pinwindow.frame
    ))
end

function pinwindow.moveWindowToFrame()
    -- local frame = hs.geometry.rect(2303.0, 767.0, 400.0, 628.0)
    print("moveWindowToFrame")
    if pinwindow.frame then
        pinwindow.win:setFrame(pinwindow.frame)
    end
end


function pinwindow.pinLoop()
    local foundWindow = hs.window.find(pinwindow.id)
    print(foundWindow)
    while foundWindow do
        pinwindow.moveWindowToFrame()
        -- pinwindow.sleep(1)
        -- socket.sleep(1)
        foundWindow = hs.window.find(pinwindow.id)
    end
end

function pinwindow.sleep(n)
    os.execute("sleep " .. tonumber(n))
end

function pinwindow.setup()
    -- pin/set window
    hs.hotkey.bind({"ctrl", "alt", "cmd"}, "P", function()
        pinwindow.setWindow()
        -- pinwindow.pinLoop()
        -- hs.timer.doEvery(1,pinwindow.moveWindowToFrame)
    end)

    -- reset window to position
    hs.hotkey.bind({"ctrl", "alt", "cmd"}, "R", function()
        pinwindow.moveWindowToFrame()
    end)
end

return pinwindow