local pglobals = require "globals"
local util = require "__core__/lualib/util"

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
  table.insert(lab.inputs, "orbital-science-pack")
end

-- Move fluid mining all the way to the beginning of the game
local fluid_mining = data.raw["technology"]["uranium-mining"]
fluid_mining.icon = "__petraspace__/graphics/technologies/fluid-mining.png"
fluid_mining.prerequisites = {"electric-mining-drill"}
fluid_mining.unit = {
  count = 30,
  ingredients = science("r"),
  time = 10,
}
-- TODO: bump uranium processing to later in the tech tree.
-- Fiddling with this now because it feels ugly, but will work on it more later
data.raw["technology"]["uranium-processing"].prerequisites = {
  "uranium-mining",
  "chemical-science-pack",
}

table.insert(data.raw["technology"]["electronics"].effects, recipe("circuit-substrate-stone"))
table.insert(data.raw["technology"]["electronics"].effects, recipe("circuit-substrate-wood"))
table.insert(data.raw["technology"]["plastics"].effects, recipe("circuit-substrate-plastic"))

table.insert(
  data.raw["technology"]["logistic-science-pack"].prerequisites,
  "steel-processing"
)

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
table.insert(laser.prerequisites, "solar-energy")
-- it doesn't have any effects by default. why include it??
laser.effects = {{type="unlock-recipe", recipe="precision-optical-component-high-pressure"}}

-- So why the hell can you research laser upgrades BEFORE
-- laser turrets?
table.insert(
  data.raw["technology"]["laser-shooting-speed-1"].prerequisites,
  "laser-turret"
)
table.insert(
  data.raw["technology"]["laser-weapons-damage-1"].prerequisites,
  "laser-turret"
)

table.insert(data.raw["technology"]["low-density-structure"].prerequisites, "simple-bauxite-extraction")

data:extend{
-- Push into space --
  {
    type = "technology",
    name = "orbital-science-pack",
    icon = "__petraspace__/graphics/technologies/orbital-science-pack.png",
    icon_size = 256,
    prerequisites = { "low-density-structure", "laser", "processing-unit" },
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
    name = "rocket-propellants",
    icon = "__petraspace__/graphics/technologies/electrolysis.png",
    icon_size = 1024,
    prerequisites = { "orbital-science-pack" },
    unit = {
      count = 250,
      ingredients = science("2r2g2bo"),
      time = 60,
    },
    effects = {
      recipe("water-electrolysis"),
      recipe("thruster-fuel-from-hydrogen"),
      recipe("thruster-oxidizer-from-oxygen"),
      recipe("thruster-fuel-from-rocket-fuel"),
    }
  },
  {
    type = "technology",
    name = "nitric-propellants",
    icon = "__petraspace__/graphics/technologies/nitric-propulsion.png",
    icon_size = 1024,
    prerequisites = { "rocket-propellants" },
    unit = {
      count = 100,
      ingredients = science("rg4bo"),
      time = 60,
    },
    effects = {
      recipe("ammonia-synthesis"),
      recipe("thruster-fuel-from-ammonia"),
      recipe("nitric-acid"),
      recipe("thruster-oxidizer-from-nitric-acid"),
      -- recipe("n2o4-thruster-oxidizer"),
    }
  },
  {
    type = "technology",
    name = "thermodynamics",
    icon = "__petraspace__/graphics/technologies/thermodynamics.png",
    icon_size = 256,
    prerequisites = { "chemical-science-pack" },
    unit = {
      count = 300,
      ingredients = science("rgb"),
      time = 30,
    },
    effects = {
      recipe("heating-tower"),
      recipe("heat-pipe"),
      recipe("heat-exchanger"),
      recipe("steam-turbine"),
    }
  },
  {
    type = "technology",
    name = "discover-viate",
    -- TODO fix this
    icons = PlanetsLib.technology_icon_moon("__petraspace__/graphics/icons/space-location/viate.png", 2048),
    localised_description = {"space-location-description.viate"},
    prerequisites = { 
      "orbital-science-pack",
      "rocket-propellants", "electric-engine", "concrete",
      "thermodynamics",
    },
    unit = {
      count = 300,
      ingredients = science("rgb2o"),
      time = 60,
    },
    effects = {
      {
        type = "unlock-space-location",
        space_location = "viate",
        -- dunno what this does
        use_icon_overlay_constant = true,
      },
      recipe("lunar-rocket-silo"),
      -- recipe("ice-melting"),
      recipe("orbital-data-card-low-pressure"),
      recipe("precision-optical-component-low-pressure"),
    }
  },
}

