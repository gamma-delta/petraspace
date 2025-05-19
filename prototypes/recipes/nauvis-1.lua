-- Recipes for before space
local pglobals = require("globals")

-- Bad aluminum
data:extend{
  {
    type = "recipe",
    name = "native-aluminum-to-plate",
    category = "smelting",
    order = "za[native-aluminum-to-plate]",
    enabled = false,
    energy_required = 3.2,
    ingredients = {{ type="item", name="native-aluminum", amount=2 }},
    results = {{ type="item", name="aluminum-plate", amount=1 }},
  },
  {
    -- This recipe should mega suck
    type = "recipe",
    name = "simple-bauxite-extraction",
    category = "chemistry",
    subgroup = "chemistry",
    order = "c[aluminum]-a",
    enabled = false,
    allow_decomposition = false,
    ingredients = {
      {type="item", name="bauxite-ore", amount=5},
      {type="item", name="stone", amount=10},
      {type="fluid", name="sulfuric-acid", amount=200},
      {type="fluid", name="steam", amount=500},
    },
    energy_required = 30,
    results = {{type="item", name="native-aluminum", amount=1}},
    auto_recycle = false,
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__base__/graphics/icons/fluid/steam.png",
      "__petraspace__/graphics/icons/bauxite/1.png"
    )
  },
}

-- Nauvian circuit substrate recipes
-- This makes the fulgoran recycling ratios a little different,
-- but you can still get plenty of iron from gears
-- and copper from LDS and POC and whatever
data:extend{
  {
    type = "recipe",
    name = "circuit-substrate-stone",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-a",
    category = "crafting",
    enabled = false,
    ingredients = {
      {type="item", name="stone-brick", amount=1},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 0.5,
    results = {{type="item", name="circuit-substrate", amount=1}},
    allow_productivity = true,
    auto_recycle = false,
    -- the "default" i suppose
    allow_decomposition = true,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/stone-brick.png",
      "__petraspace__/graphics/icons/circuit-substrate.png"
    )
  },
  {
    type = "recipe",
    name = "circuit-substrate-wood",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-b",
    -- TODO: assembling or biochamber
    -- For some reason organics-or-hand-crafting doesn't work in asm1
    category = "electronics",
    enabled = false,
    ingredients = {
      {type="item", name="wood", amount=2},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 1.0,
    results = {{type="item", name="circuit-substrate", amount=2}},
    allow_productivity = true,
    auto_recycle = false,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/wood.png",
      "__petraspace__/graphics/icons/circuit-substrate.png"
    )
  },
  {
    type = "recipe",
    name = "circuit-substrate-plastic",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-c",
    category = "electronics",
    enabled = false,
    ingredients = {
      {type="item", name="plastic-bar", amount=10},
      {type="item", name="copper-plate", amount=5},
      {type="item", name="copper-cable", amount=15},
    },
    energy_required = 10.0,
    results = {{type="item", name="circuit-substrate", amount=20}},
    allow_productivity = true,
    auto_recycle = false,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/plastic-bar.png",
      "__petraspace__/graphics/icons/circuit-substrate.png"
    )
  },
}
pglobals.recipe.replace("electronic-circuit", "iron-plate", "circuit-substrate")
-- they are very tall
table.insert(data.raw["recipe"]["advanced-circuit"].ingredients,
  {type="item", name="circuit-substrate", amount=2})
data.raw["recipe"]["processing-unit"].ingredients = {
  {type="item", name="advanced-circuit", amount=2},
  {type="item", name="electronic-circuit", amount=20},
  {type="item", name="circuit-substrate", amount=5},
  -- more properly, nitric acid is used for this
  -- however, i want sulfuric and acid to have seperate identities.
  -- Sulfuric is used for grungy mechanical processes
  -- Nitric is used for clean futuristic processes
  {type="fluid", name="sulfuric-acid", amount=20},
}

-- Steel needs nasty fuel
-- Apparently there are only 4 smelting recipes in vanilla:
-- iron, copper, steel, and bricks
data.raw["recipe"]["steel-plate"].category = "dirty-smelting"

-- Sulfur can be produced with only petro gas,
-- so cracking can require sulfuric acid.
pglobals.recipe.replace("heavy-oil-cracking", "water",
  {type="fluid", name="sulfuric-acid", amount=20})
