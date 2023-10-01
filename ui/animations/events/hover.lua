local function event(widget, events)
  local mwidget = widget:get_children_by_id('margin')[1]
  local w = mwidget ~= nil and mwidget.children[1] or widget

  w:connect_signal('mouse::enter', function ()
    events:fire('start')
  end)

  w:connect_signal('mouse::leave', function ()
    events:fire('finish')
  end)

  return widget
end

return event
