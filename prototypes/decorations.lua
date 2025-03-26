local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")

local hit_itself = { 
  layers={water_tile=true, doodad=true},
  colliding_with_tiles=true
}

local viate_crust_decal = Data.Util.duplicate(
  "optimized-decorative", "sand-decal", "viate-crust"
)
viate_crust_decal.autoplace.probability_expression = [[
  (viate_elevation >= 20)
  * (viate_meteorness < 1) / (1-viate_meteorness) * 0.01
]]
-- Intersect with itself, but appear under other rocks and stuff
viate_crust_decal.collision_mask = hit_itself
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
  rocc.collision_mask_connector = hit_itself
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
  rocc.collision_mask = hit_itself
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

local function viate_maria_flavor(cfg)
  local deco = Data.Util.duplicate("optimized-decorative", cfg.src, cfg.name)
  deco.autoplace = {
    -- Place after the maria liners so they don't overflow
    order = "a[doodad]-z[maria-flavor]-" .. cfg.order,
    local_expressions = {prob = cfg.prob},
    probability_expression = [[
      (viate_elevation < -5) * prob * 0.02
    ]],
  }
  deco.collision_mask = hit_itself
  data:extend{ deco }
end
viate_maria_flavor{
  src="waves-decal",
  name="viate-maria-waves",
  order="a",
  prob=0.03
}
viate_maria_flavor{
  src="pumice-relief-decal",
  name="viate-maria-pumice",
  order="b",
  prob=0.20
}
viate_maria_flavor{
  src="nuclear-ground-patch",
  name="viate-maria-dirt",
  order="c",
  prob=0.05
}

local function viate_random_crater(cfg)
  local deco = Data.Util.duplicate("optimized-decorative", cfg.src, cfg.name)
  deco.autoplace = {
    -- Place after the maria liners so they don't overflow
    order = "a[doodad]-b[crater]-" .. cfg.order,
    local_expressions = {prob = cfg.prob},
    probability_expression = [[
      (viate_above_basins) * prob * 0.3
    ]],
  }
  deco.collision_mask = hit_itself
  data:extend{ deco }
end
viate_random_crater{
  src="calcite-stain-small",
  name="viate-white-stain",
  order="a",
  prob=0.017
}
viate_random_crater{
  src="crater-large",
  name="viate-crater-large",
  order="b",
  prob=0.01
}
viate_random_crater{
  src="crater-small",
  name="viate-crater-small",
  order="c",
  prob=0.015
}

data:extend(
  {
    Table.merge(
      Data.Util.duplicate("simple-entity", "huge-volcanic-rock", "viate-meteorite"),
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
