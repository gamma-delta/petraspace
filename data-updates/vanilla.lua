-- === Recipes === --
local space_plat = data.raw["recipe"]["space-platform-foundation"]
space_plat.ingredients = {
  { type="item", name="copper-cable", amount=20 },
  { type="item", name="steel-plate", amount=15 },
  { type="item", name="low-density-structure", amount=1 },
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
