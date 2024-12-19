local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
local Table = require("__stdlib2__/stdlib/utils/table")

local putil = require("__petraspace__/control/utils")

putil.setup_on_type_by_tick("induction-coil", 1, function(coil)
  local working = coil.status == defines.entity_status.working
  
  local fluidboxes = coil.fluidbox
  -- Figure out which fluid box actually holds the fricking plasma
  -- because boilers HAVE to have a second fluid box gwah
  -- also they can?? be null??
  if not fluidboxes then return end
  
  for i=1,#fluidboxes do
    -- apparently???? these can also???? be null?????
    local fluid = fluidboxes[i]

    if fluid and fluid.name == "particle-stream" then
      -- fiddle with temp
      local delta = working and 100 or -200
      fluid.temperature = fluid.temperature + delta
      fluidboxes[i] = fluid
      break
    end
  end
end)
