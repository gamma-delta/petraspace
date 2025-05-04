local pglobals = require "globals"

local resource_autoplace = require("resource-autoplace")
local factoriopedia_util = require("__base__/prototypes/factoriopedia-util")

data:extend{
  pglobals.copy_then(
    data.raw["resource"]["stone"],
    {
      name = "bauxite-ore",
      map_color = { 0.75, 0.50, 0.45 },
      mining_visualization_tint = { 0.75, 0.50, 0.45 },
      icon = "__petraspace__/graphics/icons/bauxite/1.png",
      minable = {
        mining_particle = "stone-particle",
        mining_time = 1,
        result = "bauxite-ore",
      },
      stages = { sheet = {
        filename = "__petraspace__/graphics/entities/bauxite-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
      } },
      -- Make it search farther in the hope that it covers the whole
      -- patch of stone or w/e
      resource_patch_search_radius = 8,
      factoriopedia_description = { "factoriopedia-description.bauxite-ore" },
      -- TODO: probably need to make this stone with inclusions
      factoriopedia_simulation = {
        init = make_resource("bauxite-ore"),
      },
      -- Ore per cycle = yield% * 10
      infinite = true,
      minimum = 1,
      normal = 10,
      infinite_depletion_amount = 0.01,
    }
  ),
  pglobals.copy_then(
    data.raw["resource"]["stone"],
    {
      name = "ice-deposit",
      map_color = { 0.5, 0.7, 1.0 },
      mining_visualization_tint = { 0.75, 0.75, 0.1 },
      icon = "__space-age__/graphics/icons/ice.png",
      minable = {
        mining_particle = "stone-particle",
        mining_time = 1,
        result = "ice",
      },
      stages = { sheet = {
        filename = "__petraspace__/graphics/entities/ice-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
      } },
      autoplace = {
        local_expressions = {
          spread = 10,
          near_zero = "(spread - abs(elevation)) / spread",
          flavor = [[ multioctave_noise{
            x=x, y=y, persistence=0.75,
            octaves=3,
            seed0=map_seed, seed1="ice",
            input_scale=0.2
          } ]],
          blobs = [[ basis_noise{
            x=x, y=y,
            seed0=map_seed, seed1="ice-blobs",
            input_scale=0.006
          } > 0.4 ]],
        },
        probability_expression = "near_zero * blobs - flavor/3",
        richness_expression = "(near_zero + flavor*30) * 5 * (70+sqrt(distance))",
      },
      factoriopedia_simulation = {
        init = make_resource("ice-deposit"),
      }
    }
  ),
  pglobals.copy_then(
    data.raw["resource"]["stone"],
    {
      name = "regolith-deposit",
      -- dark brown?
      map_color = { 0.6, 0.2, 0.1 },
      -- mining_visualization_tint = { 0.75, 0.75, 0.1 },
      icon = "__petraspace__/graphics/icons/regolith/1.png",
      minable = {
        mining_particle = "stone-particle",
        mining_time = 2,
        result = "regolith",
      },
      stages = { sheet = {
        filename = "__petraspace__/graphics/entities/regolith-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
      } },
      autoplace = {
        local_expressions = {
          flavor = [[ multioctave_noise{
            x=x, y=y, persistence=0.75,
            octaves=3,
            seed0=map_seed, seed1="regolith",
            input_scale=0.02
          } * 0.5 + 0.6 ]],
        },
        probability_expression = [[
          (viate_above_basins * (viate_meteor_spot < 0.7))
          * (viate_meteorness > max(5 - sqrt(distance / 100), 3.8))
        ]],
        richness_expression = "viate_meteorness * (100 + sqrt(distance))",
      },
      factoriopedia_simulation = {
        init = make_resource("regolith-deposit"),
      }
    }
  ),
}

local watery_oil = pglobals.copy_then(
  data.raw["resource"]["crude-oil"],
  {
    name = "watery-crude-oil",
    factoriopedia_simulation = {
      init = make_resource("watery-crude-oil"),
    },
  }
)
local wo_sv = watery_oil.stateless_visualisation
wo_sv[1].animation.filename = "__petraspace__/graphics/entities/evil-crude-oil.png"
-- blue
wo_sv[3].animation.tint[3] = wo_sv[3].animation.tint[3] * 1.5
-- Stay on crude-oil autoplace
-- The crude-oil *autoplace spec* usually only places an entity *crude-oil*.
-- Below, I make it so entity:crude-oil cannot spawn on nauvis.
-- Nauvis will still try to use autoplace-spec:crude-oil, and the only thing
-- assigned to that that is still allowed is this new watery oil.
-- Add a helper line to the output so that the player knows it produces ~* some *~ water
table.insert(watery_oil.minable.results, {type="fluid", name="water", amount=0})

-- Spawn this with the ore inclusions script
local oily_water = pglobals.copy_then(
  data.raw["resource"]["crude-oil"],
  {
    name = "watery-crude-oil-water",
    hidden = true,
    highlight = false,
    minimum = 60000,
    normal = 100000,
    infinite_depletion_amount = 5,
    minable = {
      mining_time = 1,
      results = {{type="fluid", name="water", amount=10}}
    },
    stage_counts = {},
    stages = nil,
    stateless_visualisation = nil,
    autoplace = nil,

    selectable_in_game = false,
    -- for editor mode
    selection_priority = 255,
    selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
  }
)

data:extend{watery_oil, oily_water}

-- Add resources to planets
local nauvis = data.raw["planet"]["nauvis"]
local nauvis_gen = nauvis.map_gen_settings.autoplace_settings["entity"].settings
nauvis_gen["crude-oil"] = nil
nauvis_gen["watery-crude-oil"] = {}
