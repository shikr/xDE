local Color = require('modules.lua-color')
local clip = require('helpers.math').clip

local _color = {}

function _color.lighten(color, amount)
  local h, s, l = Color(color):hsl()

  return tostring(Color {
    h = h,
    s = s,
    l = clip(l + amount, 0, 1)
  })
end

function _color.darken(color, amount)
  local h, s, l = Color(color):hsl()
  return tostring(Color {
    h = h,
    s = s,
    l = clip(l - amount, 0, 1)
  })
end

function _color.change_opacity(color, opacity)
  local r, g, b = Color(color):rgba()

  return tostring(
    Color {
      r = r,
      g = g,
      b = b,
      a = clip(opacity, 0, 1)
    }
  )
end

return _color
