local Color = require('modules.lua-color')
local clip = require('helpers.math').clip

local _color = {}

function _color.lighten(color, amount)
  local h, s, l, a = Color(color):hsla()

  return tostring(Color {
    h = h,
    s = s,
    l = clip(l + amount, 0, 1),
    a = a
  })
end

function _color.darken(color, amount)
  local h, s, l, a = Color(color):hsla()
  return tostring(Color {
    h = h,
    s = s,
    l = clip(l - amount, 0, 1),
    a = a
  })
end

function _color.is_dark(color)
  local _, _, l = Color(color):hsla()
  return l <= 0.2
end

function _color.darken_or_lighten(color, amount)
  if _color.is_dark(color) then
    return _color.lighten(color, amount)
  else
    return _color.darken(color, amount)
  end
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
