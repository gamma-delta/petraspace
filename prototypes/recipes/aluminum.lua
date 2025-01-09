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
    name = "aluminum-nuggets-to-plates",
    category = "smelting",
    subgroup = "aluminum-processes",
    order = "za[aluminum-nuggets-to-plates]",
    enabled = false,
    ingredients = {{ type="item", name="aluminum-nugget", amount=2 }},
    results = {{ type="item", name="aluminum-plate", amount=1 }},
  },
  {
    -- This recipe should mega suck
    type = "recipe",
    name = "simple-bauxite-extraction",
    category = "chemistry",
    subgroup = "aluminum-processes",
    enabled = false,
    ingredients = {
      {type="item", name="bauxite-ore", amount=5},
      {type="fluid", name="sulfuric-acid", amount=200},
      {type="fluid", name="steam", amount=500},
    },
    energy_required = 30,
    results = {
      { type="item", name="aluminum-nugget", amount=1, probability=0.2 },
      { type="item", name="stone", amount_min=0, amount_max=5 },
    },
    auto_recycle = false,
    allow_productivity = true,
    -- TODO
    icons = simple_bauxite,
  },
  {
    type = "recipe",
    name = "bauxite-liquor",
    category = "metallurgy",
    subgroup = "aluminum-processes",
    order = "zb[bauxite-to-liquor]",
    enabled = false,
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
    icons = {
      {
        icon = "__petraspace__/graphics/icons/bauxite/1.png",
        scale = 0.75,
        shift = { 0, -8 },
      },
      {
        icon = "__petraspace__/graphics/icons/fluid/red-mud.png",
        scale = 0.5,
        shift = { 0, 8 },
      },
    }
  },
  {
    type = "recipe",
    name = "bauxite-liquor-electrolysis",
    category = "electromagnetics",
    subgroup = "aluminum-processes",
    order = "zc[bauxite-liquor-electrolysis]",
    enabled = false,
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
    icons = advanced_bauxite,
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
    allow_productivity = true,
  },
  -- this way, for EVEN MOAR PRODUCTIVITY, you can smelt the nuggets into
  -- ingots
  {
    type = "recipe",
    name = "casting-aluminum-nugget",
    category = "metallurgy",
    subgroup = "aluminum-processes",
    order = "ze[casting-aluminum-nugget]",
    enabled = false,
    ingredients = {
      { type="fluid", name="molten-aluminum", amount=5 },
    },
    energy_required = 1,
    results = {
      { type="item", name="aluminum-nugget", amount=1 },
    },
    allow_productivity = true,
  },
  
}
