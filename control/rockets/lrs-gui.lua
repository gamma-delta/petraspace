local pglobals = require("__petraspace__/globals")
local util = require "__core__/lualib/util"

local lrs_gui = {}

function lrs_gui.get_moony_dest(lrs)
  local moony_dest_name = pglobals.planet_moon_map[lrs.surface.name]
  if moony_dest_name then
    return prototypes.space_location[moony_dest_name]
  else return nil end
end

function lrs_gui.create_gui(evt)
  if evt.gui_type ~= defines.gui_type.entity
      or not evt.entity
      or evt.entity.name ~= "lunar-rocket-silo"
  then
    return
  end
  local player = game.get_player(evt.player_index)
  if not player then return end
  local lrs = evt.entity

  -- somehow it can be already there??
  local root = player.gui.relative["ps-lrs"]
  if root then root.destroy() end

  local title
  local moony_dest = lrs_gui.get_moony_dest(lrs)
  if moony_dest then
    title = {
      "gui.lrs-destination", "[space-location=" .. moony_dest.name .. "]",
      moony_dest.localised_name
    }
  else
    title = "You should never see this"
  end
  root = player.gui.relative.add{
    type = "frame",
    anchor = {
      gui = defines.relative_gui_type.rocket_silo_gui,
      position = defines.relative_gui_position.right,
    },
    caption = title,
    name = "ps-lrs",
    direction = "vertical",
  }

  local content = root.add{
    type = "frame", direction = "vertical",
    name = "content",
    style = "entity_frame",
  }

  local mass_line = content.add{
    type = "flow", direction = "horizontal",
    style = "player_input_horizontal_flow",
    name = "mass-line"
  }
  mass_line.add{
    type = "label", caption = {"gui-rocket-silo.rocket-capacity-used"}
  }
  mass_line.add{
    name = "mass-bar",
    type = "progressbar",
    style = "rocket_weight_used_progress_bar",
  }

  local launch_button = content.add{
    type = "button",
    name = "ps-lrs-launch",
    caption = {"gui.lrs-launch", moony_dest.localised_name},
    -- enabled = not problem,
    -- tooltip = problem
  }

  lrs_gui.update_gui(lrs, root)
end

function lrs_gui.update_gui(lrs, root)
  local player = game.get_player(root.player_index)
  local content = root["content"]

  local mass_bar = content["mass-line"]["mass-bar"]
  local mass = lrs_gui.get_inventory_mass(lrs)
  -- TODO
  local max_mass = 1e6
  local mass_text = (mass == max_mass)
    and "1 ton" or
    util.format_number(mass, "k") .. "g"
  mass_bar.value = mass / max_mass
  mass_bar.caption = {"", mass_text, "/ 1 ton"}

  local launch_button = content["ps-lrs-launch"]
  local moony_dest = lrs_gui.get_moony_dest(lrs)
  local player_ok_empty = true
  for ty in ipairs{
    defines.inventory.character_main, defines.inventory.character_ammo,
    defines.inventory.chracter_trash
  } do
    local inv = player.get_inventory(ty)
    if inv and not inv.is_empty() then
      player_ok_empty = false
      break
    end
  end
  -- it doesn't look like i can use scripts to launch the rocket
  -- w/o its inventory
  local rocket_ok_empty = lrs
    .get_inventory(defines.inventory.rocket_silo_rocket)
    .is_empty()
  local problem
  if not lrs.rocket then
    problem = {"gui-rocket-silo.rocket-is-not-ready"}
  elseif lrs.frozen then
    problem = {"gui-rocket-silo.frozen-rocket"}
  elseif player.controller_type ~= defines.controllers.character then
    problem = {"gui-rocket-silo.cant-travel-remotely"}
  elseif not rocket_ok_empty then
    problem = {"gui.lrs-launch-rocket-not-empty"}
  elseif not player_ok_empty then
    problem = {"gui-rocket-silo.cant-travel-with-items"}
  end
  launch_button.enabled = not problem
  launch_button.tooltip = problem
end

function lrs_gui.get_inventory_mass(lrs)
  local mass = 0
  local inv = lrs.get_inventory(defines.inventory.rocket_silo_rocket)
  if not inv then return nil end

  for _,item in ipairs(inv.get_contents()) do
    local proto = prototypes.item[item.name]
    mass = mass + (proto.weight * item.count)
  end

  return mass
end

function lrs_gui.check_launch(evt)
  if evt.element.name ~= "ps-lrs-launch" then return end
  local player = game.get_player(evt.element.player_index)
  local lrs = player.opened
  if not lrs or lrs.name ~= "lunar-rocket-silo" then return end
  local pod = lrs.rocket.attached_cargo_pod
  if not pod then
    game.print("Somehow tried to launch a LRS without a pod")
    return
  end

  local final_check = lrs.launch_rocket()
  if final_check then
    if not storage.lrs_players_in_pods then storage.lrs_players_in_pods = {} end
    storage.lrs_players_in_pods[pod.unit_number] = {
      player = player,
      character = player.character
    }

    player.opened = nil
    -- Teleporting the player inside the rocket silo hides them from view
    -- due to Z-ordering
    player.teleport({x=lrs.rocket.position.x, y=lrs.rocket.position.y - 1})
    player.set_controller{
      type = defines.controllers.cutscene,
      start_position = pod.position,
      waypoints = {{ target=pod, transition_time=0, time_to_wait=9999999 }}
    }
    player.print("This animation is really jank right now due to engine limitations, sit tight, you'll get there soon")
  end
end

function lrs_gui.check_update(evt)
  for _,player in ipairs(game.connected_players) do
    local lrs = player.opened
    if not lrs or lrs.name ~= "lunar-rocket-silo" then goto continue end
    local the_gui = player.gui.relative["ps-lrs"]
    if not the_gui then goto continue end
    lrs_gui.update_gui(lrs, the_gui)
    ::continue::
  end
end

function lrs_gui.kill_gui(evt)
  if evt.gui_type == defines.gui_type.entity
    and evt.entity
    and evt.entity.name == "lunar-rocket-silo"
  then
    local player = game.get_player(evt.player_index)
    if not player then return end
    local the_gui = player.gui.relative["ps-lrs"]
    if the_gui then
      the_gui.destroy()
    end
  end
end

return {
  events = {
    [defines.events.on_gui_opened] = lrs_gui.create_gui,
    [defines.events.on_gui_closed] = lrs_gui.kill_gui,
    [defines.events.on_gui_click] = lrs_gui.check_launch,
  },
  on_nth_tick = {
    -- Apparently it's OK to run gui events on tick?
    [5] = lrs_gui.check_update
  }
}
