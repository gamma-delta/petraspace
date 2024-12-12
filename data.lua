local requires = {
  "dust-pollution", "machines", "planets",
}

for _,req in ipairs(requires) do
  require("__petraspace__/prototypes/" .. req)
end
