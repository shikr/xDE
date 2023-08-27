local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi

local modkey = 'Mod4'
-- TODO: Update colors
local function update_tag(indicator, c3)
  if c3.selected then
    indicator.bg = beautiful.accent
    indicator.forced_width = dpi(24)
  elseif #c3:clients() == 0 then
    indicator.bg = '#000000'
    indicator.forced_width = dpi(8)
  else
    indicator.bg = beautiful.accent
    indicator.forced_width = dpi(16)
  end
end

return function (s)
  local taglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    layout = {
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      widget = wibox.container.margin,
      forced_width = dpi(25),
      forced_height = dpi(25),
      create_callback = function (self, c3)
        local indicator = wibox.widget {
          widget = wibox.container.place,
          valign = "center",
          {
            widget = wibox.container.background,
            forced_height = dpi(8),
            shape = gears.shape.rounded_bar,
          }
        }

        self:set_widget(indicator)

        update_tag(self.widget.children[1], c3)
      end,
      update_callback = function (self, c3)
        update_tag(self.widget.children[1], c3)
      end
    },
    buttons = {
      awful.button({ }, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
      end),
      awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
    }
  }

  return wibox.widget {
    taglist,
    halign = 'center',
    widget = wibox.container.place
  }
end
