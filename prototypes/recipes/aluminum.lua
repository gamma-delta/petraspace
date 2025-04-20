local pglobals = require "globals"
local simple_bauxite = {
  {
    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
    scale = 0.7,
    shift = { -16, -16 },
  },
  {
    icon = "__base__/graphics/icons/fluid/steam.png",
    scale = 0.7,
    shift = { 16, -16 },
  },
  {
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    scale = 0.75,
    shift = { 0, 8 },
  },
}
local advanced_bauxite = {
  {
    icon = "__petraspace__/graphics/icons/fluid/red-mud.png",
    scale = 0.5,
    shift = { -16, 16 },
  },
  {
    icon = "__petraspace__/graphics/icons/fluid/molten-aluminum.png",
    scale = 0.5,
    shift = { 16, 16 },
  },
  {
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    scale = 0.75,
    shift = { 0, -8 },
  },
}

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
    results = {
      { type="item", name="native-aluminum", amount=1, },
      { type="item", name="stone", amount_min=0, amount_max=5 },
    },
    auto_recycle = false,
    allow_productivity = true,
    allow_decomposition = false,
    -- TODO
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__base__/graphics/icons/fluid/steam.png",
      "__petraspace__/graphics/icons/bauxite/1.png"
    )
  },
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
