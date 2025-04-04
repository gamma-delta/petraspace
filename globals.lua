local planet_moon_map = {
  nauvis = "viate",
  viate = "nauvis",
}

local function copy_then(tbl, ...)
  local Table = require("__stdlib2__/stdlib/utils/table")
  local table2 = Table.deep_copy(tbl)
  -- So PIL just lies to me and i have to use `...` and not `arg`
  -- also, i can't just ipairs over varargs due to ?????
  local varargs = table.pack(...)
  for _,splat in ipairs(varargs) do
    table2 = Table.merge(table2, splat)
  end
  return table2
end

-- Returns a function that makes a set, each key of the array mapped to default
local function set_with(default)
  return function(array)
    local out = {}
    for _,v in ipairs(array) do
      out[v] = default
    end
    return out
  end
end
local function set(array)
  return set_with(true)(array)
end

local function surface_prop(planet, prop_name)
  local default = data.raw["surface-property"].default_value
  
  local prop_value = data.raw["planet"].surface_properties[prop_name]
  return prop_value or default
end

local function make_empty_space(prefix, etc)
  return copy_then(
    data.raw["tile"]["empty-space"],
    {
      name = prefix .. "-empty-space",
      subgroup = prefix .. "-tiles",
      default_cover_tile = nil,
    	collision_mask = {
    		colliding_with_tiles_only = true,
    		not_colliding_with_itself = true,
    		layers = data.raw.tile["empty-space"].collision_mask.layers,
    	},
    	destroys_dropped_items = true,
    },
    etc or {}
  )
end

local function make_blobby_radius_expr(cfg)
  local out = {
    type = "noise-expression",
    name = cfg.name,
    local_expressions = {
      hang = "distance - " .. cfg.radius,
      is = cfg.input_scale .. " / distance",
      radius = cfg.radius,
      overhang_ok = cfg.overhang_ok,
      overhang_bonus = cfg.overhang_bonus,
      persistence = cfg.persistence or "0.7",
      octaves = cfg.octaves or "3",
    },
    -- Have ground if it's in the safe zone,
    -- or if the noise from 0-1 beats the overhang.
    -- So at distance 1 there's a 1/5 chance to fail, 2/5, 3/5, etc
    -- (for overhang_ok=5)
    -- Plus a little bonus so it's more differentiated
    -- Based on the angle; with a small enough scale this should disallow floating rocks
    -- because once an angle "loses" the check it can never win it again by going further.
    -- Also, clock noise needs to be done by macro every time cause noise
    -- functions require constants
    expression = string.format([[
        (distance <= radius)
        | (multioctave_noise{
            x=x*is, y=y*is, seed0=map_seed, seed1=%s,
            persistence=persistence, octaves=octaves
          }/2+0.5 > (hang/lepton_overhang_ok*lepton_overhang_bonus))
    ]], cfg.seed)
  }
  return copy_then(out, cfg.etc or {})
end

local icons = {
  mini_over = function(mini, background)
    return {
      {
        icon = background,
      },
      {
        icon = mini,
        scale = 0.3333,
        shift = {-8, -8}
      },
    }
  end,
  one_into_two = function(input, out1, out2)
    return {
      {
        icon = input,
        scale = 0.75,
        shift = {0, -8},
      },
      {
        icon = out1,
        scale = 0.5,
        shift = {-16, 16},
        draw_background = true
      },
      {
        icon = out2,
        scale = 0.5,
        shift = {-16, 16},
        draw_background = true
      }
    }
  end,
  two_into_one = function(in1, in2, output)
    -- Convention set by light oil cracking is to have the inputs under the out
    return {
      {
        icon = in1,
        scale = 0.5,
        shift = {-16, -16},
        draw_background = true
      },
      {
        icon = in2,
        scale = 0.5,
        shift = {-16, -16},
        draw_background = true
      },
      {
        icon = output,
        scale = 0.75,
        shift = {0, 8},
      },
    }
  end
}

return {
  planet_moon_map = planet_moon_map,
  copy_then = copy_then,
  set_with = set_with,
  set = set,
  make_empty_space = make_empty_space,
  make_blobby_radius_expr = make_blobby_radius_expr,
  icons = icons,
}
