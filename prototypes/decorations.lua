local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")

local viate_crust_decal = Data.Util.duplicate(
  "optimized-decorative", "sand-decal", "viate-crust"
)
viate_crust_decal.autoplace.probability_expression = 
  "(elevation>20) * 0.001 * viate_meteorness"

for i,tbl in ipairs(viate_crust_decal.pictures) do
  tbl.filename = string.format(
    "__petraspace__/graphics/decorations/viate/crust-decal-%i.png", i
  )
end

data:extend{ viate_crust_decal }

local function viate_maria_edge_pebble(cfg)
  local rocc = Data.Util.duplicate(
    "optimized-decorative", cfg.src, cfg.name
  )
  rocc.autoplace = {
    order = "a[doodad]-a[rock]-c[maria]-" .. cfg.order,
    probability_expression = [[
      (3 - abs(viate_elevation-10) + (viate_elevation<10)) *
    ]] .. cfg.prob,
    control = "rocks",
  }
  data:extend{rocc}
end

viate_maria_edge_pebble{
  src = "medium-volcanic-rock",
  name = "viate-medium-maria-rock",
  order = "a",
  prob = 0.05,
}
viate_maria_edge_pebble{
  src = "small-volcanic-rock",
  name = "viate-small-maria-rock",
  order = "b",
  prob = 0.07,
}
viate_maria_edge_pebble{
  src = "tiny-volcanic-rock",
  name = "viate-tiny-maria-rock",
  order = "c",
  prob = 0.1,
}

data:extend(
  {
    Table.merge(
      Data.Util.duplicate("simple-entity", "huge-rock", "viate-meteorite"),
      {
        autoplace = {
          probability_expression = "viate_meteor_spot"
        }
      }
    )
  }
)
