local button = require('ui.widgets.button')
local beautiful = require('beautiful')
local gtable = require('gears.table')
local animate = require('ui.animations').animate

return function (child, args)
  local widget = button(child, gtable.crush({
      bg = beautiful.bg_invisible,
    }, args or {})
  )
  local mwidget = widget:get_children_by_id('margin')[1]

  local animation = animate(
    mwidget,
    'hover',
    'color',
    function (color)
      widget:get_children_by_id('background')[1].bg = color
    end,
    {
      from = beautiful.bg_invisible,
      to = beautiful.bg_hover(beautiful.bg_normal)
    }
  )

  mwidget.hover.on:subscribe(function ()
    animation.on()
  end)

  mwidget.hover.off:subscribe(function ()
    animation.off()
  end)

  return widget
end
