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
      icon = "__petraspace__/graphics/icons/bauxite-1.png",
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
        probability_expression = [[
          viate_cliff_placing * 0.9 * multioctave_noise{
            x=x, y=y,
            seed0=map_seed+123456789,
            seed1=0,
            persistence=0.2,
            octaves=2,
            input_scale=1/300
          }
        ]],
        richness_expression = "200 + viate_cliff_placing * (70+sqrt(distance))",
      },
      factoriopedia_simulation = {
        init = make_resource("ice-deposit"),
      }
    }
  )
}
