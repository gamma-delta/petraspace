local out = {}

out.dirty_steel = {
  checkerboard = true,
  planet = "nauvis",
  init = [[
    game.surfaces[1].create_global_electric_network()
    game.forces.player.enable_all_recipes()
    game.simulation.camera_alt_info = true
    local bp = "0eNqtmO2uojAQhu+lv+GEfvHhrZycGNTBbYKFlHKyruHet+BRzAo6bdY/REqfmQ7z0je9kF3dQ2uUtmRzIWrf6I5sPi+kU0dd1uM9XZ6AbIg1pe7axth4B7UlQ0SUPsBvsqHDV0RAW2UVXOdOf85b3Z92YNwD0Y2hdKW0G4r3v6CzJCJt07lpjR7jOBQTHzIiZ7KJU/YhpxDXCdsOrFX62I0PGjg137Dt3VhtwcBhqyyc3FBV1h1E5Hr7mspP4H3j1hK5Sz+uUyYROTWHcaC0cQ3llMu8nGGInhbB7ouom/Lg7rxKnrrUD8rA/jqcR8Se23Fu09u2H4v3xOfRSqGf4gh6j5NMRXqIJBbIAk9O/MgST+Z+5BRPZn7kDE1m8kaWBYac48nCj1zgyZkfmSZ4dOqJpnh04YlmeHTuicbrkFNPNF6IPPFE45XIuScaL0XOPNF4LXJPLVK8GLmnGClejdxTjWxWY+X2pFjpDoxd2mseyK7BF/crvPy4p7IZXn7cU9nMQ36eymYh++CEXoJJ7Jt6YK29qRTN4m/zyjxsiswHhDFheYB9k+l/tW/KNDpu69LCbOJoEuLiZvFC7brFqH0MGszx7MruolblHpa2voeC7fqqArPt1B+Ykrj9ljzdrOfONhriqjd6MQLPfiJkS1lz+sABqNc5InnJYc+rX0fNzZYtNxvnIZ0hAjrDmh4WMxAhzkj8+7mgbIkt30spXSfelaX0muNPQwwSMvksxCEh2XmIRUKyixCPhGOLJMQkIdk0xCUh2SzEJiHZPMQnIdkixCgh2TLAKcnlz5hIQ5wSMs8sxCoh2XmIV0Kyi4DjCCRbJiFGDMmmAb5spS8kCzjewObJAw44sGyBroF4WwOPI57X34cvt+e7zdyB5gPHiHw7ozc9IVNWiKKQqUyoTMQw/AUw0bGH"
     game.surfaces[1].create_entities_from_blueprint_string{
       string=bp, position={-6, -2}
     }
  ]],
  init_update_count = 5 * 60
}

return out
