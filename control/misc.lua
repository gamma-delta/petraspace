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

script.on_configuration_changed(function(_)
  for _,force in pairs(game.forces) do
    add_qai_techs(force)
  end
end)

return {
  events = {
    [defines.events.on_force_created] = function(evt) 
      add_qai_techs(evt.force)
    end,
  }
}
