local intro = {
  checkerboard = true,
  -- so i can place the LRS
  planet = "nauvis",
  init_update_count = 300,
  init = [[
    game.surfaces[1].create_global_electric_network()
    game.forces.player.enable_all_recipes()

    local bp = "0eNqtmd1uozAQhd/F11AB5s95lVUVEeKk1oLN2qbbbpV334FsStuYZWw1N1EM/mY8sj3nKG/k0I180EJasnsjolXSkN2PN2LEWTbdNCabnpMd6UbZ6Fir9ie3sRGdIpeICHnkL2SXXh4jwqUVVvDr9PnH616O/YFreCG6YYQ8CQmP4kEMnERkUAZmKTlFmkiUPRQReSW7uEgeijnEdcLecGuFPJsPOdknPRrLdaxexFH8gUgA5LqF6M2Zz2Et72GksaOG3xmge3WcpjY27nhjLLlcort0s/d0V7LMk09ZOhB0E5FuIfJNRLaFKDYRdAtRbiLyLUS1iSi2EPUmotxCsE1EtYVIk4Ux9oOLwT5t3qPQvL0+z1285VycYC/GQhqu7XUbfwEXX8/FFnrZw1Y30gxK2/jAO+tgl+k6O81ccOoBT3zhuQec+sILD3jmCy894IUvvPKA577w2gNe+sKZB7zyhGeJB7z2hacecOYL9zihle8hyuh9x22fuHHCKablat6rZ74f4VkHVxQ/7gX0Vnh0ajrDI3Idvnb/2x0JaoEbA4R4BB6EbtU4CY00Se4b8Uc14WzKy73QqebovCWrbL1KoAVeh2m2Gu0wQuN3hFhuB97BTC3amEuuz69wNcPqTk3r1Cz1LSrEPIynE9d7A3JkXujt4wpXBsiivMbLotPIu++SRBVeE80puhg1XhStMhheFa0xaIKXRauMFK+LVhkZXhitMiheGa0ycrw0WmUUWGn0bwNv6Be6nI175+GQR0ux2YwHuJhP+2BuU4cGLtizbp6nc5Ym5PbS/tfYdDAGL0ule3A9rnyqAKmGXGodgmYoNAtRgfdpO3tMnoSoQCw8DYIzHDxIHGPhNES/YsuSh+hXLDxIHGPLUgaVBQmvQpQ3tix1iPLGwlkQHFeWIgkqCxKehsh6ZFmKLAiOzJyGuB0sPA+CI8tShLgdLLwMcTtYeBUER9a8DioLEs5CfBqyLGUSBMdlXqYhJvB/BiPABHbqd3zk0kzBjdVjO/uOdytYBDjBMgtaF/tmcwvi0UCkWA1WtE0Xt6oflIRcl9VlIUa3pHij69pmCKNbenhp12a7C/EIi4KKwcjyf0JEnqFm84yizFjOGHxRRkt6ufwFtkTiQA=="
    game.surfaces[1].create_entities_from_blueprint_string{
      string=bp, position={0, 0}
    }
    local lrs = game.surfaces[1].find_entity("lunar-rocket-silo", {0, 0})
    lrs.set_recipe("ps-rocket-part-gravity-10")
  ]]
}
local many_kinds = {
  checkerboard = true,
  -- otherwise it complains????????
  planet = "nauvis",
  init = [[
    game.surfaces[1].create_global_electric_network()
    game.forces.player.enable_all_recipes()
    game.simulation.camera_alt_info = true
    -- game.simulation.camera_zoom = 1.8
    local bp = "0eNrFmuuOozgQhd+F3zDCN8B5lVUroomTtpbbchl1tpV3X5P0JukOlXJZLc38GTWQz8fmhFMp/BG91rPpB9tO0eYjslXXjtHmr49otIe2rJdjbdmYaBNVb6axVVknfV26i09xZNudeY827BSvXN7b3txdxE8vcWTayU7WXAY4/3HctnPzagZHif//pG33tnWnEjfiOEVx1Hej+1jXLvRlPM1+qTg6RpskS3+p8xiXT2xHM022PYzLlYNput9mO7tz9WQGs9vayTTu1L6sRxNHl8MXLZ8jD131t5mS/WxqN2zVzcui8DSOmm63nC+npDblWdN17i+nZfrfJsOvk6m7cueOPJuE0m4KOzuY6nK+iKPp2C8f7uapn5elfhhAPK7WecEfx8nz6zg5vFifsLfjbugOpl04ZqjcoOXBnO+NWzp3pJzmwf0t0pU1WVsHGX+xw1N1mVO3glDeMy0YYaZl03StLZGJJkL5TTTDJnonDphofkVMQ9mOfTdMyaupn38BPmd6754VdBGEznzQmnCH1frEWUpgSIDBCDcAYnACA5qLCFpq5bPUTAaxpRdbEe6BAOaeERgcYOQoQ6OMAmUUKEMTvAAweEpgAGvKcV9zVAfua4EywnwtfLzHw3zNvdg3X3+rX5664lJWOLI95/D0NsyjKxbOlUGyH7omuUvKy2Xbf+aydkO7y9tuaFwttCYn85dzd2NxObc4o6jJCWoygpqvdRRFESGpCv1N0Z0VGF+D377Te5fjiW1HM0yrxVlRwGy5Vo6lQRZmPhYWLIjttyaCE+ApFS78A0EW6w8eIf0f5iBD+YcKyMArvBRl5P6BADIK/4c5yND+oQIxJB5uCmXg4SZRBh5uqMck6tPb0w9koD4tUJ9K1Kca9Ye88+nc9Ktf4zsC+mSTqGc16jeJelbjfkM9q1G/KdSzGvWbQj2rUb8p1LMa9ZtCPavRZ5pCPatRzyrMszxFPasylIE+W1WOMlCfqgJloD5V2rdfwVPUbBnhl7EE2goZIwQoxOCEAIUYghB+EEMSQhhiKEKAQoyMEKAQIycEKMQoCAEKMTQhQKHWVUoIUIjBCAEKMTghQCGG8A7QzCdAc0kIUEiTIgQoxMgIAQoxckKAQoyCEKAQQxMCFGAUKSFAIQYjBCjE4IQAhRiCEKAQQxICFGIoQoBCjCwkQCHYzbCmdt/SwVaJac1wOLpf/+6n/76sVsHZJzZ33+/Xeb83w3a0/y4vCNLrv7XhipBuk3zs0K61V7p3u3MahkuLpXs/krtPhQ7pPgXJc7dtWeuysjuaRp2G9KSea2x5J5MHoURdLKQz9ahrtVGieUBn6pG9Fj86qHHrq1uGdI984YRXEhJoW+uMULhCjJxQQEOMglD8QgxNKFyh1xppSqhcQQgjlK4ghNK4ASFh7gZxQW8iJPQ+LKU4OIUghLdqkkEQSucRVEIxMahEE7wDKWGU5iOkxOOVMX53GMXFoJIwF4OawlwMqiO4WBQQhOBioSEIwcWwEoKLYSUEF4NKOMHFoBJOcDGshOBiWEmQi2FNQS6G1amAHVMC30d0rcN/ZL8U41nAdicPmV/r8R/SmvtrVQStrkovG0QlU74iC3+R+Z9eUB1k+RzaipSGbKkU8ke3VFZd75Zi+Qk3mdueSpYGbKpkd2/CPbZViuz0sJHyxY3hFLsjt12vcfTbaT4jVMa11Nr9J7TIxOn0H0VGqgw="
    game.surfaces[1].create_entities_from_blueprint_string{
      string=bp, position={5, 0}
    }
  ]]
}
return {
  intro = intro,
  many_kinds = many_kinds
}
