local viate_tnt = require("prototypes/simulations/viate-tipsntricks")

data:extend{
  {
    type = "tips-and-tricks-item",
    name = "viate-welcome",
    tag = "[planet=viate]",
    order = "![before-fulgora]-a",
    trigger = {type="research", technology="discover-viate"},
    simulation = viate_tnt.welcome,
  },
  {
    type = "tips-and-tricks-item",
    name = "viate-dust",
    order = "![before-fulgora]-b",
    indent = 1,
    tag = "[fluid=steam]",
    trigger = {type="research", technology="viate-dust"},
    simulation = viate_tnt.dust,
  }
}
