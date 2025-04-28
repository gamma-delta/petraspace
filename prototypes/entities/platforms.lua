local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local rocket_cap = 1000*kg

-- TODO: fiddle with this amount
local juice_tank_volume = 50000
local pumping_speed = 20
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
  local path = "__petraspace__/graphics/entities/propellant-tank/" .. mode .. "-1.png"

  return {
    type = "storage-tank",
    name = "platform-" .. mode .. "-tank",
    icon = "__base__/graphics/icons/storage-tank.png",
    flags = {"placeable-player", "placeable-neutral", "not-rotatable"},
    selection_box = {{-2.4, -5.5}, {2.5, 5.5}},
    collision_box = {{-2.45, -5.45}, {2.45, 5.45}},
    window_bounding_box = {{-1, -3}, {1, 3}},
    flow_length_in_ticks = 360,

    minable = {mining_time=5, result="empty-platform-tank"},
    surface_conditions = {{property="gravity", max=0}},

    fluid_box = {
      volume = juice_tank_volume,
      filter = juice_name,
      hide_connection_info = true,
      pipe_connections = {
        -- This connects to the pump below
        {
          direction=defines.direction.south,
          position={0, 0},
        },
      },
    },

    pictures = {
      picture = {
        filename = path,
        width = 64 * 5,
        height = 64 * 11,
        scale = 0.5,
      }
    }
  }
end

data:extend{
  make_rocket_juice_tank_item("empty-platform-tank", nil),
  make_rocket_juice_tank_item("platform-fuel-tank", "platform-fuel-tank"),
  make_rocket_juice_tank_item("platform-oxidizer-tank", "platform-oxidizer-tank"),
  make_rocket_juice_tank("fuel", "thruster-fuel"),
  make_rocket_juice_tank("oxidizer", "thruster-oxidizer"),
  {
    type = "pump",
    name = "platform-juice-tank-secret-pump",
    -- no idea what this does, but it's what the vanilla tank has
    collision_box = {{-1.5, -5.5}, {1.5, 5.5}},
    energy_source = { type = "void" },
    energy_usage = "1W",
    flow_scaling = false,
    pumping_speed = pumping_speed,
    flags = {
      "not-on-map", "not-flammable",
      "no-automated-item-insertion", "no-automated-item-removal",
      "get-by-unit-number",
    },
    show_fluid_icon = false,
    collision_mask = {layers={}},
    hidden = true,
    selectable_in_game = false,
    fluid_box = {
      pipe_covers = pglobals.copy_then(
        pipecoverspictures(),
        {
          north = {filename="__core__/graphics/empty.png", size=1},
          west = {filename="__core__/graphics/empty.png", size=1},
          east = {filename="__core__/graphics/empty.png", size=1},
        }
      ),
      volume = pumping_speed,
      pipe_connections = {
        {direction=defines.direction.north, position={0, 1}, flow_direction="input"},
        {direction=defines.direction.south, position={0, 5}, flow_direction="output"},
      }
    }
  }
}
