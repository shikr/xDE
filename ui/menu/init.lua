local awful = require('awful')
local beautiful = require("beautiful")
local apps = require('config.apps')
local format_cmd = require('helpers.run').format_cmd
local hotkeys_popup = require("awful.hotkeys_popup")
local menu = require('ui.widgets.menu')

return menu {
  menu.button {
    text = 'awesome',
    image = beautiful.awesome_icon,
    submenu = menu {
      menu.button {
        text = 'hotkeys',
        callback = function ()
          hotkeys_popup.show_help(nil, awful.screen.focused())
        end
      },
      menu.button {
        text = 'manual',
        callback = format_cmd('man', 'awesome'),
      },
      menu.button {
        text = 'edit config',
        callback = format_cmd(apps.editor, awesome.conffile),
      },
      menu.button {
        text = 'restart',
        callback = awesome.restart,
      },
      menu.button {
        text = 'quit',
        callback = function ()
          awesome.quit()
        end,
      },
    },
  },
  menu.button {
    text = 'open terminal',
    callback = apps.terminal,
  },
}
