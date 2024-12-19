local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
local Table = require("__stdlib2__/stdlib/utils/table")

local putil = require("__petraspace__/control/utils")

putil.setup_on_type_by_tick("induction-coil", 1, function(coil)
  local fluidboxes = coil.fluidbox
  -- Figure out which fluid box actually holds the fricking plasma
  -- because boilers HAVE to have a second fluid box gwah
  -- also they can?? be null??
  if not fluidboxes then return end
  for i=1,#fluidboxes do
    -- apparently???? these can also???? be null?????
    local fluid = fluidboxes[i]
    -- also there's no continue statement! joyous!
    if not fluid then goto next end
    -- TODO: scan for targets and make sure that something at the end
    -- is an irradiator or infinity pipe
    -- OR: look into using pump entities? particle input and output
    -- pipe types
    if fluid.name == "particle-stream" then
      local overfull = fluid.amount > 0
      -- disabled_by_script is Not Working for some reason
      coil.active = not overfull
      if overfull then
        coil.custom_status = {
          diode = defines.entity_status_diode.red,
          label = {"text.induction-coil-buffer"}
        }
      else
        coil.custom_status = nil
      end
    end
    ::next::
  end
end)
