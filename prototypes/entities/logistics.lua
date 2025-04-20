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

      -- yes, a 2x2 inserter. hashtag deal with it
      selection_box = {{-1, -0.9}, {1, 0.9}}
      collision_box = {{-0.5, -0.5}, {0.5, 0.5}},

      -- make it extend a *little* faster cause it's going to be spending
      -- a lot of time doing so
      extension_speed = 0.15,
      
      fast_replaceable_group = nil,

      hand_base_picture = inserter_pic{
        filename = ""
      },
    }
  )
}
