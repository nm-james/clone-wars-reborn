
for _, d in pairs( Falcon.InteractableNPCs ) do
    if not d.Model then
        d.Model = Falcon.Skins[math.random(1, #Falcon.Skins)].Models[Falcon.CurrentRegiment]
    end
end

for _, d in pairs( Falcon.ClientNPCs ) do
    if not d.Permanent then
        local ShouldSpawn = math.random(1, 3)
        if ShouldSpawn == 1 then
            Falcon.ClientNPCs[_] = nil
            continue
        end
    end
        
    if not d.Model then
        d.Model = Falcon.NPCData.Models[math.random(1, #Falcon.NPCData.Models)]
    end

    if not d.Occupation then
        local isEmployed = math.random(1, 3)
        if isEmployed == 1 then
            d.Occupation = "Unemployed"
        else
            d.Occupation = Falcon.NPCData.Jobs[math.random(1, #Falcon.NPCData.Jobs)]
        end
    end

    if not d.Allegience then
        d.Allegience = math.random(1, 10)
    end

    if not d.Name then
        d.Name = Falcon.NPCData.Names[math.random(1, #Falcon.NPCData.Names)]
    end
    
    d.Personality = math.random(1, 1)
end