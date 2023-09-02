local wibox = require('wibox')
local beautiful = require('beautiful')
local rubato = require('modules.rubato')
local Color = require('modules.lua-color')

local function button(child, args)
  args = args or {}
  local bg = args.bg ~= nil and args.bg or beautiful.bg_normal

  local widget = wibox.widget {
    widget = wibox.container.background,
    bg = bg,
    shape = args.shape ~= nil and args.shape or beautiful.button_shape,
    border_color = args.border_color,
    border_width = args.border_width,
    child
  }

  local h, s, light, a = Color(bg):hsla()
  local _, _, hover_l = Color(beautiful.bg_hover(bg)):hsl()

  widget.animation = rubato.timed {
    duration = 0.2,
    pos = light,
    awestore_compat = true,
    clamp_position = true,
    easing = rubato.easing.quadratic
  }

  widget.animation:subscribe(function (l)
      local color = Color({
        h = h,
        s = s,
        l = l,
        a = a
      }):tostring()
      widget.bg = color
    end)

  widget:connect_signal('mouse::enter', function ()
    widget.animation:set(hover_l)
  end)

  widget:connect_signal('mouse::leave', function ()
    widget.animation:set(widget.animation:initial())
  end)

  return widget
end

return button
