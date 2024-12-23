local function to_set(tbl)
  local out = {}
  for _,v in ipairs(tbl) do
    out[v] = {}
  end
  return out
end

local function viate_settings()
  return {
    property_expression_names = {
      elevation = "viate_elevation",

      cliffiness = "cliffiness_basic",
      -- it does not look like you can change this?
      cliff_elevation = "cliff_elevation_from_elevation",
      cliff_smoothing = 0.2,
      richness = 1.5,
    },
    cliff_settings = {
      name = "cliff",
      cliff_elevation_interval = 60,
      cliff_elevation_0 = 10,
    },
    autoplace_controls = {
      ["viate_basin"]={},
      ["viate_spotness"]={},
      ["viate_meteors"]={},
    },
    autoplace_settings = {
      tile = { settings = to_set{
        "viate-smooth-basalt",
        "viate-dust-crests",
        "viate-dust-lumpy",
        "viate-dust-patchy",
      } },
      decorative = { settings = to_set{
        "viate-crust"
      } },
      entity = { settings = to_set {
        "ice-deposit"
      } },
    }
  }
end

return {
  viate_settings = viate_settings
}
