local pglobals = require "globals"

local function inserter_pic(cfg)
  return {
    filename = cfg.filename,
    width = cfg.width,
    height = cfg.height,
    scale = 0.25,
    priority = "extra-high",
  }
end

data:extend{
  pglobals.copy_then(
    data.raw["inserter"]["bulk-inserter"],
    {
      name = "tentacle-inserter",
      allow_custom_vectors = true,
      minable = {mining_time=0.25, result = "tentacle-inserter"},
      -- TODO: do i make this require nutrients?
      -- i think that would be. evil
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        -- stackers use 1.0 kW
        drain = "1.0kW",
      },
      -- stackers use 40 kW
      energy_per_movement = "50kJ",
      energy_per_rotation = "50kJ",

      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
      pickup_position = {0, -1},
      insert_position = {0, 1.2},

      -- make it extend a *little* faster cause it's going to be spending
      -- a lot of time doing so
      extension_speed = 0.15,
      
      fast_replaceable_group = nil,

      -- TODO other parts of the inserter
      platform_picture = {
        sheet = {
          filename = "__petraspace__/graphics/entities/tentacle-inserter/platform.png",
          priority = "extra-high",
          -- Standard scale here is 0.5
          scale = 0.5,
          -- The "body" of the inserter needs to be about 32x32
          -- (so, pre-scale, 64x64)
          -- Anything outside of that box is "outside" the bounding box,
          -- which the vanilla inserters use for shadows and greebles
          width = 96,
          height = 96,
          shift = util.by_pixel(0, 3),
        },
      },
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["bulk-inserter"], {
      name = "tentacle-inserter",
      order = "z-za[tentacle-inserter]",
      place_result = "tentacle-inserter",
    }
  ),
}
