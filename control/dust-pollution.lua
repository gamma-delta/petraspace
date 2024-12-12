local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")

function create_secret_beacon(evt)
  local entity = evt.entity or evt.destination
  local surface = entity.surface

  if not storage.dust_beacons then
    storage.dust_beacons = {}
  end

  if surface.pollutant_type and surface.pollutant_type.name == "dust" 
      and entity.prototype.effect_receiver ~= nil
  then
    local secret_beacon = surface.create_entity{
      name = "dust-secret-beacon",
      position = entity.position,
      force = evt.force,
    }
    storage.dust_beacons[secret_beacon] = true
    Entity.set_data(secret_beacon, { parent=entity })
  end
end

Event.register(defines.events.on_built_entity, create_secret_beacon)
Event.register(defines.events.on_robot_built_entity, create_secret_beacon)
Event.register(defines.events.on_entity_cloned, create_secret_beacon)

Event.on_nth_tick(60 * 10, function()
  local queue_kill = {}
  local queue_rm = {}
  for secret_beacon,_ in pairs(storage.dust_beacons) do
    -- game.print(secret_beacon)
    if not secret_beacon.valid then
      table.insert(queue_rm, secret_beacon)
    elseif not Entity.get_data(secret_beacon).parent.valid then
      table.insert(queue_kill, secret_beacon)
    else
      local pollution_to_slowdown_percent = 10
      local pollution_amt = secret_beacon.surface.get_pollution(secret_beacon.position)
      local module_count = math.floor(pollution_amt / pollution_to_slowdown_percent)
      local mi = secret_beacon.get_module_inventory()
      -- game.print("Putting " .. module_count .. " modules in " .. serpent.line(secret_beacon))
      mi.clear()
      if module_count > 0 then
        mi.insert({ name="dust-secret-module", count=module_count })
      end
    end
  end

  for _,killme in ipairs(queue_kill) do
    table.insert(queue_rm, killme)
    killme.die()
  end
  for _,rmme in ipairs(queue_rm) do
    storage.dust_beacons[rmme] = nil
  end
end)
