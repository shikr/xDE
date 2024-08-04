local events = require(... .. '.events')
local animations = {
  color = require(... .. '.color'),
  size = require(... .. '.size')
}

local function animate(widget, event, animation, fn, args)
  if events[event] ~= nil and animations[animation] ~= nil then
    if widget[event] == nil then
      events[event](widget)
    end

    return animations[animation](fn, args)
  end
end

return {
  animations = animations,
  events = events,
  animate = animate
}
