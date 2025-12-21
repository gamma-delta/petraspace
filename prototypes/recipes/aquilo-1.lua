local pglobals = require("globals")

-- Rewards for Aquilo
local function decryo_thruster_juice(ty, order)
  local cold_fluid = data.raw["fluid"]["pktff-cryogenic-thruster-" .. ty]
  local fluoro = data.raw["fluid"]["fluoroketone-cold"]
  data:extend{
    {
      type = "recipe",
      name = "pktff-decryonize-" .. ty,
      icons = {
        {icon = Asset"graphics/icons/fluid/half-cryo-thruster-" .. ty .. ".png"},
        {icon = Asset"graphics/icons/cryo-snowflake.png"}
      },
      category = "cryogenics",

      ingredients = {
        {type="fluid", name="pktff-cryogenic-thruster-" .. ty, amount=10},
        {type="fluid", name="fluoroketone-hot", amount=50, ignored_by_stats=50},
      },
      -- base is 5 seconds to cool it down
      energy_required = 8,
      results = {
        {type="fluid", name="thruster-" .. ty, amount=100},
        {type="fluid", name="fluoroketone-cold", amount=50, ignored_by_stats=50},
      },
      enabled = false,
      allow_productivity = false,
      -- 1: lower inner sloshing
      -- 2: higher inner sloshing
      -- 3: billowing smoke
      -- 4: choked smoke
      crafting_machine_tint = {
        primary = cold_fluid.base_color,
        secondary = cold_fluid.flow_color,
        tertiary = fluoro.flow_color,
        quaternary = fluoro.flow_color,
      },

      subgroup = "pktff-rocket-juice",
      order = order,
    }
  }
end
decryo_thruster_juice("fuel", "a[thruster-fuel]-zzz")
decryo_thruster_juice("oxidizer", "b[thruster-oxidizer]-zzz")

local fluo_color = data.raw["fluid"]["fluoroketone-cold"].base_color
local fluow_color = data.raw["fluid"]["fluoroketone-cold"].flow_color

data:extend{
  {
    type = "recipe",
    name = "pktff-ammonia-cryogenic-thruster-fuel",
    icons = pglobals.icons.mini_over(
      "__space-age__/graphics/icons/fluid/ammonia.png",
      Asset"graphics/icons/fluid/cryo-thruster-fuel.png"
    ),
    category = "cryogenics",
    ingredients = {
      {type="fluid", name="ammonia", amount=100},
      {type="fluid", name="fluoroketone-cold", amount=10, ignored_by_stats=8},
    },
    energy_required = 1,
    results = {
      -- normal is 100 -> 200
      -- this unpacks into 100 -> 300
      {type="fluid", name="pktff-cryogenic-thruster-fuel", amount=30},
      {type="fluid", name="fluoroketone-hot", amount=8,
        ignored_by_stats=8, ignored_by_productivity=9999},
    },
    main_product = "pktff-cryogenic-thruster-fuel",
    enabled = false,

    subgroup = "pktff-rocket-juice",
    order = "c[cryo-fuel]-a",
    crafting_machine_tint = {
      primary = {0.8, 0.1, 0.0, 1},
      secondary = {0.2, 0.1, 0.8, 1},
      tertiary = fluo_color,
      quaternary = fluow_color,
    },
  },
  {
    type = "recipe",
    name = "pktff-lithium-hydrogen-cryogenic-thruster-fuel",
    icons = pglobals.icons.two_into_one(
      "__space-age__/graphics/icons/lithium-plate.png",
      Asset"graphics/icons/fluid/molecule-hydrogen.png",
      Asset"graphics/icons/fluid/cryo-thruster-fuel.png"
    ),
    category = "cryogenics",
    ingredients = {
      {type="item", name="lithium-plate", amount=1},
      {type="fluid", name="pktff-hydrogen", amount=100},
      -- ignore both consumptions, because this breaks even on fktn
      {type="fluid", name="fluoroketone-cold", amount=50, ignored_by_stats=50},
      {type="fluid", name="fluoroketone-hot", amount=10, ignored_by_stats=10},
    },
    energy_required = 6,
    results = {
      {type="fluid", name="pktff-cryogenic-thruster-fuel", amount=30},
      {type="fluid", name="fluoroketone-hot", amount=50,
        ignored_by_stats=50, ignored_by_productivity=9999},
      {type="fluid", name="fluoroketone-cold", amount=10,
        ignored_by_stats=10, ignored_by_productivity=9999},
    },
    main_product = "pktff-cryogenic-thruster-fuel",
    enabled = false,

    subgroup = "pktff-rocket-juice",
    order = "c[cryo-fuel]-b",
    crafting_machine_tint = {
      primary = {0.8, 0.1, 0.0, 1},
      secondary = {0.7, 0.72, 0.7, 1},
      tertiary = fluo_color,
      quaternary = fluow_color,
    },
  },

  {
    type = "recipe",
    name = "pktff-n2o4-cryogenic-thruster-oxidizer",
    icons = pglobals.icons.two_into_one(
      Asset"graphics/icons/fluid/molecule-nitric-acid.png",
      "__space-age__/graphics/icons/fluid/molten-copper.png",
      Asset"graphics/icons/fluid/cryo-thruster-oxidizer.png"
    ),
    category = "cryogenics",
    ingredients = {
      {type="fluid", name="pktff-nitric-acid", amount=100},
      {type="item", name="ice", amount=10},
      {type="fluid", name="molten-copper", amount=50},
      {type="fluid", name="fluoroketone-cold", amount=20},
    },
    energy_required = 20,
    results = {
      -- normal is 10 HNO3 -> 300
      -- this unpacks into 10 -> 500
      -- TOOO: is base N2H4 OP
      {type="fluid", name="pktff-cryogenic-thruster-oxidizer", amount=30},
      {type="fluid", name="fluoroketone-hot", amount=10,
        ignored_by_stats=10, ignored_by_productivity=9999},
    },
    main_product = "pktff-cryogenic-thruster-oxidizer",
    enabled = false,

    subgroup = "pktff-rocket-juice",
    order = "c[cryo-oxidizer]-a",
    crafting_machine_tint = {
      primary = {0.0, 0.1, 0.7, 1},
      -- copper's color
      secondary = {0.53, 0.1, 0.0, 1},
      tertiary = fluo_color,
      quaternary = fluow_color,
    },
  },
  {
    type = "recipe",
    name = "pktff-fluorine-cryogenic-thruster-oxidizer",
    icons = pglobals.icons.mini_over(
      "__space-age__/graphics/icons/fluid/fluorine.png",
      Asset"graphics/icons/fluid/cryo-thruster-oxidizer.png"
    ),
    category = "cryogenics",
    ingredients = {
      {type="fluid", name="fluorine", amount=100},
      {type="fluid", name="fluoroketone-cold", amount=100, ignored_by_stats=50},
    },
    energy_required = 20,
    results = {
      -- 100 fluorine -> 1000 oxy
      {type="fluid", name="pktff-cryogenic-thruster-oxidizer", amount=100},
      {type="fluid", name="fluoroketone-hot", amount=50,
        ignored_by_stats=50, ignored_by_productivity=9999},
    },
    main_product = "pktff-cryogenic-thruster-oxidizer",
    enabled = false,

    subgroup = "pktff-rocket-juice",
    order = "c[cryo-oxidizer]-b",
    crafting_machine_tint = {
      -- fluorine's colors
      primary = {0.0, 0.3, 0.15, 1},
      secondary = {0.1, 0.7, 0.4, 1},
      tertiary = fluo_color,
      quaternary = fluow_color,
    },
  },
}
