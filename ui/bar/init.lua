local awful = require('awful')
local wibox = require('wibox')
local layoutbox = require(... .. '.layoutbox')
local taglist = require(... .. '.taglist')
local tasklist = require(... .. '.tasklist')
local mylauncher = require(... .. '.start')

local mykeyboardlayout = awful.widget.keyboardlayout()

local mytextclock = wibox.widget.textclock()

screen.connect_signal('request::desktop_decoration', function (s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  s.mypromptbox = awful.widget.prompt()

  s.mylayoutbox = layoutbox(s)

  s.mytaglist = taglist(s)

  s.mytasklist = tasklist(s)

  s.mywibox = awful.wibar {
    position = "top",
    screen   = s,
    widget   = {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        mykeyboardlayout,
        wibox.widget.systray(),
        mytextclock,
        s.mylayoutbox,
      },
    }
  }
end)
