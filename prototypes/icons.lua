local simple_bauxite = {
  {
    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
    scale = 0.7,
    shift = { -16, -16 },
  },
  {
    icon = "__base__/graphics/icons/fluid/steam.png",
    scale = 0.7,
    shift = { 16, -16 },
  },
  {
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    scale = 0.75,
    shift = { 0, 8 },
  },
}
local advanced_bauxite = {
  {
    icon = "__petraspace__/graphics/icons/fluid/red-mud.png",
    scale = 0.5,
    shift = { -16, 16 },
  },
  {
    icon = "__petraspace__/graphics/icons/fluid/molten-aluminum.png",
    scale = 0.5,
    shift = { 16, 16 },
  },
  {
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    scale = 0.75,
    shift = { 0, -8 },
  },
}

return {
  simple_bauxite = simple_bauxite,
  advanced_bauxite = advanced_bauxite,
}
