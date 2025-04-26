local requires = {
  "entities/squibs",

  "planets",

  "agriculture",
  "items",
  "entities/machines",
  "entities/rockets",
  "fluids",
  "recipes",
  "entities/resources",
  "entities/logistics",
  "entities/platforms",
  "technologies",
  "entities/misc",

  "dust-pollution",

  "tips-and-tricks",
}

for _,req in ipairs(requires) do
  require("__petraspace__/prototypes/" .. req)
end

-- must do these here because otherwise quality can't make the recycling
-- recipes correctly
require "data-updates-at-home/vanilla"

-- jansharp, you are the BEST
local qai = require "__quick-adjustable-inserters__/data_api"
qai.exclude("")
qai.include(qai.to_plain_pattern("tentacle-inserter"))
