local awful = require('awful')
local button = require('ui.bar.button')

return function (s)
  return button(
    awful.widget.layoutbox {
      screen  = s,
      buttons = {
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc(-1) end),
        awful.button({ }, 5, function () awful.layout.inc( 1) end),
      }
    }
  )
end
