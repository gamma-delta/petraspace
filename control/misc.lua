local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")

local function add_qai_techs(force)
  for _,tech_name in ipairs{
    "near-inserters",
    "long-inserters-1",
    "long-inserters-2",
    "more-inserters-1",
    "more-inserters-2",
  } do
    local tech = force.technologies[tech_name]
    tech.researched = true
    tech.enabled = false
    tech.visible_when_disabled = false
  end
end

local fill_up_rocket_juice = putil.on_any_built(function(evt)
  local juice_name
  if evt.entity.name == "platform-fuel-tank" then
    juice_name = "thruster-fuel"
  elseif evt.entity.name == "platform-oxidizer-tank" then
    juice_name = "thruster-oxidizer"
  end
  if not juice_name then return end

  evt.entity.insert_fluid{
    name = juice_name,
    amount = evt.entity.fluidbox.get_capacity(1)
  }
end)

script.on_configuration_changed(function(_)
  for _,force in pairs(game.forces) do
    add_qai_techs(force)
  end
end)

return {
  events = putil.smash_events{
    fill_up_rocket_juice,
    {
      [defines.events.on_force_created] = function(evt) 
        add_qai_techs(evt.force)
      end,
    }
  }
}
