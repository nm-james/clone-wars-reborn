Falcon = Falcon or {}
Falcon.ClientsideNPCs = Falcon.ClientsideNPCs or {}
Falcon.ClientsideNPCEntities = Falcon.ClientsideNPCEntities or {}
Falcon.MainNPCEntities = Falcon.MainNPCEntities or {}


local function ClearExistingClientNPCs()
    for _, n in pairs( Falcon.ClientsideNPCEntities ) do
        if n and n:IsValid() then
            n:Remove()
        end
    end
    Falcon.ClientsideNPCEntities = {}
end

local function ClearMainNPCs()
    for _, n in pairs( Falcon.MainNPCEntities ) do
        if n and n:IsValid() then
            n:Remove()
        end
    end
    Falcon.MainNPCEntities = {}
end

local function CreateClientNPCs()
    for _, n in pairs( Falcon.ClientsideNPCs ) do
        local clientModel = ents.CreateClientProp()
        clientModel:SetModel( n.Model or "models/aussiwozzi/phase1clones/cg/riot_officer.mdl" )
        clientModel:Spawn()
        clientModel:SetPos( n.Pos )
        clientModel:SetAngles( n.Ang )
        clientModel:SetupBones()
        clientModel:ResetSequence( 0 )
        clientModel:SetSequence( n.Sequence or 2 )
        clientModel:SetCollisionGroup( 0 )
        clientModel.Occupation = n.Occupation or "Unemployed"
        clientModel.Name = n.Name or "JIMMY! [NO NAME]"
        clientModel.Allegience = n.Allegience or 5
        clientModel.FalconClient = true
        clientModel.Personality = n.Personality
        Falcon.ClientsideNPCEntities[_] = clientModel
    end
end


local function CreateMainNPCs()
    local i = Falcon.Planets[game.GetMap()].id
    for _, n in pairs( Falcon.InteractableNPCs ) do
        local pos = n.Pos[i]
        local ang = n.Ang[i]

        if not pos or not ang then continue end

        local clientModel = ents.CreateClientProp()
        clientModel:SetModel( n.Model )
        clientModel:Spawn()
        clientModel:SetPos( pos )
        clientModel:SetAngles( ang )
        clientModel:SetupBones()
        clientModel:ResetSequence( 0 )
        clientModel:SetSequence( n.Sequence or 2 )
        clientModel:SetCollisionGroup( 0 )
        clientModel.Occupation = n.Occupation or "Clone Trooper"
        clientModel.Name = n.Name or "CT-" .. tostring(math.random(1000, 9999)) .. " PVT 'NO NAME!?!?!'"
        clientModel.Allegience = n.Allegience or 10
        clientModel.FalconClient = true
        clientModel.Personality = n.Personality
        print("DESC", n.Desc)
        clientModel.Desc = n.Desc or "NO NO DESC"
        clientModel.Options = n.Options or {}

        Falcon.MainNPCEntities[_] = clientModel
    end
end

function InitNPCs( clearExisting )
    ClearExistingClientNPCs()
    CreateClientNPCs()

    if clearExisting then
        ClearMainNPCs()
        CreateMainNPCs()
    end
end

local GetOccupationColor = function( num )
    if num < 5 then
        return Color( 185, 30, 30 )
    elseif num > 6 then
        return Color( 100, 100, 210 )
    end
    return Color( 240, 240, 240 )
end

local sides = {
    "Despises the Republic",
    "Hates the Republic",
    "Dislikes Republic Occupation",
    "Finds Republic Occupation Intimidating",
    "Does not care",
    "Neutral",
    "Hesitant yet Support of the Republic",
    "Prefers Republic Occupation",
    "Cheerful of Republic Occupation",
    "Supportive of Republic Campaigns",
}

local function DrawNPCsOverhead()
    if Falcon.HasNPCSpeaking == 2 then return end
    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()
    local cone = ents.FindInCone( ply:EyePos(), ply:GetAimVector(), 150, math.cos( math.rad( 25 ) ) )

    for _, npc in pairs( cone ) do
        if not npc.FalconClient then continue end
        cam.Start3D2D( npc:GetPos() + Vector( 0, 0, 100 ), Angle( 0, ply:GetAngles().y - 90, 90 ), 0.1 )
            draw.DrawText(npc.Name, "F35", 0, 132, Color(125,125,125,255), TEXT_ALIGN_CENTER)
            draw.DrawText(npc.Occupation, "F15", 0, 197, Color(75,75,75,255), TEXT_ALIGN_CENTER)
            draw.DrawText(sides[npc.Allegience], "F11", 0, 225, GetOccupationColor(npc.Allegience), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

local function DrawNPCsInteractions()
    if Falcon.HasNPCSpeaking then return end
    local ply = LocalPlayer()
    local w, h = ScrW(), ScrH()
    local cone = ents.FindInCone( ply:EyePos(), ply:GetAimVector(), 350, math.cos( math.rad( 40 ) ) )

    for _, npc in pairs( cone ) do
        if not npc.FalconClient then continue end
        if ply:GetPos():Distance(npc:GetPos()) < 300 then
            local s = (npc:GetPos() + Vector( 0, 0, 56 )):ToScreen()

            draw.NoTexture()
            surface.SetDrawColor( Color( 255, 255, 255 ) )
            surface.SetMaterial(Material("cwreborn/hud/interaction.png"))
            surface.DrawTexturedRect( s.x - (w * 0.05 / 2), s.y - (w * 0.05 / 2), w * 0.05, w * 0.05 )

            if s.x > (w * 0.475) and s.x < (w * 0.525) and s.y > ((h * 0.5) - (w * 0.05 / 2)) and s.y < ((h * 0.5) + (w * 0.05 / 2)) and ply:GetPos():Distance(npc:GetPos()) < 100 then
                draw.DrawText("Press <E> to speak with " .. npc.Name, "F12", s.x, s.y + (h * 0.045), Color(240,240,240,255), TEXT_ALIGN_CENTER)
                
                if input.IsKeyDown( KEY_E ) then
                    OpenNPCTalk( npc )
                end
            end
        end
        -- if ply:GetPos():Distance(npc:GetPos()) < 225 then
        --     draw.DrawText("Press <E> to interact with " .. npc.Name, "F14", scrw * 0.5, scrh * 0.625, Color(240,240,240,255), TEXT_ALIGN_CENTER)
        --     if input.IsKeyDown( KEY_E ) then
        --         NPCPopupSpeech( npc )
        --     end

        --     if npc.InteractionMenu then
        --         draw.DrawText("Hold <M> to open the " .. npc.MenuUIName, "F14", scrw * 0.5, scrh * 0.655, Color(240,240,240,255), TEXT_ALIGN_CENTER)
        --         if input.IsKeyDown( KEY_M ) then
        --             npc.InteractionMenu()
        --         end
        --     end

        --     break
        -- end
    end
end


hook.Add("HUDPaint", "DrawNPCsInteractions", DrawNPCsInteractions)
hook.Add("PostDrawOpaqueRenderables", "DrawNPCsOverhead", DrawNPCsOverhead)
