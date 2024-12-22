local Table = require("__stdlib2__/stdlib/utils/table")

local pmg = require("__petraspace__/prototypes/worldgen/planet-map-gen")
local effects = require("__core__.lualib.surface-render-parameter-effects")

data:extend{
  {
    type = "noise-expression",
    name = "viate_starting_area_radius",
    expression = "0.15",
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
      -- Use voronoise to outline the basic basins.
      -- https://catlikecoding.com/unity/tutorials/pseudorandom-noise/voronoi-noise/
      voronoi = [[ voronoi_spot_noise{
        x=x+1000, y=y+1000,
        seed0=map_seed, seed1="voronoi",
        grid_size = 150,
        distance_type = "euclidean",
        jitter = 0.7
      } ]],
      -- keep params the same so that the cells are in the same place
      voronoi_cells = [[ voronoi_cell_id{
        x=x+1000, y=y+1000,
        seed0=map_seed, seed1="voronoi",
        grid_size = 150,
        distance_type = "euclidean",
        jitter = 0.7
      } ]],
      basins = [[
        max(5, 20 + (voronoi * voronoi_cells))
      ]],
      canals = [[ min(0, -(0.2-abs(basis_noise{
        x=x, y=y,
        seed0=map_seed, seed1="canals",
        input_scale = 0.02
      }))) ]],
      ridges = [[ max(0, 0.4-abs(basis_noise{
        x=x, y=y,
        seed0=map_seed, seed1="ridges",
        input_scale = 0.07
      })) / 8 ]],
    },
    expression = "basins + canals + ridges",
  },
  {
    -- Used for highlands
    type = "noise-expression",
    name = "viate_roughness",
    expression = [[ basis_noise{
      x=x, y=y/7,
      seed0=map_seed, seed1='roughness',
      input_scale = 0.3
    } ]]
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

