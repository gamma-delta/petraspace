local Table = require("__stdlib2__/stdlib/utils/table")

local effects = require("__core__.lualib.surface-render-parameter-effects")

data:extend{
  {
    type = "noise-expression",
    name = "viate_starting_area_radius",
    expression = "0.15",
  },
  {
    type = "autoplace-control",
    -- size = 0 value
    -- frequency = noise scale
    name = "viate_basin",
    category = "terrain",
  },
  {
    type = "autoplace-control",
    name = "viate_spotness",
    category = "terrain",
  },
  {
    type = "autoplace-control",
    name = "viate_meteors",
    category = "terrain",
  },
  -- Cliffs won't spawn at y=0, so make a HUGE difference in height
  -- and just make the basins really really deep.
  {
    type = "noise-expression",
    name = "viate_above_basins",
    expression = "viate_elevation >= 10"
  },
  -- Define everything mostly by elevation
  -- - Large dark basalt basins; little debris, good dust absorption
  -- - Dusty midlands with craters
  -- Elevation>0 is the midlands
  -- TODO use distorted spot noise to create the basins,
  -- with voronoi to do roughness ("distance from meteor impact")
  {
    type = "noise-expression",
    name = "viate_elevation",
    local_expressions = {
      -- so "coverage" in the GUI is actually `size`,
      -- and "scale" is `frequency`??
      -- anyways: use spot noise to create the basins, but mask it on perlin noise
      -- to add some ~interest~
      -- basin_spots and basin_noise both get higher the *more* basin-y it is
      basin_spots = [[
        clamp(
          basis_noise{
            x=x, y=y, seed0=map_seed, seed1="viate_basin_spots",
            input_scale = 0.002 * control:viate_spotness:frequency
          }
          * slider_to_linear(control:viate_spotness:size, 0.7, 2)
          * 2,
        0, 1)
      ]],
      basin_noise = [[
        max(0, multioctave_noise{
          x=x, y=y,
          seed0=map_seed, seed1="viate_basin_noise",
          input_scale = 0.03 * control:viate_basin:frequency,
          persistence = 0.7, octaves = 4
        } - 0.1)
      ]],
      basin_required = "(0.7 / slider_rescale(control:viate_basin:size, 12)) * 0.1",
      -- make the bottoms of the basins REALLY DEEP
      -- to make sure that ice doesn't spawn in the middle
      basins = [[
        if(
          (basin_spots * basin_noise) > basin_required,
          ((basin_spots * basin_noise) - basin_required) * -100,
          0
        )
      ]],
      canals = [[
        lerp(
          (0.4-abs(multioctave_noise{
            x=x, y=y*0.7,
            seed0=map_seed, seed1="canals",
            persistence=0.9,
            octaves=3,
            input_scale = 0.007
          })) * multioctave_noise{
            x=x, y=y,
            seed0=map_seed, seed1="canals2",
            persistence=0.4,
            octaves=2,
            input_scale = 0.004
          },
          0, -20
        )
      ]],
    },
    expression = "20 + basins",
  },
  {
    type = "noise-expression",
    name = "viate_meteor_size_noise",
    expression = [[ basis_noise{
      x=x, y=y, seed0=map_seed, seed1="viate_meteor_size",
      input_scale=0.03
    } + 1 ]]
  },
  {
    type = "noise-function",
    name = "viate_meteor_spot_noise",
    parameters = { "radius" },
    expression = [[
      spot_noise{
        x=x, y=y, seed0=map_seed, seed1=12345,
        density_expression = 1000000,
        spot_quantity_expression = viate_meteor_size_noise^2
          * 10000,
        spot_radius_expression = radius,
        spot_favorability_expression = 1,
        basement_value = 0,
        maximum_spot_basement_radius = 300,
        region_size = 512,
        candidate_point_count = 20,
        suggested_minimum_candidate_point_spacing = 100
      } * 5
    ]]
  },
  {
    type = "noise-expression",
    name = "viate_meteorness",
    local_expressions = {
      -- spot_noise::seed1 does not accept strings
      raw_spots = [[ viate_meteor_spot_noise(
        70 * viate_meteor_size_noise
      ) ]],
      flavor = [[
        multioctave_noise{
          x=x, y=y,
          seed0=map_seed, seed1="viate_meteor_flavor",
          persistence=0.5,
          octaves=7,
          input_scale = 0.09
        } * 0.4 + 0.6
      ]]
    },
    expression = "raw_spots * flavor"
  },
  {
    type = "noise-expression",
    name = "viate_meteor_spot",
    -- Use same config as meteors but have a tiny radius,
    -- so that they're spotlike
    expression = [[
      viate_meteor_spot_noise(1)
      >
      slider_to_linear(control:viate_meteors:size, 0, 3)
    ]],
  },
  {
    type = "planet",
    name = "viate",
    icon = "__space-age__/graphics/icons/vulcanus.png",
    starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
    starmap_icon_size = 512,
    map_gen_settings = {
      property_expression_names = {
        elevation = "viate_elevation",

        cliffiness = "cliffiness_basic",
        -- it does not look like you can change this?
        cliff_elevation = "cliff_elevation_from_elevation",
        cliff_smoothing = 0.0,
        richness = 3.5,
      },
      cliff_settings = {
        name = "cliff-viate",
        cliff_elevation_interval = 60,
        cliff_elevation_0 = 10,
      },
      autoplace_controls = {
        ["viate_basin"]={},
        ["viate_spotness"]={},
        ["viate_meteors"]={},
      },
      autoplace_settings = {
        tile = { settings = {
          ["viate-smooth-basalt"] = {},
          ["viate-dust-crests"] = {},
          ["viate-dust-lumpy"] = {},
          ["viate-dust-patchy"] = {},
        } },
        decorative = { settings = {
          ["viate-crust"] = {},
          ["viate-medium-maria-rock"] = {},
          ["viate-small-maria-rock"] = {},
          ["viate-tiny-maria-rock"] = {},
        } },
        entity = { settings = {
          ["ice-deposit"] = {},
          ["viate-meteorite"] = {},
        } },
      }
    },
    gravity_pull = 10,
    distance = 10,
    orientation = 0.1,
    magnitude = 1.5,
    order = "d[fulgora]-a",
    subgroup = "planets",
    pollutant_type = "dust",
    solar_power_in_space = 300,
    platform_procession_set =
    {
      arrival = {"planet-to-platform-b"},
      departure = {"platform-to-planet-a"}
    },
    planet_procession_set =
    {
      arrival = {"platform-to-planet-b"},
      departure = {"planet-to-platform-a"}
    },
    procession_graphic_catalogue = planet_catalogue_vulcanus,
    surface_properties =
    {
      ["day-night-cycle"] = 31 * minute,
      ["solar-power"] = 200,
      pressure = 0,
      gravity = 2,
    },
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = {},
  },
}
