local gfs = require('gears.filesystem')
local helpers = require('helpers')
local themes_dir = gfs.get_themes_dir()

local function load_theme(theme)
  theme.accent = '#FFFFFF'

  theme.background = '#101010'
  theme.background_alt = helpers.color.lighten(theme.background, 0.1)
  theme.background_alt2 = helpers.color.lighten(theme.background_alt, 0.1)

  function theme.bg_hover(color)
    return helpers.color.lighten(color, 0.05)
  end

  function theme.bg_color(color)
    return helpers.color.change_opacity(color, 0.8)
  end

  theme.bg_normal = theme.bg_color(theme.background)
  theme.bg_focus = theme.bg_color(theme.background_alt2)
  theme.bg_urgent = '#fb9c36'
  theme.bg_minimize = theme.bg_color(theme.background_alt)

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
