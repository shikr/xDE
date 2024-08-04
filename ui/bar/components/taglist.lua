local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi
local rubato = require('modules.rubato')
local animate = require('ui.animations').animations.size

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

        self.animation = animate(
          function (width)
            indicator.children[1].forced_width = width
          end,
          {
            duration = 0.2,
            initial = tag_sizes.empty
          }
        )

        self:set_widget(indicator)

        indicator:connect_signal('mouse::enter', function ()
          if not c3.selected  then
            self.animation.update(tag_sizes.selected)
            if #c3:clients() == 0 then
              indicator.children[1].bg = beautiful.bg_hover(beautiful.bg_item, 0.15)
            end
          end
        end)

        indicator:connect_signal('mouse::leave', function ()
          if not c3.selected then
            local bg, width = update_tag(c3)
            self.animation.update(width)
            indicator.children[1].bg = bg
          end
        end)

        local bg, width = update_tag(c3)

        indicator.children[1].bg = bg
        self.animation.update(width)
      end,
      update_callback = function (self, c3)
        local bg, width = update_tag(c3)
        self.widget.children[1].bg = bg
        self.animation.update(width)
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
