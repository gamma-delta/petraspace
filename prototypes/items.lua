local Data = require("__stdlib2__/stdlib/data/data")
local Table = require("__stdlib2__/stdlib/utils/table")

local item_sounds = require("__base__/prototypes/item_sounds")
local spage_sounds = require("__space-age__/prototypes/item_sounds")
local item_tints = require("__base__/prototypes/item-tints")

local rocket_cap = 1000 * kg;

local function make_pics(prefix, count, etc)
  local out = {}
  for i=1,count do
    local row = Table.merge(
      {
        filename = 
          string.format("__petraspace__/graphics/icons/%s/%s.png", prefix, i)
      },
      etc
    )
    table.insert(out, row)
  end
  return out
end

local function data_card_props() return {
  type = "item",
  subgroup = "data-cards",
  stack_size = 100,
  weight = rocket_cap / 1000,
  pick_sound = item_sounds.electric_small_inventory_pickup,
  drop_sound = item_sounds.electric_small_inventory_move,
  move_sound = item_sounds.electric_small_inventory_move,
} end
local function make_programmed_card(name, icon, order, spoil_time)
  -- apparently merge mutates.
  return Table.merge(data_card_props(), {
    name = name,
    icon = icon,
    order = order,
    spoil_result = nil,
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
  make_programmed_card(
    "orbital-data-card",
    "__petraspace__/graphics/icons/orbital-data-card.png",
    "ba",
    -- survive for 1 rotation
    data.raw["planet"]["nauvis"].surface_properties["day-night-cycle"]
  ),
}

data:extend{
  Table.merge(
    Data.Util.duplicate("item", "electronic-circuit", "precision-optical-component"),
    {
      -- between electric engines and robot frames
      order = "c[advanced-intermediates]-ba[poc]",
      icon = "__petraspace__/graphics/icons/precision-optical-component.png",

      -- glassy sound, maybe? i don't want to use science's glassy tink
      -- cause it's only for science
      pick_sound = spage_sounds.ice_inventory_pickup,
      drop_sound = spage_sounds.ice_inventory_move,
      move_sound = spage_sounds.ice_inventory_move,
      weight = rocket_cap / 400,
    }
  )
}

-- Regolith
data:extend{
  Table.merge(
    Data.Util.duplicate("item", "stone", "regolith"),
    {
      subgroup = "raw-resource",
      -- after bauxite?
      order = "fb[regolith]",
      icon = "__petraspace__/graphics/icons/regolith/1.png",
      pictures = make_pics("regolith", 4, {size=64, scale=0.5, mipmap_count = 4})
    }
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
      pictures = make_pics("bauxite", 4, {size=64, scale=0.5, mipmap_count = 4})
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "iron-ore", "native-aluminum"),
    {
      subgroup = "aluminum-processes",
      -- after copper, before uranium
      order = "a[native-aluminum]",
      icon = "__petraspace__/graphics/icons/native-aluminum/1.png",
      pictures = make_pics("native-aluminum", 3, {size=64, scale=0.5, mipmap_count = 4})
    }
  ),
  Table.merge(
    Data.Util.duplicate("item", "iron-plate", "aluminum-plate"),
    {
      weight = rocket_cap / 500,
      subgroup = "aluminum-processes",
      order = "b[aluminum-plate]",
      icon = "__petraspace__/graphics/icons/aluminum-plate.png",
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
    -- gotta put it somewhere...
    type = "ammo-category",
    name = "subatomic-mishap",
  },
  {
    type = "item",
    name = "antimatter-magnetic-bottle",
    stack_size = 1,
    -- by all means, try to get this onto a rocket
    weight = rocket_cap / 100,

    icon = "__petraspace__/graphics/icons/antimatter-magnetic-bottle.png",
    subgroup = "particle-accelerator",
    order = "a",

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
