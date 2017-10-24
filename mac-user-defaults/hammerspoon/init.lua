if (hs.keycodes.currentLayout() ~= 'ABC') then
  hs.keycodes.setLayout('ABC')
  hs.reload()
else

local debug = 0
local eventtap = require "hs.eventtap"
-- local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/Downloads", function() labels() end):start()


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


function dd(string)
  if debug == 1 then
    hs.alert.show(string, nil, hs.screen.mainScreen(), 15)
  end  
end



hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x 
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)


hs.hotkey.bind({"shift", "cmd"}, "w", function()
local app = hs.appfinder.appFromName("Finder")
  if (app:isRunning()) then
    if (app:isFrontmost()) then
      local event = require("hs.eventtap").event
      -- app:selectMenuItem({"View", "as List"})
      app:selectMenuItem({"Finder", "Services", "New iTerm2 Tab Here"})
      event.newKeyEvent({"ctrl"}, string.lower("§"), true):post()
      event.newKeyEvent({"ctrl"}, string.lower("§"), false):post()
    end
  end
end)


hs.hotkey.bind({"shift"}, "Escape", function()
local app = hs.appfinder.appFromName("Finder")
  if (app:isRunning()) then
    if (app:isFrontmost()) then
      local event = require("hs.eventtap").event
      local as = [[tell application "Finder"
      activate
      tell the front Finder window
        set the current view to list view
        set the toolbar visible to true
      end tell
      
      tell list view options of front Finder window
        set properties to {sort column:name column, sort direction:normal, icon size:small icon, text size:12, uses relative dates:false, calculates folder sizes:true, shows icon preview:false}
        set width of column name column to 250
      end tell
      
      tell application "System Events" to tell process "Finder"
        tell menu item "Show View Options" of menu of menu bar item "View" of menu bar 1 to if exists then click
        tell checkbox "Always open in icon view" of window 1 to if (exists) and value is 1 then click
        tell checkbox "Always open in list view" of window 1 to if (exists) and value is 0 then click
        tell checkbox "Date Modified" of group 1 of window 1 to if value is 1 then click
        tell checkbox "Date Created" of group 1 of window 1 to if value is 1 then click
        tell checkbox "Size" of group 1 of window 1 to if value is 0 then click
        tell checkbox "Kind" of group 1 of window 1 to if value is 1 then click
        tell checkbox "Version" of group 1 of window 1 to if value is 1 then click
        tell checkbox "Comments" of group 1 of window 1 to if value is 1 then click
        tell checkbox "Tags" of group 1 of window 1 to if value is 0 then click
        -- click button 0 of window 1
        -- click menu item "Zoom" of menu of menu bar item "Window" of menu bar 1
      end tell
    end tell]]
      -- app:selectMenuItem({"View", "as List"})
      -- app:selectMenuItem({"View", "Arrange By", "Application"})
      event.newKeyEvent({"cmd"}, string.lower("2"), true):post()
      event.newKeyEvent({"cmd"}, string.lower("2"), false):post()
      event.newKeyEvent({"cmd","ctrl"}, string.lower("1"), true):post()
      event.newKeyEvent({"cmd","ctrl"}, string.lower("1"), false):post()
      event.newKeyEvent({"cmd","ctrl","alt"}, string.lower("2"), true):post()
      event.newKeyEvent({"cmd","ctrl","alt"}, string.lower("2"), false):post()
      event.newKeyEvent("", string.lower("alt"), false):post()
      hs.osascript.applescript(as)
      event.newKeyEvent({"cmd"}, string.lower("j"), true):post()
      event.newKeyEvent({"cmd"}, string.lower("j"), false):post()
    end
  end
end)

hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)


-- hs.hotkey.bind({"ctrl"}, "`", function()
-- app = hs.appfinder.appFromName("Terminal")
--   if ( app == nil ) then
--     hs.application.launchOrFocus("Terminal")
--     hs.timer.usleep(300000)
--     local win = hs.window.focusedWindow()
--     local f = win:frame()
--     local screen = win:screen()
--     local max = screen:frame()

--     f.x = max.x 
--     f.y = max.y
--     f.w = max.w
--     f.h = max.h
--     win:setFrame(f)
--   elseif (app:isFrontmost()) then
--   	app:hide()
--   else
--   	hs.application.launchOrFocus("Terminal")
--   	local win = hs.window.focusedWindow()
--   	local f = win:frame()
--   	local screen = win:screen()
--   	local max = screen:frame()

--   	f.x = max.x 
--   	f.y = max.y
--   	f.w = max.w
--   	f.h = max.h
--   	win:setFrame(f)
--   end
-- end)



-- Brobrolab artefacts


-- hs.hotkey.bind({"shift"}, "f1", function()
--   hs.alert.show("f1 = Phone | f2 = Repairs | f3 = Diag | f4 = Zendesk | f5 = DHL", 5)
-- end)


-- hs.hotkey.bind({""}, "f1", function()
--   hs.execute('/usr/local/bin/_bbl-phone')
--   hs.alert.show("You do the talking...")
-- end)

