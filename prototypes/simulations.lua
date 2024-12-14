local bp_spoiling_cards = require("__petraspace__/prototypes/simulations/spoiling-cards.blueprint.lua")

local sim_spoiling_cards = {
  init_update_count = 60,
  -- this is S O J A N K
  init = [[
    game.simulation.camera_position = {0, 1.5}
    game.simulation.camera_alt_info = true
    game.forces.player.recipes["orbital-science-pack"].enabled = true
    game.forces.player.recipes["orbital-data-card-high-pressure"].enabled = true
    game.forces.player.recipes["format-expired-data-card"].enabled = true
    
    game.surfaces[1].create_entities_from_blueprint_string{
      string = "]] .. bp_spoiling_cards .. [[",
      position = {0, 0}
    }

    script.on_nth_tick(1, function()
      local spoiled_cards_chest = game.surfaces[1].find_entities_filtered{name="wooden-chest"}[1]
      spoiled_cards_chest.insert{name="orbital-data-card", count=20, spoil_percent=0.5}
    end)
  ]],
}

data:extend{
  {
    type = "tips-and-tricks-item-category",
    name = "petraspace",
    order = "l-[petraspace]",
  },
  {
    type = "tips-and-tricks-item",
    name = "spoiling-data-cards",
    category = "petraspace",
    order = "a-a",
    trigger = {
      type = "research",
      technology = "data-cards",
    },
    simulation = sim_spoiling_cards,
  }
}
