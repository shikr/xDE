local rubato = require('modules.rubato')
local helpers = require('helpers.math')
local dpi = require('beautiful.xresources').apply_dpi

local function size(widget, args)
  args = args or {}
  local paddings = args.paddings ~= nil and args.paddings or dpi(3)
  local reduce = (args.reduce ~= nil and helpers.percent(args.reduce) or 1) * paddings + paddings

  widget._size_animation = rubato.timed {
    duration = 0.1,
    intro = 0,
    pos = paddings,
    awestore_compat = true,
    clamp_position = true
  }

  widget._size_animation:subscribe(function (pos)
    widget:get_children_by_id('padding')[1].margins = pos
  end)

  return {
    start = function ()
      widget._size_animation:set(reduce)
    end,
    finish = function ()
      widget._size_animation:set(widget._size_animation:initial())
    end,
  }
end

return size
