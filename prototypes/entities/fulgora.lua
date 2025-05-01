local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local rocket_cap = 1000*kg

-- Nerf lightning tools
local fulgoran_lightningrod = data.raw["lightning-attractor"]["fulgoran-ruin-attractor"]
fulgoran_lightningrod.efficiency = 1
-- Same as vanilla's big lightning rod ...
fulgoran_lightningrod.energy_source = {
  type = "electric",
  buffer_capacity = "1000MJ",
  usage_priority = "primary-output",
  output_flow_limit = "1000MJ",
  -- but worse drain. because it's old or something
  drain = "5MJ"
}
-- be REALLY SURE
fulgoran_lightningrod.minable.mining_time = 5
-- this has a range of 20 by default
fulgoran_lightningrod.range_elongation = 25

local small_rod = data.raw["lightning-attractor"]["lightning-rod"]
small_rod.range_elongation = 10

-- t1
data:extend{
  {
    -- this is deranged
    type = "electric-energy-interface",
    name = "electrostatic-funneler",
    icon = "__space-age__/graphics/icons/lightning-collector.png",
    gui_mode = "none",
    energy_usage = "10MW",
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = { dust = -300 },
      buffer = "10MJ",
    },
    minable = {mining_time=1, result = "electrostatic-funneler"},
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    max_health = 200,
    picture = {
      layers = {
        util.sprite_load("__space-age__/graphics/entity/lightning-collector/lightning-collector",
        {
          priority = "high",
          scale = 0.5,
          repeat_count = repeat_count
        }),
        util.sprite_load("__space-age__/graphics/entity/lightning-collector/lightning-collector-shadow",
        {
          priority = "high",
          draw_as_shadow = true,
          scale = 0.5,
          repeat_count = repeat_count
        })
      }
    },
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    impact_category = "metal",
    open_sound = sounds.electric_large_open,
    close_sound = sounds.electric_large_close,
  },
  {
    type = "item",
    name = "electrostatic-funneler",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "wa[electrostatic]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "dust-sprayer",
    stack_size = 5,
    weight = rocket_cap / 5
  },
}

-- Particle physics
data:extend{
  {
    type = "item-subgroup",
    name = "particle-accelerator-machines",
    group = "production",
    -- after space
    order = "h",
  },
  {
    type = "assembling-machine",
    name = "particle-trap",
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    icon = "__base__/graphics/icons/fluid/steam.png",
    minable = {mining_time=2, result = "particle-trap"},
    collision_box = {{-3.4, -3.4}, {3.4, 3.4}},
    selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
    crafting_speed = 1,
    crafting_categories = { "particle-trap" },
    -- one lightning bolt has 1GJ in it, but collectors are 40% efficient.
    energy_usage = "300MW",
    allowed_effects = { "speed", "productivity", "pollution" },
    energy_source = { type = "electric", usage_priority = "secondary-input" },

    fluid_boxes = {
      {
        volume = 1000,
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        pipe_connections = { {
          direction = defines.direction.west,
          position = { -3, 2 },
          flow_direction = "input",
        } },
      },
      {
        volume = 1000,
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        pipe_connections = { { 
          direction = defines.direction.east,
          position = { 3, -2 },
          flow_direction = "input",
        } },
      },
    },
    
    graphics_set = {
      animation = {
        north = {
          filename = "__petraspace__/graphics/entities/particle-trap.png",
          size = {448, 448},
          scale = 0.5,
        }
      }
    }
  },
  {
    type = "item",
    name = "particle-trap",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "particle-accelerator-machines",
    order = "a",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "particle-trap",
    stack_size = 10,
    weight = rocket_cap / 10
  },
}

