local awful = require("awful")
local button = require('ui.widgets.button.color')

return function ()
  return button(awful.widget.keyboardlayout())
end
