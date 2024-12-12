data:extend{
  type = "airborne-pollutant",
  name = "dust",
  icon = "__base__/graphics/icons/fluid/steam.png",
  chart_color = { r=100, g=120, b=190, a=140 },
  affects_evolution = false,
  affects_water_tint = false,
}

-- Implement dust slowdown by putting a !!SECRET!! invisible
-- beacon on top of every entity
data:extend{
  type = "beacon",
  name = "dust-secret-beacon",
  energy_usage = "0",
  energy_source = { type="void" },
  supply_area_distance = 0.1,
  distribution_efficiency = 1,
  module_slots = 100,
  allowed_module_categories = "dust-secret-module",

  selectable_in_game = false,
  selection_priority = 0,
  flags = {
    "not-on-map", "not-flammable",
    "no-automated-item-insertion", "no-automated-item-removal",
  },
}

data:extend{
  type = "module-category",
  name = "dust-secret-module",
}
data:extend{
  type = "module",
  name = "dust-secret-module",
  category = "dust-secret-module",
  effect = {
    speed = -0.05,
  }
}
