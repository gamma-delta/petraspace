local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
-- extends lua's table, apparently?
local table = require('__stdlib2__/stdlib/utils/table')

local putil = require("__petraspace__/control/utils")

local planet_moon_map = {
  nauvis = "viate",
  viate = "nauvis",
}

Event.register(defines.events.on_cargo_pod_finished_ascending, function(evt)
  local pod = evt.cargo_pod
  if pod.name == "lunar-cargo-pod" then
    local origin_surface_name = 
      pod.cargo_pod_origin
      and pod.cargo_pod_origin.surface
      and pod.cargo_pod_origin.surface.name
    local moony_dest = planet_moon_map[origin_surface_name]
    game.print("Found cargo pod " .. tostring(pod) .. ", sending to " .. tostring(moony_dest))
    if moony_dest then
      pod.cargo_pod_destination = {
        type = defines.cargo_destination.surface,
        surface = moony_dest
      }
    end
  end
end)
