-- Recipes for Viate, and its use as a stepping stone

local pglobals = require("globals")

local function icon_regolith_over(target, under)
  return {
    {
      icon = target,
    },
    {
      icon = "__petraspace__/graphics/icons/regolith/1.png",
      scale = 0.3,
      shift = {-8, -8}
    },
  }
end

-- Regolith
data:extend{
  {
    type = "recipe",
    name = "stone-bricks-from-regolith",
    category = "smelting",
    enabled = false,
    energy_required = 6.4,
    ingredients = {{type="item", name="regolith", amount=2}},
    results = {{type="item", name="stone-brick", amount=1}},
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__petraspace__/graphics/icons/regolith/1.png",
      "__base__/graphics/icons/stone-brick.png"
    ),
  },
  {
    type = "recipe",
    name = "washing-regolith",
    category = "crafting-with-fluid",
    subgroup = "raw-material",
    order = "c[chemistry]-zb",
    enabled = false,
    energy_required = 8,
    ingredients = {
      {type="item", name="regolith", amount=10},
      -- 1 ice = 20 water = 200 steam
      -- so each of these is five ice (at freddie's)
      {type="fluid", name="steam", amount=1000},
    },
    allow_productivity = true,
    allow_decomposition = false,
    results = {
      {type="item", name="stone", amount=5},
      {type="item", name="iron-ore", amount=10},
      {type="item", name="bauxite-ore", amount=5},
    },
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/fluid/steam.png",
      "__petraspace__/graphics/icons/regolith/1.png"
    ),
  },
  {
    type = "recipe",
    name = "dissolving-regolith",
    category = "chemistry",
    subgroup = "raw-material",
    order = "c[chemistry]-zc",
    enabled = false,
    energy_required = 8,
    ingredients = {
      {type="item", name="regolith", amount=10},
      {type="fluid", name="sulfuric-acid", amount=10},
    },
    allow_productivity = true,
    allow_decomposition = false,
    results = {
      {type="item", name="stone", amount=10},
      {type="item", name="native-aluminum", amount=5},
      {type="item", name="copper-ore", amount=2},
      -- One sulfur makes 10 H2SO4. Naively looping it around will not
      -- produce enough to close the loop; you need >20% productivity.
      -- Filling this recipe and the sulfuric acid recipe with 3 prod1 mods
      -- should barely close the loop.
      -- However you also need enough iron ore to react it ...
      -- and use the sulfur to get rid of your excess bauxite from the
      -- washing recipe.
      -- You will probably be relying on shipments of S from Nauvis for a while.
      {type="item", name="sulfur", amount=1, probability=0.8},
    },
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__petraspace__/graphics/icons/regolith/1.png"
    ),
  },
}

-- Advanced sprinkling
data:extend{
  {
    type = "recipe",
    name = "dust-sprayer",
    enabled = false,
    ingredients = {
      {type="item", name="pump", amount=1},
      {type="item", name="pipe", amount=10},
      {type="item", name="low-density-structure", amount=1},
    },
    results = {{type="item", name="dust-sprayer", amount=1}},
    energy_required = 3,
  },
  {
    type = "recipe",
    name = "dust-spraydown-water",
    category = "dust-spraydown",
    subgroup = "chemistry",
    icon = "__base__/graphics/icons/fluid/water.png",
    ingredients = {{ type="fluid", name="water", amount=200 }},
    results = {},
    energy_required = 1,
    -- prod mods add pollution, so does that make this even more effective?
    -- either way, it's interesting
    allow_productivity = true,
    allow_quality = false,
    
    crafting_machine_tint = {
      primary = {r = 0.45, g = 0.78, b = 1.000, a = 1.000},
      secondary = {r = 0.591, g = 0.856, b = 1.000, a = 1.000},
      tertiary = {r = 0.381, g = 0.428, b = 0.536, a = 0.502},
      quaternary = {r = 0.499, g = 0.797, b = 0.8, a = 0.733},
    }
  }
}

local hsm = data.raw["recipe"]["chcs-heliostat-mirror"]
hsm.ingredients = {
  {type="item", name="electronic-circuit", amount=5},
  {type="item", name="aluminum-plate", amount=5}, -- FeC -> Al
  {type="item", name="precision-optical-component", amount = 5}, -- Cu -> POC
}

local spt = data.raw["recipe"]["chcs-solar-power-tower"]
spt.ingredients = {
  -- Keep it the same, also this way it encourages you to make conc reat babay
  {type = "item", name="concrete", amount=500},
  -- Split half of FeC to Al
  {type = "item", name="aluminum-plate", amount=200},
  {type = "item", name="steel-plate", amount=200},
  {type = "item", name="precision-optical-component", amount=100}, -- Cu -> POC
  -- This is only turned on in the Krastorio compat. Why? It makes sense.
  {type = "item", name="heat-pipe", amount=20}
}

-- make the SLT more expensive than in the base game because
-- you don't really need hardcore combat utils as much until later.
local slt = data.raw["recipe"]["chcs-solar-laser-tower"]
slt.ingredients = {
  {type = "item", name="concrete", amount=500},
  -- i guess it needs to be lighter or something to be able to swivel
  {type = "item", name="aluminum-plate", amount=400},
  {type = "item", name="precision-optical-component", amount=100},
  {type = "item", name="electric-engine-unit", amount=20},
}
