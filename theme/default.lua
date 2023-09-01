local gfs = require('gears.filesystem')
local helpers = require('helpers')
local themes_dir = gfs.get_themes_dir()
local theme = dofile(themes_dir .. 'default/theme.lua')
local theme_assets = require('beautiful.theme_assets')
local config_dir = gfs.get_configuration_dir()
local gcolor = require('gears.color')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local colors = require('theme.dark')


colors(theme)

theme.font_name = 'Sans '
theme.font = theme.font_name .. dpi(8)

theme.border_width = 0
theme.border_radius = dpi(10)

theme.menu_submenu_icon = gcolor.recolor_image(config_dir .. 'theme/assets/submenu.svg', theme.fg_normal)
theme.awesome_icon = gcolor.recolor_image(config_dir .. 'theme/assets/awesome.svg', theme.fg_normal)

theme.tooltip_border_width = dpi(1)
theme.tooltip_shape = helpers.ui.rrect(dpi(4))
-- theme.tooltip_opacity = 0.95 -- defined in picom

theme.button_shape = helpers.ui.rrect(dpi(4))

theme.wibar_height = dpi(30)

theme.icon_theme = nil

return theme
