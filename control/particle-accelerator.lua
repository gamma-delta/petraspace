local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
local Table = require("__stdlib2__/stdlib/utils/table")

local putil = require("__petraspace__/control/utils")

local function all_particles_hooked_up(fluid_box)
  for i=1,#fluid_box do
    local fluid = fluid_box[i]
    -- apparently???? these can also???? be null?????
    if fluid then
      -- Check that it's particle stream
      local filter = fluid_box.get_filter(i)
      if filter and filter.name == "particle-stream" then
        local connections = fluid_box.get_connections(i)
        local pipes = fluid_box.get_pipe_connections(i)
        -- game.print("connections: " .. serpent.line(connections))
        -- game.print("pipes: " .. serpent.line(pipes))
        -- Every pipe needs to be connected
        if #connections ~= #pipes then
          return false
        end
      end
    end
  end
  return true
end

putil.setup_on_type_by_tick("induction-coil", 1, function(coil)
  local ok = all_particles_hooked_up(coil.fluidbox)
  coil.custom_status = (not ok)
    and {
      label = {"text.particle-stream-unconnected"},
      diode = defines.entity_status_diode.red
    } or nil
  -- for some reason disabled_by_script doesn't work
  coil.active = ok
end)
