local Table = require("__stdlib2__/stdlib/utils/table")
local effects = require("__core__.lualib.surface-render-parameter-effects")

local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local pglobals = require("globals")

data:extend{
  {
    type = "noise-expression",
    -- Minimum radius
    name = "lepton_radius",
    expression = 40 -- or whatever
  },
  {
    type = "noise-expression",
    -- Minimum radius
    name = "lepton_overhang_ok",
    expression = 10 -- or whatever
  },
  {
    type = "noise-expression",
    -- Minimum radius
    name = "lepton_overhang_bonus",
    expression = 0.9
  },
  {
    type = "noise-expression",
    name = "lepton_clock",
    expression = "atan2(y, x)",
  },
  {
    type = "noise-expression",
    name = "lepton_has_ground",
    local_expressions = {
      hang = "distance - lepton_radius",
      -- input scale. i can't pass a non-constant to the basis_noise
      is = "3 / distance"
    },
    -- Have ground if it's in the safe zone,
    -- or if the noise from 0-1 beats the overhang.
    -- So at distance 1 there's a 1/5 chance to fail, 2/5, 3/5, etc
    -- (for lepton_overhang_ok=5)
    -- Plus a little bonus so it's more differentiated
    -- Based on the angle; with a small enough scale this should disallow floating rocks
    -- because once an angle "loses" the check it can never win it again by going further.
    -- Also, clock noise needs to be retyped by hand every time cause noise
    -- functions require constants
    expression = [[
        (distance <= lepton_radius)
        | (multioctave_noise{
            x=x*is, y=y*is, seed0=map_seed, seed1="lepton-has-ground",
            persistence=0.7, octaves=3
          }/2+0.5 > (hang/lepton_overhang_ok*lepton_overhang_bonus))
    ]]
  },
  {
    type = "noise-expression",
    name = "lepton_elevation",
    expression = "0"
  }
}

-- I don't have any idea what this does
local lepton_offset = 80

-- Empty space always spawns if there is no other tile spawned there
-- (very low order, probability=1000)
data:extend{
  {
    type = "item-subgroup",
    name = "lepton-tiles",
    group = "tiles",
    order = "f-b",
  },
  pglobals.copy_then(
    data.raw["tile"]["empty-space"],
    {
      name = "lepton-space",
      subgroup = "lepton-tiles",
      offset = lepton_offset,
      default_cover_tile = nil,
    	collision_mask = {
    		colliding_with_tiles_only = true,
    		not_colliding_with_itself = true,
    		layers = data.raw.tile["empty-space"].collision_mask.layers,
    	},
    	destroys_dropped_items = true,
    }
  ),
  pglobals.copy_then(
    data.raw["tile"]["volcanic-cracks-hot"],
    {
      name = "lepton-cracks-hot",
      subgroup = "lepton-tiles",
      offset = lepton_offset + 1,
      autoplace = {
        probability_expression="lepton_has_ground"
      },
    }
  ),
}

data:extend{{
  type = "planet",
  name = "lepton",
  icon = "__space-age__/graphics/icons/vulcanus.png",
  starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
  starmap_icon_size = 512,

  gravity_pull = 10,
  distance = 12,
  orientation = 0.3,
  magnitude = 1.5,
  order = "a[nauvis]-a",
  subgroup = "planets",
  pollutant_type = nil,
  solar_power_in_space = 1000,
  platform_procession_set =
  {
    arrival = {"planet-to-platform-b"},
    departure = {"platform-to-planet-a"}
  },
  planet_procession_set =
  {
    arrival = {"platform-to-planet-b"},
    departure = {"planet-to-platform-a"}
  },
  procession_graphic_catalogue = planet_catalogue_vulcanus,
  asteroid_spawn_influence = 1,
  asteroid_spawn_definitions = {},

  surface_render_parameters = {
    -- TODO: could maybe use this to render meteor shadows?
    clouds = nil,
    day_night_cycle_color_lookup = data.raw["planet"]["vulcanus"].
      surface_render_parameters.day_night_color_cycle_lookup
  },

  map_gen_settings = {
    property_expression_names = {
      elevation = "lepton_elevation",
      cliffiness = 0,
      -- it does not look like you can change this?
      cliff_elevation = 0,
      cliff_smoothing = 0.0,
      richness = 3.5,
      aux = 0,
      moisture = 0,
    },
    cliff_settings = nil,
    autoplace_controls = {
    },
    autoplace_settings = {
      tile = { settings = pglobals.set_with({}){
        "lepton-cracks-hot",
        "lepton-space",
      } },
      decorative = { settings = {} },
      entity = { settings = {} },
    }
  },
  surface_properties = {
    ["day-night-cycle"] = 0.75 * minute,
    ["solar-power"] = 700,
    pressure = 0,
    gravity = 1,
    ["magnetic-field"] = 0,
  },
}}


