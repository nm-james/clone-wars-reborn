Falcon = Falcon or {}

function GM:InitPostEntity()
    if LocalPlayer().Loaded then return end

    net.Start("Falcon:RequestDataInfo")
    net.SendToServer()
    
    hook.Add("Think", "DrawHosteredItems", DrawHolsters)
    LocalPlayer().Loaded = true
end

net.Receive("Falcon:SendDataInfo", function()
	local t = net.ReadTable()

    Falcon.ClientsideNPCs = t.ClientNPCs
    Falcon.CurrentRegiment = t.CurrentRegiment

    local shouldClearPrimary = false

    if not Falcon.InteractableNPCs or table.IsEmpty( Falcon.InteractableNPCs ) or #Falcon.InteractableNPCs ~= #t.InteractableNPCs then
        Falcon.InteractableNPCs = t.InteractableNPCs
        shouldClearPrimary = true
    end

    Falcon.InteractableNPCs = t.InteractableNPCs
    InitNPCs( true )

    -- InitNPCs( shouldClearPrimary )
    InitProps()

    Falcon.IsLoaded = true
end)

net.Start("Falcon:RequestDataInfo")
net.SendToServer()

local playerSkin = "1camo_test/dc15a/l115/red"

function UpdatePlayerGuns( ply, nextWep )
    if ply ~= LocalPlayer() then return true end
    if ply.ChangeWeaponsDelay and ply.ChangeWeaponsDelay > CurTime() then return true end

    local e = Falcon.Inventory.Equipped[1]
    local ee = Falcon.Inventory.Equipped[2]

    if e.id then
        local i = Falcon.Items[ Falcon.Inventory.Backpack[e.id].item ]

        if nextWep:GetClass() == i.Class then

            local att = Falcon.Inventory.Attachments.Equipped[1]
            for _, a in pairs( att ) do
                if a == 0 then continue end

                local cat = Falcon.Attachments[a]

                if not cat or not cat.Offsets[i.Class] then continue end
                PrintTable(cat.Offsets[i.Class])
                if _ == 8 then
                    nextWep.VElements["dc15"].material = cat.Offsets[i.Class].Material
                    nextWep.WElements["dc15"].material = cat.Offsets[i.Class].Material
                    continue
                end

                nextWep:SetTFAAttachment( _, cat.Offsets[i.Class].ID, true )
            end
        end

        return true
    end

    if ee.id then

        return true
    end

    return true
end

hook.Add("Think", "WeaponCheck", function()
    local ply = LocalPlayer()
    if ply.UpdateNewAttachments and not ply:Alive() then
        ply.UpdateNewAttachments = false
    end
    if not ply:Alive() or ply.UpdateNewAttachments then return end
    local wep = ply:GetActiveWeapon()
    if wep and wep:IsValid() and wep.IsBuilt then
        timer.Simple(0.1, function()
            UpdatePlayerGuns( ply, wep )
        end)
        ply.UpdateNewAttachments = true
    end
end)

function GM:PlayerSwitchWeapon( player, oldWeapon, newWeapon )
    UpdatePlayerGuns( player, newWeapon )
    player.ChangeWeaponsDelay = CurTime() + 0.25
end


net.Receive("Falcon:SENDPLAYERMESSAGE", function()
    local title = net.ReadString()
    local desc = net.ReadString()

    chat.AddText( Color( 210, 40, 40 ), title .. " ", Color( 240, 240, 240 ), desc )
end )



local meta = FindMetaTable("Player")

function meta:GetCurrency()
    return self:GetNWInt("FALCON:CURRENCY", 1000000000)
end