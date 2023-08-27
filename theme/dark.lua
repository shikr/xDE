local gfs = require('gears.filesystem')
local helpers = require('helpers')
local themes_dir = gfs.get_themes_dir()

local function load_theme(theme)
  theme.accent = '#FFFFFF'

  theme.bg_color = '#101010'
  theme.bg_normal = theme.bg_color .. 'E6'
  theme.bg_focus = helpers.color.lighten(theme.bg_color, 0.25)
  theme.bg_urgent = '#fb9c36'
  theme.bg_minimize = helpers.color.lighten(theme.bg_color, 0.1)

  theme.fg_normal = '#FFFFFF'
  theme.fg_focus = themes_dir.fg_normal
  theme.fg_urgent = themes_dir.fg_normal
  theme.fg_minimize = themes_dir.fg_normal

  theme.border_color = helpers.color.darken(theme.accent, 0.75)

  theme.tooltip_bg = theme.bg_normal
  theme.tooltip_fg = theme.fg_normal
  theme.tooltip_border_color = theme.border_color
end

return load_theme
