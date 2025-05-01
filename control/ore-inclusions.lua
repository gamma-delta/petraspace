-- Code based on Mylon's DivOresity
-- Thanks for making it MIT licensed, but less thanks for not distributing
-- the source code anywhere...
-- Ideally this would be done at generation time :<
local function add_inclusions(evt, ok_surface, target, new, probability, richness_coeff)
  local surface = evt.surface
  if surface.name ~= ok_surface then return end

  local resources = surface.find_entities_filtered{
    type="resource", area=evt.area, name=target,
  }
  for _,res in pairs(resources) do
    if math.random() < probability then
      local new_richness = math.ceil(res.amount * richness_coeff)

      surface.create_entity{
        name=new, position=res.position, amount=new_richness,
      }
      res.destroy()
    end
  end
end

return {
  events = {
    [defines.events.on_chunk_generated] = function(evt)
      add_inclusions(evt, "nauvis", "stone", "bauxite-ore", 1/40, 0.001) 
    end
  }
}
