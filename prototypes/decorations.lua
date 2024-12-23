local Table = require("__stdlib2__/stdlib/utils/table")
local Data = require("__stdlib2__/stdlib/data/data")

local viate_crust_decal = Data.Util.duplicate(
  "optimized-decorative", "sand-decal", "viate-crust"
)
viate_crust_decal.autoplace.probability_expression = "(elevation>0) * 0.03"

for i,tbl in ipairs(viate_crust_decal.pictures) do
  tbl.filename = string.format(
    "__petraspace__/graphics/decorations/viate/crust-decal-%i.png", i
  )
end

data:extend{ viate_crust_decal }
