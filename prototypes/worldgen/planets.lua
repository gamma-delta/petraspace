local Table = require("__stdlib2__/stdlib/utils/table")

local pmg = require("__petraspace__/prototypes/worldgen/planet-map-gen")
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
    category = "resource",
    richness = true,
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
            input_scale = 0.012 * control:viate_spotness:frequency
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
          10
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
    -- Cliffs won't spawn at y=0, so make a HUGE difference in height
    -- and just make the basins really really deep. (see -100 above)
    expression = "50 + basins + canals",
  },
  {
    -- Used for highlands
    type = "noise-expression",
    name = "viate_meteorness",
    local_expressions = {
      meteor_size = [[ basis_noise{
        x=x, y=y, seed0=map_seed, seed1="viate_meteor_size",
        input_scale=0.03
      } + 1 ]],
      -- spot_noise::seed1 does not accept strings
      raw_spots = [[
        spot_noise{
          x=x, y=y, seed0=map_seed, seed1=12345,
          density_expression = 10,
          spot_quantity_expression = 10000 * meteor_size * meteor_size 
            * control:viate_meteors:frequency,
          spot_radius_expression = 100 * meteor_size 
            * control:viate_meteors:richness,
          spot_favorability_expression = 1,
          basement_value = 0,
          maximum_spot_basement_radius = 128,
          region_size = 2048 * control:viate_meteors:size,
          candidate_point_count = 100
        } * 10
      ]],
      flavor = [[
        multioctave_noise{
          x=x, y=y,
          seed0=map_seed, seed1="viate_meteor_flavor",
          persistence=0.7,
          octaves=7,
          input_scale = 0.09
        } * 0.5 + 0.5
      ]]
    },
    expression = "raw_spots * flavor"
  },
  {
    type = "planet",
    name = "viate",
    icon = "__space-age__/graphics/icons/vulcanus.png",
    starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
    starmap_icon_size = 512,
    gravity_pull = 10,
    distance = 10,
    orientation = 0.1,
    magnitude = 1.5,
    order = "d[fulgora]-a",
    subgroup = "planets",
    map_gen_settings = pmg.viate_settings(),
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

-- Post fixups so I can truly make per-planet recipes
local planet_names = Table.map(
  data.raw["planet"],
  function(p) return p.name end
)

for _,planet in pairs(data.raw["planet"]) do
  for _,planet_name in ipairs(planet_names) do
    local amount
    if planet.name == planet_name then
      amount = 1
    else
      amount = 0
    end
    local quiddity = "is-" .. planet.name
    planet.surface_properties[quiddity] = 1.0
  end
end

