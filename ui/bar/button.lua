local button = require('ui.widgets.button')
local beautiful = require('beautiful')
local gtable = require('gears.table')

return function (child, args)
  return button(
    child,
    gtable.crush({
      bg = beautiful.bg_invisible,
      bg_hover = beautiful.bg_hover(beautiful.bg_normal)
    }, args or {})
  )
end
