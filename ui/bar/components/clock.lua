local awful = require('awful')
local wibox = require('wibox')
local button = require('ui.bar.button')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

return function ()
  local clock = button(wibox.widget.textclock('%I:%M %p'), {
    paddings = {
      left = dpi(3),
      right = dpi(3),
    },
  })

  awful.tooltip{
    objects = {
      clock,
    },
    timeout = 60,
    delay_show = 1,
    timer_function = function ()
      return os.date('%A %B %d %Y')
    end
  }

  return clock
end
