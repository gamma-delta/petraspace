local requires = {
  "dust-pollution",
}

for _,req in requires do
  require("__petraspace__/control/" .. req)
end
