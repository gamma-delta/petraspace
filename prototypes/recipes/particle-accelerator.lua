data:extend{
  {
    type = "recipe-category",
    name = "particle-trap",
  },
  {
    type = "recipe",
    name = "full-muon-trap",
    category = "particle-trap",
    enabled = true,
    energy_required = 1,
    ingredients = {
      { type="fluid", name="electrolyte", amount=10, fluidbox_index=1 },
      { type="fluid", name="holmium-solution", amount=10, fluidbox_index=2 },
      { type="item", name="empty-muon-trap", amount=1 },
    },
    results = {
      { type="item", name="full-muon-trap", amount=1 }
    },
    auto_recycle = false,
    allow_quality = false,
    allow_productivity = false,
  },
  {
    type = "recipe",
    name = "refresh-muon-trap",
    category = "electromagnetics",
    enabled = true,
    icon = "__petraspace__/graphics/icons/refresh-muon-trap.png",
    energy_required = 0.5,
    ingredients = {
      { type="item", name="full-muon-trap", amount=1 },
      { type="item", name="supercapacitor", amount=1 },
      { type="fluid", name="electrolyte", amount=100 },
    },
    results = {
      { type="item", name="full-muon-trap", amount=1, percent_spoiled=0 }
    },
    auto_recycle = false,
    allow_quality = false,
    allow_productivity = false,
  },
}
