local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
-- extends lua's table, apparently?
local table = require('__stdlib2__/stdlib/utils/table')

local putil = require("__petraspace__/control/utils")
local pglobals = require("__petraspace__/globals")

putil.register_any_built(function(evt)
  if evt.entity.name ~= "lunar-rocket-silo" then return end

  local moony_dest = pglobals.planet_moon_map[evt.entity.surface.name]
  if not moony_dest or not evt.entity.force.is_space_location_unlocked(moony_dest) then
    -- https://github.com/danielmartin0/Space-Age-Hardcore-Mode/blob/main/Rocs-Hardcore-Space-Tweaks/data.lua
    -- This is a little janky

    -- This spams it to everyone in the force, a little annoying,
    -- but works for now. Who has friends anyways
    evt.entity.force.print({"text.lunar-rocket-fail-local-system"}, {color=warning_color})
    -- destroy it last so i can print to its user
    evt.entity.destroy()
  end
end)

Event.register(defines.events.on_cargo_pod_finished_ascending, function(evt)
  local pod = evt.cargo_pod
  if pod.name == "lunar-cargo-pod" then
    local origin_surface_name = 
      pod.cargo_pod_origin
      and pod.cargo_pod_origin.surface
      and pod.cargo_pod_origin.surface.name
    local moony_dest = pglobals.planet_moon_map[origin_surface_name]
    -- game.print("Found cargo pod " .. tostring(pod) .. ", sending to " .. tostring(moony_dest))
    if moony_dest then
      pod.cargo_pod_destination = {
        type = defines.cargo_destination.surface,
        surface = moony_dest
      }
    else
      -- Bruh
      pod.cargo_pod_destination = {
        type = defines.cargo_destination.surface,
        surface = origin_surface_name
      }
      game.print("How did you manage to launch a lunar rocket on [planet=" .. origin_surface_name .. "] which doesn't have a partner body??? Stop that. You're *lucky* I let you get your items back. Please open a bug report")
    end
  end
end)
