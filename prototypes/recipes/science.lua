data:extend{
  {
    type = "recipe",
    name = "orbital-science-pack",
    enabled = false,
    energy_required = 21,
    ingredients = {
      { type="item", name="orbital-data-card", amount=5,
        ignored_by_stats=5 },
      { type="item", name="electric-engine-unit", amount=2 },
      { type="item", name="space-platform-foundation", amount=1 },
      -- does not require LDS to make it not too similar to yellow science,
      -- and because LDS is really expensive at this stage
    },
    results = {
      { type="item", name="orbital-science-pack", amount=3 },
      { type="item", name="blank-data-card", 
        amount_min=1, amount_max=5, probability=0.9,
        ignored_by_productivity=9999, ignored_by_stats=5 },
    },
    main_product = "orbital-science-pack",
    allow_productivity = true,
    allow_quality = false,
  },
}
