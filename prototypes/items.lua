local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local item_sounds = require("__base__/prototypes/item_sounds")
local item_tints = require("__base__/prototypes/item-tints")

local rocket_cap = 1000 * kg;

local function data_card_props() return {
  type = "item",
  subgroup = "data-cards",
  stack_size = 100,
  weight = rocket_cap / 1000,
  pick_sound = item_sounds.electric_small_inventory_pickup,
  move_sound = item_sounds.electric_small_inventory_move,
} end
local function make_programmed_card(name, icon, order, spoil_time)
  -- apparently merge mutates.
  return Table.merge(data_card_props(), {
    name = name,
    icon = icon,
    order = order,
    spoil_result = "expired-data-card",
    spoil_ticks = spoil_time,
  })
end

data:extend{
  -- === Data cards === --
  {
    type = "item-subgroup",
    name = "data-cards",
    group = "intermediate-products",
    -- right before science
    order = "x",
  },
  Table.merge(data_card_props(), {
    name = "blank-data-card",
    order = "a[blank]",
    icon = "__petraspace__/graphics/icons/blank-data-card.png",
  }),
  Table.merge(data_card_props(), {
    name = "expired-data-card",
    order = "z[expired]",
    icon = "__petraspace__/graphics/icons/expired-data-card.png",
  }),
}
data:extend{
  -- Do this in chunks because apparently this doesn't believe expired-data-card is real
  make_programmed_card(
    "orbital-data-card",
    "__petraspace__/graphics/icons/orbital-data-card.png",
    "ba",
    data.raw["planet"]["nauvis"].surface_properties["day-night-cycle"]
  ),
}

  -- === Aluminum === --
data:extend{
  {
    type = "item-subgroup",
    name = "aluminum-processes",
    group = "intermediate-products",
    -- right after raw-material, the row with iron&copper plates
    order = "ca",
  },
  
  Table.merge(
    Data.Util.duplicate("item", "iron-ore", "bauxite-ore"),
    {
      subgroup = "raw-resource",
      -- after copper, before uranium
      order = "fa[bauxite-ore]",
      icon = "__petraspace__/graphics/icons/bauxite/1.png",
      pictures =
      {
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite/1.png", scale = 0.5, mipmap_count = 4},
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite/2.png", scale = 0.5, mipmap_count = 4},
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite/3.png", scale = 0.5, mipmap_count = 4},
        {size = 64, filename = "__petraspace__/graphics/icons/bauxite/4.png", scale = 0.5, mipmap_count = 4},
      },
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "iron-plate", "aluminum-nugget"),
    {
      weight = rocket_cap / 2000,
      -- right after steel plates
      subgroup = "aluminum-processes",
      order = "b[aluminum-nugget]",
      icon = "__petraspace__/graphics/icons/aluminum-ingot.png",
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "iron-plate", "aluminum-plate"),
    {
      weight = rocket_cap / 500,
      subgroup = "aluminum-processes",
      order = "c[aluminum-plate]",
      icon = "__petraspace__/graphics/icons/aluminum-ingot.png",
    }
  ),
}

-- Particle physics
data:extend{
  {
    type = "item-subgroup",
    name = "particle-accelerator",
    group = "intermediate-products",
    -- after uranium
    order = "j",
  },
  {
    type = "item",
    name = "empty-muon-trap",
    stack_size = 1,
    weight = rocket_cap / 100,

    icon = "__petraspace__/graphics/icons/muon-trap.png",
    subgroup = "particle-accelerator",
    order = "a",
  },
  {
    -- gotta put it somewhere...
    type = "ammo-category",
    name = "subatomic-mishap",
  },
  {
    type = "item",
    name = "full-muon-trap",
    stack_size = 1,
    -- by all means, try to get this onto a rocket
    weight = rocket_cap / 100,

    subgroup = "particle-accelerator",
    order = "a",
    icon = "__petraspace__/graphics/icons/full-muon-trap.png",

    spoil_ticks = 10*60,
    spoil_to_trigger_result = { 
      items_per_trigger = 1,
      trigger = {
        type = "direct",
        action_delivery = {
          type = "instant",
          source_effects = {
            type = "create-entity",
            entity_name = "subatomic-mishap-explosion",
            show_in_tooltip = true,
          }
        }
      }
    }
  },
  make_programmed_card(
    "subatomic-data-card",
    "__petraspace__/graphics/icons/orbital-data-card.png",
    "be", 60*60*15
  ),
}

-- === Science! === --
local function science_pack(name, order, icon, tint)
  return Table.merge(
    Data.Util.duplicate("tool", "automation-science-pack", name),
    {
      icon = icon,
      order = order,
      random_tint_color = tint,
    }
  )
end
data:extend{
  science_pack(
    "orbital-science-pack", "d[chemical-science-pack]-a",
    "__petraspace__/graphics/icons/orbital-science-pack.png",
    item_tints.bluish_science
  ),
}
