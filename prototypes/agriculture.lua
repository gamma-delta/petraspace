-- Thank you, LordMiguel!
-- https://mods.factorio.com/mod/boompuff-agriculture?from=search

-- I think I can do it a little smarter than them though.
-- The Plant prototype (for farmables) extends TreePrototype,
-- and only adds a few more fields!
-- So just clone the boompuff and turn it into a plampt
local pglobals = require "globals"

local vanilla_boompuff = data.raw["tree"]["boompuff"]
-- Make boompuffs weak to their own explosions
-- Perhaps this is how they propogate in the wild
vanilla_boompuff.resistances = {
  -- They have 50 health by default
  -- I don't want any explosion to completely wipe out a grove, but i do want it to be
  -- fairly deadly. Mine it quick!
  {type="explosion", decrease=-5}
}
vanilla_boompuff.minable.results = {
  -- instead of spoilage.
  -- remember that, even though each tree drops 50 fruit, there's only a 2%
  -- chance to get another seed out.
  -- LordMiguel had a really smart idea here -- you can't count on every
  -- harvest giving you a propagule! but you also can't buffer the seeds.
  {type="item", name="boompuff-propagule", amount_min=0, amount_max=10},
  {type="item", name="wood", amount=4},
}

local boompuff_plant = pglobals.copy_then(vanilla_boompuff, {
  name = "boompuff-plant",
  type = "plant",
  -- Same as yumako and jellynut
  growth_ticks = 5 * minute,
  harvest_emissions = { spores=15 },
  -- Primary is the mash on the outside ("plant-mask")
  -- Secondary is the churning inside the tower ("light")
  -- Or something.
  agricultural_tower_tint = {
    -- kind of a puce yellow, from the stems
    primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
    -- violent red, from the harvest
    secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
  },
  -- Stop placing the cute decoratives everywhere
  created_effect = nil,
  -- TODO: look into why they vibrate violenty
})
-- The autoplace restriction is binding for some reason?
-- Make them also plantable on yumako soil, idfk,
-- I don't want to add special new yellow soil
boompuff_plant.autoplace.tile_restriction = util.merge{
  boompuff_plant.autoplace.tile_restriction,
  data.raw["plant"]["yumako-tree"].autoplace.tile_restriction,
}
-- Only plant "natural" boompuffs
boompuff_plant.autoplace.probability_expression = "0"

data:extend{boompuff_plant}
