local requires = {
  "dust-pollution",
}

for _,req in requires do
  require("__petraspace__/prototypes/" .. req)
end
