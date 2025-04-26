-- local do_noise_tools = true
if do_noise_tools then
  -- My local copy of noise-tools is patched to disable all of Earendel's
  -- built-in visuals so i can do it all meself
  noise_debug.remove_non_tile_autoplace()
  noise_debug.tiles_to_visualisation("visualisation", 0, 1, "3-band")
  noise_debug.add_visualisation_target("lepton_has_ground", nil, 1)
  data.raw["noise-expression"]["visualisation"].expression = "debug_lepton_has_ground"

  noise_debug.apply_controls()
end

-- Add heat info to everything
local heatable_types = {
  "boiler", "assembling-machine", "furnace", "generator",
  "heat-interface", "heat-pipe", "reactor",
}
for _,type in ipairs(heatable_types) do
  local protos = data.raw[type]
  for name,proto in pairs(protos) do
    local heat_buf
    if proto.heat_buffer then
      heat_buf = proto.heat_buffer
    elseif proto.energy_source and proto.energy_source.type == "heat" then
      heat_buf = proto.energy_source
    end
    if heat_buf then
      local message = {"text.heat-info", 
        heat_buf.specific_heat, tostring(heat_buf.max_temperature)}
      if proto.factoriopedia_description then
        message = {"", proto.factoriopedia_description, "\n\n", message}
      end
      proto.factoriopedia_description = message
    end
  end
end

-- Make science pack descriptions be their tech descriptions
for _,sp in ipairs{
  "automation-science-pack",
  "logistic-science-pack",
  "military-science-pack",
  "chemical-science-pack",
  "orbital-science-pack",
  "production-science-pack",
  "utility-science-pack",
  "space-science-pack",
  "metallurgic-science-pack",
  "electromagnetic-science-pack",
  "agricultural-science-pack",
  "cryogenic-science-pack",
  "promethium-science-pack",
} do
  local proto = data.raw["tool"][sp]
  proto.localised_description = "technology-name." .. sp
end
