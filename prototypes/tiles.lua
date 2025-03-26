local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")

local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local viate_offset = 70

-- genuinely have no idea what most of this stuff does
local viate_transitions = {
  {
    to_tiles = {"out-of-map","empty-space"},
    transition_group = out_of_map_transition_group_id,

    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,

    spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_4_4_8_1_1,
    overlay_enabled = false
  },
  {
    -- stolen from vanilla dirt->water
    -- i think this makes the basalt appear "sunken"?
    to_tiles = {"viate-smooth-basalt"},
    transition_group = water_transition_group_id,
    -- dark enough
    -- aquilo uses the ice transition even when it's dust, which I guess
    -- makes sense
    spritesheet = "__base__/graphics/terrain/water-transitions/nuclear-ground.png",
    layout = tile_spritesheet_layout.transition_8_8_8_2_4,
    background_enabled = false,
  },
}

local function viate_tile(cfg)
  return Table.merge({
    type = "tile",
    name = cfg.name,
    order = "b[natural]-j[viate]-" .. cfg.order,
    subgroup = "viate-tiles",

    collision_mask = tile_collision_masks.ground(),
    autoplace = cfg.autoplace,
    absorptions_per_second = cfg.absorptions_per_second,

    layer = viate_offset + cfg.offset,
    variants = tile_variations_template(
      cfg.texture, "__base__/graphics/terrain/masks/transition-4.png",
      {
        max_size = 4,
        [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
        [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
        [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
        --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
      }
    ),
    map_color = cfg.map_color,

    scorch_mark_color = {0.318, 0.222, 0.152},
  }, cfg.etc)
end

local dusty_absorb = {
  dust = 0.1 / 60 / (32*32)
}

data:extend{
  {
    type = "item-subgroup",
    name = "viate-tiles",
    group = "tiles",
    order = "f-a",
  },
  viate_tile{
    name = "viate-smooth-basalt",
    order = "a",
    offset = 0,
    absorptions_per_second = { dust = 2 / 60 / (32*32) },
    autoplace = {probability_expression="viate_above_basins==0"},
    texture = "__petraspace__/graphics/tiles/viate/smooth-basalt.png",
    map_color = { 0.2, 0.21, 0.25 },
  },
  viate_tile{
    name = "viate-dust-crests",
    order = "zzz",
    offset = 1,
    absorptions_per_second = dusty_absorb,
    autoplace = {
      probability_expression=[[
        (viate_above_basins) * 0.01
      ]]
    },
    texture = "__space-age__/graphics/terrain/aquilo/dust-crests.png",
    map_color = { 0.6, 0.61, 0.7 },
    etc = { transitions=viate_transitions },
  },
  viate_tile{
    name = "viate-dust-lumpy",
    order = "bb",
    offset = 2,
    absorptions_per_second = dusty_absorb,
    autoplace = {
      probability_expression=[[
        (viate_above_basins) * (viate_meteorness_deco / 50)
      ]]
    },
    texture = "__space-age__/graphics/terrain/aquilo/dust-lumpy.png",
    map_color = { 0.7, 0.71, 0.80 },
    etc = { transitions=viate_transitions },
  },
  viate_tile{
    name = "viate-dust-patchy",
    order = "ba",
    offset = 3,
    absorptions_per_second = dusty_absorb,
    autoplace = {
      probability_expression=[[
        (viate_above_basins) * (viate_meteorness > 5)
      ]]
    },
    texture = "__space-age__/graphics/terrain/aquilo/dust-patchy.png",
    map_color = { 0.8, 0.81, 0.85 },
    etc = { transitions=viate_transitions },
  },
}
