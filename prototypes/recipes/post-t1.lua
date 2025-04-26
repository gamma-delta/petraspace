-- After conquering all planets once (where vanilla spage ends)
local pglobals = require "globals"

-- Petrichor enrichment process (holy shit hexcasting reference)
data:extend{
  {
    type = "recipe",
    name = "bauxite-liquor",
    category = "metallurgy",
    subgroup = "chemistry",
    order = "c[aluminum]-b",
    enabled = false,
    allow_decomposition = false,
    ingredients = {
      { type="item", name="bauxite-ore", amount=100 },
      { type="item", name="calcite", amount=4 },
      { type="fluid", name="sulfuric-acid", amount=200 },
    },
    energy_required = 64,
    results = {
      { type="fluid", name="bauxite-liquor", amount=500 },
    },
    main_product = "bauxite-liquor",
    auto_recycle = false,
    enabled = false,
    unlock_results = true,
    allow_productivity = true,
    allow_decomposition = true,
    icons = pglobals.icons.three_into_one(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__space-age__/graphics/icons/calcite.png",
      "__petraspace__/graphics/icons/bauxite/1.png",
      "__petraspace__/graphics/icons/fluid/red-mud.png"
    )
  },
  {
    type = "recipe",
    name = "bauxite-liquor-electrolysis",
    category = "electromagnetics",
    subgroup = "chemistry",
    order = "c[aluminum]-c",
    enabled = false,
    allow_decomposition = false,
    ingredients = {
      { type="fluid", name="bauxite-liquor", amount=100 },
      -- two electrodes, two items
      { type="item", name="carbon-fiber", amount=2 },
    },
    -- it's atomic number 13. also this makes the math dreadful
    -- i want the number of EM plants and foundries to be quite mismatched,
    -- because it makes the setups look more interesting
    energy_required = 130,
    results = {
      { type="fluid", name="molten-aluminum", amount=50 },
      { type="item", name="bauxite-ore", amount_min = 1, amount_max = 20, probability = 0.5 },
    },
    main_product = "molten-aluminum",
    allow_productivity = true,
    -- This should probably involve some kind of zapping
    icons = pglobals.icons.two_into_one(
      "__space-age__/graphics/icons/carbon-fiber.png",
      "__petraspace__/graphics/icons/fluid/red-mud.png",
      "__petraspace__/graphics/icons/fluid/molten-aluminum.png"
    ),
  },
  {
    type = "recipe",
    name = "casting-aluminum-plate",
    category = "metallurgy",
    subgroup = "aluminum-processes",
    order = "zd[casting-aluminum-plate]",
    enabled = false,
    ingredients = {
      { type="fluid", name="molten-aluminum", amount=10 },
    },
    energy_required = 3.2,
    results = {
      { type="item", name="aluminum-plate", amount=1 },
    },
    -- This way the tooltip shows the native aluminum, not liquid,
    -- which will be relavent for longer
    allow_decomposition = false,
    allow_productivity = true,
  },
}

-- Foundries only allow 2 fluids :<
data.raw["recipe"]["casting-low-density-structure"].ingredients = {
  { type="fluid", name="molten-copper", amount=250 },
  { type="fluid", name="molten-aluminum", amount=8 },
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="plastic-bar", amount=5 },
}
