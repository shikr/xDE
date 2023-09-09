local wibox = require('wibox')
local beautiful = require('beautiful')
local rubato = require('modules.rubato')
local Color = require('modules.lua-color')

local function button(child, args)
  args = args or {}
  local bg = args.bg ~= nil and args.bg or beautiful.bg_normal
  local bg_hover = args.bg_hover ~= nil and args.bg_hover or beautiful.bg_hover(bg)

  local widget = wibox.widget {
    widget = wibox.container.background,
    bg = bg,
    shape = args.shape ~= nil and args.shape or beautiful.button_shape,
    border_color = args.border_color,
    border_width = args.border_width,
    child
  }

  local color = Color(bg)
  local color_hover = Color(bg_hover)

  widget.animation = rubato.timed {
    duration = 0.2,
    awestore_compat = true,
    clamp_position = true,
    easing = rubato.easing.quadratic
  }

  widget.animation:subscribe(function (pos)
    local new_color = Color(color)
    widget.bg = new_color:mix(color_hover, pos):tostring()
  end)

  widget:connect_signal('mouse::enter', function ()
    widget.animation:set(1)
  end)

  widget:connect_signal('mouse::leave', function ()
    widget.animation:set(widget.animation:initial())
  end)

  return widget
end

return button
