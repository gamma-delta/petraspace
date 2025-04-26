local pglobals = require "globals"

data:extend{
  {
    type = "recipe",
    name = "lime-calcination",
    category = "metallurgy",
    enabled = false,
    show_amount_in_title = false,
    surface_properties = {
      {name="pressure", min=4000, max=4000}
    },
    ingredients = {
      {type="item", name="calcite", amount=50},
    },
    energy_required = 60,
    results = {
      {type="item", name="quicklime", amount=40},
      {type="item", name="magnesium-slag", amount_min=0, amount_max=4}
    },
    main_product = "quicklime",
  }
}

for _,calcite2lime in ipairs{
  -- Keep the basic planetside recipes using normal calcite.
  -- This is metal from lava and simple liquefaction.
  -- This way if you're a madman you can make use orbital quicklime to
  -- run your foundaries, and it's still easier to get set up on Vulc.
  "acid-neutralisation", "molten-iron", "molten-copper",
  -- just like expanding grout!
  "cliff-explosives",
} do
  local recipe = data.raw["recipe"][calcite2lime]
  for _,ingredient in ipairs(recipe.ingredients) do
    if ingredient.type == "item" and ingredient.name == "calcite" then
      ingredient.name = "quicklime"
    end
  end
end
