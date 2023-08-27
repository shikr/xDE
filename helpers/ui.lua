local gears = require('gears')

local helpers = {}

function helpers.rrect(radius)
  return function (cr, width, heigth)
    gears.shape.rounded_rect(cr, width, heigth, radius)
  end
end

---Update the cursor of a widget with hover.
---@param widget table
---@param cursor string hand2
function helpers.add_hover_cursor(widget, cursor)
  local old_cursor, old_widget

  widget:connect_signal('mouse::enter', function ()
    local w = mouse.current_wibox
    if w then
      old_cursor, old_widget = w.cursor, w
      w.cursor = cursor
    end
  end)

  widget:connect_signal('mouse::leave', function ()
    if old_widget then
      old_widget.cursor = old_cursor
      old_widget = nil
    end
  end)
end

return helpers
