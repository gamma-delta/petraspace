local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local rocket_cap = 1000*kg

local function make_rocket_juice_tank_item(name, overlay)
  return {
    type = "item",
    name = name,
    stack_size = 1,
    icons = pglobals.icons.mini_over(
      overlay,
      "__base__/graphics/icons/storage-tank.png"
    ),
    subgroup = "space-related",
    -- TODO order
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    weight = rocket_cap,
  }
end

data:extend{
  make_rocket_juice_tank_item("pktff-platform-fuel-tank", "__space-age__/graphics/icons/fluid/thruster-fuel.png"),
  make_rocket_juice_tank_item("pktff-platform-oxidizer-tank", "__space-age__/graphics/icons/fluid/thruster-oxidizer.png"),
}

-- Spaaaaace!
--[[
Scooping another lordmiguel idea thanks :]
I am just going to make them long and tall solar panels
that only require the *center* tile to be placed on a foundation
]]
data:extend{
  pglobals.copy_then(data.raw["solar-panel"]["solar-panel"], {
    name = "pktff-platform-solar-array",
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    icon = Asset"graphics/icons/platform-solar-array.png",
    minable = { mining_time=1, result="pktff-platform-solar-array" },
    -- 15 x 5
    -- the picture is closer to 15x6, but hush
    -- This collision box is mixel-y, but i would be surprised if anyone noticed
    -- Basically it has a "real" footprint of 7 tiles high, but you can
    -- cram another solar panel in right next to it
    collision_box = {{-7.4, -2.9}, {7.4, 2.9}},
    selection_box = {{-7.5, -3}, {7.5, 3}},
    tile_width = 15, tile_height = 5,
    surface_conditions = {{ property="gravity", max=0 }},
    -- Asteroids only deal damage when hitting foundation, then they damage
    -- whatever is on top.
    -- So I can't make all of the panel take damage, ... just the
    -- central spine you'll need to build
    collision_mask = { layers = {
      is_object=true, is_lower_object=true, transport_belt=true,
    }},
    tile_buildability_rules = {{
      area={{-0.4, -0.4}, {0.4, 0.4}},
      required_tiles={layers={ ground_tile=true }},
      colliding_tiles={layers={ empty_space=true }},
      remove_on_collision=true,
    }},
    placeable_position_visualization = pglobals.placevis,
    picture = {
      filename = Asset"graphics/entities/platform-solar-array.png",
      width = 955, height = 385,
      scale = 0.5,
    },
    overlay = pglobals.null,
    energy_source = { type = "electric", usage_priority = "solar" },
    -- It is 10x as large as a solar panel; let's give 8x the power
    production = "480kW",
  }),
  pglobals.copy_then(data.raw["item"]["solar-panel"], {
    name = "pktff-platform-solar-array",
    icon = Asset"graphics/icons/platform-solar-array.png",
    subgroup = "space-platform",
    order = "az[platform-solar-array]",
    stack_size = 10,
    weight = rocket_cap / 10,
    place_result = "pktff-platform-solar-array",
  }),

}

local bad_collector = pglobals.copy_then(data.raw["asteroid-collector"]["asteroid-collector"], {
  name = "pktff-basic-asteroid-collector",
  subgroup = "space-platform",
  energy_source = {type="void"},
  passive_energy_usage = "69W",
  arm_energy_usage = "69W",
  arm_slow_energy_usage = "69W",
  collection_radius = 2,
  head_collection_radius = 1.5,
  collection_box_offset = 1,
  -- Make it a little slower than base to make it look like they're getting drawn in
  arm_speed_base = 0.15,
  minable = {mining_time = 0.2, result="pktff-basic-asteroid-collector"},
  arm_extend_sound = pglobals.null,
  arm_retract_sound = pglobals.null,
})
bad_collector.graphics_set.arm_head_animation = pglobals.invisible
bad_collector.graphics_set.arm_head_top_animation = pglobals.invisible
bad_collector.graphics_set.arm_link = {
  direction_count = 1,
  filename = "__core__/graphics/empty.png",
  width = 1, height = 1
}

data:extend{
  bad_collector,
  pglobals.copy_then(data.raw["item"]["asteroid-collector"], {
    type = "item",
    name = "pktff-basic-asteroid-collector",
    icon = Asset"graphics/icons/basic-asteroid-collector.png",
    place_result = "pktff-basic-asteroid-collector",
    -- TODO
    subgroup = "space-platform",
    -- right after cargo bay
    order = "cz",
    stack_size = 20,
    weight = rocket_cap / 20,
  })
}

local wc_thruster = pglobals.copy_then(data.raw["thruster"]["thruster"], {
  name = "pktff-advanced-thruster",
  max_health = 500,
  minable = {mining_time=0.1, result="pktff-advanced-thruster"},
})
wc_thruster.graphics_set.animation = util.sprite_load(
  Asset"graphics/entities/advanced-thruster/thruster",
  {
    animation_speed = 0.5,
    frame_count = 64,
    scale = 0.5,
    shift = {0, 3},
  }
)
local wcwv = wc_thruster.graphics_set.working_visualisations
wcwv[#wcwv].animation = util.sprite_load(
  Asset"graphics/entities/advanced-thruster/light",
  {
    animation_speed = 0.5,
    frame_count = 64,
    blend_mode = "additive",
    draw_as_glow = true,
    scale = 0.5,
    shift = {0,3}
  }
)
wc_thruster.graphics_set.flame_effect.filename = Asset"graphics/entities/advanced-thruster/flame.png"

data:extend{
  wc_thruster,
  pglobals.copy_then(data.raw["item"]["thruster"], {
    name = "pktff-advanced-thruster",
    icon = Asset"graphics/icons/advanced-thruster.png",
    place_result = "pktff-advanced-thruster",
    order = "f[thruster]-a"
  })
}
