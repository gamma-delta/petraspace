data:extend{
  {
    type = "recipe-category",
    name = "orbital-data-card",
  },
  {
    type = "recipe",
    name = "orbital-data-card-high-pressure",
    category = "orbital-data-card",
    enabled = false,
    ingredients = {
      { type="item", name="low-density-structure", amount=1 },
      { type="item", name="advanced-circuit", amount=1 },
    },
    energy_required = 2,
    results = {{
      type="item", name="orbital-data-card", amount=1,
    }},
    -- this means you can do it in space, Viate, and Aquilo, but not Fulgora
    surface_conditions = {{ property="pressure", min=500 }},
    -- nice try
    allow_productivity = false,
    allow_quality = false,
    icons = {
      { icon = "__base__/graphics/icons/nauvis.png", },
      { icon = "__petraspace__/graphics/icons/orbital-data-card.png", },
    }
  },
  {
    type = "recipe",
    name = "orbital-data-card-low-pressure",
    category = "orbital-data-card",
    enabled = false,
    ingredients = {
      { type="item", name="low-density-structure", amount=1 },
      { type="item", name="electronic-circuit", amount=2 },
    },
    energy_required = 1.5,
    results = {{ type="item", name="orbital-data-card", amount=1 }},
    surface_conditions = {{ property="pressure", max=500 }},
    allow_productivity = false,
    allow_quality = false,
    icons = {
      { icon = "__space-age__/graphics/icons/solar-system-edge.png", },
      { icon = "__petraspace__/graphics/icons/orbital-data-card.png", },
    }
  },

  {
    type = "recipe",
    name = "subatomic-data-card",
    category = "electromagnetics",
    enabled = true,
    energy_required = 2,
    ingredients = {
      { type="item", name="antimatter-magnetic-bottle", amount=10 },
      { type="item", name="processing-unit", amount=100 },
    },
    results = {
      { type="item", name="subatomic-data-card", amount=100, percent_spoiled=0 }
    },
    auto_recycle = false,
    allow_quality = true,
    allow_productivity = true,
  },
}
