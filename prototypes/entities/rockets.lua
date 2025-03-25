local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

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
