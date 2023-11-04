local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local container = require('ui.widgets.container')

return function ()
  local widget = wibox.widget {
    layout = wibox.layout.flex.horizontal,
  }

  local wcontainer = container(widget,
  {
    paddings = dpi(4),
    shape = gears.shape.rounded_bar,
    bg = beautiful.background_alt,
  })

  return wcontainer
end
