local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local rocket_cap = 1000*kg

local function make_rocket_juice_tank_item(name, place_result)
  return {
    type = "item",
    name = name,
    stack_size = 1,
    icon = "__base__/graphics/icons/storage-tank.png",
    subgroup = "space-related",
    -- TODO order
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    weight = rocket_cap,
    place_result = place_result
  }
end
local function make_rocket_juice_tank(mode, juice_name)
  local path = "__petraspace__/graphics/entities/propellant-tank/" .. mode .. ".png"

  -- TODO: fiddle with this amount
  local volume = 50000
  local pumping_speed = 20
  local ticks_to_deplete = volume / pumping_speed

  local frames = 11
  local ticks_per_frame = ticks_to_deplete / frames
  
  -- TODO: this doesn't work because it will only pump fluid
  -- from the *back* to the *front*, no animation plays
  -- for fluid to drain out of the FB passively.
  -- So must use compound entity.
  return {
    type = "pump",
    name = "platform-" .. mode .. "-tank",
    icon = "__base__/graphics/icons/storage-tank.png",
    flags = {"placeable-player", "placeable-neutral", "not-rotatable"},
    selection_box = {{-2.4, -5.5}, {2.5, 5.5}},
    collision_box = {{-2.45, -5.45}, {2.45, 5.45}},
    energy_source = { type = "void" },
    energy_usage = "1W",
    flow_scaling = false,
    pumping_speed = pumping_speed,

    minable = {mining_time=5, result="empty-platform-tank"},
    surface_conditions = {{property="gravity", max=0}},

    fluid_box = {
      volume = volume,
      pipe_covers = pipecoverspictures(),
      filter = juice_name,
      pipe_connections = {
        { 
          direction=defines.direction.north,
          position={0, -5},
          flow_direction="output"
        },
        -- This is required to make it pump
        {
          direction=defines.direction.north,
          position={0, 0},
          flow_direction="input",
        },
      },
    },

    animations = {
      filename = path,
      width = 64 * 5,
      height = 64 * 11,
      scale = 0.5,
      frame_count = frames,
      animation_speed = ticks_per_frame,
    }
  }
end

data:extend{
  make_rocket_juice_tank_item("empty-platform-tank", nil),
  make_rocket_juice_tank_item("platform-fuel-tank", "platform-fuel-tank"),
  make_rocket_juice_tank_item("platform-oxidizer-tank", "platform-oxidizer-tank"),
  make_rocket_juice_tank("fuel", "thruster-fuel"),
  make_rocket_juice_tank("oxidizer", "thruster-oxidizer"),
}
