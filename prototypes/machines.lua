local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local function spraydown(fluid_name, amount, speed, colors)
  return {
    type = "recipe",
    name = "dust-spraydown-" .. fluid_name,
    localised_name = { "recipe-name.dust-spraydown-with", { "fluid-name."..fluid_name } },
    category = "dust-spraydown",
    crafting_machine_tint = colors,
    -- TODO: create a Dust image
    icon = "__base__/graphics/icons/fluid/water.png",
    ingredients = { {type="fluid", name=fluid_name, amount=amount} },
    results = {},
    energy_required = speed,
    -- prod mods add pollution, so does that make this even more effective?
    -- either way, it's interesting
    allow_productivity = true,
    allow_quality = false,
  }
end

data:extend{
  {
    type = "recipe-category",
    name = "dust-spraydown",
  },
  {
    type = "recipe-category",
    name = "electrostatic-funneler",
  },
  spraydown("water", 200, 1, {
    primary = {r = 0.45, g = 0.78, b = 1.000, a = 1.000},
    secondary = {r = 0.591, g = 0.856, b = 1.000, a = 1.000},
    tertiary = {r = 0.381, g = 0.428, b = 0.536, a = 0.502},
    quaternary = {r = 0.499, g = 0.797, b = 0.8, a = 0.733},
  }),
  -- longer time means that it spends more time crafting
  spraydown("holmium-solution", 30, 15, {
    -- borrowed i mean stolen from the holmium solution crafting recipe
    primary = {r = 0.598, g = 0.274, b = 0.501, a = 0.502}, -- #98457f80
    secondary = {r = 0.524, g = 0.499, b = 0.521, a = 0.502}, -- #857f8480
    tertiary = {r = 0.716, g = 0.716, b = 0.716, a = 0.502}, -- #b6b6b680
    quaternary = {r = 0.768, g = 0.487, b = 0.684, a = 0.502}, -- #c37cae80
  }),
}

local dust_sprayer = Data.Util.duplicate("furnace", "electric-furnace", "dust-sprayer", true)
Table.merge(dust_sprayer, {
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
  minable = {mining_time=0.25, result = "electrostatic-funneler"},
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
})

data:extend{
  dust_sprayer,
  {
    -- this is deranged
    type = "electric-energy-interface",
    name = "electrostatic-funneler",
    icon = "__space-age__/graphics/icons/lightning-collector.png",
    energy_usage = "10MW",
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = { dust = -300 },
      buffer = "10MJ",
    },
    minable = {mining_time=0.25, result = "electrostatic-funneler"},
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
  {
    type = "item",
    name = "dust-sprayer",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "w[dust-sprayer]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "dust-sprayer",
    stack_size = 10,
  },
  {
    type = "item",
    name = "electrostatic-funneler",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "x[electrostatic-funneler]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "electrostatic-funneler",
    stack_size = 10,
  }
}
