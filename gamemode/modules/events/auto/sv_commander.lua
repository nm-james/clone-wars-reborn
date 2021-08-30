
Falcon = Falcon or {}
Falcon.AI = Falcon.AI or {}

local a = Falcon.AI

a.Objectives = a.Objectives or {}
a.GunshipEntities = a.GunshipEntities or {}

-- a.StartDelay = a.StartDelay or CurTime() + 240
a.StartDelay = CurTime() + 1

a.Initialize = function( gamemode )
    local map = game.GetMap()
    a.Objectives = {}
    a.GunshipEntities = {}

    Falcon.Missions[gamemode].Initialize()
    a.GunshipLocations = Falcon.Missions[gamemode][map].CIS.Gunships.Starting
    a.SpawnDelay = nil

    a.Gamemode = gamemode

    hook.Add("Think", "GMThink", a.Think)
end

a.PlayerSpawn = function( ply )

end

a.Forces = {"falcon_b1", "falcon_b1_heavy", "falcon_b1_sniper"}

a.Think = function( self )
    if a.StartDelay and a.StartDelay > CurTime() then return end

    if not a.SpawnDelay or a.SpawnDelay < CurTime() then
        -- a.MaxNPCs = math.Clamp( math.Round( #player.GetAll() * 1.57, 0 ), 12, 72 )
        a.MaxNPCs = 36
        local cis = ents.FindByClass("falcon_b*")
        local gunships = ents.FindByClass("falcon_gunship")

        local t = {}

        if #cis ~= a.MaxNPCs and #gunships == 0 then
            for i = 1, math.Clamp(a.MaxNPCs - #cis, 0, 12) do
                local obj = a.Objectives[math.random(1, #a.Objectives)]
                table.insert( t, a.Forces[math.random(1, #a.Forces)] )
            end
            
            local pos = a.GunshipLocations[math.random(1, #a.GunshipLocations)]
            local npos = a.GunshipEntities[math.random(1, #a.GunshipEntities)]
    
            local gunship = ents.Create("falcon_gunship")
            gunship:SetPos( pos )
            gunship:SetNWVector("FALCON:NEXTPOS", npos:GetPos() + Vector( 0, 0, 400 ))
            gunship:SetNWAngle("FALCON:NEXTANGLES", npos:GetAngles())
            gunship:PointAtEntity( npos )
            gunship:SetAngles( Angle( 0, gunship:GetAngles().y, 0 ))
            gunship.Droids = t
            gunship:Spawn()
        end

        a.SpawnDelay = CurTime() + 75
    end
end