-- hs.hotkey.bind({""}, "f2", function()
--   hs.execute('/usr/local/bin/_bbl-fix')
--   hs.alert.show("Чини блин, чини!!!")
-- end)

-- hs.hotkey.bind({""}, "f3", function()
--   hs.execute('/usr/local/bin/_bbl-diag')
--   hs.alert.show("Диагностика, АХА!")
-- end)

-- hs.hotkey.bind({""}, "f4", function()
--   hs.execute('/usr/local/bin/_bbl-zd')
--   hs.alert.show("Zendesk fun")
-- end)

-- hs.hotkey.bind({""}, "f5", function()
--   hs.execute('/usr/local/bin/_bbl-dhl')
--   hs.alert.show("Прием делалей")
-- end)

-- hs.hotkey.bind({"alt"}, "/", function()
--   local id = hs.execute("/usr/local/bin/_bbl-gsx")
--   hs.alert.show(id)
--   hs.application.launchOrFocus("Google Chrome")
--   hs.timer.usleep(300000)
--   hs.eventtap.leftClick({ x = 103, y = 169 })
--   hs.timer.usleep(100000)
--   hs.eventtap.keyStroke({""}, "F7")
--   hs.timer.usleep(100000)
--   hs.eventtap.keyStrokes(id)
--   hs.timer.usleep(100000)
--   hs.eventtap.keyStroke({""}, "return")
-- end)



hs.hotkey.bind({"alt", "cmd", "ctrl"}, "/", function() check_text2() end)
hs.hotkey.bind({"alt"}, "l", function() parse_url() end)
hs.hotkey.bind({"alt", "cmd", "ctrl"}, "d", function() get_date() end)
hs.hotkey.bind({"alt", "cmd"}, "d", function() get_remind_date() end)
hs.hotkey.bind({"alt", "cmd", "ctrl"}, "p", function() remove_ps() end)

function check_text2()
  hs.pasteboard.setContents(nil)
  dd("Prepping script")
  local line = select_line2()
  dd("Line content = " .. line )
  local cmd = "/usr/local/bin/checkboxer " .. "\"" .. line .. "\" | tr -d \"\n\" "
  --app:selectMenuItem({"Typora", "Services", "md-make-check"})
  dd("Executing script")
  local o, r = hs.execute(cmd)
  if r then
    dd(o)
    hs.pasteboard.setContents(o)
    hs.eventtap.keyStroke({"cmd"}, "v") 
    dd("Finished!!!")
  else
    dd("Failed to process text via shell script @ check_text2()")
  end
end

function select_line2()
  dd("Selecting current line")
  local l = nil
  local event = require("hs.eventtap").event
  event.newKeyEvent("cmd", string.lower("l"), true):post()
  event.newKeyEvent("cmd", string.lower("l"), false):post()
  event.newKeyEvent("cmd", string.lower("c"), true):post()
  event.newKeyEvent("cmd", string.lower("c"), false):post()
  hs.timer.usleep(200000)
  event.newKeyEvent("", string.lower("delete"), true):post()
  event.newKeyEvent("", string.lower("delete"), false):post()    
  l = hs.pasteboard.getContents()
  dd(l)
  if l == nil then
    dd("Line is empty")
    return nil
  else
    dd("Line is not empty")
    return l
  end

  dd("Done copying current line")
end

function remove_ps()
  dd("Checking link") 
    line = ""
    select_buff()
    parse_ps()
    dd("Done checking link") 
end


function parse_ps()
  local text = " "
  local text2 = ""
  dd("Entered parse_ps()")
  local result = string.gsub(line, '<p>', text)
  local result = string.gsub(result, '</p>', text2)
  dd("The result line is = " .. result)
  -- hs.eventtap.keyStrokes(result)  // so slow
  hs.pasteboard.setContents(result)
  hs.eventtap.keyStroke({"cmd"}, "v")
end


-- function select_line()
--   dd("Selecting current line")
--   local event = require("hs.eventtap").event
--   event.newKeyEvent("cmd", string.lower("left"), true):post()
--   event.newKeyEvent("cmd", string.lower("left"), false):post()
--   event.newKeyEvent({"shift", "cmd"}, string.lower("right"), true):post()
--   event.newKeyEvent({"shift", "cmd"}, string.lower("right"), false):post()
--   hs.eventtap.keyStroke({"cmd"}, "c")
--   event.newKeyEvent({"cmd"}, string.lower("right"), true):post()
--   event.newKeyEvent({"cmd"}, string.lower("right"), false):post()    
--   line = hs.pasteboard.getContents()
--   dd("Done copying current line")
-- end




function delete_line()
  dd("About to delete the line")
  local event = require("hs.eventtap").event
  event.newKeyEvent("cmd", string.lower("left"), true):post()
  event.newKeyEvent("cmd", string.lower("left"), false):post()
  event.newKeyEvent({"shift", "cmd"}, string.lower("right"), true):post()
  event.newKeyEvent({"shift", "cmd"}, string.lower("right"), false):post()
  event.newKeyEvent("", string.lower("delete"), true):post()
  event.newKeyEvent("", string.lower("delete"), false):post()  
  dd("Line deleted")
