-- Fiddle with scrapping
-- The objective is to make iron much rarer.
-- (although you really don't need that much Fe on Fulgora)
-- Og probs: 20 7 6 5 4 4 4 3 3 2 1 1
local scrapping = data.raw["recipe"]["scrap-recycling"]
scrapping.results = {
  {type="item", name="stone", amount=1, probability=0.20},
  {type="item", name="concrete", amount=1, probability=0.07},
  {type="item", name="ice", amount=1, probability=0.06},
  {type="item", name="steel-plate", amount=1, probability=0.05},
  {type="item", name="car", amount=1, probability=0.04},
  {type="item", name="battery", amount=1, probability=0.04},
  {type="item", name="substation", amount=1, probability=0.03},
  {type="item", name="precision-optical-component", amount=1, probability=0.03},
  {type="item", name="copper-cable", amount=1, probability=0.03},
  {type="item", name="processing-unit", amount=1, probability=0.02},
  {type="item", name="low-density-structure", amount=1, probability=0.01},
  {type="item", name="holmium-ore", amount=1, probability=0.01},
  -- TODO: archaeological find
}

data:extend{
  {
    type = "recipe-category",
    name = "particle-trap",
  },
  {
    type = "recipe",
    name = "antimatter-magnetic-bottle",
    category = "particle-trap",
    enabled = false,
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
    enabled = false,
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
