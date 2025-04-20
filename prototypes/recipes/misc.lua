local function poc_recipe(hi_pressure)
  local name = hi_pressure and "high-pressure" or "low-pressure"
  local pressure_bound = hi_pressure and "min" or "max"
  local icon_under = hi_pressure 
    and "__base__/graphics/icons/nauvis.png"
    or "__space-age__/graphics/icons/solar-system-edge.png" 

  return {
    type = "recipe",
    name = "precision-optical-component-" .. name,
    -- it would probably just be bloat to add a "vacuum craftinginator"
    category = "advanced-crafting",
    enabled = false,
    -- i want your first craft of this on Viate to feel REALLY GOOD AND FAST
    -- therefore, the space recipe can't be *too* complicated, so you get to it soon.
    energy_required = hi_pressure and 20 or 4,
    ingredients = {
      { type="item", name="advanced-circuit", amount=5 },
      { type="item", name="solar-panel", amount=1 },
      -- it's funny to me
      { type="item", name="small-lamp", amount=5 },
      -- mostly to make heavy oil used for SOMETHING
      hi_pressure and { type="fluid", name="heavy-oil", amount=50 } or nil,
    },
    results = {
      { type="item", name="precision-optical-component", amount=4 },
    },
    allow_productivity = true,
    allow_quality = true,
    auto_recycle = hi_pressure,
    surface_conditions = {{property="pressure", [pressure_bound]=500}},
    icons = {
      { icon = icon_under },
      { icon = "__petraspace__/graphics/icons/precision-optical-component.png" },
    }
  }
end
data:extend{
  poc_recipe(true),
  poc_recipe(false),
}

data:extend{
  {
    type = "recipe",
    name = "lunar-rocket-silo",
    category = "advanced-crafting",
    enabled = false,
    energy_required = 30,
    ingredients = {
      {type="item", name="concrete", amount=1000},
      {type="item", name="electric-engine-unit", amount=200},
      {type="item", name="pipe", amount=100},
      {type="item", name="processing-unit", amount=200},
      -- Split steel/aluminum 50-50
      {type="item", name="steel-plate", amount=500},
      {type="item", name="aluminum-plate", amount=500},
    },
    results = {{type="item", name="lunar-rocket-silo", amount=1}},
    allow_productivity = true,
    allow_quality = true,
  },
}
