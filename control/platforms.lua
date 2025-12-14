local util = require "__core__/lualib/util"
local putil = require("__pk-the-first-frontier__/control/utils")

---@param evt EventData.on_script_trigger_effect
local fill_up_rocket_juice = function(evt)
  if evt.effect_id ~= "pktff-rocket-juice-tank" then return end
  ---@type LuaEntity
  local entity = evt.source_entity
  local juice_name
  if entity.name == "pktff-platform-fuel-tank" then
    juice_name = "thruster-fuel"
  elseif entity.name == "platform-oxidizer-tank" then
    juice_name = "pktff-thruster-oxidizer"
  end
  if not juice_name then return end

  entity.insert_fluid{
    name = juice_name,
    amount = entity.fluidbox.get_capacity(1)
  }
end

local damage_thrusters_interval = 60 * 10
---@param platform LuaSpacePlatform
local function damage_thrusters(platform)
  -- this is in km/hr, not km/s as the wiki claims
  local speed = math.abs(platform.speed) * 60
  if speed <= 10 or platform.distance == nil then return end

  local checks_per_minute = 60 * 60 / damage_thrusters_interval
  local cfg = settings.global["pktff-speed-to-thruster-damage-per-minute"].value
  local dmg = speed * cfg / checks_per_minute
  for _,thruster in ipairs(platform.surface.find_entities_filtered{name="thruster"}) do
    if thruster.status == defines.entity_status.working then
      thruster.damage(dmg, "enemy")
    end
  end
end

---@param evt NthTickEventData
local function damage_thrusters_everywhere(evt)
  for _,force in pairs(game.forces) do
    for _,platform in pairs(force.platforms) do
      damage_thrusters(platform)
    end
  end
end

return {
  events = {
    [defines.events.on_script_trigger_effect] = fill_up_rocket_juice,
  },
  on_nth_tick = {[damage_thrusters_interval] = damage_thrusters_everywhere}
}
