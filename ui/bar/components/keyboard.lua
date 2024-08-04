local awful = require("awful")
local label = require('ui.bar.label')

return function ()
  return label(awful.widget.keyboardlayout())
end
