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
      cliff_elevation = "cliff_elevation_from_elevation",

      ["entity:ice-deposit:probability"] = "viate_ice_deposit_probability",
    },
    cliff_settings = {
      name = "cliff",
      cliff_elevation_interval = 70,
      cliff_elevation_0 = 0,
    },
    autoplace_controls = {},
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
