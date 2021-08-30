
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "config.lua" )
include( 'shared.lua' )
include( 'config.lua' )

util.AddNetworkString("F:SW:Player:Loaded")
net.Receive("F:SW:Player:Loaded", function( len, ply )
    if game.GetMap() ~= Falcon.Locations[tonumber(Falcon.World_Info.location)] then
        -- RunConsoleCommand("map", Falcon.Locations[1])
    end
end)

Falcon.HasNavMesh = false


local n = navmesh.GetAllNavAreas()

if n and not table.IsEmpty( n ) then
    Falcon.HasNavMesh = true
end

hook.Add("PlayerSay", "TESTINGTEXT", function( ply, text )

    if text == "/conquest" then
        Falcon.AI.Initialize( "Conquest" )
    end

    if text == "/hp" then
        ply:SetHealth( 10000000 )
        
    end
    
end)

