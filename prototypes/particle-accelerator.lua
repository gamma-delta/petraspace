local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")
local Area = require("__stdlib2__/stdlib/area/area")

require("__base__/prototypes/entity/pipecovers")

local particle_specific_heat = 1

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
    max_temperature = 1e6, -- a million, or a thousand thousand
    heat_capacity = particle_specific_heat .. "J",
    base_color = { 0.8, 0.45, 0.21 },
    flow_color = { 0.85, 0.50, 0.40 },
    auto_barrel = false,
  },
}

-- Sputtering coil
do
  local horz = {
    filename = "__petraspace__/graphics/entities/sputtering-coil/horz.png",
    size = {192, 320},
    scale = 0.5,
  }
  local vert = {
    filename = "__petraspace__/graphics/entities/sputtering-coil/vert.png",
    size = {320, 192},
    scale = 0.5,
  }
  data:extend { {
    type = "assembling-machine",
    name = "sputtering-coil",
    minable = {mining_time=2, result = "sputtering-coil"},
    collision_box = {{-1.4, -2.4}, {1.4, 2.4}},
    selection_box = {{-1.5, -2.5}, {1.5, 2.5}},
    crafting_speed = 1,
    crafting_categories = { "particle-sputtering" },
    energy_usage = "1MW",
    allowed_effects = { "speed", "productivity", "consumption", "pollution" },
    energy_source = { type = "electric", usage_priority = "secondary-input" },

    fluid_boxes = {
      {
        volume = 10,
        filter = "particle-stream",
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        pipe_connections = {
          { direction = defines.direction.north, position = { 0, -2 } },
          { direction = defines.direction.south, position = { 0, 2 } },
        }
      },
      {
        volume = 1000,
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        pipe_connections = { {
          direction = defines.direction.west,
          position = { -1, 2 },
          flow_direction = "input",
        } },
      },
      {
        volume = 1000,
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        pipe_connections = { { 
          direction = defines.direction.east,
          position = { 1, -2 },
          flow_direction = "input",
        } },
      },
    },
    
    graphics_set = {
      animation = {
        north = horz,
        south = horz,
        west = vert,
        east = vert,
      }
    }
  } }
end

do -- Inductor coil
  local pics = {
    horz = {
      structure = {
        filename = "__petraspace__/graphics/entities/induction-coil/induction-coil.png",
        size = { 704, 192 },
        scale = 0.5,
      },
    },
    vert = {
      structure = {
        filename = "__petraspace__/graphics/entities/induction-coil/induction-coil-vert.png",
        size = { 192, 704 },
        scale = 0.5,
      },
    }
  }

  -- heat up this many droplet*degrees per second
  local pow = (particle_specific_heat * 10 * 100000) .. "W"

  data:extend{ {
    type = "boiler",
    name = "induction-coil",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    max_health = 1000,
    icon = "__petraspace__/graphics/icons/induction-coil.png",
    subgroup = "particle-accelerator",
    order = "b",
    collision_box = {{-5.4, -1.4}, {5.4, 1.4}},
    selection_box = {{-5.5, -1.5}, {5.5, 1.5}},
    minable = {mining_time=2, result = "induction-coil"},
    pictures = {
      -- Default has it being horz
      north = pics.horz,
      south = pics.horz,
      west = pics.vert,
      east = pics.vert,
    },
    burning_cooldown = 0,

    mode = "heat-fluid-inside",
    energy_consumption = pow,
    energy_source = {
      type = "electric",
      buffer_capacity = pow,
      usage_priority = "secondary-input",
      drain = "100kW",
    },
    fluid_box = {
      volume = 1,
      pipe_covers = pipecoverspictures(),
      production_type = "input-output",
      pipe_connections = {
        {
          direction = defines.direction.west,
          position = {-5, 0},
        },
        {
          direction = defines.direction.east,
          position = {5, 0},
        },
      },
      filter = "particle-stream",
    },
    -- unused, but the game still needs it?
    output_fluid_box = { volume = 1, pipe_connections = {} },
  } }
