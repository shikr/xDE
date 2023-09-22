local _helpers = {}

function _helpers.subscribable()
  local obj = {}

  obj._subscribed = {}

  function obj:subscribe(func)
    local id = tostring(func):gsub("function: ", "")

    self._subscribed[id] = func
  end

  function obj:unsubscribe(func)
    if func ~= nil then
      local id = tostring(func):gsub("function: ", "")

      self._subscribed[id] = nil
    else
      self._subscribed = {}
    end
  end

  function obj:fire(...)
    for _, func in pairs(self._subscribed) do
      func(...)
    end
  end

  return obj
end

return _helpers
