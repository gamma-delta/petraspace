local pglobals = require "globals"

local item_sounds = require("__base__/prototypes/item_sounds")
local spage_sounds = require("__space-age__/prototypes/item_sounds")
local item_tints = require("__base__/prototypes/item-tints")

local rocket_cap = 1000 * kg

local function make_pics(prefix, count, etc)
  local out = {}
  for i=1,count do
    local row = util.merge{
      {
        filename = 
          string.format("__petraspace__/graphics/icons/%s/%s.png", prefix, i),
        size = 64, mipmap_count = 4, scale = 0.5,
      },
      etc or {}
    }
    table.insert(out, row)
  end
  return out
end

local function make_programmed_card(name, icon, order, spoil_time)
  return {
    type = "item",
    name = name,
    subgroup = "data-cards",
    icon = icon,
    order = order,

    -- This way it actually shows in the UI that it spoils into something.
    spoil_result = "copper-cable",
    spoil_ticks = spoil_time,

    stack_size = 100,
    weight = rocket_cap / 1000,
    pick_sound = item_sounds.electric_small_inventory_pickup,
    drop_sound = item_sounds.electric_small_inventory_move,
    move_sound = item_sounds.electric_small_inventory_move,
  }
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

-- Common components
data:extend{
  pglobals.copy_then(
    data.raw["item"]["plastic-bar"],
    {
      name = "circuit-substrate",
      order = "b[circuits]-![circuit-substrate]",
      icon = "__petraspace__/graphics/icons/circuit-substrate.png",
      weight = rocket_cap / 1000,
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["electronic-circuit"],
    {
      name = "precision-optical-component",
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

  -- === Aluminum === --
data:extend{
  {
    type = "item-subgroup",
    name = "aluminum-processes",
    group = "intermediate-products",
    -- right after raw-material, the row with iron&copper plates
    order = "ca",
  },
  
  pglobals.copy_then(
    data.raw["item"]["iron-ore"],
    {
      -- yes, bauxite ore is redundant
      name = "bauxite-ore",
      subgroup = "raw-resource",
      -- after copper, before uranium
      order = "fa[bauxite-ore]",
      icon = "__petraspace__/graphics/icons/bauxite/1.png",
      pictures = make_pics("bauxite", 4),
      -- Otherwise it will detect the "locked" recipe for petrichor enrichment
      -- and restrict it.
      flags = {"always-show"},
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["iron-ore"],
    {
      name = "native-aluminum",
      subgroup = "aluminum-processes",
      -- after copper, before uranium
      order = "a[native-aluminum]",
      icon = "__petraspace__/graphics/icons/native-aluminum/1.png",
      pictures = make_pics("native-aluminum", 3)
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["iron-ore"],
    {
      name = "aluminum-plate",
      weight = rocket_cap / 500,
      subgroup = "aluminum-processes",
      order = "b[aluminum-plate]",
      icon = "__petraspace__/graphics/icons/aluminum-plate.png",
    }
  ),
}

-- Viate
data:extend{
  pglobals.copy_then(
    data.raw["item"]["stone"],
    {
      name = "regolith",
      subgroup = "raw-resource",
      -- after bauxite?
      order = "fb[regolith]",
      icon = "__petraspace__/graphics/icons/regolith/1.png",
      pictures = make_pics("regolith", 4)
    }
  ),
}

-- Vulcanus
data:extend{
  pglobals.copy_then(data.raw["item"]["calcite"], {
    name = "quicklime",
    order = "a[melting]-za",
    icon = "__petraspace__/graphics/icons/quicklime/1.png",
    pictures = make_pics("quicklime", 3),
  }),
  pglobals.copy_then(data.raw["item"]["tungsten-ore"], {
    name = "magnesium-slag",
    order = "za[refinement]-a[magnesium-slag]",
    -- Using malcolm's titanium as "magnesium" to get the consistent color
    -- in my mind magnesium is pinkish? but this is probably because of greg
    -- Only using the first 3 images b/c they have better contrast
    icon = "__petraspace__/graphics/icons/magnesium-slag/1.png",
    pictures = make_pics("magnesium-slag", 3),
  }),
}

-- Gleba
data:extend{
  pglobals.copy_then(data.raw["capsule"]["yumako"], {
    type = "item",
    name = "boompuff-propagule",
    icon = "__petraspace__/graphics/icons/boompuff-propagule.png",
    order = "b[agriculture]-b[jellynut]-a[boompuff-propagule]",
    -- place_result overrides the normal name/desc stuff
    localised_name = {"item-name.boompuff-propagule"},
    localised_description = {"item-description.boompuff-propagule"},
    pictures = { sheet = {
      filename = "__petraspace__/graphics/icons/boompuff-propagule-sheet.png",
      width = 64, height = 64, scale = 0.5,
      variation_count = 8,
    }},
    -- same as wood
    stack_size = 100,
    weight = rocket_cap / 500,
    plant_result = "boompuff-plant",
    place_result = "boompuff-plant",
    -- no i'm not making it explode! i'm pulling that joke already
    -- with particle physics!
    -- i might steal lordmiguels' grenades-at-home tho
    spoil_ticks = 5 * minute,
    capsule_action = nil,
    fuel_category = "chemical",
    -- a little better than coal
    fuel_value = "5MJ",
  }),
}
-- Stop burning these wet fruits that makes no sense
for _,stopthat in ipairs{"yumako", "jellynut"} do
  local it = data.raw["capsule"][stopthat]
  it.fuel_value = nil
  it.fuel_category = nil
end
-- sigh
data:extend{
  {
    name = "fertilizer",
    type = "item",
    icon = "__petraspace__/graphics/icons/fertilizer/1.png",
    subgroup = "agriculture-products",
    order = "c[nutrients]-z-a[fertilizer]",
    pictures = make_pics("fertilizer", 3, {size=64, scale=0.5, mipmap_count=4}),
    fuel_category = "nutrients",
    fuel_value = "3MJ",
    inventory_move_sound = spage_sounds.agriculture_inventory_move,
    pick_sound = spage_sounds.agriculture_inventory_pickup,
    drop_sound = spage_sounds.agriculture_inventory_move,
    stack_size = 100,
    spoil_ticks = nil,
    spoil_result = nil,
    weight = rocket_cap / 1000,
    default_import_location = "gleba",
  },
  {
    type = "item",
    name = "presto-fuel",
    icon = "__base__/graphics/icons/rocket-fuel.png",
    fuel_category = "chemical",
    fuel_value = "1MJ",
    fuel_acceleration_multiplier = 12.1,
    fuel_top_speed_multiplier = 2,
    subgroup = "agriculture-products",
    subgroup = "intermediate-product",
    order = "a[organic-products]-z-d[presto-fuel]",
    inventory_move_sound = item_sounds.fuel_cell_inventory_move,
    pick_sound = item_sounds.fuel_cell_inventory_pickup,
    drop_sound = item_sounds.fuel_cell_inventory_move,
    stack_size = 1,
    weight = rocket_cap / 100,
  }
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

data:extend{
  {
    type = "item",
    name = "antimatter-cell",
    stack_size = 1,
    icons = {
      { icon = "__petraspace__/graphics/icons/antimatter-cell.png" },
      { icon = "__petraspace__/graphics/icons/antimatter-cell-glow.png" },
    },
    pictures = { layers = {
      {
        filename = "__petraspace__/graphics/icons/antimatter-cell.png",
        size = 64,
        scale = 0.5,
      },
      {
        filename = "__petraspace__/graphics/icons/antimatter-cell-glow.png",
        size = 64,
        scale = 0.5,
        draw_as_light = true,
      },
    }},

    fuel_category = "antimatter",
    fuel_value = "500GJ"
  },
}

-- === Science! === --
local function science_pack(name, order, icon, tint)
  return pglobals.copy_then(
    data.raw["tool"]["automation-science-pack"],
    {
      name = name,
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
