local pglobals = require "globals"
local sounds = require "__base__/prototypes/entity/sounds"

-- Make capsule bots good, and all the same tier, one per inner planet.

-- Defenders:
-- - From Vulcanus
-- - Stationary
-- - Basically like turret spam without needing to micro them
local defender = data.raw["combat-robot"]["defender"]
defender.is_military_target = true
defender.speed = 0
-- Still count against follower robot count
defender.follows_player = true
-- tank has 2000
defender.max_health = 1000
-- Slow it down to make it feel punchier?
defender.attack_parameters.cooldown = 35
defender.attack_parameters.ammo_type = 
  data.raw["ammo"]["uranium-rounds-magazine"].ammo_type
-- this is what the tank uses
defender.attack_parameters.sound = sounds.heavy_gunshot
-- How many are spawned is controlled in the *projectile*
-- Capsule item with throw effect ...
-- that creates a projectile ...
-- that spawns the combat-robot on reaching the target
data.raw["projectile"]["defender-capsule"]
  .action.action_delivery.target_effects[1]
  .offsets = {{0, -0.25}, {-0.25, 0.25}, {0.25, 0.25}}

-- Distractors:
-- - From Gleba
-- - Keep flying in the direction you shot them in
-- - Attract enemies to it
local distractor = data.raw["combat-robot"]["distractor"]
distractor.is_military_target = true
distractor.follows_player = true
-- run away!
-- it will always try to "return" to the player,
-- but because its speed is negative it will go the wrong way
distractor.range_from_player = 0.1
distractor.speed = -0.0008
-- so it doesn't accelerate forever
distractor.friction = 0.0002
distractor.max_health = 100
distractor.healing_per_tick = distractor.max_health / 1 / 60
distractor.time_to_live = 15 * 60
distractor.attack_parameters = {
  type = "projectile",
  -- so it doesn't get bonuses
  ammo_category = "biological",
  cooldown = 1 * 60,
  cooldown_deviation = 0,
  range = 16,
  range_mode = "center-to-bounding-box",
  sound = nil,
  -- Not sure why it has to be nested like this
  -- See discharge-defense
  ammo_type = {
    type = "projectile",
    action = {
      {
        type = "area",
        radius = 8.0,
        force = "enemy",
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "script",
              effect_id = "ps-distractor-capsule"
            }
          }
        }
      },
      -- TODO: direct trigger item with puff of smoke?
    }
  }
}
data.raw["projectile"]["distractor-capsule"]
  .action.action_delivery.target_effects[1].offsets = {{0, 0}}

-- Destroyers:
-- - From Fulgora
-- - Fire electric zappies that jump like the gun
-- - On death, explode into electric arcs
-- - Probably still the best capsule but what can I do
local destroyer = data.raw["combat-robot"]["destroyer"]
destroyer.is_military_target = true
destroyer.time_to_live = 15 * 60
destroyer.max_health = 100
destroyer.attack_parameters.cooldown = 60
destroyer.attack_parameters.ammo_type = data.raw["ammo"]["tesla-ammo"].ammo_type
-- to not make it hideously overpowered, hopefully
destroyer.attack_parameters.damage_modifier = 0.25
-- Turn this from Trigger to Trigger[]
local og_destroyer_death_sfx = destroyer.destroy_action
destroyer.destroy_action = {
  og_destroyer_death_sfx,
  -- See grenade
  {
    type = "area",
    radius = 6.0,
    -- Apply the tesla gun zap to every target in range. Blammo!
    -- This includes you, be careful
    action_delivery = data.raw["ammo"]["tesla-ammo"].ammo_type.action.action_delivery
  }
}

-- for some reason this is not an array but the other two are
data.raw["projectile"]["destroyer-capsule"]
  .action.action_delivery.target_effects.offsets = {{0, 0}}
