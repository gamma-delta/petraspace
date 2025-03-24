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
    },
    factoriopedia_simulation = {
      init = [[
        game.simulation.camera_alt_info = true
        game.simulation.camera_zoom = 4
      ]],
      init_update_count = 60 * 8,
      -- the Lua docs for create_entity are wrong
      -- and say that the entity name is "item"
      update = [[
        if game.tick % (60 * 12) == 0 then
          game.surfaces[1].create_entity{
            name="item-on-ground",
            position={0,0},
            stack={name="antimatter-magnetic-bottle", count=1}
          }
        end
      ]]
    }
  },
}

local function pollution_squib(name, pollutant, smoke_color)
  
end
