local rubato = require('modules.rubato')
local beautiful = require('beautiful')
local Color = require('modules.lua-color')

local function new(updatefn, args)
  args = args or {}
  local from = args.from ~= nil and args.from or beautiful.bg_normal
  local to = args.to ~= nil and args.to or beautiful.bg_hover(from)

  local color = Color(from)
  local tcolor = Color(to)

  local animation = rubato.timed {
    duration = args.duration or 0.2,
    awestore_compat = true,
    clamp_position = true,
    easing = rubato.easing.quadratic,
  }

  animation:subscribe(function (pos)
    local new_color = Color(color)
    updatefn(new_color:mix(tcolor, pos):tostring())
  end)

  return {
    on = function ()
      animation:set(1)
    end,
    off = function ()
      animation:set(0)
    end,
    toggle = function ()
      if animation:last() == 0 then
        animation:set(1)
      else
        animation:set(0)
      end
    end
  }
end

return new
