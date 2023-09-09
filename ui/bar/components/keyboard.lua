local awful = require("awful")
local button = require('ui.bar.button')

return function ()
  return button(awful.widget.keyboardlayout())
end
