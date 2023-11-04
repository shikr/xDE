local awful = require('awful')
local wibox = require('wibox')
local layoutbox = require(... .. '.components.layoutbox')
local taglist = require(... .. '.components.taglist')
local tasklist = require(... .. '.components.tasklist')
local mylauncher = require(... .. '.components.start')
local keyboard = require(... .. '.components.keyboard')
local clock = require(... .. '.components.clock')
local control_center = require(... .. '.components.control-center')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local mykeyboardlayout = keyboard()

local mytextclock = clock()

local spacing = dpi(4)

screen.connect_signal('request::desktop_decoration', function (s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  s.mypromptbox = awful.widget.prompt()

  s.mylayoutbox = layoutbox(s)

  s.mytaglist = taglist(s)

  s.mytasklist = tasklist(s)

  s.control_center = control_center()

  s.mywibox = awful.wibar {
    position = "top",
    screen   = s,
    widget   = {
      {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          spacing = spacing,
          mylauncher,
          s.mytasklist,
          s.mypromptbox,
        },
        s.mytaglist, -- Middle widget
        { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          spacing = spacing,
          mykeyboardlayout,
          wibox.widget.systray(),
          mytextclock,
          s.control_center,
          s.mylayoutbox,
        },
      },
      margins = dpi(3),
      widget = wibox.container.margin
    }
  }
end)
