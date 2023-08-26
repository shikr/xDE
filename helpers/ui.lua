local gears = require('gears')

local helpers = {}

function helpers.rrect(radius)
  return function (cr, width, heigth)
    gears.shape.rounded_rect(cr, width, heigth, radius)
  end
end

return helpers
