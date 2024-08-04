local awful = require('awful')
local wibox = require('wibox')
local beautiful = require("beautiful")
local main_menu = require('ui.menu')
local gtable = require('gears.table')
local gcolor = require('gears.color')
local helpers = require('helpers')
local button = require('ui.bar.button')
local gfs = require('gears.filesystem')
local config_dir = gfs.get_configuration_dir()
local animate = require('ui.animations').animate
local image_icon = config_dir .. 'theme/assets/awesome.svg'

local widget_menu = button(
  {
    id = 'awesome_icon',
    image = beautiful.awesome_icon,
    resize = true,
    clip_shape = helpers.ui.squircle(1.5),
    widget = wibox.widget.imagebox,
  }
)

local icon_animation = animate(
  widget_menu,
  'click',
  'color',
  function (color)
    widget_menu:get_children_by_id('awesome_icon')[1].image = gcolor.recolor_image(image_icon, color)
  end,
  {
    from = beautiful.accent,
    to = helpers.color.darken_or_lighten(beautiful.accent, 0.5)
  }
)

widget_menu.click.on:subscribe(function ()
  icon_animation.on()
end)

widget_menu.click.off:subscribe(function ()
  icon_animation.off()
end)

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
