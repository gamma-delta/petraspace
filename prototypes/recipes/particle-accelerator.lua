data:extend{
  {
    type = "recipe-category",
    name = "particle-trap",
  },
  {
    type = "recipe",
    name = "antimatter-magnetic-bottle",
    category = "particle-trap",
    enabled = true,
    energy_required = 1,
    ingredients = {
      { type="item", name="holmium-ore", amount=10, },
      { type="item", name="supercapacitor", amount=5 },
      { type="fluid", name="electrolyte", amount=100, fluidbox_index=1 },
    },
    results = {
      { type="item", name="antimatter-magnetic-bottle", amount=1 }
    },
    auto_recycle = false,
    allow_quality = false,
    allow_productivity = false,
  },
  {
    type = "recipe",
    name = "refresh-magnetic-bottle",
    category = "electromagnetics",
    enabled = true,
    icon = "__petraspace__/graphics/icons/refresh-magnetic-bottle.png",
    energy_required = 0.5,
    ingredients = {
      { type="item", name="antimatter-magnetic-bottle", amount=1 },
      { type="item", name="supercapacitor", amount=1 },
      { type="fluid", name="electrolyte", amount=100 },
    },
    results = {
      { type="item", name="antimatter-magnetic-bottle", amount=1, percent_spoiled=0 }
    },
    auto_recycle = false,
    allow_quality = false,
    allow_productivity = false,
  },
}
