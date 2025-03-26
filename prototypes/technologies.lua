local Table = require("__stdlib2__/stdlib/utils/table")

local icons = require("__petraspace__/prototypes/icons")

local function science(s)
  local mapping = {
    r = { "automation-science-pack", 1 },
    g = { "logistic-science-pack", 1 },
    b = { "chemical-science-pack", 1 },
    m = { "military-science-pack", 1 },
    o = { "orbital-science-pack", 1 },
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
    name = "orbital-science-pack",
    icon = "__petraspace__/graphics/technologies/orbital-science-pack.png",
    icon_size = 256,
    prerequisites = { "low-density-structure", "laser" },
    unit = {
      count = 500,
      ingredients = science("rgb"),
      time = 60,
    },
    effects = { 
      recipe("data-card-programmer"),
      recipe("orbital-data-card-high-pressure"),
      recipe("orbital-science-pack"),
    },
  },
  {
    type = "technology",
    name = "discover-viate",
    icon = "__space-age__/graphics/technology/vulcanus.png",
    icon_size = 256,
    prerequisites = { "orbital-science-pack" },
    unit = {
      count = 1000,
      ingredients = science("rgbo"),
      time = 60,
    },
    effects = { 
      {
        type = "unlock-space-location",
        space_location = "viate",
        -- dunno what this does
        use_icon_overlay_constant = true,
      }
    },
  },
-- === Aluminum === --
-- TODO: do i do this as a tip and trick?
  {
    type = "technology",
    name = "bauxite-hint",
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    icon_size = 64,
    prerequisites = { "electric-mining-drill" },
    effects = {},
    research_trigger = {
      type = "mine-entity",
      entity = "bauxite-ore",
    },
  },
  {
    type = "technology",
    name = "simple-bauxite-extraction",
    -- TODO
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    icon_size = 64,
    prerequisites = {"sulfur-processing", "bauxite-hint"},
    unit = {
      count = 150,
      ingredients = science("rgb"),
      time = 30,
    },
    effects = {
      recipe("simple-bauxite-extraction"),
      recipe("native-aluminum-to-plate"),
    },
  },
  {
    type = "technology",
    name = "advanced-bauxite-extraction",
    icon = "__petraspace__/graphics/icons/fluid/molten-aluminum.png",
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
      recipe("casting-low-density-structure"),
    },
  }
}
