
function GM:PlayerInitialSpawn( ply )
    ply:CheckPlayerUserID()
end

function GM:PlayerSpawn( ply )

    local model = ply:GetModelSkin()
    print(model)
    ply:SetModel( model )

    ply:SetWalkSpeed( 165 )
    ply:SetRunSpeed( 235 )

    ply:StripWeapons()

    -- ply:Give("falcon_dc15a")

    -- ply:SetNWString("Falcon:FirstWeapon", "falcon_dc15a")

    ply:SetPos( Vector( 4686.723633, -7075.539551, 80.031250 ) )
    ply:SetAngles( Angle( 0, 90, 0 ) )

    ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    ply:SetNoDraw( true )

    timer.Simple(10, function()
        ply:SetNoDraw( false )
    end)

    -- if ply:SteamID64() == "76561198271753170" then
    --     ply:SetModel("models/pacagma/seishun_buta_yarou_wa_bunny_girl_senpai_no_yume_wo_minai/mai_sakurajima_bunny/mai_sakurajima_bunny_player.mdl")
    -- end
end
