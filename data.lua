local requires = {
  "dust-pollution",

  "tiles",
  "decorations",
  "worldgen/planets",

  "items",
  "machines",
  "fluids",
  "recipes",
  "resources",
  "technologies",

  "simulations",
}

for _,req in ipairs(requires) do
  require("__petraspace__/prototypes/" .. req)
end
