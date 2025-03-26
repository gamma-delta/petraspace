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
    local_expressions = { prob = cfg.prob } ,
    probability_expression = [[
      ((3 - abs(viate_elevation-10) + (viate_elevation<10)) * prob)
      + (prob * 0.2)
    ]],
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

local function viate_crater_lining_pebble(cfg)
  local rocc = Data.Util.duplicate(
    "optimized-decorative", cfg.src, cfg.name
  )
  rocc.autoplace = {
    order = "a[doodad]-a[rock]-d[crater]-" .. cfg.order,
    local_expressions = { 
      prob = cfg.prob,
      p = "1.3", -- period of trongle
      triangle = "1 / p * abs((viate_meteorness - p/4) % p)"
    },
    probability_expression = [[
      viate_above_basins * (viate_meteorness > 1.5) * (triangle > 0.95) * prob
    ]],
    control = "rocks",
  }
  data:extend{rocc}
end
viate_crater_lining_pebble{
  -- TODO: lighter rocks
  src = "medium-volcanic-rock",
  name = "viate-medium-crater-rock",
  order = "a",
  prob = 0.3,
}
viate_crater_lining_pebble{
  src = "small-volcanic-rock",
  name = "viate-small-crater-rock",
  order = "b",
  prob = 0.5,
}
viate_crater_lining_pebble{
  src = "tiny-volcanic-rock",
  name = "viate-tiny-crater-rock",
  order = "c",
  prob = 0.6,
}

data:extend(
  {
    Table.merge(
      Data.Util.duplicate("simple-entity", "huge-rock", "viate-meteorite"),
      {
        autoplace = {
          probability_expression = "viate_meteor_spot > 0"
        },
        -- This way, more than one doesn't try to generate in each crater
        map_generator_bounding_box = {{-20, -20}, {20, 20}}
      }
    )
  }
)