-- Welcome to Viate
data:extend{
  {
    type = "technology",
    name = "discover-regolith",
    icon = "__petraspace__/graphics/technologies/discover-regolith.png",
    -- Weird size
    icon_size = 968,
    prerequisites = { "discover-viate" },
    research_trigger = {
      type = "mine-entity",
      entity = "regolith-deposit",
    },
    effects = { 
      recipe("washing-regolith"),
      recipe("dissolving-regolith"),
      recipe("stone-bricks-from-regolith"),
    },
  }
}
-- Play with tech costs.
-- To give some fun progress feeling on Viate, make it a trigger tech.
-- I'd rather have it be "melt or mine N ice", but these are both not
-- possible in the trigger system due to WOKE
local tech_cse = data.raw["technology"]["chcs-concentrated-solar-energy"]
tech_cse.prerequisites = {"discover-viate"}
tech_cse.unit = nil
tech_cse.research_trigger = {
  type = "mine-entity",
  entity = "ice-deposit",
}
tech_cse.effects = {
  recipe("chcs-solar-power-tower"),
  recipe("chcs-heliostat-mirror"),
  recipe("ice-melting"),
}

local tech_vanilla_spience = data.raw["technology"]["space-science-pack"]
tech_vanilla_spience.prerequisites = {"discover-viate"}
tech_vanilla_spience.research_trigger = nil
tech_vanilla_spience.unit = {
  count = 1000,
  time = 60,
  ingredients = science("rgbo"),
}
tech_vanilla_spience.effects = { recipe("space-science-pack") }
-- SPACE AGE!
data:extend{
  {
    type = "technology",
    name = "dust-spraydown",
    -- TODO
    icon = "__petraspace__/graphics/technologies/thermodynamics.png",
    icon_size = 256,
    prerequisites = { "space-science-pack" },
    unit = { count = 50, time = 10, ingredients = science("s") },
    effects = {
      recipe("dust-sprayer"),
      recipe("dust-spraydown-water"),
    },
  },
}

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
local tech_vanilla_splatform = data.raw["technology"]["space-platform"]
tech_vanilla_splatform.effects = {
  recipe("cargo-bay"),
  recipe("thruster"),
  recipe("empty-platform-tank"),
  recipe("platform-fuel-tank"),
  recipe("platform-oxidizer-tank"),
}
for _,planet_tech in ipairs{"vulcanus", "fulgora", "gleba"} do
  local tech = data.raw["technology"]["planet-discovery-" .. planet_tech]
  tech.prerequisites[1] = "space-platform"
end
local vanilla_thruster_tech = data.raw["technology"]["space-platform-thruster"]
vanilla_thruster_tech.enabled = false
vanilla_thruster_tech.visable_when_disabled = false

-- Vulcanus I
pglobals.tech.remove_unlock("foundry", "casting-low-density-structure")

-- Gleba I
-- Strike out coal synth and good sulfur
pglobals.tech.remove_unlock("rocket-turret", "coal-synthesis")
pglobals.tech.remove_unlock("bioflux-processing", "biosulfur")

table.insert(data.raw["technology"]["bacteria-cultivation"].effects, 
  recipe("light-oil-reforming"))
table.insert(data.raw["technology"]["bacteria-cultivation"].effects, 
  recipe("heavy-oil-reforming"))

data:extend{
  {
    type = "technology",
    name = "boompuff",
    icon = "__petraspace__/graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="boompuff-processing" },
    },
    prerequisites = {"agriculture"},
    research_trigger = {
      type = "mine-entity",
      entity = "boompuff",
    }
  },
  {
    type = "technology",
    name = "fertilizer",
    -- TODO
    icon = "__petraspace__/graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="fertilizer" },
    },
    prerequisites = {"agricultural-science-pack"},
    unit = {
      count = 1000,
      ingredients = science("rgbyA"),
      time = 60,
    }
  },
  {
    type = "technology",
    name = "presto-fuel",
    -- TODO
    icon = "__petraspace__/graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="presto-fuel" },
    },
    prerequisites = {"agricultural-science-pack"},
    unit = {
      count = 4000,
      ingredients = science("rgbspyA"),
      time = 60,
    }
  },
}

data:extend{
  -- Each pair of inner planets has its own cool technology.
  -- Fulgora+Vulc already is ... deep oil ocean rails? seems lame.
  -- may play with that.
  -- Fulgora+Gleba is Logi system (complex robotics and swarming behaviors)
  -- Gleba+Vulcanus is ... some kind of productivity probably? Or Fertilizer?
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
