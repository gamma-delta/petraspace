local requires = {
  "freeplay",
  "dust-pollution", "ore-inclusions", "rockets",
  "combat-utils"
}

for _,req in ipairs(requires) do
  require("__petraspace__/control/" .. req)
end
