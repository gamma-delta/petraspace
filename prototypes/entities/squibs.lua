-- Miscellaneous triggers and stuff
local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

data:extend{
  {
    type = "simple-entity-with-owner",
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
    subcategory = "environment",

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

local function pollution_squib(name, pollutant, amount, color_inner, color_outer)
  -- We cannot use trivial smoke because the color has to change
  color_outer = color_outer or util.multiply_color(color_inner, 0.8)
  local lifetime = 2
  return {
    type = "smoke-with-trigger",
    name = name,
    flags = {"not-on-map"},
    emissions_per_second = {[pollutant] = amount / lifetime},
    cyclic = false,
    duration = lifetime * 60,
    fade_in_duration = 20,
    fade_away_duration = 40,
    animation = {
      layers = {
        {
          filename = "__base__/graphics/entity/crude-oil/oil-smoke-outer.png",
          frame_count = 47,
          line_length = 16,
          width = 90,
          height = 188,
          animation_speed = 0.3,
          shift = util.by_pixel(-2, 24 -152),
          scale = 1.5,
          tint = color_outer
        },
        {
          filename = "__base__/graphics/entity/crude-oil/oil-smoke-inner.png",
          frame_count = 47,
          line_length = 16,
          width = 40,
          height = 84,
          animation_speed = 0.3,
          shift = util.by_pixel(0, 24 -78),
          scale = 1.5,
          tint = color_inner
        }
      }
    }
  }
end

data:extend{
  pollution_squib("dust-squib-white", "dust", 20, {0.7, 0.72, 0.8, 0.2}),
  pollution_squib("dust-squib-reddish", "dust", 20, {0.9, 0.65, 0.6, 0.2}),
}
