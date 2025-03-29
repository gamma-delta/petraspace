local planet_moon_map = {
  nauvis = "viate",
  viate = "nauvis",
}

local function copy_then(tbl, ...)
  local Table = require("__stdlib2__/stdlib/utils/table")
  local table2 = Table.deep_copy(tbl)
  -- So PIL just lies to me and i have to use `...` and not `arg`
  -- also, i can't just ipairs over varargs due to ?????
  local varargs = table.pack(...)
  for _,splat in ipairs(varargs) do
    table2 = Table.merge(table2, splat)
  end
  return table2
end

-- Returns a function that makes a set, each key of the array mapped to default
local function set_with(default)
  return function(array)
    local out = {}
    for _,v in ipairs(array) do
      out[v] = default
    end
    return out
  end
end
local function set(array)
  return set_with(true)(array)
end

local function surface_prop(planet, prop_name)
  local default = data.raw["surface-property"].default_value
  
  local prop_value = data.raw["planet"].surface_properties[prop_name]
  return prop_value or default
end

return {
  planet_moon_map = planet_moon_map,
  copy_then = copy_then,
  set_with = set_with,
  set = set,
}
