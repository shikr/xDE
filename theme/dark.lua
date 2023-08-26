local gfs = require('gears.filesystem')
local gcolor = require('gears.color')
local helpers = require('helpers')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local themes_dir = gfs.get_themes_dir()
local theme = dofile(themes_dir .. 'default/theme.lua')
local config_dir = gfs.get_configuration_dir()

theme.font_name = 'Sans '
theme.font = theme.font_name .. dpi(8)

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

theme.border_width = 0
theme.border_color = helpers.color.darken(theme.accent, 0.75)
theme.border_radius = dpi(10)

theme.menu_submenu_icon = gcolor.recolor_image(config_dir .. 'theme/assets/submenu.svg', theme.fg_normal)

theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal
theme.tooltip_border_width = dpi(1)
theme.tooltip_border_color = theme.border_color
theme.tooltip_shape = helpers.ui.rrect(dpi(4))
-- theme.tooltip_opacity = 0.95 -- defined in picom

theme.icon_theme = nil

return theme
