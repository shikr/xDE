local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local helpers = require('helpers')
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi
local rubato = require('modules.rubato')

local modkey = 'Mod4'

local tag_sizes = {
  selected = dpi(24),
  empty = dpi(8),
  busy = dpi(16),
}

local function update_tag(c3)
  local bg, width
  if c3.selected then
    bg = beautiful.accent
    width = tag_sizes.selected
  elseif #c3:clients() == 0 then
    bg = beautiful.bg_item
    width = tag_sizes.empty
  else
    bg = beautiful.accent
    width = tag_sizes.busy
  end

  return bg, width
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
            forced_height = tag_sizes.empty,
            shape = gears.shape.rounded_bar,
          }
        }

        self.animation = rubato.timed {
          duration = 0.2,
          pos = tag_sizes.empty,
          awestore_compat = true,
          clamp_position = true,
        }

        self.animation:subscribe(function (pos)
          indicator.children[1].forced_width = pos
        end)

        self:set_widget(indicator)

        indicator:connect_signal('mouse::enter', function ()
          self.animation:set(tag_sizes.selected)
          if not c3.selected and #c3:clients() == 0 then
            indicator.children[1].bg = helpers.color.lighten(beautiful.bg_item, 0.15)
          end
        end)

        indicator:connect_signal('mouse::leave', function ()
          local bg, width = update_tag(c3)
          self.animation:set(width)
          indicator.children[1].bg = bg
        end)

        local bg, width = update_tag(c3)

        indicator.children[1].bg = bg
        self.animation:set(width)
      end,
      update_callback = function (self, c3)
        local bg, width = update_tag(c3)
        self.widget.children[1].bg = bg
        self.animation:set(width)
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
