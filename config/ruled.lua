local ruled = require("ruled")
local awful = require('awful')
local gears = require('gears')
local naughty = require 'naughty'

local last_text = ''
local notify = function (text)
  if text == nil or last_text == text then
    return
  end
  naughty.notify{text = text}
  last_text = text
end

local function mouse_on_border(c, coords)
  local geometry = c:geometry()
  local cx, cy, cw, ch = geometry.x, geometry.y, geometry.width, geometry.height
  local mx, my = coords.x, coords.y
  local onborder = nil
  if mx < cx or mx > (cx + cw + 1) or my < cy or my > (cy + ch + 1) then
    return
  elseif my > (cy + ch - 6) then
    if mx < (cx + 30) then
      onborder = "bottom_left"
    elseif mx > (cx + cw - 30) then
      onborder = "bottom_right"
    else onborder = "bottom"
    end
  elseif my < (cy + 6) then
    if mx < (cx + 30) then
      onborder = "top_left"
    elseif mx > (cx + cw - 30) then
      onborder = "top_right"
    else onborder = "top"
    end
  elseif mx < (cx + 4) then onborder = "left"
  elseif mx > (cx + cw - 4) then onborder = "right"
  end
  return onborder
end

ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id         = "global",
    rule       = { },
    properties = {
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
    },
    callback = function (c)
      c:connect_signal('mouse::move', function ()
        local position, cursor = mouse_on_border(c, mouse.coords())
        if position ~= nil then
          c.border_width = 2
        else
          c.border_width = 1
        end
        -- notify(position)
      end)
      c:connect_signal('mouse::leave', function ()
        c.border_width = 1
      end)
      c:buttons(gears.table.join(
        awful.button({}, 1, function ()
          c:emit_signal("request::activate", "mouse_click", {raise = true})
          local pos = mouse_on_border(c, mouse.coords())
          if pos ~= nil then
            awful.mouse.client.resize(c, pos)
          end
        end)
      ))
    end
  }

  -- Floating clients.
  ruled.client.append_rule {
    id       = "floating",
    rule_any = {
      instance = { "copyq", "pinentry" },
      class    = {
        "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
        "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name    = {
        "Event Tester",  -- xev.
      },
      role    = {
        "AlarmWindow",    -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  }

  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id         = "titlebars",
    rule_any   = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true      }
  }

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- ruled.client.append_rule {
  --     rule       = { class = "Firefox"     },
  --     properties = { screen = 1, tag = "2" }
  -- }
end)
