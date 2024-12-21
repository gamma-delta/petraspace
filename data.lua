local requires = {
  "squibs",

  "tiles",
  "decorations",
  "worldgen/planets",

  "items",
  "machines",
  "fluids",
  "recipes",
  "resources",
  "technologies",

  "dust-pollution",

  "simulations",
}

for _,req in ipairs(requires) do
  require("__petraspace__/prototypes/" .. req)
end
