local rubato = require('modules.rubato')
local beautiful = require('beautiful')
local Color = require('modules.lua-color')

local function new(widget, args)
  args = args or {}
  local bg = args.bg ~= nil and args.bg or beautiful.bg_normal
  local bg_hover = args.bg_hover ~= nil and args.bg_hover or beautiful.bg_hover(bg)

  local color = Color(bg)
  local color_hover = Color(bg_hover)

  widget._color_animation = rubato.timed {
    duration = 0.2,
    awestore_compat = true,
    clamp_position = true,
    easing = rubato.easing.quadratic
  }

  widget._color_animation:subscribe(function (pos)
    local new_color = Color(color)
    widget:get_children_by_id('background')[1].bg = new_color:mix(color_hover, pos):tostring()
  end)

  return {
    start = function ()
      widget._color_animation:set(1)
    end,
    finish = function ()
      widget._color_animation:set(widget._color_animation:initial())
    end,
  }
end

return new
