data:extend{
  {
    type = "double-setting",
    name = "pktff-dust-to-1percent-slower",
    minimum_value = 1,
    default_value = 10,
    setting_type = "runtime-global",
  },
  {
    type = "double-setting",
    name = "pktff-speed-to-thruster-damage-per-minute",
    minimum_value = 0,
    -- at 100km/s, take 10 minutes to die
    default_value = 300 / (100 * 10),
    setting_type = "runtime-global",
  }
}
