local wibox = require('wibox')

local function new(child, args)
  args = args or {}

  local widget = wibox.widget {
    widget = wibox.container.rotate,
    direction = args.direction,
    {
      widget = wibox.container.margin,
      margins = args.margins,
      id = 'margin',
      {
        widget = wibox.container.background,
        forced_height = args.forced_height,
        forced_width = args.forced_width,
        shape = args.shape,
        bg = args.bg,
        border_width = args.border_width,
        border_color = args.border_color,
        id = 'background',
        {
          widget = wibox.container.margin,
          margins = args.paddings,
          id = 'padding',
          child
        }
      }
    }
  }

  return widget
end

return new
