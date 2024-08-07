local button = require('ui.widgets.button')
local beautiful = require('beautiful')
local gtable = require('gears.table')
local animate = require('ui.animations').animate

return function (child, args)
  local widget = button(
    child,
    gtable.crush({
      bg = beautiful.bg_invisible,
    }, args or {})
  )
  local mwidget = widget:get_children_by_id('margin')[1]

  local color = animate(
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
  local scale = animate(
    widget,
    'click',
    'size',
    function (margin)
      widget:get_children_by_id('padding')[1].margins = margin
    end
  )

  mwidget.hover.on:subscribe(function ()
    color.on()
  end)
  widget.click.on:subscribe(function ()
    scale.scale(1)
  end)

  mwidget.hover.off:subscribe(function ()
    color.off()
  end)
  widget.click.off:subscribe(function ()
    scale.reset()
  end)

  return widget
end
