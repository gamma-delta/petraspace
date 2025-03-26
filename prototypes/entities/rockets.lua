local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local function rocket_part_recipe(gravity)
  -- Nauvis at 10m/s^2 is our baseline.
  local default_fuel = 100
  local real_fuel = default_fuel / 10 * gravity
  return {
    type = "recipe",
    name = "ps-rocket-part-gravity-" .. gravity,
    energy_required = 3,
    -- CBA to have the right technology unlock all of it.
    -- If you have a rocket silo you can craft it
    enabled = true,
    hide_from_player_crafting = true,
    auto_recycle = false,
    hidden = true,
    category = "rocket-building",
    ingredients =
    {
      {type = "item", name = "processing-unit", amount = 1},
      {type = "item", name = "low-density-structure", amount = 1},
      {type = "item", name = "precision-optical-component", amount = 1},
      {type = "fluid", name = "thruster-fuel", amount = real_fuel, fluidbox_index = 1},
      {type = "fluid", name = "thruster-oxidizer", amount = real_fuel, fluidbox_index = 2},
    },
    results = {{type="item", name="rocket-part", amount=1}},
    allow_productivity = true,
    localised_name = {
      "",
      {"item-name.rocket-part"},
      " (",
      {"surface-property-name.gravity"},
      " = ",
      {"surface-property-unit.gravity", tostring(gravity)},
      ")"
    }
  }
end
local all_gravities = {}
for _,planet in pairs(data.raw["planet"]) do
  all_gravities[planet.surface_properties.gravity or 10] = true
end
for gravi,_ in pairs(all_gravities) do
  data:extend{ rocket_part_recipe(gravi) }
end

-- Edit some rocket silo stuff here, not in data-updates,
-- so i can clone the edited version into the lunar one
local vanilla_rocket = data.raw["rocket-silo"]["rocket-silo"]
vanilla_rocket.fluid_boxes_off_when_no_fluid_recipe = false
vanilla_rocket.fluid_boxes = {
  -- Fuel
  {
    production_type = "input",
    volume = 1000,
    pipe_picture = assembler2pipepictures(),
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
      { flow_direction="input", direction = defines.direction.south, position = {-1, 4} },
      { flow_direction="input", direction = defines.direction.north, position = {1, -4} },
      { flow_direction="input", direction = defines.direction.west, position = {-4, 1} },
      { flow_direction="input", direction = defines.direction.east, position = {4, -1} }
    },
  },
  -- Oxidizer
  {
    production_type = "input",
    volume = 1000,
    pipe_picture = assembler2pipepictures(),
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
      { flow_direction="input", direction = defines.direction.south, position = {1, 4} },
      { flow_direction="input", direction = defines.direction.north, position = {-1, -4} },
      { flow_direction="input", direction = defines.direction.west, position = {-4, -1} },
      { flow_direction="input", direction = defines.direction.east, position = {4, 1} }
    },
  }
}
-- Update it via script later
vanilla_rocket.fixed_recipe = nil

data:extend{
  -- Make this a new entity so we can listen for it in events
  Table.merge(
    Data.Util.duplicate("cargo-pod", "cargo-pod", "lunar-cargo-pod"),
    {}
  ),
  Table.merge(
    Data.Util.duplicate("rocket-silo-rocket", "rocket-silo-rocket", "lunar-rocket-rsr"),
    {
      cargo_pod_entity = "lunar-cargo-pod",
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "rocket-silo", "lunar-rocket-silo"),
    {
      place_result = "lunar-rocket-silo",
    }
  ),
  Table.merge(
    Data.Util.duplicate("rocket-silo", "rocket-silo", "lunar-rocket-silo", "lunar-rocket-silo"),
    {
      surface_conditions = {{property = "gravity", min = 1}},
      -- always launches "to the moon"
      launch_to_space_platforms = false,
      rocket_entity = "lunar-rocket-rsr",
      -- for testing
      rocket_parts_required = 1,
    }
  ),
}
