local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")
local putil = require("__petraspace__/control/utils")

Event.register(defines.events.on_script_trigger_effect, function(evt)
  if evt.effect_id ~= "ps-distractor-capsule" then return end
  if evt.target_entity.commandable then
    -- using set_command and not set_distraction_command because
    -- biters can only get distracted for 5 seconds, which isn't
    -- really long enough for anything interesting to happen
    evt.target_entity.commandable.set_command{
      type = defines.command.attack,
      -- the capsule
      target = evt.source_entity,
      -- This isn't a strong distraction and will get overridden by
      -- any player-built entity in range
      distraction = defines.distraction.by_anything,
    }
  end
end)
