local requires = {
  "entities/squibs",

  "tiles",
  "decorations",

  "planets",

  "items",
  "entities/machines",
  "entities/rockets",
  "fluids",
  "recipes",
  "entities/resources",
  "technologies",
  "entities/misc",

  "dust-pollution",

  "tips-and-tricks",

  -- Have to do "updates" here because otherwise recycling has a bad time
  "data-updates-at-home/vanilla",
  "data-updates-at-home/ch-concentrated-solar",
}

for _,req in ipairs(requires) do
  require("__petraspace__/prototypes/" .. req)
end
