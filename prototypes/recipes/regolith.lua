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
    enabled = false,
    energy_required = 8,
    ingredients = {
      {type="item", name="regolith", amount=10},
      -- 1 ice = 20 water = 200 steam
      -- so each of these is five ice (at freddie's)
      {type="fluid", name="steam", amount=1000},
    },
    results = {
      -- TODO: silicon
      {type="item", name="stone", amount=5},
      {type="item", name="iron-ore", amount=3},
    },
    icons = {
      { icon="__base__/graphics/icons/fluid/steam.png" },
      { icon="__petraspace__/graphics/icons/regolith/1.png", scale=0.5 },
    }
  },
  {
    type = "recipe",
    name = "dissolving-regolith",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 8,
    ingredients = {
      {type="item", name="regolith", amount=10},
      {type="fluid", name="sulfuric-acid", amount=20},
    },
    results = {
      -- TODO: silicon
      {type="item", name="stone", amount=9},
      {type="item", name="native-aluminum", amount=1},
    },
    icons = {
      { icon="__base__/graphics/icons/fluid/sulfuric-acid.png" },
      { icon="__petraspace__/graphics/icons/regolith/1.png", scale=0.5 },
    }
  },
}
