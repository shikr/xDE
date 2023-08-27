local awful = require('awful')
local beautiful = require("beautiful")
local main_menu = require('ui.menu')

return awful.widget.launcher {
  image = beautiful.awesome_icon,
  menu = main_menu,
}
