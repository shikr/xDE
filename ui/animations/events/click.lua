local function event(widget, events)
  widget:connect_signal('button::press', function (_, _, _, b)
    widget.button = b
    events:fire('start')
  end)

  widget:connect_signal('button::release', function ()
    widget.button = nil
    events:fire('finish')
  end)

  widget:connect_signal('mouse::leave', function (_, find_widgets_result)
    if widget.button ~= nil then
      widget:emit_signal('button::release', 1, 1, widget.button, {}, find_widgets_result)
    end
  end)

  return widget
end

return event
