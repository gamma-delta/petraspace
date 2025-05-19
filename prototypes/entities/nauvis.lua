local pglobals = require "globals"

--[[
data:extend{
  -- yoink! thanks krastorio 2
  -- unclear if I will actually do anything with this.
  {
    name = "spaceship-reactor",
    type = "accumulator",
    icon = "__Krastorio2Assets__/icons/entities/spaceship-reactor.png",
    flags = { "placeable-player", "player-creation", "not-rotatable" },
    hidden = true,
    map_color = { r = 0, g = 0.365, b = 0.58, a = 1 },
    max_health = 150,
    resistances = {
      { type = "fire", percent = 100 },
      { type = "impact", percent = 60 },
      { type = "physical", percent = 50 },
    },
    corpse = "medium-remnants",
    collision_box = { { -1.5, -0.9 }, { 0.9, 0.9 } },
    selection_box = { { -1.5, -0.9 }, { 0.9, 0.9 } },

    burner = {
      type = "burner",
      fuel_inventory_size = 1,
      fuel_categories = {"antimatter"},
      initial_fuel_percent = 0,
      light_flicker = {
        minimum_intensity = 0.24,
        maximum_intensity = 0.4,
        minimum_light_size = 1,
        color = { r = 0.196, g = 0.658, b = 0.650 },
        shift = { 64 / 64, -140 / 64 },
      }
    },
    energy_source = {
      type = "electric",
      usage_priority = "primary-output",
    },
    energy_source = {
      type = "electric",
      buffer_capacity = "5MJ",
      usage_priority = "tertiary",
      input_flow_limit = "0W",
      output_flow_limit = "500kW",
      drain = "1kW", -- dies in 5000 seconds -> little over an hour
    },

    chargable_graphics = {
      picture = {
        layers = {
          {
            filename = "__Krastorio2Assets__/buildings/spaceship-reactor/spaceship-reactor.png",
            width = 286,
            height = 252,
            frame_count = 5,
            line_length = 5,
            shift = util.by_pixel(-11, -23),
            scale = 0.5,
          },
          {
            filename = "__Krastorio2Assets__/buildings/spaceship-reactor/spaceship-reactor-shadow.png",
            width = 474,
            height = 152,
            frame_count = 1,
            line_length = 1,
            repeat_count = 5,
            draw_as_shadow = true,
            shift = util.by_pixel(25, 5),
            scale = 0.5,
          },
        }
      },
      discharge_animation = {
        layers = {
          {
            filename = "__Krastorio2Assets__/buildings/spaceship-reactor/spaceship-reactor-beams.png",
            width = 224,
            height = 232,
            frame_count = 16,
            line_length = 4,
            repeat_count = 5,
            shift = util.by_pixel(-8, -30),
            draw_as_glow = true,
            scale = 0.5,
          },
          {
            filename = "__Krastorio2Assets__/buildings/spaceship-reactor/spaceship-reactor-beams-light.png",
            width = 224,
            height = 232,
            frame_count = 16,
            line_length = 4,
            repeat_count = 5,
            shift = util.by_pixel(-8, -30),
            draw_as_light = true,
            scale = 0.5,
          },
        }
      },
      discharge_light = {
        intensity = 0.35,
        size = 1,
        color = { r = 0.196, g = 0.658, b = 0.650 },
        shift = { 64 / 64, -140 / 64 },
        flicker_interval = 2,
        flicker_min_modifier = 0.8,
        flicker_max_modifier = 1.0,
      }
      -- it can't charge
    },
    integration_patch = {
      filename = "__Krastorio2Assets__/buildings/spaceship-reactor/spaceship-reactor-ground.png",
      width = 384,
      height = 360,
      shift = util.by_pixel(-28, -38),
      frame_count = 1,
      line_length = 1,
      scale = 0.5,
    },
    integration_patch_render_layer = "decals",
    damaged_trigger_effect = hit_effects.entity(),
    allow_copy_paste = false,
    continuous_animation = true,
    vehicle_impact_sound = sounds.generic_impact,
  },
}
]]
