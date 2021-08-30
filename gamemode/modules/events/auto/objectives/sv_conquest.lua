
Conquest = {}


Conquest["gm_fork"] = {
    Posts = {
        Vector(-6325.216309, 7759.271973, -10007.923828),
        Vector(8305.798828, 2915.777588, -7487.969238),
        Vector(-8181.312988, -12605.596680, -9017.966797),
        Vector(-1068.563110, -5914.143555, -8978.188477)
    },
    CIS = {
        Gunships = {
            Starting = {
                Vector(-14136.069336, 12799.507813, 2677.459717)
            },
            Landing = {
                Vector(-11381.720703, 5751.496094, -10023.968750),
                Vector(-8224.620117, 11423.543945, -10142.354492),
                Vector(6586.029297, 2954.999512, -7488.240234),
                Vector(14086.210938, 8708.159180, -7487.968750),
                Vector(4026.527588, -4462.684082, -8570.788086),
                Vector(-719.422180, -7045.580078, -8983.385742),
                Vector(-2662.703369, -14486.794922, -7615.968750),
                Vector(-14241.630859, -8492.145508, -9925.035156),
                Vector(-11490.008789, 3127.072021, -9943.968750)
            },
        },
    }
}


util.AddNetworkString("Falcon:ShowCommandPosts")
Conquest.Initialize = function()
    local map = game.GetMap()
    
    local d = Conquest[map]

    for _, pos in pairs( d.Posts ) do
        local e = ents.Create("falcons_command_post")
        e:SetPos( pos )
        e:DropToFloor()
        e:Spawn()
        Falcon.AI.Objectives[#Falcon.AI.Objectives + 1] = e
    end

    for _, pos in pairs( d.CIS.Gunships.Landing ) do
        local e = ents.Create("prop_physics")
        e:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
        e:SetPos( pos )
        e:DropToFloor()
        e:Spawn()
        e:SetNoDraw( true )
        Falcon.AI.GunshipEntities[#Falcon.AI.GunshipEntities + 1] = e
    end
end

Falcon.Missions["Conquest"] = Conquest