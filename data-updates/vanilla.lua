local pglobals = require("__petraspace__/globals")

-- === Recipes === --
local space_plat = data.raw["recipe"]["space-platform-foundation"]
space_plat.ingredients = {
  { type="item", name="copper-cable", amount=20 },
  { type="item", name="steel-plate", amount=15 },
  { type="item", name="low-density-structure", amount=1 },
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

-- === Technology === --
local foundry_tech = data.raw["technology"]["foundry"]
for i, v in ipairs(foundry_tech.effects) do
  if v.type == "unlock-recipe" and v.recipe == "casting-low-density-structure" then
    table.remove(foundry_tech.effects, i)
    break
  end
end

table.insert(data.raw["technology"]["low-density-structure"].prerequisites, "simple-bauxite-extraction")

-- why launch a rocket if you are unaware of anything up there?
local rocket_silo = data.raw["technology"]["rocket-silo"]
table.insert(rocket_silo.prerequisites, "orbital-science-pack")
table.insert(rocket_silo.unit.ingredients, {"orbital-science-pack", 1})

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
