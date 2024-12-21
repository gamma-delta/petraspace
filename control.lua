local requires = {
  "dust-pollution", "ore-inclusions",
}

for _,req in ipairs(requires) do
  require("__petraspace__/control/" .. req)
end
