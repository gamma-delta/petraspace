require "control/freeplay"

local veh = require "__core__/lualib/event_handler"
veh.add_libraries({
  require("control/dust-pollution"),
  require("control/ore-inclusions"),
  require("control/rockets"),
  require("control/misc"),
})
