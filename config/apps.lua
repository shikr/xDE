local menubar = require('menubar')

local default_applications = {
  terminal = 'kitty',
  editor = os.getenv('EDITOR') or 'vim'
}

menubar.utils.terminal = default_applications.terminal

return default_applications
