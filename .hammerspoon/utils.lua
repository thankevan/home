local utils = {}

function utils.printAllRunningApplications()
    -- Get a list of all running applications
    local apps = hs.application.runningApplications()

    -- Iterate through the list and print the name of each application
    for _, app in ipairs(apps) do
        print(app:name())
    end
end

function utils.printApplicationByWindowTitle(title)
    -- Get a list of all running applications
    local apps = hs.application.runningApplications()

    -- Iterate through the list of applications
    for _, app in ipairs(apps) do
        -- Get a list of all windows for the current application
        local windows = app:allWindows()

        -- Iterate through the list of windows
        for _, win in ipairs(windows) do
            -- Check if the window title matches "Polls/quizzes"
            if win:title() == title then
                -- Print the application name
                print("Application with window titled '" .. title .. "': " .. app:name())
                return
            end
        end
    end

    print("No application with a window titled '" .. title .. "' found.")
end

function utils.printApplicationWindowNames(appName)
    -- Find the application by name
    local app = hs.application.get(appName)

    -- Check if the application is running
    if app then
        -- Get a list of all windows for the application
        local windows = app:allWindows()

        -- Print the names of all windows
        print("Windows for application '" .. appName .. "':")
        for _, win in ipairs(windows) do
            print(win:title())
        end
    else
        print("Application '" .. appName .. "' is not running.")
    end
end

-- Function to find and report windows with a specified word in the title
function utils.printApplicationAndWindowByWindowTitleSubstring(word)
    -- Convert the word to lowercase for case-insensitive comparison
    local wordLower = word:lower()

    -- Get a list of all windows managed by the system
    local windows = hs.window.allWindows()

    -- Iterate through the list of windows
    for _, win in ipairs(windows) do
        -- Get the window title and convert it to lowercase for comparison
        local winTitleLower = win:title():lower()

        print("***** " .. win:title())

        -- Check if the window title contains the specified word
        if string.find(winTitleLower, wordLower) then
            -- Print the application name and window title
            print("Application: " .. win:application():name() .. ", Window: " .. win:title())
        end
    end
end

function utils.printWindowInfo(win)
    -- Get the window title and application name
    local winTitle = win:title()
    local appName = win:application():name()

    -- Get more window attributes
    local winID = win:id()
    local winFrame = win:frame()
    local winRole = win:role()
    local winSubrole = win:subrole()
    local winPID = win:pid()

    -- Format the window attributes for display
    local winInfo = string.format(
        "Application: [%s]\nWindow Title: [%s]\nWindow ID: [%s]\nFrame: [%s]\nRole: [%s]\nSubrole: [%s]\nPID: [%d]",
        appName, winTitle, winID, winFrame, winRole, winSubrole, winPID
    )

    -- Display the information using an alert
    print("\n*****\n" .. winInfo)
end

function utils.printFocusedWindowInfo()
    -- Get the currently focused window
    local win = hs.window.focusedWindow()

    if win then
        utils.printWindowInfo(win)
    else
        -- Display a message if no window is focused
        print("No focused window")
    end
end

return utils
