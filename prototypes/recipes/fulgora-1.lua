local pglobals = require "globals"

-- Fiddle with scrapping
-- The objective is to make iron much rarer.
-- (although you really don't need that much Fe on Fulgora)
-- Og probs: 20 7 6 5 4 4 4 3 3 2 1 1
local function scrapout(name, prob)
  return {
    type = "item",
    name = name,
    amount = 1,
    probability = prob,
    show_details_in_recipe_tooltip = false,
  }
end
local scrapping = data.raw["recipe"]["scrap-recycling"]
scrapping.results = {
  scrapout("stone", 0.20),
  scrapout("concrete", 0.07),
  scrapout("ice", 0.06),
  scrapout("steel-plate", 0.05),
  scrapout("iron-gear-wheel", 0.04),
  scrapout("battery", 0.04),
  scrapout("precision-optical-component", 0.04),
  scrapout("copper-cable", 0.03),
  scrapout("processing-unit", 0.03),
  scrapout("archaeological-scrap", 0.02),
  scrapout("low-density-structure", 0.01),
  scrapout("holmium-ore", 0.01),
}
data:extend{{
  type = "recipe",
  name = "archaeological-scrap-recycling",
  icons = {
    {
      icon = "__quality__/graphics/icons/recycling.png"
    },
    {
      icon = "__petraspace__/graphics/icons/archaeological-scrap/1.png",
      scale = 0.4
    },
    {
      icon = "__quality__/graphics/icons/recycling-top.png"
    }
  },
  category = "recycling",
  subgroup = "fulgora-processes",
  order = "a[trash]-b",
  auto_recycle = false,
  energy_required = 0.2,
  ingredients = {{type="item", name="archaeological-scrap", amount=1}},
  results = {
    scrapout("selector-combinator", 1 / 2),
    scrapout("superconductor", 1 / 4), -- the money shot
    scrapout("programmable-speaker", 1 / 8),
    scrapout("display-panel", 1 / 16),
    scrapout("aluminum-plate", 1 / 32),
    scrapout("low-density-structure", 1 / 64),
    scrapout("car", 1 / 128),
    scrapout("holmium-ore", 1 / 256),
    scrapout("tank", 1 / 512),
    scrapout("requester-chest", 1 / 1024),
    scrapout("personal-roboport-mk2-equipment", 1 / 2048),
    scrapout("battery-mk3-equipment", 1 / 2048),
  }
}}

pglobals.recipe.add("electromagnetic-plant",
  {type="item", name="superconductor", amount=5})
pglobals.recipe.add("lightning-rod", 
  {type="item", name="supercapacitor", amount=2})

-- t2
data:extend{
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
