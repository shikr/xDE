local awful = require('awful')
local wibox = require('wibox')
local beautiful = require("beautiful")
local main_menu = require('ui.menu')
local gtable = require('gears.table')
local gcolor = require('gears.color')
local helpers = require('helpers')
local button = require('ui.bar.button')
local gfs = require('gears.filesystem')
local rubato = require('modules.rubato')
local Color = require('modules.lua-color')
local config_dir = gfs.get_configuration_dir()

local function icon_animation(widget)
  local accent = beautiful.accent
  local hover_accent = helpers.color.darken_or_lighten(accent, 0.5)
  local image_icon = config_dir .. 'theme/assets/awesome.svg'
  local color = Color(accent)
  local color_hover = Color(hover_accent)

  widget._icon_animation = rubato.timed {
    duration = 0.2,
    awestore_compat = true,
    clamp_position = true,
    easing = rubato.easing.quadratic,
  }

  widget._icon_animation:subscribe(function (pos)
    local new_color = Color(color):mix(color_hover, pos):tostring()
    widget:get_children_by_id('awesome_icon')[1].image = gcolor.recolor_image(image_icon, new_color)
  end)

  return {
    start = function ()
      widget._icon_animation:set(1)
    end,
    finish = function ()
      widget._icon_animation:set(widget._icon_animation:initial())
    end,
  }
end

local widget_menu = button(
  {
    id = 'awesome_icon',
    image = beautiful.awesome_icon,
    resize = true,
    clip_shape = helpers.ui.squircle(1.5),
    widget = wibox.widget.imagebox,
  },
  {
    animations = { hover = 'color', click = { 'size', icon_animation } }
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
