local awful = require('awful')
local wibox = require('wibox')
local beautiful = require("beautiful")
local main_menu = require('ui.menu')
local gtable = require('gears.table')
local helpers = require('helpers.ui')
local button = require("ui.widgets.button")

local widget_menu = button.color(
  button.size {
    image = beautiful.awesome_icon,
    resize = true,
    clip_shape = helpers.squircle(1.5),
    widget = wibox.widget.imagebox,
  }
)

widget_menu:buttons(
  gtable.join(
    awful.button(
      {},
      1,
      nil,
      function ()
        main_menu:toggle()
      end
    )
  )
)

return widget_menu
