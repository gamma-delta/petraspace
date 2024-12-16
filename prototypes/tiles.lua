local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")

local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")

local viate_offset = 70

local function viate_tile(name, texture, color, order, autoplace)
  return {
    type = "tile",
    name = name,
    order = "b[natural]-j[viate]-" .. order,
    collision_mask = tile_collision_masks.ground(),
    autoplace = autoplace,
    layer = viate_offset,
    variants = tile_variations_template(
      texture, "__base__/graphics/terrain/masks/transition-4.png",
      {
        max_size = 4,
        [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
        [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
        [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
        --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
      }
    ),
    subgroup = "viate-tiles",
    map_color = color,

    scorch_mark_color = {0.318, 0.222, 0.152},
  }
end

data:extend{
  {
    type = "item-subgroup",
    name = "viate-tiles",
    group = "tiles",
    order = "f-a",
  },
  Table.merge(
    Data.Util.duplicate("tile", "dust-crests", "viate-dust-crests"),
    {
      autoplace = {probability_expression="expression_in_range_base(0.8, -10, 1.7, 0.2) + noise_layer_noise(33) + elevation"}  
    }
  ),
  Table.merge(
    Data.Util.duplicate("tile", "dust-lumpy", "viate-dust-lumpy"),
    {
      autoplace = {probability_expression="expression_in_range_base(0.8, -10, 1.7, 0.2) + noise_layer_noise(34)"}  
    }
  ),
  Table.merge(
    Data.Util.duplicate("tile", "dust-patchy", "viate-dust-patchy"),
    {
      autoplace = {probability_expression="expression_in_range_base(0.8, -10, 12, 0.2) + noise_layer_noise(35) + elevation / 2"}  
    }
  ),
}
