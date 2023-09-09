local wibox = require('wibox')
local button = require('ui.widgets.button')
local dpi = require('beautiful.xresources').apply_dpi

return function ()
  return button(wibox.widget.textclock('%I:%M %p'), {
    margins = {
      left = dpi(3),
      right = dpi(3),
    }
  })
end
