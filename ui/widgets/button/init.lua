local wibox = require('wibox')
local color = require(... .. '.color')
local dpi = require('beautiful.xresources').apply_dpi

--- @type metatable
local meta = {}

-- default button
function meta.__call(_, child, args)
  args = args or {}
  local margins = args.margins ~= nil and args.margins or dpi(3)
  return color({
    widget = wibox.container.margin,
    margins = margins,
    child
  }, args)
end

return setmetatable({
  color = color,
  size = require(... .. '.size'),
}, meta)
