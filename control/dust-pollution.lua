local Event = require("__stdlib__/event/event").set_protected_mode(true)

function create_secret_beacon(evt)
  local entity = evt.entity or evt.destination
  local surface = evt.surface

  if surface.pollutant_type and surface.pollutant_type.name == "dust" 
      and entity.effect_reciever ~= nil
  then
    evt.surface.create_entity{
      name = "dust-secret-beacon",
      position = entity.position,
      force = evt.force,
    }
  end
end

Event.register(defines.events.on_built_entity, create_secret_beacon)
Event.register(defines.events.on_robot_built_entity, create_secret_beacon)
Event.register(defines.events.on_entity_cloned, create_secret_beacon)
Event.register(defines.events.script_raised_cloned, create_secret_beacon)
Event.register(defines.events.script_raised_built, create_secret_beacon)
