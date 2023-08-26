local _math = {}

function _math.clip(num, min_num, max_num)
  return math.max(math.min(num, max_num), min_num)
end

return _math
