local requires = {
  "entities/squibs",

  "tiles",
  "decorations",

  "planets/viate",

  "items",
  "entities/machines",
  "entities/rockets",
  "fluids",
  "recipes",
  "entities/resources",
  "technologies",
  "entities/misc",

  "dust-pollution",

  "simulations",
}

for _,req in ipairs(requires) do
  require("__petraspace__/prototypes/" .. req)
end
