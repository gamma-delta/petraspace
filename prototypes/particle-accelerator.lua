local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")

require("__base__/prototypes/entity/pipecovers")

local particle_specific_heat = 1000
local coil_heat_increase = 1000

data:extend{
  {
    type = "item-subgroup",
    name = "particle-accelerator",
    group = "production",
    order = "g[space-related]-a",
  },
  {
    type = "fluid",
    name = "particle-stream",
    icon = "__space-age__/graphics/icons/fluid/fusion-plasma.png",
    subgroup = "fluid",
    order = "b[new-fluid]-e[petraspace]-c[particle-stream]",
    default_temperature = 0,
    max_temperature = 1000000, -- a million
    heat_capacity = particle_specific_heat .. "J",
    base_color = { 0.8, 0.45, 0.21 },
    flow_color = { 0.85, 0.50, 0.40 },
    auto_barrel = false,
  },
}

do -- Inductor coil
  local pics = {
    horz = {
      filename = "__petraspace__/graphics/entities/induction-coil/induction-coil.png",
      size = { 224, 96 },
    },
    vert = {
      filename = "__petraspace__/graphics/entities/induction-coil/induction-coil-vert.png",
      size = { 96, 224 },
    }
  }
  local power_usage = particle_specific_heat * coil_heat_increase

  data:extend{
    {
      type = "pump",
      name = "induction-coil",
      flags = {"placeable-neutral", "placeable-player", "player-creation"},
      max_health = 1000,
      icon = "__petraspace__/graphics/icons/induction-coil.png",
      subgroup = "particle-accelerator",
      order = "b",
      collision_box = {{-3.4, -1.4}, {3.4, 1.4}},
      selection_box = {{-3.5, -1.5}, {3.5, 1.5}},
      animations = {
        -- Default has it being horz
        north = pics.horz,
        south = pics.horz,
        west = pics.vert,
        east = pics.vert,
      },
      burning_cooldown = 0,
      minable = {mining_time=2, result = "induction-coil"},

      energy_usage = power_usage.."J",
      energy_source = {
        type = "electric",
        buffer_capacity = power_usage.."J",
        usage_priority = "secondary-input",
        drain = "100kJ",
      },
      -- make sure the pumping speed is lower than the volume,
      -- so fluid stays in there to get heated.
      pumping_speed = 1,
      fluid_box = {
        volume = 10,
        pipe_covers = pipecoverspictures(),
        pipe_connections = {
          {
            flow_direction = "input",
            direction = defines.direction.west,
            position = {-3, 0},
          },
          {
            flow_direction = "output",
            direction = defines.direction.east,
            position = {3, 0},
          },
        },
        filter = "particle-stream",
      },
    },
  }
end

data:extend{
  {
    name = "particle-irradiator",
    type = "assembling-machine",
    collision_box = {{-2.4, -2.4}, {2.4, 2.4}},
    selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
    crafting_speed = 1,
    crafting_categories = { "particle-irradiation" },
    energy_usage = (particle_specific_heat * coil_heat_increase * 1000) .. "J",
    allowed_effects = { "speed", "productivity", "consumption", "pollution", "quality" },
    energy_source = {
      type = "fluid",
      -- consume it all
      scale_fluid_usage = false,
      burns_fluid = false,
      -- > If the attempt of the game to calculate this value fails
      -- > (scale_energy_usage is false and a fluid box filter is set),
      -- > then scale_energy_usage will be forced to true,
      -- > to prevent the energy source from being an infinite fluid sink.
      -- nerd emoji
      fluid_usage_per_tick = 1000000000000,
      fluid_box = {
        volume = 10,
        pipe_connections = {
          {
            flow_direction = "input",
            direction = defines.direction.west,
            position = {-2, 0},
          }
        }
      }
    },
    graphics_set = {
      animation = {
        filename = "__petraspace__/graphics/entities/irradiator.png",
        size = { 320, 320 },
      }
    }
  }
}
