local pglobals = require("globals")

local function to_rocket_juice(result, icon, order_stub)
  -- amount is the amount produced by 1 drop, or 1 item
  -- fluid ingredients are scaled by 10 first
  return function (name, amount, order, type)
    type = type or "fluid"
    local multiplier = (type == "fluid") and 10 or 1

    -- please don't do any funny business here
    local ingr_proto = data.raw[type][name]
    -- local ingr_size = ingr_proto.icon_size or 64
    local juice_proto = data.raw["fluid"][result]
    -- local juice_size = juice_proto.icon_size or 64
    return {
      type = "recipe",
      name = "pktff-" .. result .. "-from-" .. name,
      categories = { "chemistry", "cryogenics" },
      enabled = false,
      ingredients = {{ type=type, name=name, amount=1*multiplier }},
      energy_required = 1,
      results = {{ type="fluid", name=result, amount=amount*multiplier }},
      subgroup = "pktff-rocket-juice",
      order = order_stub .. order,
      localised_name = {
        "recipe-name." .. "pktff-" .. result .. "-from-whatever",
        {type .. "-name." .. name},
      },
      icons = pglobals.icons.mini_over(ingr_proto.icon, icon),
      crafting_machine_tint = {
        primary = juice_proto.base_color,
        secondary = juice_proto.flow_color,
        tertiary = juice_proto.base_color,
        quaternary = juice_proto.flow_color,
      },
    }
  end
end
local to_fuel = to_rocket_juice("thruster-fuel", "__space-age__/graphics/icons/fluid/thruster-fuel.png", "a[thruster-fuel]-")
local to_oxy = to_rocket_juice("thruster-oxidizer", "__space-age__/graphics/icons/fluid/thruster-oxidizer.png", "b[thruster-oxidizer-]")

--[[
  Water -> H2 + O2
  H2 -> Fuel
  O2 -> Oxidizer
  Pgas + Fe + N (atmosphere) = Ammonia
  Ammonia + O2 -> Nitric acid + water
  Nitric acid + steam + copper -> N2O4
]]

data:extend{
  -- Phase 0: plain electrolysis
  to_fuel("pktff-hydrogen", 0.5, "a"),
  to_oxy("pktff-oxygen", 1, "b"),

  -- or you can do the one block vertical difficulty curve for the beef
  -- Phase 1: nitrogen compound oxidizers, ammonia or kerosene fuel
  to_fuel("ammonia", 2, "c"),
  to_oxy("pktff-nitric-acid", 2, "a"),
  {
    type = "recipe",
    name = "pktff-n2o4-thruster-oxidizer",
    categories = { "chemistry", "cryogenics" },
    ingredients = {
      {type="fluid", name="pktff-nitric-acid", amount=10},
      {type="fluid", name="steam", amount=100},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 35,
    enabled = false,
    results = {
      {type="fluid", name="thruster-oxidizer", amount=300},
    },
    subgroup = "pktff-rocket-juice",
    order = "b[thruster-oxidizer]-b",
    icons = pglobals.icons.two_into_one(
      Asset"graphics/icons/fluid/molecule-nitric-acid.png",
      "__base__/graphics/icons/copper-plate.png",
      "__space-age__/graphics/icons/fluid/thruster-oxidizer.png"
    ),
  },
  to_fuel("rocket-fuel", 500, "d", "item"),
}

local function rocket_part_recipe(gravity)
  -- Nauvis at 10m/s^2 is our baseline.
  local default_fuel = 100
  local real_fuel = default_fuel / 10 * gravity
  return {
    type = "recipe",
    name = "pktff-rocket-part-gravity-" .. gravity,
    energy_required = 3,
    -- CBA to have the right technology unlock all of it.
    -- If you have a rocket silo you can craft it
    enabled = true,
    hide_from_player_crafting = true,
    auto_recycle = false,
    hidden = gravity ~= 10,
    categories = { "rocket-building" },
    ingredients =
    {
      -- Vulcanus
      {type = "item", name = "low-density-structure", amount = 1},
      -- Fulgora
      {type = "item", name = "pktff-rocket-control-unit", amount = 1},
      -- Gleba
      {type = "item", name = "pktff-precision-optical-component", amount = 1},
      {type = "fluid", name = "thruster-fuel", amount = real_fuel, fluidbox_index = 1},
      {type = "fluid", name = "thruster-oxidizer", amount = real_fuel, fluidbox_index = 2},
    },
    results = {{type="item", name="rocket-part", amount=1}},
    allow_productivity = true,
    surface_conditions = {
      -- this shouldn't be possible to get on the wrong surface,
      -- but it will at least make a handy tooltip.
      { property = "gravity", min = gravity, max = gravity }
    },
    localised_name = {
      "",
      {"item-name.rocket-part"},
      " (",
      {"surface-property-name.gravity"},
      " = ",
      {"surface-property-unit.gravity", tostring(gravity)},
      ")"
    }
  }
end
local all_gravities = {}
for _,planet in pairs(data.raw["planet"]) do
  all_gravities[planet.surface_properties.gravity or 10] = true
end
for gravi,_ in pairs(all_gravities) do
  data:extend{ rocket_part_recipe(gravi) }
end
