local subscribable = require('helpers.table').subscribable

local function event(widget)
  widget.click = {
    on = subscribable(),
    off = subscribable()
  }

  widget:connect_signal('button::press', function (_, _, _, b)
    widget.button = b
    widget.click.on:fire()
  end)

  widget:connect_signal('button::release', function ()
    widget.button = nil
    widget.click.off:fire()
  end)

  widget:connect_signal('mouse::leave', function (_, find_widgets_result)
    if widget.button ~= nil then
      widget:emit_signal('button::release', 1, 1, widget.button, {}, find_widgets_result)
    end
  end)

  return widget
end

return event
