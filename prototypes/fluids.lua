data:extend{
  {
    type = "item-subgroup",
    name = "gasses",
    group = "fluids",
    order = "b",
  },
  {
    type = "fluid",
    name = "bauxite-liquor",
    icon = "__petraspace__/graphics/icons/fluid/red-mud.png",
    subgroup = "fluid",
    order = "b[new-fluid]-e[petraspace]-a[bauxite-liquor]",
    default_temperature = 1500,
    max_temperature = 1500,
    heat_capacity = "0.01kJ",
    base_color = { 0.8, 0.45, 0.21 },
    flow_color = { 0.85, 0.50, 0.40 },
    auto_barrel = false,
  },
  {
    type = "fluid",
    name = "molten-aluminum",
    icon = "__petraspace__/graphics/icons/fluid/molten-aluminum.png",
    subgroup = "fluid",
    order = "b[new-fluid]-e[petraspace]-b[molten-aluminum]",
    default_temperature = 1500,
    max_temperature = 1500,
    heat_capacity = "0.01kJ",
    base_color = { 0.8, 0.7, 0.9 },
    flow_color = { 0.67, 0.60, 0.7 },
    auto_barrel = false,
  },
  {
    type = "fluid",
    name = "hydrogen",
    icon = "__petraspace__/graphics/icons/fluid/molecule-hydrogen.png",
    subgroup = "gasses",
    order = "b[new-gas]-a[elemental]-a[hydrogen]",
    -- room temperature idfc
    default_temperature = 300,
    max_temperature = 300,
    -- Always use the gas visualization
    gas_temperature = 0,
    heat_capacity = "0.01kJ",
    base_color = { 0.9, 0.9, 0.92 },
    flow_color = { 0.8, 0.8, 0.92 },
    auto_barrel = false,
  },
  {
    type = "fluid",
    name = "oxygen",
    icon = "__petraspace__/graphics/icons/fluid/molecule-oxygen.png",
    subgroup = "gasses",
    order = "b[new-gas]-a[elemental]-b[oxygen]",
    default_temperature = 300,
    max_temperature = 300,
    gas_temperature = 0,
    heat_capacity = "0.01kJ",
    base_color = { 0.9, 0.3, 0.35 },
    flow_color = { 0.9, 0.2, 0.2 },
    auto_barrel = false,
  },
  {
    type = "fluid",
    name = "nitric-acid",
    icon = "__petraspace__/graphics/icons/fluid/molecule-nitric-acid.png",
    subgroup = "gasses",
    order = "b[new-gas]-b[chemical]-a[nitric-acid]",
    default_temperature = 300,
    max_temperature = 300,
    gas_temperature = 0,
    heat_capacity = "0.01kJ",
    -- Unpleasant toxic red-orange color like RFNA
    base_color = { 0.7, 0.1, 0.05 },
    flow_color = { 0.65, 0.2, 0.0 },
    auto_barrel = false,
  },
  -- unused-renders does not actually have N204, so
  -- nitric acid to oxidizer directly it is
}
