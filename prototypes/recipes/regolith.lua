local function icon_regolith_over(target)
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
    icons = icon_regolith_over("__base__/graphics/icons/stone-brick.png")
  },
  {
    type = "recipe",
    name = "concrete-from-regolith",
    category = "crafting-with-fluid",
    subgroup = "raw-material",
    order = "c[chemistry]-za",
    enabled = false,
    energy_required = 10,
    -- require sulfur?
    -- see: https://en.wikipedia.org/wiki/Lunarcrete
    ingredients = {
      {type="item", name="regolith", amount=5},
      {type="item", name="stone-brick", amount=5},
      {type="fluid", name="water", amount=150},
      -- this should probably require something somewhat scarce on Viate
      -- so that you have an interesting choice for whether to go for it
    },
    results = {{type="item", name="concrete", amount=12}},
    allow_productivity = true,
    icons = icon_regolith_over("__base__/graphics/icons/concrete.png")
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
    results = {
      {type="item", name="stone", amount=5},
      {type="item", name="iron-ore", amount=10},
      {type="item", name="bauxite-ore", amount=5},
    },
    icons = {
      { icon="__base__/graphics/icons/fluid/steam.png" },
      { icon="__petraspace__/graphics/icons/regolith/1.png", scale=0.5 },
    }
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
    icons = {
      { icon="__base__/graphics/icons/fluid/sulfuric-acid.png" },
      { icon="__petraspace__/graphics/icons/regolith/1.png", scale=0.5 },
    }
  },
}
