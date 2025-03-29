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