end

-- containment coils
do
  local function coil_base(cfg)
    local sprite_horz = {
      filename = cfg.horz_filename,
      size = cfg.ani_size,
      scale = 0.5,
    }
    local sprite_vert = {
      filename = cfg.vert_filename,
      size = { cfg.ani_size[2], cfg.ani_size[1] },
      scale = 0.5,
    }
    return {
      type = "storage-tank",
      name = cfg.name,
      flags = {"placeable-neutral", "placeable-player", "player-creation"},
      minable = { mining_time=1, result=cfg.name },
      icon = cfg.icon,

      collision_box = Area.new(cfg.box):shrink(0.1),
      selection_box = cfg.box,

      fluid_box = {
        volume = 50,
        filter = "particle-stream",
        pipe_covers = pipecoverspictures(),
        pipe_connections = cfg.pipe_connections,
      },

      window_bounding_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
      flow_length_in_ticks = 64,
      pictures = {
        picture = {
          north = sprite_horz,
          south = sprite_horz,
          west = sprite_vert,
          east = sprite_vert,
        }
      }
    }
  end

  data:extend{
    coil_base{
      name = "containment-coil-c",
      box = { {-1.5, -3.5}, { 1.5, 3.5 } },
      icon = "__base__/graphics/icons/fluid/steam.png",
      horz_filename = "__petraspace__/graphics/entities/containment-coil/c-horz.png",
      vert_filename = "__petraspace__/graphics/entities/containment-coil/c-vert.png",
      ani_size = { 192, 448 },
      pipe_connections = {
        {
          direction = defines.direction.west,
          position = { -1, -2 },
        },
        {
          direction = defines.direction.west,
          position = { -1, 2 },
        },
      }
    },
    coil_base{
      name = "containment-coil-l",
      box = { {-1.5, -1.5}, { 1.5, 1.5 } },
      icon = "__base__/graphics/icons/fluid/steam.png",
      ani_size = { 192, 192 },
      horz_filename = "__petraspace__/graphics/entities/containment-coil/l.png",
      vert_filename = "__petraspace__/graphics/entities/containment-coil/l.png",
      pipe_connections = {
        {
          direction = defines.direction.north,
          position = { 0, -1 },
        },
        {
          direction = defines.direction.east,
          position = { 1, 0 },
        },
      }
    },
  }
end

data:extend{ {
  type = "assembling-machine",
  name = "irradiation-chamber",
  collision_box = {{-3.4, -3.4}, {3.4, 3.4}},
  selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
  minable = {mining_time=5, result = "irradiation-chamber"},
  crafting_speed = 1,
  crafting_categories = { "particle-irradiation" },
  energy_usage = (particle_specific_heat * 1e6 * 10).."W",
  allowed_effects = { "speed", "productivity", "consumption", "pollution", "quality" },
  energy_source = {
    type = "fluid",
    burns_fluid = false,
    scale_fluid_usage = false,
    -- this much plasma per tick as long as it's at a million degrees
    fluid_usage_per_tick = 1,
    maximum_temperature = 1e6,
    fluid_box = {
      volume = 20,
      filter = "particle-stream",
      pipe_connections = {
        { direction = defines.direction.west,  position = {-3, -2 } },
        { direction = defines.direction.west,  position = {-3,  2 } },
        { direction = defines.direction.east,  position = { 3, -2 } },
        { direction = defines.direction.east,  position = { 3,  2 } },
        { direction = defines.direction.north, position = {-2, -3 } },
        { direction = defines.direction.north, position = { 2, -3 } },
        { direction = defines.direction.south, position = {-2,  3 } },
        { direction = defines.direction.south, position = { 2,  3 } },
      },
    },
    drain = "0W",
  },
  graphics_set = {
    animation = {
      filename = "__petraspace__/graphics/entities/irradiation-chamber.png",
      size = { 448, 448 },
      scale = 0.5,
    }
  }
} }
