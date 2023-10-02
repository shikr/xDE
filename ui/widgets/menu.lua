local awful = require('awful')
local wibox = require('wibox')
local gtable = require('gears.table')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local popup = require('ui.widgets.popup')
local animate = require('ui.animations')
local container = require('ui.widgets.container')

local menu = {}
--- @type metatable
local mt = {}

function menu:hide_parents()
  if self.parent_menu ~= nil then
    self.parent_menu:hide(true)
  end
end

function menu:hide_children()
  for _, button in ipairs(self.widget.children) do
    if button.submenu ~= nil then
      button.submenu:hide()
    end
  end
end

function menu:hide(parent)
  self:_hide()

  self:hide_children()

  if parent then
    self:hide_parents()
  end
end

local function place_child(widget, geo)
  local workarea = awful.screen.focused().workarea
  local screen_w = workarea.x + workarea.width
  local screen_h = workarea.y + workarea.height
  local xwidget = geo.x + geo.width
  local ywidget = geo.y + geo.height

  if xwidget + widget.width > screen_w then
    widget.x = geo.x - widget.width
  else
    widget.x = xwidget
  end

  if geo.y + widget.height > screen_h then
    widget.y = ywidget - widget.height
  else
    widget.y = geo.y
  end
end

function menu:show()
  if self.parent_menu ~= nil then
    -- FIX: get all separators of parent_menu, currently returns an empty table
    local separators = self.parent_menu.widget:get_children_by_id('separator')
    local children = self.parent_menu.widget.children
    local sep = 1
    local sep_h = 0
    local selected
    for i, button in ipairs(children) do
      -- obtain the position of separators and plus the height
      require('naughty').notify {text = tostring(#separators)}
      if sep <= #separators then
        local w = separators[sep]
        local wsep = w.children[1]
        local h = w.top + wsep.forced_height + w.bottom
        if children[i] == w then
          sep = sep + 1
          sep_h = sep_h + h
        end
      end

      if button.submenu ~= nil  then
        if button.submenu ~= self then
          button.submenu:hide()
        else
          selected = {
            index = i,
            sep_height = sep_h
          }
        end
      end
    end
    if selected ~= nil then
      local geo = self.parent_menu:geometry()
      local height = geo.height - sep_h
      local wheight = height / (#self.parent_menu.widget.children - #separators)
      place_child(self, {
        x = geo.x,
        y = geo.y + wheight * (selected.index - 1) + selected.sep_height,
        width = geo.width,
        height = wheight,
      })
    end
  else
    local coords = mouse.coords()
    awful.placement.next_to(self, {
      preferred_positions = 'right',
      preferred_anchors = 'front',
      geometry = {
        x = coords.x,
        y = coords.y,
        width = 0,
        height = 0,
      }
    })
  end

  self:_show()
end

function menu:toggle()
  if self.visible then
    self:hide()
  else
    self:show()
  end
end

function menu:add(widget)
  if widget.submenu ~= nil then
    widget.submenu.parent_menu = self
  end
  widget.menu = self
  self.widget:add(widget)
end

function menu:remove(widget)
  self.widget:remove(widget)
end

function menu:reset()
  self.widget:reset()
end

function menu.menu(widgets)
  local widget = popup {
    type = 'menu',
    visible = false,
    ontop = true,
    shape = beautiful.menu_shape,
    widget = {
      widget = wibox.layout.fixed.vertical,
    },
  }

  rawset(widget, '_hide', widget.hide)
  rawset(widget, '_show', widget.show)

  gtable.crush(widget, menu, true)

  for _, item in ipairs(widgets) do
    widget:add(item)
  end

  return widget
end

local function onhover(args)
  return function (widget)
    return {
      start = function ()
        if args.submenu ~= nil then
          args.submenu:show()
        else
          widget.menu:hide_children()
        end
      end,
      finish = function () end
    }
  end
end

function menu.button(args)
  local fill_widget = wibox.widget {
    bg = beautiful.bg_invisible,
    forced_width = beautiful.font_size * 2,
    widget = wibox.container.background,
  }
  local icon, wsubmenu = fill_widget, fill_widget

  if args.image ~= nil then
    icon = wibox.widget {
      image = args.image,
      clip_shape = args.image_shape,
      forced_width = beautiful.font_size * 2,
      forced_height = beautiful.font_size * 2,
      resize = true,
      widget = wibox.widget.imagebox,
    }
  end
  if args.submenu ~= nil then
    wsubmenu = wibox.widget {
      image = beautiful.menu_submenu_icon,
      forced_width = beautiful.font_size * 2,
      forced_height = beautiful.font_size * 2,
      resize = true,
      widget = wibox.widget.imagebox,
    }
  end

  local widget = container(
    {
      layout = wibox.layout.align.horizontal,
      icon,
      {
        {
          text = args.text,
          widget = wibox.widget.textbox,
        },
        margins = {
          right = beautiful.font_size / 2,
          left = beautiful.font_size / 2,
        },
        widget = wibox.container.margin,
      },
      wsubmenu,
    },
    {
      margins = dpi(2),
      paddings = dpi(3),
      shape = beautiful.menu_shape,
    }
  )
  animate({ hover = { 'color', onhover(args) } }, widget, {
    bg = beautiful.bg_invisible,
    bg_hover = beautiful.bg_hover(beautiful.bg_normal),
  })

  widget:buttons(
    gtable.join(
      awful.button(
        {},
        1,
        nil,
        function ()
          if type(args.callback) == 'string' then
            awful.spawn(args.callback)
          elseif type(args.callback) == 'function' then
            args.callback()
          end
          widget.menu:hide(true)
        end
      )
    )
  )

  widget.submenu = args.submenu

  return widget
end

function menu.separator()
  return wibox.widget {
    {
      forced_height = dpi(2),
      bg = beautiful.bg_item,
      widget = wibox.container.background,
    },
    id = 'separator',
    margins = dpi(4),
    widget = wibox.container.margin,
  }
end

function mt.__call(_, ...)
  return menu.menu(...)
end

return setmetatable(menu, mt)
