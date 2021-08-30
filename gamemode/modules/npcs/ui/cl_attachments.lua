Falcon = Falcon or {}
Falcon.Att = Falcon.Att or {}
local att = Falcon.Att

att.Defaults = {}
att.Nexts = {}


local attachmentTypes = { 
    {
        Name = "Ammunition Type",
        Mat = "tracer_icon",
    },
    {
        Name = "Scope",
        Mat = "sniper_icon",
    },
    {
        Name = "Muzzle",
        Mat = "gun_end_icon",
    },
    {
        Name = "Magazine",
        Mat = "magazine_icon",
    },
    [8] = {
        Name = "Weapon Skin",
        Mat = "spray_icon",
    },
}
local function FocusOnAttachment( frame, position, we )
    frame:Clear()
    frame.Paint = nil
    local attachments = vgui.Create("DPanel", frame)
    attachments:SetSize( frame:GetWide() * 0.3, frame:GetTall() * 0.6 )
    attachments:SetPos( frame:GetWide() * 0.025, frame:GetTall() * 0.025 )
    attachments.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 195 )
        surface.DrawRect( w * 0.0125, 0, w * 0.975, h )

        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( 0, 0, w, h * 0.08 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h * 0.08 )
        draw.DrawText( attachmentTypes[position].Name, "F19", w * 0.5, h * 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end

    local contentPnl = vgui.Create("DScrollPanel", attachments)
    contentPnl:SetSize( attachments:GetWide() * 0.975, attachments:GetTall() * 0.92 )
    contentPnl:SetPos( attachments:GetWide() * 0.0125, attachments:GetTall() * 0.08 )

    local ply = LocalPlayer()

    local tbl = {}

    for _, data in pairs( Falcon.Attachments ) do
        local w = Falcon.Items[Falcon.Inventory.Backpack[we].item]
        local id = data.Offsets[w.Class].ID
        tbl[data.Name] = _
    end

    for _, i in SortedPairsByMemberValue( Falcon.Attachments, "Rarity" ) do
        if i.Category ~= position then continue end

        local wep = vgui.Create("DButton", contentPnl)
        wep:SetSize( contentPnl:GetWide(), contentPnl:GetTall() * 0.09 )
        wep:SetText("")
        wep:Dock( TOP )
        local name = i.Name
        local col = Falcon.RarityColors[i.Rarity]
        local mat = Material("cwreborn/customisation/" .. attachmentTypes[position].Mat .. ".png")

        if not ply:IsValidAttachment( i.Name ) then
            name = "Locked"
            col = Color( 255, 30, 30 )
            mat = Material("cwreborn/tfa/locked_att.png")
        end

        wep.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 195 )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( col )
            surface.DrawRect( 0, h * 0.9175, w, h * 0.08 )

            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( mat )
            surface.DrawTexturedRect( h * 0.075, h * 0.025, w * 0.08, w * 0.08 )

            draw.DrawText( name, "F16", w * 0.095, h * 0.05, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

        end

        wep.OnCursorEntered = function( self )
            local a = att.Attachments[position]
            local item = Falcon.Items[Falcon.Inventory.Backpack[we].item]

            if i.Model then
                if a and a:IsValid() then
                    a:Remove()
                end

                local attatch = ents.CreateClientProp()
                attatch:SetPos( att.WepEntity:GetPos() + i.Offsets[item.Class].Pos )
                attatch:SetAngles( i.Offsets[item.Class].Ang )
                attatch:SetModel( i.Model )
                attatch:Spawn()
                att.Attachments[position] = attatch
            elseif i.Offsets and i.Offsets[item.Class] and i.Offsets[item.Class].Material then
                att.WepEntity:SetMaterial( i.Offsets[item.Class].Material )
            end

        end

        wep.DoClick = function( self, w, h )
            local w = Falcon.Items[Falcon.Inventory.Backpack[we].item]
            Falcon.Inventory.Attachments.Equipped[we][position] = tbl[name]
            -- UpdatePlayerGuns()
        end
    end 

    local backBtn = vgui.Create("DButton", frame)
    backBtn:SetSize( frame:GetWide() * 0.125, frame:GetTall() * 0.1 )
    backBtn:SetPos( frame:GetWide() * 0.03, frame:GetTall() * 0.825 )
    backBtn:SetText("<< BACK")
    backBtn:SetFont("F30")
    backBtn:SetColor( Color( 240, 240, 240 ) )
    backBtn:SetContentAlignment( 4 )
    backBtn.Paint = nil

    backBtn.DoClick = function( self )
        att.Nexts.pos = Vector( 4032.656738, -6756.564453, 112.031250 )
        att.Nexts.ang = Angle( 16.873247, 91.366547, 0 )
        frame:GetParent().LerpingVector = 0
        frame:Clear()
        
        local a = att.Attachments[position]
        local as = Falcon.Inventory.Attachments.Equipped[we][position]

        if as and as ~= 0 then
            local curAtt = Falcon.Attachments[as]
            local item = Falcon.Items[Falcon.Inventory.Backpack[we].item]

            if curAtt.Model then
                a:SetPos( att.WepEntity:GetPos() + curAtt.Offsets[item.Class].Pos )
                a:SetAngles( curAtt.Offsets[item.Class].Ang )
                a:SetModel( curAtt.Model )
            elseif curAtt.Offsets[item.Class].Material then
                att.WepEntity:SetMaterial( curAtt.Offsets[item.Class].Material )
            end
        else
            if a and a:IsValid() then
                a:Remove()
            else
                if position == 8 then
                    att.WepEntity:SetMaterial( "" )
                end
            end
        end

        timer.Simple(0.3, function()
            ATTACHMENTS_EditWeaponUI( frame, we )
        end)
    end
end

function ATTACHMENTS_EditWeaponUI( frame, id )
    frame:Clear()

    local i = Falcon.Items[Falcon.Inventory.Backpack[id].item]

    frame.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255, 255 )
        for _, offset in pairs( i.Attachments ) do
            if not offset[1] or (offset[1] == 0 and offset[2] == 0) then continue end
            local add = 0
            if not offset[5] then
                add = 0.0725
            end
            surface.DrawLine( w * (offset[3] + (0.15 / 2)), h * (offset[4] + add), w * offset[1], h * offset[2] )
        end
    end

    local pos = att.WepEntity:GetPos()
    
    for _, offset in pairs( i.Attachments ) do
        if not offset[1] then continue end
        local a = Falcon.Inventory.Attachments.Equipped[id][_]

        local name = "No " .. attachmentTypes[_].Name
        local col = Color( 255, 255, 255, 255 )

        if a and a ~= 0 then
            local at = Falcon.Attachments[a]
            col = Falcon.RarityColors[at.Rarity]
            name = at.Name
        end
        
        local editPnl = vgui.Create("DButton", frame)
        editPnl:SetSize( frame:GetWide() * 0.15, frame:GetTall() * 0.075 )
        editPnl:SetPos( frame:GetWide() * offset[3], frame:GetTall() * offset[4] )
        editPnl:SetText("")
        editPnl:SetAlpha( 0 )
        editPnl.IsNotFadeInIdkLol = true
        editPnl.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 225 )
            surface.DrawRect( 2, 2, w - 4, h - 4 )
    
            surface.SetDrawColor( col )
            -- TOP LEFT CORNER
            surface.DrawLine( 0, 0, 0, h * 0.3 )
            surface.DrawLine( 0, 0, w * 0.2, 0 )
    
            -- TOP RIGHT
            surface.DrawLine( w - 1, 0, w - 1, h * 0.3 )
            surface.DrawLine( w, 0, w - (w * 0.2), 0 )
    
            -- BOTTOM LEFT CORNER
            surface.DrawLine( 0, h - 1, 0, h - (h * 0.3) )
            surface.DrawLine( 0, h - 1, w * 0.2, h - 1 )
    
            -- BOTTOM RIGHT
            surface.DrawLine( w - 1, h, w - 1, h - (h * 0.3) )
            surface.DrawLine( w, h - 1, w - (w * 0.2), h - 1 )

            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( Material("cwreborn/customisation/" .. (attachmentTypes[_].Mat or "muzzle_icon") .. ".png") )
            surface.DrawTexturedRect( h * 0.1, h * 0.05, h * 0.9, h * 0.9 )
    
            draw.DrawText( name, "F15", w * 0.285, h * 0.225, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
        end

        editPnl.Think = function( self )
            if self:IsHovered() or self.IsNotFadeInIdkLol then
                if self.IsNotFadeInIdkLol and self:GetAlpha() >= 185 then
                    self.IsNotFadeInIdkLol = false
                    self:SetAlpha( 185 )
                    return
                end
                self:SetAlpha( math.Clamp(self:GetAlpha() + ((FrameTime() * 4) * 255), 0, 255) )
            else
                self:SetAlpha( math.Clamp(self:GetAlpha() - ((FrameTime() * 4) * 255), 185, 255) )
            end 
        end

        editPnl.DoClick = function( self, w, h )
            if not offset[6] then return end
            att.Nexts.pos = offset[6]
            att.Nexts.ang = offset[7]
            frame:GetParent().LerpingVector = 0

            FocusOnAttachment( frame, _, id )
        end
    end

    local backBtn = vgui.Create("DButton", frame)
    backBtn:SetSize( frame:GetWide() * 0.125, frame:GetTall() * 0.1 )
    backBtn:SetPos( frame:GetWide() * 0.03, frame:GetTall() * 0.825 )
    backBtn:SetText("<< BACK")
    backBtn:SetFont("F30")
    backBtn:SetColor( Color( 240, 240, 240 ) )
    backBtn:SetContentAlignment( 4 )
    backBtn.Paint = nil

    backBtn.DoClick = function( self )
        att.Nexts.pos = att.Defaults.pos
        att.Nexts.ang = att.Defaults.ang
        frame:GetParent().LerpingVector = 0
        frame:Clear()
        frame.Paint = nil
        timer.Simple(0.3, function()
            ATTACHMENTS_MainUI( frame )
        end)
    end
end

function ATTACHMENTS_MainUI( frame )
    frame:Clear()
    frame.Paint = nil
    local wepsPnl = vgui.Create("DPanel", frame)
    wepsPnl:SetSize( frame:GetWide() * 0.4, frame:GetTall() * 0.825 )
    wepsPnl:SetPos( frame:GetWide() * 0.55, frame:GetTall() * 0.075 )
    wepsPnl.Paint = function( self, w, h )
        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( 0, 0, w, h * 0.07 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h * 0.07 )

        draw.DrawText( "WEAPON CUSTOMISATION", "F20", w * 0.5, h * 0.00325, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )



        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( w * 0.0125, h * 0.0725, w * 0.975, h * 0.045 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( w * 0.0125, h * 0.0725, w * 0.975, h * 0.045 )
        draw.DrawText( "CURRENT", "F15", w * 0.5, h * 0.07, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )



        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( w * 0.0125, h * 0.345, w * 0.975, h * 0.045 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( w * 0.0125, h * 0.345, w * 0.975, h * 0.045 )
        draw.DrawText( "BACKPACK", "F15", w * 0.5, h * 0.34325, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

    end


    local wepContentCurrent = vgui.Create("DPanel", wepsPnl)
    wepContentCurrent:SetSize( wepsPnl:GetWide() * 0.975, wepsPnl:GetTall() * 0.225 )
    wepContentCurrent:SetPos( wepsPnl:GetWide() * 0.0125, wepsPnl:GetTall() * 0.1175 )
    wepContentCurrent.Paint = nil


    local e = Falcon.Inventory.Equipped
    local wep1 = vgui.Create("DPanel", wepContentCurrent)
    wep1:SetSize( wepContentCurrent:GetWide() * 0.45, wepContentCurrent:GetTall() * 0.9 )
    wep1:DockMargin( wepContentCurrent:GetWide() * 0.025, wepContentCurrent:GetTall() * 0.05, wepContentCurrent:GetWide() * 0.025, wepContentCurrent:GetTall() * 0.05 )
    wep1:Dock( LEFT )

    local color = Color( 255, 255, 255, 255 )
    if e[1].id then
        local id = e[1].id

        local i = Falcon.Items[Falcon.Inventory.Backpack[id].item]

        local t = weapons.Get( i.Class )

        color = Falcon.RarityColors[i.Rarity]

        local model = vgui.Create("DModelPanel", wep1)
        model:SetSize( wep1:GetWide() * 0.4, wep1:GetWide() * 0.4 )
        model:SetPos( wep1:GetWide() * 0.075, wep1:GetTall() * 0.125 )
        model:SetModel( i.Model.String )
        model:SetCamPos( i.Model.Offsets.Pos )
        model:SetLookAng( i.Model.Offsets.Ang )
        model:SetFOV( i.Model.Offsets.FOV ) 
        
    
        local wep1Btn = vgui.Create("DButton", wep1)
        wep1Btn:SetSize( wep1:GetWide(), wep1:GetTall() )
        wep1Btn.Paint = function( self, w, h )
    
        end
        wep1Btn.DoClick = function( self )
            att.Nexts.pos = Vector( 4032.656738, -6756.564453, 112.031250 )
            att.Nexts.ang = Angle( 16.873247, 91.366547, 0 )
            frame:GetParent().LerpingVector = 0

            for _, attac in pairs( att.Attachments or {} ) do
                if not attac or not attac:IsValid() then continue end
                attac:Remove()
            end

            att.Attachments = {}

            att.WepEntity = ents.CreateClientProp()
            att.WepEntity:SetPos( Vector( 4046.980713, -6720.885742, 100.829887) )
            att.WepEntity:SetAngles( Angle( 0, -180, 0 ) )
            att.WepEntity:SetModel( i.Model.String )
            att.WepEntity:Spawn()

            att.AttachmentRail = ents.CreateClientProp()
            att.AttachmentRail:SetPos( att.WepEntity:GetPos() + Vector(-3.5, 0, -0.125) )
            att.AttachmentRail:SetAngles( Angle( 0, -180, 0 ) )
            att.AttachmentRail:SetModel( "models/sw_battlefront/weapons/2019/e11_carbine_top1.mdl" )
            att.AttachmentRail:Spawn()

            for _, attac in pairs( Falcon.Inventory.Attachments.Equipped[id] ) do
                if attac == 0 then continue end
                local attD = Falcon.Attachments[attac]
                if not attD.Offsets[i.Class].Pos then 
                    if _ == 8 then
                        att.WepEntity:SetMaterial( attD.Offsets[i.Class].Material )
                    end
                    continue 
                end

                local attatch = ents.CreateClientProp()
                attatch:SetPos( att.WepEntity:GetPos() + attD.Offsets[i.Class].Pos )
                attatch:SetAngles( attD.Offsets[i.Class].Ang )
                attatch:SetModel( attD.Model )
                attatch:Spawn()
                att.Attachments[_] = attatch

            end

            frame:Clear()
            timer.Simple(0.3, function()
                ATTACHMENTS_EditWeaponUI( frame, id )
            end)
        end
    
    end

    wep1.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 225 )
        surface.DrawRect( 2, 2, w - 4, h - 4 )

        surface.SetDrawColor( color )
        -- TOP LEFT CORNER
        surface.DrawLine( 0, 0, 0, h * 0.3 )
        surface.DrawLine( 0, 0, w * 0.2, 0 )

        -- TOP RIGHT
        surface.DrawLine( w - 1, 0, w - 1, h * 0.3 )
        surface.DrawLine( w, 0, w - (w * 0.2), 0 )

        -- BOTTOM LEFT CORNER
        surface.DrawLine( 0, h - 1, 0, h - (h * 0.3) )
        surface.DrawLine( 0, h - 1, w * 0.2, h - 1 )

        -- BOTTOM RIGHT
        surface.DrawLine( w - 1, h, w - 1, h - (h * 0.3) )
        surface.DrawLine( w, h - 1, w - (w * 0.2), h - 1 )

        surface.SetDrawColor( 0, 0, 0, 225 )
        surface.DrawRect( w * 0.075, h * 0.125, w * 0.4, w * 0.4 )

    end

    local wep2 = vgui.Create("DButton", wepContentCurrent)
    wep2:SetSize( wepContentCurrent:GetWide() * 0.45, wepContentCurrent:GetTall() * 0.9 )
    wep2:DockMargin( wepContentCurrent:GetWide() * 0.025, wepContentCurrent:GetTall() * 0.05, wepContentCurrent:GetWide() * 0.025, wepContentCurrent:GetTall() * 0.05 )
    wep2:Dock( LEFT )


    local wepContentBackpack = vgui.Create("DScrollPanel", wepsPnl)
    wepContentBackpack:SetSize( wepsPnl:GetWide() * 0.975, wepsPnl:GetTall() * 0.55 )
    wepContentBackpack:SetPos( wepsPnl:GetWide() * 0.0125, wepsPnl:GetTall() * 0.391 )

end

local function OpenAttachmentsFrame()
    local w, h = ScrW(), ScrH()
    local frame = vgui.Create("DFrame")
    frame:SetSize( w, h )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:SetTitle("")
    frame:Center()
    frame.LerpingVector = 1
    frame.LerpingFinished = true

    att.Defaults.pos = Vector( 4033.090088, -6900.957520, 112.031250 )
    att.Defaults.ang = Angle( 9.207818, -179.700195, 0 )

    att.CamPos = Vector( 4033.090088, -6900.957520, 112.031250 )
    att.CamAng = Angle( 9.207818, -179.700195, 0 )

    att.Nexts.pos = Vector( 4033.090088, -6900.957520, 112.031250 )
    att.Nexts.ang = Angle( 9.207818, -179.700195, 0 )

    frame.Paint = function( self, w, h )

        local pos = LerpVector(self.LerpingVector, att.CamPos, att.Nexts.pos)
        local ang = LerpAngle(self.LerpingVector, att.CamAng, att.Nexts.ang)

        if pos ~= att.Nexts.pos then
            if self.LerpingFinished then
                self.LerpingFinished = false
                self.LerpingVector = 0
            end
            self.LerpingVector = math.Clamp(self.LerpingVector + (FrameTime() * 3), 0, 1)
        elseif not self.LerpingFinished then
            self.LerpingFinished = true
            att.CamPos = att.Nexts.pos
            att.CamAng = att.Nexts.ang
        end

        local old = DisableClipping( true )
        render.RenderView( {
            origin = pos,
            angles = ang,
            x = 0,
            y = 0,
            w = w,
            h = h
        } )

        DisableClipping( old )
    end

    local exit = vgui.Create("DButton", frame)
    exit:SetSize( frame:GetWide() * 0.025, frame:GetTall() * 0.025 )
    exit:SetPos( frame:GetWide() * 0.975, frame:GetTall() * 0.004 )
    exit:SetFont( "F15" )
    exit:SetText( "X" )
    exit:SetColor( Color( 255, 255, 255 ) )
    exit.Paint = nil
    exit.DoClick = function( self )
        frame:Close()

        if att.WepEntity and att.WepEntity:IsValid() then
            att.WepEntity:Remove()
            att.AttachmentRail:Remove()
            for _, attac in pairs( att.Attachments ) do
                attac:Remove()
            end
        end
    end

    local content = vgui.Create("DPanel", frame)
    content:SetSize( frame:GetWide() * 1, frame:GetTall() * 0.975 )
    content:SetPos( 0, frame:GetTall() * 0.025 )
    content.Paint = nil

    ATTACHMENTS_MainUI( content )

    return frame
end

function OpenAttachments()
    local fade = vgui.Create("DFrame")
    fade:SetSize( ScrW(), ScrH() )
    fade:Center()
    fade:MakePopup()
    fade.FadeIn = true
    fade:SetAlpha( 0 )
    fade:SetTitle("")
    fade:SetDraggable( false )
    fade:ShowCloseButton( false )
    fade.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0 ) )
    end
    fade.Think = function( self )
        if self.FadeIn then
            self:SetAlpha( math.Clamp(self:GetAlpha() + ((3 * FrameTime()) * 255), 0, 255) )

            if self:GetAlpha() == 255 then
                if not self.Delay then
                    self.Delay = CurTime() + 1
                    return
                end
                if self.Delay > CurTime() then return end

                self.FadeIn = false
                self.NextFrame = OpenAttachmentsFrame()
                hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
            end
        else
            self:SetAlpha( math.Clamp(self:GetAlpha() - ((3 * FrameTime()) * 255), 0, 255) )

            if self:GetAlpha() <= 0 then
                self:Remove()
                self.NextFrame:MakePopup()
            end
        end
    end
end

concommand.Add("open_attachments", function()
    OpenAttachments()
end)