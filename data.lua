local requires = {
  "entities/squibs",

  "planets",

  "items",
  "entities/machines",
  "entities/rockets",
  "fluids",
  "recipes",
  "entities/resources",
  "entities/logistics",
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
require "data-updates-at-home/ch-concentrated-solar"
