local Table = require("__stdlib2__/stdlib/utils/table")

local function poc_recipe()
  return {
    type = "recipe",
    name = "precision-optical-component-high-pressure",
    -- it would probably just be bloat to add a "vacuum craftinginator"
    category = "advanced-crafting",
    enabled = false,
    -- yep!
    -- i want your first craft of this on Viate to feel REALLY GOOD AND FAST
    -- therefore, the space recipe can't be *too* complicated, so you get to it soon.
    -- or feature sulfur.
    energy_required = 20,
    ingredients = {
      { type="item", name="advanced-circuit", amount=5 },
      { type="item", name="solar-panel", amount=1 },
      -- it's funny to me
      { type="item", name="small-lamp", amount=5 },
      -- mostly to make heavy oil used for SOMETHING
      { type="fluid", name="heavy-oil", amount=50 },
    },
    results = {
      { type="item", name="precision-optical-component", amount=4 },
    },
    allow_productivity = true,
    allow_quality = true,
    surface_conditions = {{property="pressure", min=500}}
  } end

data:extend{
  poc_recipe(),
  -- The fact that this is crafted in a normal assembling machine,
  -- which can only get up to +100% productivity,
  -- means i can make a recipe that is up to 2x as good as the original
  -- and not exploit with recyclers.
  Table.merge(poc_recipe(), {
    -- sure, i guess if you're in space you can craft it by hand.
    category = "crafting",
    name = "precision-optical-component-low-pressure",
    -- zooooooom
    energy_required = 4,
    ingredients = {
      { type="item", name="advanced-circuit", amount=5 },
      { type="item", name="solar-panel", amount=1 },
      { type="item", name="small-lamp", amount=5 },
      -- no oil (noil)
    },
    surface_conditions = {{property="pressure", max=500}},
    auto_recycle = false,
  })
}
