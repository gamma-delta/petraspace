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
      }
    }
  )
}
