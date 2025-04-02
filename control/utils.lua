local function register_any_built(callback)
  local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
  local cb2 = function(evt)
    evt["entity"] = evt.entity or evt.destination
    callback(evt)
  end
  Event.register(defines.events.on_built_entity, cb2)
  Event.register(defines.events.on_robot_built_entity, cb2)
  Event.register(defines.events.on_entity_cloned, cb2)
  Event.register(defines.events.on_space_platform_built_entity, cb2)
  Event.register(defines.events.script_raised_built, cb2)
end

local function setup_on_type_by_tick(entity_name, ticks, fn)
  -- Todo, do this spread across multiple ticks ig
  local Event = require("__stdlib2__/stdlib/event/event")

  local function register(evt)
    if not storage.on_type_by_tick[entity_name] then
    -- A set of all those entities
      storage.on_type_by_tick[entity_name] = {}
    end

    -- and now for the actual logic
    local entity = evt.entity or evt.destination
    if entity.name == entity_name then
      -- game.print("Registering " .. tostring(entity) .. " for tick evts")
      storage.on_type_by_tick[entity_name][entity] = true
    end
  end
  register_any_built(register)
  
  Event.on_nth_tick(ticks, function()
    -- i think storage doesn't exist properly until this point
    if not storage.on_type_by_tick then
      storage.on_type_by_tick = {}
    end
    if not storage.on_type_by_tick[entity_name] then
      -- No entities of this type have been placed
      return
    end
    local to_remove = {}
    for entity,_ in pairs(storage.on_type_by_tick[entity_name]) do
      if entity.valid then
        fn(entity)
      end
      -- in case the function kills the entity
      if not entity.valid then
        table.insert(to_remove, entity)
      end
    end

    for _,entity in ipairs(to_remove) do
      storage.on_type_by_tick[entity_name] = nil
    end
  end)
end

return {
  setup_on_type_by_tick = setup_on_type_by_tick,
  register_any_built = register_any_built,
}
