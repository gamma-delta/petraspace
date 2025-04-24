local pglobals = require "globals"

data:extend{
  {
    type = "recipe",
    name = "boompuff-processing",
    icons = pglobals.icons.one_into_two(
      "__petraspace__/graphics/icons/boompuff-propagule.png",
      "__space-age__/graphics/icons/fluid/ammonia.png",
      "__petraspace__/graphics/icons/fluid/molecule-hydrogen.png"
    ),
    category = "organic",
    subgroup = "agriculture-processes",
    order = "a[seeds]-z",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 1,
    ingredients = {{type="item", name="boompuff-propagule", amount=1}},
    results = {
      {type="fluid", name="ammonia", amount=50},
      {type="fluid", name="hydrogen", amount=10},
      {type="item", name="spoilage", amount=4},
    },
    -- Same as boompuff agriculture tower color
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  -- NITRIFICATION!!!!!!!!
  {
    type = "recipe",
    name = "nitrogen-fixation",
    icons = pglobals.icons.three_into_one(
      "__space-age__/graphics/icons/fluid/ammonia.png",
      "__space-age__/graphics/icons/spoilage.png",
      "__space-age__/graphics/icons/iron-bacteria.png",
      "__petraspace__/graphics/icons/fluid/molecule-nitric-acid.png"
    ),
    category = "organic",
    subgroup = "agriculture-processes",
    order = "a[organic-processes]-z-a[nitrogen-fixation]",
    enabled = false,
    allow_productivity = true,
    energy_required = 7,
    ingredients = {
      -- IRL, the bio-catalyst used for this contains iron!
      -- or magnesium, or vanadium.
      -- Of course IRL soil-fixing bacteria make ammonia, not nitric acid,
      -- but what can I do
      {type="item", name="iron-bacteria", amount=1},
      {type="item", name="spoilage", amount=50},
      {type="fluid", name="ammonia", amount=30},
    },
    results = {
      -- Maybe you get more nitrogen out of the atmosphere idk
      {type="fluid", name="nitric-acid", amount=50},
      {type="item", name="iron-bacteria", amount_min=0, amount_max=2},
    },
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  {
    type = "recipe",
    name = "fertilizer",
    icon = "__petraspace__/graphics/icons/fertilizer.png",
    category = "organic",
    subgroup = "agriculture-products",
    order = "c[nutrients]-z-a[fertilizer]",
    enabled = false,
    allow_productivity = true,
    energy_required = 10,
    ingredients = {
      {type="fluid", name="ammonia", amount=50},
      {type="fluid", name="nitric-acid", amount=50},
      {type="item", name="nutrients", amount=20},
    },
    results = {{type="item", name="fertilizer", amount=10}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  {
    type = "recipe",
    name = "anje-explosives",
    icons = pglobals.icons.two_into_one(
      "__petraspace__/graphics/icons/fluid/molecule-nitric-acid.png",
      "__space-age__/graphics/icons/jelly.png",
      "__base__/graphics/icons/explosives.png"
    ),
    category = "organic",
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-b[anje-explosives]",
    enabled = false,
    allow_productivity = true,
    energy_required = 4,
    -- "Fuel oil" (light oil?) is hard to get on Glorbo
    -- I'll use jelly as equivalent exchange with the rocket fuel recipe
    -- removing it
    ingredients = {
      {type="item", name="fertilizer", amount=2},
      {type="item", name="jelly", amount=1},
    },
    results = {{type="item", name="explosives", amount=5}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  {
    type = "recipe",
    name = "presto-fuel",
    category = "chemistry-or-cryogenics",
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-d[presto-fuel]",
    enabled = false,
    allow_productivity = true,
    energy_required = 25,
    ingredients = {
      {type="item", name="wood", amount=5},
      {type="item", name="coal", amount=5},
      {type="item", name="boompuff-propagule", amount=10},
      {type="fluid", name="thruster-fuel", amount=20},
      {type="fluid", name="nitric-acid", amount=20},
    },
    results = {{type="item", name="presto-fuel", amount=1}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
}
-- just like the original prototype!
-- jellynt
-- This does mean jelly is used for even less :<
-- they'll figure it out
local vanilla_gleba_rocketfuel = data.raw["recipe"]["rocket-fuel-from-jelly"]
vanilla_gleba_rocketfuel.icon = nil
vanilla_gleba_rocketfuel.icons = pglobals.icons.two_into_one(
  "__space-age__/graphics/icons/bioflux.png",
  "__petraspace__/graphics/icons/boompuff-propagule.png",
  "__base__/graphics/icons/rocket-fuel.png"
)
vanilla_gleba_rocketfuel.ingredients[2] = {
  type="item", name="boompuff-propagule", amount=5,
}
