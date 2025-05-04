-- Code based on Mylon's DivOresity
-- Thanks for making it MIT licensed, but less thanks for not distributing
-- the source code anywhere...
-- Ideally this would be done at generation time :<
local function add_inclusions(evt)
  local surface = evt.surface
  if surface.name == "nauvis" then
    local replacees = surface.find_entities_filtered{
      type="resource", area=evt.area,
      name={"stone", "watery-crude-oil"},
    }
    for _,res in pairs(replacees) do
      if res.name == "stone" then
        if math.random() < 1/40 then
          local new_richness = math.ceil(res.amount * 0.001)

          surface.create_entity{
            name="bauxite-ore", position=res.position, amount=new_richness,
          }
          res.destroy()
        end
      elseif res.name == "watery-crude-oil" then
        -- local new_richness = res.amount * 0.2
        -- surface.create_entity{
        --   name="watery-crude-oil-water", position=res.position,
        --   amount=new_richness,
        -- }
      end
    end
  end
  
end

return {
  events = {
    [defines.events.on_chunk_generated] = add_inclusions
  }
}
