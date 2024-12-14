local icons = require("__petraspace__/prototypes/icons")

data:extend{
-- === Data cards === --
  {
    type = "recipe",
    name = "blank-data-card",
    category = "electronics-or-assembling",
    enabled = false,
    ingredients = {
      { type="item", name="processing-unit", amount=5 },
      { type="item", name="steel-plate", amount=1 },
      { type="item", name="copper-wire", amount=2 },
    },
    energy_required = 3,
    results = {{ type="item", name="blank-data-card", amount=1 }},
  },
  {
    type = "recipe",
    name = "format-expired-data-card",
    category = "electronics-or-assembling",
    enabled = false,
    ingredients = {{ type="item", name="expired-data-card", amount=1 }},
    -- this is so low because i want you to use the cards, darnit
    results = {{ type="item", name="blank-data-card", amount=1, probability = 0.25 }},
    show_amount_in_title = false,
    allow_quality = false,
    allow_productivity = true,
    icon = "__base__/graphics/icons/checked-green.png",
  },
  {
    type = "recipe-category",
    name = "orbital-data-card",
  },
  {
    type = "recipe",
    name = "orbital-data-card-high-pressure",
    category = "orbital-data-card",
    enabled = false,
    ingredients = {
      { type="item", name="blank-data-card", amount=1 },
      { type="item", name="advanced-circuit", amount=1 },
    },
    energy_required = 2,
    results = {{ type="item", name="orbital-data-card", amount=1 }},
    -- this means you can do it in space, Viate, and Aquilo, but not Fulgora
    surface_conditions = {{ property="pressure", min=500 }},
    -- nice try
    allow_productivity = false,
    allow_quality = false,
    icons = {
      { icon = "__base__/graphics/icons/nauvis.png", },
      { icon = "__base__/graphics/icons/automation-science-pack.png", },
    }
  },
  {
    type = "recipe",
    name = "orbital-data-card-low-pressure",
    category = "orbital-data-card",
    enabled = false,
    ingredients = {
      { type="item", name="blank-data-card", amount=1 },
      { type="item", name="electronic-circuit", amount=1 },
    },
    energy_required = 1.5,
    results = {{ type="item", name="orbital-data-card", amount=1 }},
    surface_conditions = {{ property="pressure", max=500 }},
    allow_productivity = false,
    allow_quality = false,
    icons = {
      { icon = "__space-age__/graphics/icons/solar-system-edge.png", },
      { icon = "__base__/graphics/icons/automation-science-pack.png", },
    }
  },
  
-- === Aluminum recipes ===
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
    auto_recycle=false,
    allow_productivity = true,
    icons = icons.simple_bauxite,
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
        icon = "__petraspace__/graphics/icons/bauxite-1.png",
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

  -- === Dust deleters === --
  {
    type = "recipe-category",
    name = "dust-spraydown",
  },
  {
    type = "recipe",
    name = "dust-spraydown-water",
    category = "dust-spraydown",
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
  },

-- === Science! === --
  {
    type = "recipe",
    name = "orbital-science-pack",
    enabled = false,
    -- the hard part should be the card logistics
    energy_required = 8,
    ingredients = {
      { type="item", name="orbital-data-card", amount=5 },
      { type="item", name="electric-engine-unit", amount=2 },
      { type="item", name="space-platform-foundation", amount=1 },
      -- does not require LDS to make it not too similar to yellow science,
      -- and because LDS is really expensive at this stage
    },
    results = {
      { type="item", name="orbital-science-pack", amount=2 },
      -- you can only craft these in normal assembling machines;
      -- with 4 legendary prod 3s that makes you break even
      { type="item", name="blank-data-card", amount=1, probability=0.5 },
    },
    main_product = "orbital-science-pack",
    allow_productivity = true,
    -- i dunno, maybe the science imparts quality onto it
    allow_quality = true,
    maximum_productivity = 1,
  }
}

-- Fix up LDS recipes
data.raw["recipe"]["low-density-structure"].ingredients = {
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="copper-plate", amount=10 },
  { type="item", name="aluminum-plate", amount=1 },
  { type="item", name="plastic-bar", amount=5 },
}
-- Foundries only allow 2 fluids :<
data.raw["recipe"]["casting-low-density-structure"].ingredients = {
  { type="fluid", name="molten-copper", amount=250 },
  { type="fluid", name="molten-aluminum", amount=8 },
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="plastic-bar", amount=5 },
}
