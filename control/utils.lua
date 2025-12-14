local utils = {}

---@return table
utils.storage_table = function(key)
  if not storage[key] then
    storage[key] = {}
  end
  return storage[key]
end

-- Return a table associated with the entity for extra data.
-- This stores it by unit number! So be careful when iterating
utils.extra = function(entity)
  local entity_key
  if type(entity) == "number" then
    entity_key = entity
  else
    entity_key = entity.unit_number
    if entity_key == nil then
      error("Entity " .. tostring(entity) .. " did not have a unit number!"
        .. " Remember to give it a unit number in prototypes")
    end
  end

  if not storage.extras then storage.extras = {} end
  if not storage.extras[entity_key] then storage.extras[entity_key] = {} end
  return storage.extras[entity_key]
end

utils.smash_events = function(events_lists)
  local evt_to_handlers = {}
  for _,event_pack in ipairs(events_lists) do
    for event,handler in pairs(event_pack) do
      if not evt_to_handlers[event] then evt_to_handlers[event] = {} end
      table.insert(evt_to_handlers[event], handler)
    end
  end
  local out = {}
  for evt,handlers in pairs(evt_to_handlers) do
    out[evt] = function(evt_object)
      for _,handler in ipairs(handlers) do
        handler(evt_object)
      end
    end
  end
  return out
end

-- Return a table that you can splice into a vanilla event handler "veh"
utils.on_any_built = function(callback)
  local cb2 = function(evt)
    evt["entity"] = evt.entity or evt.destination
    callback(evt)
  end
  return {
    [defines.events.on_built_entity] = cb2,
    [defines.events.on_robot_built_entity] = cb2,
    [defines.events.on_entity_cloned] = cb2,
    [defines.events.on_space_platform_built_entity] = cb2,
    [defines.events.script_raised_built] = cb2,
    [defines.events.script_raised_revive] = cb2,
  }
end
utils.on_any_removed = function(callback)
  return {
    [defines.events.on_entity_died] = callback,
    [defines.events.on_player_mined_entity] = callback,
    [defines.events.on_robot_mined_entity] = callback,
    [defines.events.on_space_platform_mined_entity] = callback,
    [defines.events.script_raised_destroy] = callback,
  }
end

return utils
