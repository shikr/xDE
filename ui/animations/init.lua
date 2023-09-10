local animations = {
  color = require(... .. '.color'),
  size = require(... .. '.size')
}

--- @type metatable
local mt = {}

function mt.__call(_, animation, widget, args)
  if type(animation) == 'string' and animations[animation] ~= nil then
    return animations[animation](widget, args)
  end
  return animation(widget, args)
end

return setmetatable(animations, mt)
