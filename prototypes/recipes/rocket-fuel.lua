-- And rocket oxidizer

data:extend{
  {
    type = "item-subgroup",
    name = "rocket-juice",
    group = "space",
    order = "zzz"
  }
}

local function rocket_juice_icon(result)
  return function(original_icon)
    return {
      {
        icon = result,
        icon_size = 64,
        shift = {2, 0},
      },
      {
        icon = original_icon,
        icon_size = 64,
        scale = 0.333,
        shift = {-6, -6},
        draw_background = true,
      },
      -- {icon = "__petraspace__/graphics/icons/transform-arrow.png"},
    }
  end
end
local fuel_icon = rocket_juice_icon("__space-age__/graphics/icons/fluid/thruster-fuel.png")
local oxy_icon = rocket_juice_icon("__space-age__/graphics/icons/fluid/thruster-oxidizer.png")

local function to_rocket_juice(result, iconator, order_stub)
  return function (name, unit, amt, type)
    type = type or "fluid"
    local drops_per_second = 10
    local time = amt / drops_per_second

    -- please don't do any funny business here
    local ingr_proto = data.raw[type][name]
    local ingr_size = ingr_proto.icon_size or 64
    local juice_proto = data.raw["fluid"][result]
    local juice_size = juice_proto.icon_size or 64
    return {
      type = "recipe",
      name = result .. "-from-" .. name,
      category = "chemistry-or-cryogenics",
      ingredients = {{ type=type, name=name, amount=unit }},
      energy_required = time,
      results = {{ type="fluid", name=result, amount=amt }},
      subgroup = "rocket-juice",
      order = "z[auto]-" .. order_stub,
      localised_name = {
        "recipe-name." .. result .. "-from-whatever",
        {type .. "-name." .. name},
      },
      icons = iconator(ingr_proto.icon),
    }
  end
end
local to_fuel = to_rocket_juice("thruster-fuel", fuel_icon, "a")
local to_oxy = to_rocket_juice("thruster-oxidizer", oxy_icon, "b")

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
  {
    type = "recipe",
    name = "water-electrolysis",
    category = "chemistry",
    ingredients = {
      {type="fluid", name="water", amount=100},
    },
    results = {
      -- Do it in mols, I guess? This is what GT does
      {type="fluid", name="hydrogen", amount=200},
      {type="fluid", name="oxygen", amount=100},
    },
    -- So the play here is to just make a buttload of chemmy plants
    -- and use *efficiency* modules, not speed mods
    energy_required = 600,
    subgroup = "chemistry",
    order = "d[electro]-a",
    -- TODO
    icons = {
      {
        icon = "__base__/graphics/icons/fluid/water.png",
        scale = 0.666,
        shift = {0, -4},
      },
      {
        icon = "__petraspace__/graphics/icons/fluid/molecule-hydrogen.png",
        scale = 0.333,
        shift = {-8, 4},
      },
      {
        icon = "__petraspace__/graphics/icons/fluid/molecule-oxygen.png",
        scale = 0.333,
        shift = {8, 4},
      },
    }
  },
  {
    type = "recipe",
    name = "the-cooler-water-electrolysis",
    category = "electromagnetics",
    ingredients = {
      {type="fluid", name="water", amount=100},
      {type="fluid", name="electrolyte", amount=10},
    },
    results = {
      {type="fluid", name="hydrogen", amount=200},
      {type="fluid", name="oxygen", amount=100},
    },
    energy_required = 60,
    subgroup = "chemistry",
    order = "d[electro]-b",
    -- TODO
    icon = "__base__/graphics/icons/fluid/water.png",
  },
  to_fuel("hydrogen", 10, 5),
  to_oxy("oxygen", 10, 10),

  -- Phase 1: nitrogen compound oxidizers, ammonia or kerosene fuel
  {
    type = "recipe",
    name = "ammonia-synthesis",
    category = "chemistry-or-cryogenics",
    ingredients = {
      {type="fluid", name="petroleum-gas", amount=20},
      -- this way you have something to do with all that hydrogen,
      -- but you still have to juice some of it
      {type="fluid", name="hydrogen", amount=10},
      -- this is your "finely powdered iron".
      -- i am an iron stick truther. if the devs added it, it should
      -- be used for things
      {type="item", name = "iron-stick", amount=4},
    },
    -- surface_conditions = {
    --   {property="atmospheric-nitrogen", min=30}
    -- },
    energy_required = 5,
    results = {{type="fluid", name="ammonia", amount=10}},
    subgroup = "chemistry",
    order = "e[synthesis]-a",
    icon = "__space-age__/graphics/icons/fluid/ammonia.png",
  },
  -- is this just silly?
  to_fuel("ammonia", 10, 20),
  {
    type = "recipe",
    name = "nitric-acid",
    category = "chemistry-or-cryogenics",
    ingredients = {
      {type="fluid", name="ammonia", amount=10},
      {type="fluid", name="oxygen", amount=20},
    },
    energy_required = 7,
    results = {
      {type="fluid", name="nitric-acid", amount=10},
      -- turn this into steam for your n2o4!
      {type="fluid", name="water", amount=10},
    },
    main_product = "nitric-acid",
    subgroup = "chemistry",
    order = "e[synthesis]-b",
  },
  to_oxy("nitric-acid", 10, 30),
  -- or you can do the one block vertical difficulty curve for the beef
  {
    type = "recipe",
    name = "n2o4-thruster-oxidizer",
    category = "chemistry-or-cryogenics",
    ingredients = {
      {type="fluid", name="nitric-acid", amount=10},
      {type="fluid", name="steam", amount=100},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 35,
    results = {
      {type="fluid", name="thruster-oxidizer", amount=70},
    },
    subgroup = "rocket-juice",
    order = "b[oxy]-a",
    icons = oxy_icon("__petraspace__/graphics/icons/fluid/molecule-nitric-acid.png"),
  },
  to_fuel("rocket-fuel", 10, 100, "item"),
}
