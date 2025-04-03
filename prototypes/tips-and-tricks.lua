local viate_tnt = require("prototypes/simulations/viate-tipsntricks")

data:extend{
  {
    type = "tips-and-tricks-item",
    name = "viate-welcome",
    category = "space-age",
    tag = "[planet=viate]",
    order = "![before-fulgora]-a",
    trigger = {type="research", technology="discover-viate"},
    simulation = viate_tnt.welcome,
  },
  {
    type = "tips-and-tricks-item",
    name = "viate-dust",
    category = "space-age",
    order = "![before-fulgora]-b",
    indent = 1,
    tag = "[fluid=steam]",
    trigger = {type="surface", surface="viate"},
    simulation = viate_tnt.dust,
  }
}
