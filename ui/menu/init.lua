local awful = require('awful')
local beautiful = require("beautiful")
local apps = require('config.apps')
local format_cmd = require('helpers.run').format_cmd
local hotkeys_popup = require("awful.hotkeys_popup")

local awesome_menu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", format_cmd('man', 'awesome') },
  { "edit config", format_cmd(apps.editor, awesome.conffile) },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

return awful.menu {
  items = {
    { "awesome", awesome_menu, beautiful.awesome_icon },
    { "open terminal", apps.terminal },
  },
}
