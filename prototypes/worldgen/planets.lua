local pmg = require("__petraspace__/prototypes/worldgen/planet-map-gen")

local effects = require("__core__.lualib.surface-render-parameter-effects")

data:extend{
  {
    type = "noise-expression",
    name = "viate_starting_area_radius",
    expression = "0.15",
  },
  {
    type = "noise-expression",
    name = "viate_elevation",
    local_expressions = {
      -- factorio devs document noise expressions challenge
      -- todo: this sucks
      main = [[ voronoi_pyramid_noise{
        x=x+1000, y=y+1000,
        seed0 = map_seed,
        seed1 = 0,
        grid_size = 300,
        distance_type = "manhattan",
        jitter = 0.1
      } ]],
      extra = [[ basis_noise{
        x=x, y=y,
        seed0 = map_seed, seed1 = 0,
        input_scale = 0.02
      } ]]
    },
    expression = "main",
  },
  {
    type = "noise-expression",
    name = "viate_cliff_placing",
    -- no tau :<
    expression = [[
      (max(
        cos(2*pi*(viate_elevation-cliff_elevation_0)/cliff_elevation_interval) - 0.8,
      0) * 5) ^ 10]],
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

