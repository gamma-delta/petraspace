local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local rocket_cap = 1000*kg

-- TODO: fiddle with this amount
local pumping_speed = 20
local function make_rocket_juice_tank_item(name, place_result, overlay)
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
      volume = pglobals.platform_juice_tank_volume,
      filter = juice_name,
      pipe_connections = {
        {
          direction=defines.direction.south,
          position={0, 5},
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
  make_rocket_juice_tank_item("empty-platform-tank", nil, "__core__/graphics/icons/alerts/fluid-icon-red.png"),
  make_rocket_juice_tank_item("platform-fuel-tank", "platform-fuel-tank", "__space-age__/graphics/icons/fluid/thruster-fuel.png"),
  make_rocket_juice_tank_item("platform-oxidizer-tank", "platform-oxidizer-tank", "__space-age__/graphics/icons/fluid/thruster-oxidizer.png"),
  make_rocket_juice_tank("fuel", "thruster-fuel"),
  make_rocket_juice_tank("oxidizer", "thruster-oxidizer"),
}
