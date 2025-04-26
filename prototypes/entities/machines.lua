-- Entities that are machines, and their items
local pglobals = require "globals"

local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local rocket_cap = 1000*kg

local function metal_machine_item(entity_id, icon, subgroup, order, splat)
  return util.merge{{
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
    weight = rocket_cap / 10,
  }, splat}
end

local function heat_pipe_direction_pic(direction, hot)
  local img = hot and "heatex-endings-heated.png" or "heatex-endings.png"

  local sx_map = {north=0, east=1, south=2, west=3}
  local sx = sx_map[direction] * 64

  local new_sprite = {
    filename = "__base__/graphics/entity/heat-exchanger/" .. img,
    x = sx, y = 0,
    size = 64, scale = 0.5, priority = "high"
  }
  if hot then new_sprite = apply_heat_pipe_glow(new_sprite) end
  return new_sprite
end

data:extend{
-- === Card programmers === --
  pglobals.copy_then(
    data.raw["assembling-machine"]["assembling-machine-3"], {
      name = "data-card-programmer",
      energy_usage = "500kW",
      crafting_speed = 1,
      crafting_categories = {"data-card-programming"},
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        drain = "50kW",
        emissions_per_minute = { dust=5, pollution=2 },
      },
      minable = {mining_time=0.25, result = "data-card-programmer"},
      source_inventory_size = 1,
    }
  ),
  metal_machine_item(
    "data-card-programmer", "__base__/graphics/icons/fluid/steam.png",
    "production-machine", "ea[data-card-programmer]"
  ),
