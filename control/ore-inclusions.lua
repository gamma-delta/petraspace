-- Code based on Mylon's DivOresity
-- Thanks for making it MIT licensed, but less thanks for not distributing
-- the source code anywhere...
local Event = require("__stdlib2__/stdlib/event/event").set_protected_mode(true)
local Entity = require("__stdlib2__/stdlib/entity/entity")

local function add_inclusions(evt, ok_surface, target, new, probability, richness_coeff)
  local surface = evt.surface
  if surface.name ~= ok_surface then return end

  local resources = surface.find_entities_filtered{
    type="resource", area=evt.area, name=target,
  }
  for _,res in pairs(resources) do
    if math.random() < probability then
      local new_richness = math.floor(res.amount * richness_coeff)
      if new_richness < 1 then goto next end

      surface.create_entity{
        name=new, position=res.position, amount=new_richness,
      }
      res.destroy()
    end
    ::next::
  end
end

Event.register(defines.events.on_chunk_generated, function(evt)
  add_inclusions(evt, "nauvis", "stone", "bauxite-ore", 1/40, 2.5)
end)
