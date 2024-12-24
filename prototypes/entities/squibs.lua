-- Miscellaneous triggers and stuff
local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

data:extend{
  {
    type = "simple-entity-with-force",
    name = "landmine-triggerinator",
    is_military_target = false,
    max_health = 1,
    -- should die quickly, but slow enough to blow up the land mine
    healing_per_tick = -0.2,
  },
  -- this is a "land mine" so it can have an ammo category,
  -- so we can reduce the damage thru research
  {
    type = "land-mine",
    name = "subatomic-mishap-explosion",
    flags = { "not-on-map" },
    hidden = true,
    icon = "__base__/graphics/icons/explosion.png",

    ammo_category = "subatomic-mishap",
    trigger_radius = 10,
    timeout = 0,
    trigger_force = "all",

    created_effect = {
      type = "direct",
      action_delivery = {
        type = "instant",
        source_effects = {
          type = "create-entity",
          entity_name = "landmine-triggerinator"
        }
      }
    },
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        source_effects = {
          {
            type = "nested-result",
            affects_target = true,
            action = {
              type = "area",
              radius = 6,
              force = "all",
              action_delivery = {
                type = "instant",
                target_effects = {
                  {
                    type = "damage",
                    damage = { amount = 1000, type = "explosion"}
                  },
                }
              }
            }
          },
          {
            type = "create-entity",
            entity_name = "big-explosion"
          },
        }
      }
    }
  },
}

local function pollution_squib(name, pollutant, smoke_color)
end