-- === Dust === --
  pglobals.copy_then(
    data.raw["furnace"]["electric-furnace"],
    {
      name = "dust-sprayer",
      -- a pump uses 30
      energy_usage = "70kW",
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
  metal_machine_item(
    "electrostatic-funneler", "__base__/graphics/icons/fluid/steam.png",
    "production-machine", "wa[electrostatic]"
  ),
}

-- Vulcanus
local function heat_connect(x, y, dir)
  return {
    position = { x, y },
    direction = defines.direction[dir],
  }
end
local ghx_pics = require("geothermal-heat-exchanger-gfx")
local big_x = {
  filename = "__core__/graphics/too-far.png",
  size = 64, scale = 0.5,
}

data:extend{
  {
    type = "reactor",
    name = "geothermal-heat-exchanger",
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    icon = "__petraspace__/graphics/icons/geothermal-heat-exchanger.png",
    minable = {mining_time=2, result = "geothermal-heat-exchanger"},
    selection_box = {{-4.5, -4.5}, {4.5, 4.5}},
    collision_box = {{-4.3, -4.3}, {4.3, 4.3}},
    tile_width = 9,
    tile_height = 9,
    impact_category = "metal",
    open_sound = sounds.steam_open,
    close_sound = sounds.steam_close,

    energy_source = { type = "void" },
    consumption = "500MW",
    neighbor_bonus = 1,

    stateless_visualisation = {
      animation = ghx_pics.normal,
    },
    water_reflection = ghx_pics.reflection,
    -- lower_layer_picture = ghx_pics.heat_pipes,
    -- heat_lower_layer_picture = apply_heat_pipe_glow(ghx_pics.heat_pipes_hot),
    heat_buffer = {
      default_temperature = 30,
      min_working_temperature = 350,
      minimum_glow_temperature = 350,
      max_temperature = 2000,
      -- Make this rather high so it takes a while to heat up
      -- Nuclear reactors are at 10MJ
      specific_heat = "50MJ",
      -- this is what matters
      max_transfer = "1GW",
      connections = {
        heat_connect(-2, -4.0, "north"),
        heat_connect(2, -4.0, "north"),
        heat_connect(-2, 4.0, "south"),
        heat_connect(2, 4.0, "south"),
        heat_connect(-4.0, -2, "west"),
        heat_connect(-4.0, 2, "west"),
        heat_connect(4.0, -2, "east"),
        heat_connect(4.0, 2, "east"),
      },
      pipe_covers = {
        --[[
        north = heat_pipe_direction_pic("north", false),
        east = heat_pipe_direction_pic("east", false),
        south = heat_pipe_direction_pic("south", false),
        west = heat_pipe_direction_pic("west", false),
        ]]
        north = big_x,
        east = big_x,
        south = big_x,
        west = big_x,
      },
      heat_pipe_covers = {
        north = heat_pipe_direction_pic("north", true),
        east = heat_pipe_direction_pic("east", true),
        south = heat_pipe_direction_pic("south", true),
        west = heat_pipe_direction_pic("west", true),
      }
    },

    -- Thankfully there is a lava_tile rule.
    -- It looks like collision_mask and tile_buildability_rules are ANDed,
    -- so unfortunately I do need to specify every tile individually.
    -- Referencing offshore pumps. Same collision mask but w/ elevated rails
    collision_mask = { layers = pglobals.set{ 
      "object", "train", "is_object", "is_lower_object",
      "elevated_rail",
    }},
    -- Require some lava in the middle. Everything else, anything goes
    tile_buildability_rules = {
      {
        area = {{-2.4, -2.4}, {2.4, 2.4}},
        required_tiles = {layers = {lava_tile=true}},
        colliding_tiles = {layers = {ground_tile=true}},
        remove_on_collision = true,
      }
    },
    placeable_position_visualization = {
      filename = "__core__/graphics/cursor-boxes-32x32.png",
      priority = "extra-high-no-scale",
      size = 64,
      scale = 0.5,
      x = 3 * 64
    },
    --[[
    placeable_position_visualisation = {
      filename = "__space-age__/graphics/icons/fluid/lava.png",
      priority = "extra-high-no-scale",
      size = 64,
      scale = 0.5,
    },
    ]]
    
    resistances = {
      { type="fire", percent=100 },
      { type="impact", percent=30 },
    },
    max_health = 300,
    dying_explosion = "foundry-explosion",
  },
  metal_machine_item(
    "geothermal-heat-exchanger",
    "__petraspace__/graphics/icons/geothermal-heat-exchanger.png",
    -- right before foundry
    "smelting-machine", "cz[geothermal]",
    { default_import_location = "vulcanus", weight = rocket_cap / 20 }
  ),
}
-- Make the foundry worse
local heatex = data.raw["boiler"]["heat-exchanger"]
local foundry = data.raw["assembling-machine"]["foundry"]
local nothingburger = {
  filename = "__core__/graphics/empty.png",
  width = 1, height = 1
}
foundry.energy_usage = "50MW"
foundry.energy_source = {
  type = "heat",
  -- every second while running, it goes down by 50c
  specific_heat = "1MJ",
  default_temperature = 30,
  max_temperature = 2000,
  -- this is about the melting point of steel
  min_working_temperature = 1500,
  -- so it heats up some time this century
  max_transfer = "1GW",
  connections = {
    heat_connect(0, -2, "north"),
    heat_connect(0, 2, "south"),
    heat_connect(-2, 0, "west"),
    heat_connect(2, 0, "east"),
  },
  pipe_covers = {
    -- The north one is covered by the sprite
    north = nothingburger,
    east = heat_pipe_direction_pic("east", false),
    south = heat_pipe_direction_pic("south", false),
    west = heat_pipe_direction_pic("west", false),
  },
  heat_pipe_covers = {
    north = nothingburger,
    east = heat_pipe_direction_pic("east", true),
    south = heat_pipe_direction_pic("south", true),
    west = heat_pipe_direction_pic("west", true),
  }
}
-- Make the nuclear reactor actually get that hot
data.raw["reactor"]["nuclear-reactor"].heat_buffer.max_temperature = 2000
-- Make heat pipes get that hot, and lower their specific heat
local heat_pipe = data.raw["heat-pipe"]["heat-pipe"].heat_buffer
heat_pipe.max_temperature = 2000
-- it takes a WHOLE MEGAWATT to heat a heat pipe by 1 degree in vanilla.
-- Jesus, no wonder reactors take so long to spin up.
heat_pipe.specific_heat = "100kJ"
heat_pipe.max_transfer = "100GW"

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
  metal_machine_item(
    "particle-trap", "__base__/graphics/icons/fluid/steam.png",
    "particle-accelerator-machines", "a"
  ),
}
