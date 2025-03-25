data:extend{
  {
    type = "recipe-category",
    name = "data-card-programming",
  },
  {
    type = "recipe",
    name = "orbital-data-card",
    category = "data-card-programming",
    enabled = false,
    ingredients = {
      -- TODO: precision optical components
      { type="item", name="low-density-structure", amount=1 },
      { type="item", name="advanced-circuit", amount=1 },
    },
    energy_required = 2,
    results = {{
      type="item", name="orbital-data-card", amount=1,
    }},
    -- this means you can do it in space, Viate, and Aquilo, but not Fulgora
    surface_conditions = {{ property="pressure", min=500 }},
    icon = "__petraspace__/graphics/icons/orbital-data-card.png"
  }
}
