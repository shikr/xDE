local beautiful = require('beautiful')
local container = require('ui.widgets.container')
local dpi = require('beautiful.xresources').apply_dpi

local function button(child, args)
  args = args or {}
  args.paddings = args.paddings ~= nil and args.paddings or dpi(3)
  args.shape = args.shape ~= nil and args.shape or beautiful.button_shape
  local widget = container(child, args)

  return widget
end

return button
