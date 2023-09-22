local function event(widget, events)
  local w = widget:get_children_by_id('margin')[1].children[1]

  w:connect_signal('mouse::enter', function ()
    events:fire('start')
  end)

  w:connect_signal('mouse::leave', function ()
    events:fire('finish')
  end)

  return widget
end

return event
