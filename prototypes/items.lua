local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local rocket_cap = 1000 * kg;

data:extend{
  {
    type = "item-subgroup",
    name = "aluminum-processes",
    group = "intermediate-products",
    -- right after raw-material, the row with iron&copper plates
    order = "ca",
  },
  
  Table.merge(
    Data.Util.duplicate("item", "iron-ore", "bauxite-ore"),
    {
      subgroup = "raw-resource",
      -- after copper, before uranium
      order = "fa[bauxite-ore]",
      icon = "__petraspace__/graphics/icons/bauxite-1.png",
      pictures =
      {
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite-1.png", scale = 0.5, mipmap_count = 4},
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite-2.png", scale = 0.5, mipmap_count = 4},
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite-3.png", scale = 0.5, mipmap_count = 4},
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite-4.png", scale = 0.5, mipmap_count = 4},
      },
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "iron-plate", "aluminum-nugget"),
    {
      weight = rocket_cap / 2000,
      -- right after steel plates
      subgroup = "aluminum-processes",
      order = "b[aluminum-nugget]",
      icon = "__petraspace__/graphics/icons/aluminum-ingot.png",
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "iron-plate", "aluminum-plate"),
    {
      weight = rocket_cap / 500,
      subgroup = "aluminum-processes",
      order = "c[aluminum-plate]",
      icon = "__petraspace__/graphics/icons/aluminum-ingot.png",
    }
  ),
}
