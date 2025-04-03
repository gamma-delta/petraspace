local requires = {
  "vanilla",
  "ch-concentrated-solar",
}

for _,req in ipairs(requires) do
  require("__petraspace__/data-updates/" .. req)
end

