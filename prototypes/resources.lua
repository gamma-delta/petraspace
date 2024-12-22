local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local resource_autoplace = require("resource-autoplace")
local factoriopedia_util = require("__base__/prototypes/factoriopedia-util")

data:extend{
  Table.merge(
    Data.Util.duplicate("resource", "stone", "bauxite-ore"),
    {
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
    }
  ),
  Table.merge(
    Data.Util.duplicate("resource", "stone", "ice-deposit"),
    {
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
          -- Only spawn near elevation=0, with a bias towards the lowlands
          near_zero = "20 - abs(elevation) * (1 - ((elevation>0) * 0.5))",
          flavor = [[ multioctave_noise{
            x=x, y=y, persistence=0.75,
            octaves=3,
            seed0=map_seed, seed1="ice",
            input_scale=0.2
          } ]],
        },
        probability_expression = "near_zero + flavor/20",
        richness_expression = "(near_zero + flavor*30) * 5 * (70+sqrt(distance))",
      },
      factoriopedia_simulation = {
        init = make_resource("ice-deposit"),
      }
    }
  )
}
