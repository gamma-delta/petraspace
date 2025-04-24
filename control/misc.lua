local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")

-- Geo generators

local geothermal = putil.on_any_built(function(evt)
  local entity = evt.entity
  if entity.name ~= "geothermal-heat-exchanger" then return end
  -- per second
  local power_generated = 100 * 1000 * 1000
  local specific_heat = entity.prototype.heat_buffer_prototype.specific_heat
  local degrees_per_second = power_generated / specific_heat

  entity.set_heat_setting{
    temperature = degrees_per_second / 60,
    mode = "add"
  }
end)

return {
  events = geothermal
}
