require("planets/viate")
require("planets/lepton")

data:extend{
  {
    type = "surface-property",
    name = "atmospheric-nitrogen",
    default_value = 0,
  },
  -- TODO: atmospheric co2? to restrict steel production.
  -- it would be cute but probably not helpful
}

data.raw["planet"]["nauvis"].surface_properties["atmospheric-nitrogen"] = 78
-- more o2 than nauvis
data.raw["planet"]["gleba"].surface_properties["atmospheric-nitrogen"] = 69
-- mostly co2
data.raw["planet"]["fulgora"].surface_properties["atmospheric-nitrogen"] = 50
-- mostly co2
data.raw["planet"]["vulcanus"].surface_properties["atmospheric-nitrogen"] = 30
-- probably mostly ammonia or hydrogen or some other disaster
-- what the fuck is the deal with aquilo
data.raw["planet"]["aquilo"].surface_properties["atmospheric-nitrogen"] = 0
