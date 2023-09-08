local _math = {}

function _math.clip(num, min_num, max_num)
  return math.max(math.min(num, max_num), min_num)
end

function _math.percent(percentage)
  local negative = percentage < 0
  percentage = math.abs(percentage)
  if percentage > 1 then
    percentage = percentage * .01
  end
  return negative and -percentage or percentage
end

return _math
