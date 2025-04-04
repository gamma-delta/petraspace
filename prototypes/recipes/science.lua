data:extend{
  {
    type = "recipe",
    name = "data-card-programmer",
    enabled = false,
    ingredients = {
      { type="item", name="precision-optical-component", amount=20 },
      { type="item", name="radar", amount=5 },
      { type="item", name="steel-plate", amount=15 },
      { type="item", name="processing-unit", amount=30 },
    },
    energy_required = 2,
    results = {{
      type="item", name="data-card-programmer", amount=1,
    }},
    allow_productivity = true,
    allow_quality = true,
  },
  {
    type = "recipe-category",
    name = "data-card-programming",
  },
  {
    type = "recipe",
    name = "orbital-data-card-high-pressure",
    category = "data-card-programming",
    enabled = false,
    ingredients = {
      { type="item", name="precision-optical-component", amount=1 },
      { type="item", name="processing-unit", amount=1 },
    },
    energy_required = 2,
    results = {{
      type="item", name="orbital-data-card", amount=1,
    }},
    surface_conditions = {{ property="pressure", min=500 }},
    auto_recycle = false,
    icons = {
      { icon = "__base__/graphics/icons/nauvis.png" },
      { icon = "__petraspace__/graphics/icons/orbital-data-card.png" },
    }
  },
  {
    type = "recipe",
    name = "orbital-data-card-low-pressure",
    category = "data-card-programming",
    enabled = false,
    ingredients = {
      { type="item", name="precision-optical-component", amount=1 },
      { type="item", name="electronic-circuit", amount=2 },
    },
    energy_required = 1,
    results = {{
      type="item", name="orbital-data-card", amount=1,
    }},
    -- this means you can do it in space, Viate, and Aquilo, but not Fulgora
    surface_conditions = {{ property="pressure", max=500 }},
    auto_recycle = false,
    icons = {
      { icon = "__space-age__/graphics/icons/solar-system-edge.png" },
      { icon = "__petraspace__/graphics/icons/orbital-data-card.png" },
    }
  },
  {
    type = "recipe",
    name = "orbital-science-pack",
    enabled = false,
    energy_required = 21,
    ingredients = {
      { type="item", name="orbital-data-card", amount=5 },
      -- for lack of a better idea
      { type="item", name="fast-transport-belt", amount=1 },
      { type="item", name="radar", amount=2 },
    },
    results = {
      { type="item", name="orbital-science-pack", amount=3 },
    },
    allow_productivity = true,
    allow_quality = true,
  },
}

-- Do I want to introduce viate skip? it would be funny.
local spience = data.raw["recipe"]["space-science-pack"]
-- Spience makes 5 of them
spience.ingredients = {
  {type="item", name="space-platform-foundation", amount=1},
  {type="item", name="precision-optical-component", amount=5},
  {type="item", name="heat-pipe", amount=5},
  {type="item", name="rocket-fuel", amount=5},
}
