local rubato = require('modules.rubato')
local helpers = require('helpers.math')
local dpi = require('beautiful.xresources').apply_dpi

local function size(updatefn, args)
  args = args or {}
  local initial = args.initial ~= nil and args.initial or dpi(3)

  local animation = rubato.timed {
    duration = args.duration or 0.1,
    intro = 0,
    pos = initial,
    awestore_compat = true,
    clamp_position = true
  }

  animation:subscribe(updatefn)

  return {
    update = function (new_size)
      animation:set(new_size)
    end,
    scale = function (scale)
      local scaled_size = helpers.percent(scale) * initial + initial
      animation:set(scaled_size)
    end,
    reset = function ()
      animation:set(animation:initial())
    end,
  }
end

return size
