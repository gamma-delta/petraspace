local requires = {
  "dust-pollution",
}

for _,req in ipairs(requires) do
  require("__petraspace__/control/" .. req)
end
