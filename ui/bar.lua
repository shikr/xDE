local awful = require('awful')
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require('config.apps')
local beautiful = require("beautiful")
local wibox = require('wibox')

local format_cmd = function (...)
  local str = ''
  for i, value in ipairs({...}) do
    if i == 1 then
      str = value
    else
      str = str .. ' ' .. value
    end
  end
  return apps.terminal .. ' "' .. str .. '"'
end

local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", format_cmd('man', 'awesome') },
   { "edit config", format_cmd(apps.editor, awesome.conffile) },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu {
  items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", apps.terminal },
  },
}

local mylauncher = awful.widget.launcher {
  image = beautiful.awesome_icon,
  menu = mymainmenu,
}

local mykeyboardlayout = awful.widget.keyboardlayout()

local mytextclock = wibox.widget.textclock()

screen.connect_signal('request::desktop_decoration', function (s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  s.mypromptbox = awful.widget.prompt()

  s.mylayoutbox = awful.widget.layoutbox {
    screen  = s,
    buttons = {
      awful.button({ }, 1, function () awful.layout.inc( 1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end),
      awful.button({ }, 4, function () awful.layout.inc(-1) end),
      awful.button({ }, 5, function () awful.layout.inc( 1) end),
    }
  }
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
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

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = {
      awful.button({ }, 1, function (c)
        c:activate { context = "tasklist", action = "toggle_minimization" }
      end),
      awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
      awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
      awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
    }
  }

  -- Create the wibox
  s.mywibox = awful.wibar {
    position = "top",
    screen   = s,
    widget   = {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        mykeyboardlayout,
        wibox.widget.systray(),
        mytextclock,
        s.mylayoutbox,
      },
    }
  }
end)

-- TODO: move to keys.lua
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
