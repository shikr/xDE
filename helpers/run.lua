local apps = require('config.apps')

local _run = {}

function _run.format_cmd(...)
  local str = ''
  for i, value in ipairs({...}) do
    if i == 1 then
      str = value
    else
      str = str .. ' ' .. value
    end
  end
  return apps.terminal .. ' ' .. str
end

return _run
