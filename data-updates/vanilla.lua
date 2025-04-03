local pglobals = require("__petraspace__/globals")
local rocket_cap = 1000 * kg;

-- Make things use POC
table.insert(
  data.raw["recipe"]["laser-turret"].ingredients,
  {type="item", name="precision-optical-component", amount=5}
)
local scrapping = data.raw["recipe"]["scrap-recycling"]
for i, v in ipairs(scrapping.results) do
  if v.name == "advanced-circuit" then
    v.name = "precision-optical-component"
    break
  end
end


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

-- === Technology === --
local foundry_tech = data.raw["technology"]["foundry"]
for i, v in ipairs(foundry_tech.effects) do
  if v.type == "unlock-recipe" and v.recipe == "casting-low-density-structure" then
    table.remove(foundry_tech.effects, i)
    break
  end
end

-- Let you place the rocket silo on airless moons but not space platforms
data.raw["rocket-silo"]["rocket-silo"].surface_conditions = 
  {{property="gravity", min=1}}

-- Augh
-- Stick anything in a lunar rocket silo
for _,item in pairs(data.raw["item"]) do
  if item.send_to_orbit_mode == nil or item.send_to_orbit_mode == "not-sendable" then
    item.send_to_orbit_mode = "manual"
  end
end

-- Make slower items easier to ship up to space
data.raw["item"]["transport-belt"].weight = rocket_cap / 200
data.raw["item"]["fast-transport-belt"].weight = rocket_cap / 100
data.raw["item"]["express-transport-belt"].weight = rocket_cap / 100
-- turbo is already 50
data.raw["item"]["inserter"].weight = rocket_cap / 100
data.raw["item"]["long-handed-inserter"].weight = rocket_cap / 50
data.raw["item"]["bulk-inserter"].weight = rocket_cap / 25
data.raw["item"]["stack-inserter"].weight = rocket_cap / 10

data.raw["item"]["assembling-machine-1"].weight = rocket_cap / 100

-- Move gasses to be gasses
local pg = data.raw["fluid"]["petroleum-gas"]
pg.subgroup = "gasses"
pg.order = "a[existing-gas]-a"
local nh3 = data.raw["fluid"]["ammonia"]
nh3.subgroup = "gasses"
nh3.order = "a[existing-gas]-b"

table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "electrochemistry")
table.insert(data.raw["assembling-machine"]["electromagnetic-plant"].crafting_categories, "electrochemistry")

-- Remove OG rocket juice recipes
data.raw["recipe"]["thruster-fuel"].hidden = true
data.raw["recipe"]["thruster-oxidizer"].hidden = true
data.raw["recipe"]["advanced-thruster-fuel"].hidden = true
data.raw["recipe"]["advanced-thruster-oxidizer"].hidden = true
