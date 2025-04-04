local viate_tnt = require("prototypes/simulations/viate-tipsntricks")
local rocket_juice = require("prototypes/simulations/rocket-juice")

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
    trigger = {type="change-surface", surface="viate"},
    simulation = viate_tnt.dust,
  },
  {
    type = "tips-and-tricks-item-category",
    name = "rocket-juice",
    order = "jz[after-quality]"
  },
  {
    type = "tips-and-tricks-item",
    name = "rocket-juice-intro",
    category = "rocket-juice",
    is_title = true,
    order = "!first",
    indent = 0,
    trigger = {type="research", technology="lunar-rocket-silo"},
    simulation = rocket_juice.intro
  },
  {
    type = "tips-and-tricks-item",
    name = "rocket-juice-many-kinds",
    category = "rocket-juice",
    is_title = false,
    order = "a",
    indent = 1,
    tag = "[item=rocket-fuel]",
    trigger = {type="research", technology="lunar-rocket-silo"},
    simulation = rocket_juice.many_kinds
  },
}
