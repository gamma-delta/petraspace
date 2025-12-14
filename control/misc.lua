local util = require "__core__/lualib/util"
local putil = require("__pk-the-first-frontier__/control/utils")

local function add_qai_techs(force)
  for _,tech_name in ipairs{
    "bob-near-inserters",
    "bob-long-inserters-1",
    "bob-long-inserters-2",
    "bob-more-inserters-1",
    "bob-more-inserters-2",
  } do
    local tech = force.technologies[tech_name]
    if tech then
      tech.researched = true
    end
  end
end
local function add_qai_techs_everywhere()
  for _,force in pairs(game.forces) do
    add_qai_techs(force)
  end
end

local tmp_you_win = function(evt)
  if evt.research.name ~= "space-platform" then return end
  game.set_win_ending_info{
    title="You win!",
    message="This is all the content I have so far",
    bullet_points={
      "You rock",
      "Wow they give you a lot of parameters here",
      "Congration"
    },
    final_message = "A winner is you yay"
  }
  game.set_game_state{
    can_continue=true,
    game_finished=true,
    player_won=true,
  }
end

return {
  events = {
    [defines.events.on_force_created] = function(evt)
      add_qai_techs(evt.force)
    end,
    -- [defines.events.on_research_finished] = tmp_you_win,
    [defines.events.on_surface_created] = function(evt)
      local surface = game.surfaces[evt.surface_index]
      if surface.name == "aquilo" then
        surface.freeze_daytime = true
        -- 0 is midday for some reason
        -- 0.5 is the middle of the night i guess
        surface.daytime = 0.5
      end
    end,
  },
  on_init = add_qai_techs_everywhere,
  on_configuration_changed = add_qai_techs_everywhere
}
