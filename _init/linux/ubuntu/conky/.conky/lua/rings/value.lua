local function eval(expr)
  local value = string.format('${%s}', expr)
  value = conky_parse(value)
  value = tonumber(value)
  return value;
end

return {
  eval = eval
}