end

function check_text()
    line = ""
    select_line2()
    dd("Selected line is = " .. '"' .. line .. '"')
    if string.match(string.lower(line), "- %[ %]") then
	    dd("Found [ ]")
	    dd("current line is = " .. line)
        make_checked()
    elseif string.match(string.lower(line), "- %[x%]")then
        dd("Found [x]")
        dd("current line is = " .. line)
        make_unchecked()
    else
        dd("None was found")
        dd("current line is = " .. line)
        new_unchecked()
    end
end


function parse_url()
  local line = hs.pasteboard.getContents() 
	result = "[link](" .. line .. ")"
  -- hs.eventtap.keyStrokes(result) --// so slow
  hs.pasteboard.setContents(result)
  hs.eventtap.keyStroke({"cmd"}, "v")

end

function select_buff()
	local event = require("hs.eventtap").event
	dd("Selecting current buffer")
	hs.eventtap.keyStroke({"cmd"}, "c")
	dd("Should copy the buff")   
	line = hs.pasteboard.getContents()
	dd("Now delete") 
	event.newKeyEvent("", string.lower("delete"), true):post()
	event.newKeyEvent("", string.lower("delete"), false):post()
	dd("Done copying current buffer")
end

function new_unchecked()  
  local text = "- [ ] "
  dd("Entered new_unchecked()")
  local result = string.gsub(line, "- ", text, 1)
  dd("The result line is = " .. result)
  delete_line()
  hs.pasteboard.setContents(result)
  hs.eventtap.keyStroke({"cmd"}, "v")
  dd("Finished new_unchecked()")
  line = ""
end


function make_unchecked()
  local text = "- [ ] "
  dd("Entered make_unchecked()")
  local result = string.gsub(line, '- %[x%] ~~', text, 1)
  result = result .. "~~"
  dd("The result line is = " .. result)
  -- delete_line()
  hs.pasteboard.setContents(result)
  hs.eventtap.keyStroke({"cmd"}, "v")
  dd("Finished make_unchecked() ")
  line = ""
end


function make_checked() 
  local text = "- [x] ~~"
  dd("Entered make_checked()")
  local result = string.gsub(line, "- %[ %] ", text, 1)
  result = string.gsub(line, "", "~~", 1) 
  dd("The result line is = " .. result)
  -- delete_line()
  hs.pasteboard.setContents(result)
  hs.eventtap.keyStroke({"cmd"}, "v")
  dd("Finished make_checked()")
  line = ""
end




function get_date()
  local date = hs.execute('date "+%d.%m.%Y" | tr -d "\n\r"')
  hs.eventtap.keyStrokes(date .. " ")
end

function get_remind_date()
  local date = hs.execute('date "+%Y-%m-%d" | tr -d "\n\r"')
  hs.eventtap.keyStrokes(date .. " ")
end

-- hs.hotkey.bind({"alt"}, ".", function()
--   hs.application.launchOrFocus("Google Chrome")
--   hs.timer.usleep(100000)
--   hs.eventtap.leftClick({ x = 103, y = 169 })
--   hs.timer.usleep(100000)
--   hs.eventtap.keyStroke({""}, "F7")
-- end)

-- hs.hotkey.bind({"alt"}, "\\", function() labels() end)

function mouseget()
  local mptr = hs.mouse.getRelativePosition()
  hs.alert('mouse pointer at ' .. dump(mptr))
end

function mousepoint()
  hs.mouse.setRelativePosition({ x = 103, y = 169 })
  hs.eventtap.leftClick({ x = 103, y = 169 })
end

function mp1()
  hs.mouse.setRelativePosition({ x = 542, y = 1315 })
  hs.eventtap.leftClick({ x = 542, y = 542 })
  hs.eventtap.leftClick({ x = 542, y = 542 })
  hs.eventtap.keyStroke({"cmd"}, "c")
end


function labels()
  hs.execute('/usr/local/bin/_bbl-labels')
end

-- hs.hotkey.bind({"cmd"}, "/", function() mouseget() end)

-- hs.hotkey.bind({"cmd"}, "'", function() mousepoint() end)

-- hs.hotkey.bind({"cmd"}, "l", function() mp1() end)


-- hs.hotkey.bind({"ctrl"}, "§", function()
-- app = hs.appfinder.appFromName("Terminal")
--   if (app:isFrontmost()) then
--   app:hide()
--   else
--   hs.application.launchOrFocus("Terminal")
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--   local screen = win:screen()
--   local max = screen:frame()

--   f.x = max.x 
--   f.y = max.y
--   f.w = max.w
--   f.h = max.h
--   win:setFrame(f)
--   end
-- end)



hs.hotkey.bind({"ctrl"}, "Escape", function()
  -- local scrnsrvr = "tell application \"System Events\" to start current screen saver"
  -- local app = hs.task.new("/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine", nil, {""})
  -- app:start()
  -- hs.osascript.applescript(scrnsrvr)
  hs.caffeinate.startScreensaver()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
  hs.reload()
end)
hs.notify.new({title="Hammerspoon", informativeText="Config Loaded!"}):send()
end
