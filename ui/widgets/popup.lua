local awful = require('awful')
local gtimer = require('gears.timer')
local gtable = require('gears.table')

local popup = {}

function popup:hide()
  self.visible = false
end

function popup:show()
  if self.visible then
    return
  end

  self.can_hide = false

  gtimer({
    timeout = .1,
    autostart = true,
    call_now = false,
    single_shot = true,
    callback = function ()
      self.can_hide = true
    end
  })

  self.visible = true
end

function popup:toggle()
  if self.visible then
    self:hide()
  else
    self:show()
  end
end

local function new(args)
  local widget = awful.popup(gtable.crush({
    placement = awful.placement.next_to_mouse
  }, args, true))

  gtable.crush(widget, popup, true)

  local function binding()
    if widget.can_hide then
      widget:hide()
    end
  end

  awful.mouse.append_client_mousebinding(awful.button({ "Any" }, 1, binding))

  awful.mouse.append_client_mousebinding(awful.button({ "Any" }, 3, binding))

  awful.mouse.append_global_mousebinding(awful.button({ "Any" }, 1, binding))

  awful.mouse.append_global_mousebinding(awful.button({ "Any" }, 3, binding))

  tag.connect_signal("property::selected", function ()
    widget:hide()
  end)

  return widget
end

return new
