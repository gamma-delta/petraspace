local pglobals = require("__petraspace__/globals")
local rocket_cap = 1000 * kg;

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
-- you use chemmy plants much more than in vanilla,
-- frankly i'm surprised they didn't already update it
data.raw["item"]["chemical-plant"].stack_size = 50
data.raw["item"]["chemical-plant"].weight = rocket_cap / 50

-- Move gasses to be gasses
local function togas(name, order)
  local gas = data.raw["fluid"][name]
  gas.subgroup = "gasses"
  gas.order = "a[existing-gas]-" .. order
end
togas("steam", "a")
togas("petroleum-gas", "b")
togas("ammonia", "c")
togas("fluorine", "d")
-- i guess it's a "gas"
-- source: they might be giants
togas("fusion-plasma", "e")

table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "electrochemistry")
table.insert(data.raw["assembling-machine"]["electromagnetic-plant"].crafting_categories, "electrochemistry")

-- Remove OG rocket juice recipes
data.raw["recipe"]["thruster-fuel"].hidden = true
data.raw["recipe"]["thruster-oxidizer"].hidden = true
data.raw["recipe"]["advanced-thruster-fuel"].hidden = true
data.raw["recipe"]["advanced-thruster-oxidizer"].hidden = true

-- Make flamethrower turrets have Consequences
-- It looks like each individual blob of flame in a stream is a separate object.
-- They last for 2-3 seconds each.
-- Let's make it as bad as a normal mining drill?
for _,path in ipairs{"flamethrower-fire-stream", "handheld-flamethrower-fire-stream"} do
  local obj = data.raw["stream"][path]
  obj.emissions_per_second = {pollution=10/60}
end

-- Make oxide asteroids drop quicklime
-- It turns out that we don't actually know very much about the makeup
-- of comets, so this is 100% alright (lies)
data.raw["recipe"]["advanced-oxide-asteroid-crushing"].results[2].name = "quicklime"
