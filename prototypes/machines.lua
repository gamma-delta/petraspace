local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local function metal_machine_item(entity_id, icon, subgroup, order, splat)
  return Table.merge({
    type = "item",
    name = entity_id,
    icon = icon,
    subgroup = subgroup,
    order = order,
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = entity_id,
    stack_size = 10,
  }, splat)
end

data:extend{
-- === Card programmers === --
  Table.merge(
    Data.Util.duplicate(
      "assembling-machine", "assembling-machine-3",
      "orbital-data-programmer", true
    ), {
      energy_usage = "500kW",
      crafting_speed = 1,
      crafting_categories = {"orbital-data-card"},
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        drain = "50kW",
        emissions_per_minute = { dust=5, pollution=2 },
      },
      minable = {mining_time=0.25, result = "orbital-data-programmer"},
      source_inventory_size = 1,
    }
  ),
  metal_machine_item(
    "orbital-data-programmer", "__base__/graphics/icons/fluid/steam.png",
    "production-machine", "ea[orbital-data-programmer]"
  ),
-- === Dust === --
  Table.merge(
    Data.Util.duplicate("furnace", "electric-furnace", "dust-sprayer", true),
    {
      -- a pump uses 30
      energy_usage = "50kW",
      crafting_speed = 1,
      crafting_categories = {"dust-spraydown"},
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        -- I think this is at passive? Don't consume energy just to stay awake
        -- so that it doesn't passively remove dust
        drain = "0W",
        emissions_per_minute = { dust = -40 },
      },
      minable = {mining_time=0.25, result = "dust-sprayer"},
      -- urhghhh
      source_inventory_size = 0,
      fluid_boxes = {
        {
          production_type = "input",
          volume = 1000,
          pipe_connections = {{ flow_direction="input", direction = defines.direction.north, position = {0, -1} }},
        }
      },
      fluid_boxes_off_when_no_fluid_recipe = false,
    }
  ),
  metal_machine_item(
    "dust-sprayer", "__base__/graphics/icons/fluid/steam.png",
    "production-machine", "w[dust-sprayer]"
  ),
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
    flags = {"player-creation", "placeable-neutral"},
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
  metal_machine_item(
    "electrostatic-funneler", "__base__/graphics/icons/fluid/steam.png",
    "production-machine", "wa[electrostatic]"
  ),

  -- Particle physics
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
    minable = {mining_time=2, result = "particle-trap"},
    collision_box = {{-3.4, -3.4}, {3.4, 3.4}},
    selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
    crafting_speed = 1,
    crafting_categories = { "particle-trap" },
    energy_usage = "1GW",
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
  metal_machine_item(
    "particle-trap", "__base__/graphics/icons/fluid/steam.png",
    "particle-accelerator-machines", "a"
  ),
}
