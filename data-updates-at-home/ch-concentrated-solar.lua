local hsm = data.raw["recipe"]["chcs-heliostat-mirror"]
hsm.ingredients = {
  {type="item", name="electronic-circuit", amount=5},
  {type="item", name="aluminum-plate", amount=5}, -- FeC -> Al
  {type="item", name="precision-optical-component", amount = 5}, -- Cu -> POC
}

local spt = data.raw["recipe"]["chcs-solar-power-tower"]
spt.ingredients = {
  -- Keep it the same, also this way it encourages you to make conc reat babay
  {type = "item", name="concrete", amount=500},
  -- Split half of FeC to Al
  {type = "item", name="aluminum-plate", amount=200},
  {type = "item", name="steel-plate", amount=200},
  {type = "item", name="precision-optical-component", amount=100}, -- Cu -> POC
  -- This is only turned on in the Krastorio compat. Why? It makes sense.
  {type = "item", name="heat-pipe", amount=20}
}

-- make the SLT more expensive than in the base game because
-- you don't really need hardcore combat utils as much until later.
local slt = data.raw["recipe"]["chcs-solar-laser-tower"]
slt.ingredients = {
  {type = "item", name="concrete", amount=500},
  -- i guess it needs to be lighter or something to be able to swivel
  {type = "item", name="aluminum-plate", amount=400},
  {type = "item", name="precision-optical-component", amount=100},
  {type = "item", name="electric-engine-unit", amount=20},
}
