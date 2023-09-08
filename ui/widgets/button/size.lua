local wibox = require('wibox')
local beautiful = require('beautiful')
local rubato = require('modules.rubato')
local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers.math')

local function button(child, args)
  args = args or {}
  local margins = args.margins ~= nil and args.margins or dpi(3)
  local reduce = (args.reduce ~= nil and helpers.percent(args.reduce) or .7) * margins + margins

  local widget = wibox.widget {
    widget = wibox.container.margin,
    margins = margins,
    child
  }

  widget.animation = rubato.timed {
    duration = 0.2,
    intro = 0,
    pos = margins,
    awestore_compat = true,
    clamp_position = true,
  }

  widget.animation:subscribe(function (m)
    widget.margins = m
  end)

  widget:connect_signal('button::press', function (_, _, _, b)
    widget.button = b
    widget.animation:set(reduce)
  end)

  widget:connect_signal('button::release', function ()
    widget.button = nil
    widget.animation:set(margins)
  end)

  widget:connect_signal('mouse::leave', function (_, find_widgets_result)
    if widget.button ~= nil then
      widget:emit_signal('button::release', 1, 1, widget.button, {}, find_widgets_result)
    end
  end)

  return widget
end

return button
