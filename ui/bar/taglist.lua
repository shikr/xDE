local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi
local rubato = require('modules.rubato')

local modkey = 'Mod4'
local function update_tag(indicator, c3, animation)
  if c3.selected then
    indicator.bg = beautiful.accent
    animation:set(dpi(24))
    -- indicator.forced_width = dpi(24)
  elseif #c3:clients() == 0 then
    indicator.bg = beautiful.bg_item
    animation:set(dpi(8))
    -- indicator.forced_width = dpi(8)
  else
    indicator.bg = beautiful.accent
    animation:set(dpi(16))
    -- indicator.forced_width = dpi(16)
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

        self.animation = rubato.timed {
          duration = 0.2,
          pos = dpi(8),
          awestore_compat = true,
          clamp_position = true,
          -- subscribed = function (pos)
          -- require('naughty').notify {text = tostring(pos)}
          --   indicator.forced_width = pos
          -- end
        }

        self.animation:subscribe(function (pos)
          indicator.children[1].forced_width = pos
        end)

        self:set_widget(indicator)

        update_tag(self.widget.children[1], c3, self.animation)
      end,
      update_callback = function (self, c3)
        update_tag(self.widget.children[1], c3, self.animation)
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
    {
      {
        taglist,
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
      },
      bg = beautiful.bg_color(beautiful.background_alt),
      shape = gears.shape.rounded_bar,
      widget = wibox.container.background
    },
    halign = 'center',
    widget = wibox.container.place
  }
end
