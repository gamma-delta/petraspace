local pglobals = require "globals"

-- go away
data.raw["recipe"]["coal-synthesis"].hidden = true

local coll = data.raw["recipe"]["asteroid-collector"]
coll.ingredients = {
  {type="item", name="pktff-basic-asteroid-collector", amount=1},
  {type="item", name="long-handed-inserter", amount=5},
  {type="item", name="jelly", amount=20},
}
coll.surface_conditions = {
  {property="pressure", min=2000, max=2000}
}
