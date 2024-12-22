local Table = require("__stdlib2__/stdlib/utils/table")

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

-- Make sure that the labs can actually take all of this stuff
for _,lab in pairs(data.raw["lab"]) do
  Table.merge(lab.inputs, {"orbital-science-pack"}, true)
end

data:extend{
-- === Data cards === --
  {
    type = "technology",
    name = "data-cards",
    icon = "__petraspace__/graphics/icons/blank-data-card.png",
    icon_size = 64,
    prerequisites = { "advanced-circuit" },
    unit = {
      count = 200,
      ingredients = science("rgb"),
      time = 30,
    },
    effects = { recipe("blank-data-card"), recipe("format-expired-data-card") },
  },
  {
    type = "technology",
    name = "orbital-science-pack",
    icon = "__petraspace__/graphics/technologies/orbital-science-pack.png",
    icon_size = 256,
    prerequisites = { "data-cards", "low-density-structure" },
    unit = {
      count = 500,
      ingredients = science("rgb"),
      time = 60,
    },
    effects = { 
      --recipe("orbital-data-collector"),
      recipe("orbital-data-card-high-pressure"),
      recipe("orbital-data-card-low-pressure"),
      recipe("orbital-science-pack"),
    },
  },
-- === Aluminum === --
  {
    type = "technology",
    name = "bauxite-hint",
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
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
    prerequisites = {"sulfur-processing", "bauxite-hint"},
    unit = {
      count = 150,
      ingredients = science("rgb"),
      time = 30,
    },
    effects = {
      recipe("simple-bauxite-extraction"),
      recipe("aluminum-nuggets-to-plates"),
    },
  },
  {
    type = "technology",
    name = "advanced-bauxite-extraction",
    icons = icons.advanced_bauxite,
    icon_size = 64,
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
    },
    effects = {
      recipe("bauxite-liquor"),
      recipe("bauxite-liquor-electrolysis"),
      recipe("casting-aluminum-plate"),
      recipe("casting-aluminum-nugget"),
      recipe("casting-low-density-structure"),
    },
  }
}
