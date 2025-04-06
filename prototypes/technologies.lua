local Table = require("__stdlib2__/stdlib/utils/table")

local icons = require("__petraspace__/prototypes/icons")

local function science(s)
  local mapping = {
    r = "automation-science-pack",
    g = "logistic-science-pack",
    b = "chemical-science-pack",
    m = "military-science-pack",
    o = "orbital-science-pack",
    p = "production-science-pack",
    y = "utility-science-pack",
    s = "space-science-pack",
    M = "metallurgic-science-pack",
    E = "electromagnetic-science-pack",
    A = "agricultural-science-pack",
    C = "cryogenic-science-pack",
    P = "prometheum-science-pack",
  }
  
  local unit = {}
  -- this is so dumb
  local count = 1
  s:gsub(".", function(c)
    local as_num = tonumber(c)
    if as_num then
      count = as_num
    end
    local v = mapping[c]
    if v then
      table.insert(unit, {v, count})
      count = 1
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
  -- Should I do this as a tip and trick?
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
}
-- I wonder why lamp isn't a prereq of optics anymore
local laser = data.raw["technology"]["laser"]
table.insert(laser.prerequisites, "lamp")
-- it doesn't have any effects by default. why include it??
laser.effects = {{type="unlock-recipe", recipe="precision-optical-component-high-pressure"}}

table.insert(data.raw["technology"]["low-density-structure"].prerequisites, "simple-bauxite-extraction")

data:extend{
-- Push into space --
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
      count = 500,
      ingredients = science("2r2g2bo"),
      time = 60,
    },
    effects = { 
      {
        type = "unlock-space-location",
        space_location = "viate",
        -- dunno what this does
        use_icon_overlay_constant = true,
      },
      recipe("ice-melting"),
      recipe("orbital-data-card-low-pressure"),
      recipe("precision-optical-component-low-pressure"),
    }
  },
  {
    type = "technology",
    name = "lunar-rocket-silo",
    -- TODO
    icon = "__space-age__/graphics/technology/vulcanus.png",
    icon_size = 256,
    -- why go up there if you don't know anything
    prerequisites = { "discover-viate" },
    unit = {
      count = 500,
      ingredients = science("2r2g2bo"),
      time = 60,
    },
    effects = { 
      recipe("lunar-rocket-silo"),
      recipe("water-electrolysis"),
      recipe("hydrogen-to-thruster-fuel"),
      recipe("oxygen-to-thruster-oxidizer"),

      recipe("ammonia-synthesis"),
      recipe("ammonia-to-thruster-fuel"),
      recipe("nitric-acid"),
      recipe("nitric-acid-to-thruster-oxidizer"),
      recipe("n2o4-thruster-oxidizer"),
    }
  },
}

data:extend{
  {
    type = "technology",
    name = "discover-regolith",
    icon = "__petraspace__/graphics/technologies/discover-regolith.png",
    prerequisites = { "lunar-rocket-silo" },
    research_trigger = {
      type = "mine-entity",
      entity = "regolith-deposit",
    },
    effects = { 
      recipe("washing-regolith"),
      recipe("dissolving-regolith"),
      recipe("stone-bricks-from-regolith"),
      recipe("concrete-from-regolith"),
    },
  }
}
-- Play with tech costs.
-- To give some fun progress feeling on Viate, make it a trigger tech.
-- I'd rather have it be "melt or mine N ice", but these are both not
-- possible in the trigger system due to WOKE
local tech_cse = data.raw["technology"]["chcs-concentrated-solar-energy"]
tech_cse.prerequisites = {"lunar-rocket-silo"}
tech_cse.unit = nil
tech_cse.research_trigger = {
  type = "mine-entity",
  entity = "ice-deposit",
}

-- Okay so i guess you can skip Viate if you REALLY want to for some godforsaken
-- reason
local tech_vanilla_spience = data.raw["technology"]["space-science-pack"]
tech_vanilla_spience.prerequisites = {"lunar-rocket-silo"}
tech_vanilla_spience.research_trigger = nil
tech_vanilla_spience.unit = {
  count = 1000,
  time = 60,
  ingredients = science("rgbo"),
}
tech_vanilla_spience.effects = { recipe("space-science-pack") }
local tech_vanilla_rocket = data.raw["technology"]["rocket-silo"]
tech_vanilla_rocket.prerequisites = { "space-science-pack" }
tech_vanilla_rocket.unit = {
  count = 1000,
  time = 60,
  ingredients = science("2r2b2g2os"),
}
tech_vanilla_rocket.effects = {
  recipe("rocket-silo"),
  recipe("cargo-landing-pad"),
  recipe("space-platform-foundation"),
  recipe("space-platform-starter-pack"),
}

data:extend{
  -- Each pair of inner planets has its own cool technology.
  -- Fulgora+Vulc already is ... deep oil ocean rails? seems lame.
  -- may play with that.
  -- Fulgora+Gleba is Logi system (complex robotics and swarming behaviors)
  -- Gleba+Vulcanus is ... some kind of productivity probably. Or Fertilizer.
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
      count = 4000,
      ingredients = science("rgbpMEA"),
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
