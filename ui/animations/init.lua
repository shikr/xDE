local subscribable = require('helpers.table').subscribable
local events = require(... .. '.events')
local animations = {
  color = require(... .. '.color'),
  size = require(... .. '.size')
}

--- @type metatable
local mt = {}

local function subscribe(start, finish, handler)
  start:subscribe(handler.start)
  finish:subscribe(handler.finish)
end

function mt.__call(_, animation, widget, args)
  widget.event_handlers = {}
  for name, func in pairs(events) do
    if animation[name] ~= nil then
      local start = subscribable()
      local finish = subscribable()
      local ani = animation[name]
      if type(ani) == 'string' then
        subscribe(start, finish, animations[ani](widget, args))
      elseif type(ani) == 'function' then
        subscribe(start, finish, ani(widget, args))
      else
        for _, value in ipairs(ani) do
          if type(value) == 'string' then
            subscribe(start, finish, animations[value](widget, args))
          else if type(value) == 'function' then
              subscribe(start, finish, value(widget, args))
            end
          end
        end
      end
      local handler = subscribable()
      handler:subscribe(function (method)
        if method == 'start' then
          start:fire()
        elseif method == 'finish' then
          finish:fire()
        end
      end)
      func(widget, handler)
      widget.event_handlers[name] = handler
    end
  end

  return widget
end

return setmetatable(animations, mt)
