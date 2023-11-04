local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local button = require('ui.bar.button')
local network = require('daemons.network')

local function render_icon()
  return gears.color.recolor_image(beautiful.icons.network[network.state], beautiful.fg_normal)
end

local widget = wibox.widget {
  image = render_icon(),
  resize = true,
  widget = wibox.widget.imagebox,
}

network:connect_signal('property::state', function ()
  widget.image = render_icon()
end)

return button(widget, {
  shape = gears.shape.circle,
  bg_hover = beautiful.bg_hover(beautiful.background_alt)
})
