local icons = require("__petraspace__/prototypes/icons")

local function science(s)
  local mapping = {
    r = { "automation-science-pack", 1 },
    g = { "logistic-science-pack", 1 },
    b = { "chemical-science-pack", 1 },
    m = { "military-science-pack", 1 },
    p = { "production-science-pack", 1 },
    y = { "utility-science-pack", 1 },
    s = { "space-science-pack", 1 },
    M = { "metallurgic-science-pack", 1 },
    E = { "electromagnetic-science-pack", 1 },
    A = { "agricultural-science-pack", 1 },
    C = { "cryogenic-science-pack", 1 },
    P = { "prometheum-science-pack", 1 },
  }
  
  local unit = {}
  s:gsub(".", function(c)
    local v = mapping[c]
    if v then
      table.insert(unit, v)
    end
  end)
  return unit
end

local function recipe(name)
  return { type="unlock-recipe", recipe=name }
end

data:extend{
  {
    type = "technology",
    name = "bauxite-hint",
    icon = "__petraspace__/graphics/icons/bauxite-1.png",
    icon_size = 64,
    effects = {},
    research_trigger = {
      type = "mine-entity",
      entity = "bauxite-ore",
    },
  },
  {
    type = "technology",
    name = "simple-bauxite-extraction",
    icons = icons.simple_bauxite,
    icon_size = 64,
    effects = {
      recipe("simple-bauxite-extraction"),
      recipe("aluminum-nuggets-to-plates"),
    },
    prerequisites = {"sulfur-processing", "bauxite-hint"},
    unit = {
      count = 150,
      ingredients = science("rgb"),
      time = 30,
    },
  },
  {
    type = "technology",
    name = "advanced-bauxite-extraction",
    icons = icons.advanced_bauxite,
    icon_size = 64,
    effects = {
      recipe("bauxite-to-liquor"),
      recipe("bauxite-liquor-electrolysis"),
      recipe("casting-aluminum-plate"),
      recipe("casting-aluminum-nugget"),
      recipe("casting-low-density-structure"),
    },
    prerequisites = {
      "simple-bauxite-extraction",
      "metallurgic-science-pack",
      "electromagnetic-science-pack",
      "carbon-fiber",
    },
    unit = {
      count = 1500,
      ingredients = science("rgbpsMEA"),
      time = 60,
    }
  }
}

local foundry_tech = data.raw["technology"]["foundry"]
for i, v in ipairs(foundry_tech.effects) do
  if v.type == "unlock-recipe" and v.recipe == "casting-low-density-structure" then
    table.remove(foundry_tech.effects, i)
    break
  end
end