pglobals.recipe.replace("light-oil-cracking", "water",
  {type="fluid", name="sulfuric-acid", amount=20})

-- Misc mall ingredient changes
table.insert(data.raw["recipe"]["medium-electric-pole"].ingredients,
  {type="item", name="stone-brick", amount=2})
table.insert(data.raw["recipe"]["big-electric-pole"].ingredients,
  {type="item", name="concrete", amount=2})
table.insert(data.raw["recipe"]["substation"].ingredients,
  {type="item", name="refined-concrete", amount=10})

local function poc_recipe(hi_pressure)
  local name = hi_pressure and "high-pressure" or "low-pressure"
  local pressure_bound = hi_pressure and "min" or "max"
  local icon_under = hi_pressure 
    and "__base__/graphics/icons/nauvis.png"
    or "__space-age__/graphics/icons/solar-system-edge.png" 

  return {
    type = "recipe",
    name = "precision-optical-component-" .. name,
    -- it would probably just be bloat to add a "vacuum craftinginator"
    category = "advanced-crafting",
    enabled = false,
    -- i want your first craft of this on Viate to feel REALLY GOOD AND FAST
    -- therefore, the space recipe can't be *too* complicated, so you get to it soon.
    energy_required = hi_pressure and 20 or 4,
    ingredients = {
      { type="item", name="advanced-circuit", amount=5 },
      { type="item", name="solar-panel", amount=1 },
      -- it's funny to me
      { type="item", name="small-lamp", amount=5 },
      -- mostly to make heavy oil used for SOMETHING
      hi_pressure and { type="fluid", name="heavy-oil", amount=50 } or nil,
    },
    results = {
      { type="item", name="precision-optical-component", amount=4 },
    },
    allow_productivity = true,
    allow_quality = true,
    auto_recycle = hi_pressure,
    surface_conditions = {{property="pressure", [pressure_bound]=500}},
    icons = {
      { icon = icon_under },
      { icon = "__petraspace__/graphics/icons/precision-optical-component.png" },
    }
  }
end
data:extend{
  poc_recipe(true),
  poc_recipe(false),
}

data:extend{
  {
    type = "recipe",
    name = "lunar-rocket-silo",
    category = "advanced-crafting",
    enabled = false,
    energy_required = 30,
    ingredients = {
      {type="item", name="concrete", amount=1000},
      {type="item", name="electric-engine-unit", amount=200},
      {type="item", name="pipe", amount=100},
      {type="item", name="processing-unit", amount=200},
      -- Split steel/aluminum 50-50
      {type="item", name="steel-plate", amount=500},
      {type="item", name="aluminum-plate", amount=500},
    },
    results = {{type="item", name="lunar-rocket-silo", amount=1}},
    allow_productivity = true,
    allow_quality = true,
  },
}

-- Make things use POC
data.raw["recipe"]["laser-turret"].ingredients = {
  -- vanilla is 20 grurcuits
  {type="item", name="advanced-circuit", amount=10},
  {type="item", name="precision-optical-component", amount=20},
  {type="item", name="steel-plate", amount=20},
  {type="item", name="battery", amount=20},
}
table.insert(
  data.raw["recipe"]["night-vision-equipment"].ingredients,
  {type="item", name="precision-optical-component", amount=20}
)

-- These things are SO expensive. Why?
local heat_pipe_recipe = data.raw["recipe"]["heat-pipe"]
heat_pipe_recipe.category = "advanced-crafting"
heat_pipe_recipe.ingredients = {
  { type="item", name="copper-plate", amount=5 },
  { type="item", name="steel-plate", amount=2 },
  { type="fluid", name="water", amount=100 },
}
heat_pipe_recipe.allow_decomposition = true

-- Fix up LDS recipe
-- The molten one is in vulcanus-1
data.raw["recipe"]["low-density-structure"].ingredients = {
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="copper-plate", amount=10 },
  { type="item", name="aluminum-plate", amount=1 },
  { type="item", name="plastic-bar", amount=5 },
}

-- stop POSTING about SHOVING STONE INTO CHESTS
-- this is only 1 iron plate per 50 stone, quite cheap,
-- but it means you can't compress stone 50->1 and need to
-- actually handle it.
-- Turn it into ourple science or make your walls thicker or something.
table.insert(data.raw["recipe"]["landfill"].ingredients, 
  {type="item", name="iron-stick", amount=2})
