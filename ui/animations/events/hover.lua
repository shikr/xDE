local subscribable = require('helpers.table').subscribable

local function event(widget)
  widget.hover = {
    on = subscribable(),
    off = subscribable()
  }

  widget:connect_signal('mouse::enter', function ()
    widget.hover.on:fire()
  end)

  widget:connect_signal('mouse::leave', function ()
    widget.hover.off:fire()
  end)

  return widget
end

return event
