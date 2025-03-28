local Table = require("__stdlib2__/stdlib/utils/table")
local effects = require("__core__.lualib.surface-render-parameter-effects")

data:extend{
  {
    type = "noise-expression",
    -- Minimum radius
    name = "lepton_radius",
    expression = 50 -- or whatever
  },
  {
    type = "noise-expression",
    -- Minimum radius
    name = "lepton_overhang_ok",
    expression = 5 -- or whatever
  },
  {
    type = "noise-expression",
    name = "lepton-clock",
    expression = "atan2(y, x)",
  },
  {
    type = "noise-function",
    name = "lepton-clock-random",
    parameters = {"seed0", "seed1", "x", "y", "scale"},
    -- The hard part is that it has to be seamless across the -pi to pi jump
    -- To do this, ignore the atan and actually just trace out a circle in noise space, lol, lmao
    local_expressions = {
      dist = "sqrt(x^2 + y^2)"
    },
    expression = [[
        basis_noise{
          x=x, y=y, seed0=seed0, seed1=seed1,
          scale=scale / dist,
        }
    ]]
  },
  {
    type = "noise-expression",
    name = "lepton-has-ground",
    local_expressions = {
      hang = "distance - lepton_radius"
    },
    -- Have ground if it's in the safe zone,
    -- or if the noise from 0-1 beats the overhang.
    -- So at distance 1 there's a 1/5 chance to fail, 2/5, 3/5, etc
    -- (for lepton_overhang_ok=5)
    -- Based on the angle; with a small enough scale this should disallow floating rocks
    -- because once an angle "loses" the check it can never win it again by going further.
    expression = [[
        (distance <= lepton_radius)
        | (lepton_clock_random(seed, "lepton-has-ground", x, y, 5) > (hang/lepton_overhang_ok))
    ]]
  }
}
