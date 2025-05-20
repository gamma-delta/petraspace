local pglobals = require("globals")

data:extend{
  {
    type = "burner-usage",
    name = "mfp-scouts",
    empty_slot_sprite = {
      filename = "__core__/graphics/icons/mip/empty-robot-slot.png",
      priority = "extra-high-no-scale",
      size = 64, mipmap_count = 2,
      flags = {"gui-icon"},
    },
    empty_slot_caption = {"gui.mfp-scouts"},
    empty_slot_description = {"gui.mfp-scouts-description"},
    icon = {
      filename = "__petraspace__/graphics/icons/mfp-no-scouts.png",
      priority = "extra-high-no-scale",
      size = 64,
      flags = {"icon"},
    },
    no_fuel_status = {"entity-status.mfp-no-scouts"},
    accepted_fuel_key = "description.mfp-accepted-scouts",
    burned_in_key = "mfp-scout-burned-in",
  },
  {
    type = "fuel-category",
    name = "mfp-scouts",
    fuel_value_type = {"description.mfp-scouts-energy-value"}
  },
  {
    type = "fuel-category",
    name = "antimatter",
  },
  {
    type = "collision-layer",
    name = "strafer_anti_air_target"
  },
}
