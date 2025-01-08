data:extend{
  {
    type = "recipe",
    name = "blank-data-card",
    category = "electronics-or-assembling",
    enabled = false,
    ingredients = {
      { type="item", name="processing-unit", amount=5 },
      { type="item", name="low-density-structure", amount=1 },
      -- apparently "copper wire" is the fakse item used to connect cables
      { type="item", name="copper-cable", amount=2 },
    },
    energy_required = 10,
    results = {{ type="item", name="blank-data-card", amount=1 }},
  },
  {
    type = "recipe",
    name = "format-expired-data-card",
    category = "electronics-or-assembling",
    enabled = false,
    ingredients = {{ type="item", name="expired-data-card", amount=1 }},
    -- this is so low because i want you to use the cards, darnit
    results = {{ type="item", name="blank-data-card", amount=1, probability = 0.25 }},
    show_amount_in_title = false,
    allow_quality = false,
    allow_productivity = true,
    icon = "__base__/graphics/icons/checked-green.png",
  },
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
      { type="item", name="blank-data-card", amount=1 },
      { type="item", name="advanced-circuit", amount=1 },
    },
    energy_required = 2,
    results = {{
      type="item", name="orbital-data-card", amount=1,
      percent_spoiled=0.8,
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
      { type="item", name="blank-data-card", amount=1 },
      { type="item", name="electronic-circuit", amount=1 },
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
      { type="item", name="full-muon-trap", amount=10 },
      { type="item", name="blank-data-card", amount=100 },
    },
    results = {
      { type="item", name="subatomic-data-card", amount=100, percent_spoiled=0 }
    },
    auto_recycle = false,
    allow_quality = false,
    allow_productivity = false,
  },
}
