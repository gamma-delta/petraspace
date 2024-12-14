local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

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
    }
  )
}
