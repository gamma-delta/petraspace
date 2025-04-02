local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
-- extends lua's table, apparently?
local table = require('__stdlib2__/stdlib/utils/table')

local putil = require("__petraspace__/control/utils")

local special_dust_immune = {
  ["dust-secret-beacon"] = true,
}
local function is_dust_immune(entity)
  return
    special_dust_immune[entity.name]
    or entity.prototype.effect_receiver == nil
    or entity.prototype.module_inventory_size == 0
end

local function create_secret_beacon(evt)
  local entity = evt.entity
  local surface = entity.surface
  log(tostring(entity) .. " HI DUST")

  -- TODO: how to mark entity as immune to dust?
  -- ancillary keys don't get carried through to the runtime stage
  if surface.pollutant_type and surface.pollutant_type.name == "dust" 
    and not is_dust_immune(entity)
  then
    local secret_beacon = surface.create_entity{
      name = "dust-secret-beacon",
      position = entity.position,
      force = evt.force,
      raise_built = true,
    }
    game.print("Created beacon " .. tostring(secret_beacon) .. " parented to " .. tostring(entity))
    log("Created beacon " .. tostring(secret_beacon) .. " parented to " .. tostring(entity))
    Entity.set_data(secret_beacon, { parent=entity })
  end
end

putil.register_any_built(create_secret_beacon)

putil.setup_on_type_by_tick("dust-secret-beacon", 60 * 10, function(secret_beacon)
  local dat = Entity.get_data(secret_beacon)
  if dat.parent.valid then
    local pollution_to_slowdown_percent = 10
    local pollution_amt = secret_beacon.surface.get_pollution(secret_beacon.position)
    local module_count = math.floor(pollution_amt / pollution_to_slowdown_percent)
    local mi = secret_beacon.get_module_inventory()
    -- game.print("Putting " .. module_count .. " modules in " .. serpent.line(secret_beacon))
    mi.clear()
    if module_count > 0 then
      mi.insert({ name="dust-secret-module", count=module_count })
    end
  else
    -- game.print("Beacon " .. secret_beacon .. " was invalid, killing")
    secret_beacon.die()
  end
end)
