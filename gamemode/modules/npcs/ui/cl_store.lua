Falcon = Falcon or {}
Falcon.StoreUI = Falcon.StoreUI or {}
Falcon.Store = Falcon.Store or {}
Falcon.Store.Minly = Falcon.Store.Minly or {}
Falcon.Store.Daily = Falcon.Store.Daily or {}
Falcon.Store.Weekly = Falcon.Store.Weekly or {}



local str = Falcon.StoreUI
str.Defaults = str.Defaults or {}
str.Nexts = str.Nexts or {}


local itemPos = {
    [1] = {
        [1] = {
            Pos = Vector( 4128.929199, -7328.967285, 112.031250 ),
            Ang = Angle( 23.099907, -90.286964, 0.000000 ),
            EntPos = Vector( 4095.965332, -7381.985352, 86.903305 ),
        },
        [2] = {
            Pos = Vector( 4128.929199, -7328.967285, 112.031250 ),
            Ang = Angle( 23.099907, -90.286964, 0.000000 ),
            EntPos = Vector( 4095.965332, -7381.985352, 86.903305 ),
        },
        [3] = {
            Pos = Vector( 3936.134766, -7328.108887, 112.031250 ),
            Ang = Angle( 35.099907, -90.286964, 0.000000 ),
            EntPos = Vector( 4095.965332, -7381.985352, 86.903305 ),
        },
        [4] = {
            Pos = Vector( 3936.134766, -7328.108887, 112.031250 ),
            Ang = Angle( 35.099907, -90.286964, 0.000000 ),
            EntPos = Vector( 4095.965332, -7381.985352, 86.903305 ),
        },
        [5] = {
            Pos = Vector( 3936.134766, -7328.108887, 112.031250 ),
            Ang = Angle( 35.099907, -90.286964, 0.000000 ),
            EntPos = Vector( 4095.965332, -7381.985352, 86.903305 ),
        },
        [10] = {
            Pos = Vector( 3981.580811, -7326.383301, 117.206215 ),
            Ang = Angle( 7, -180, 0 ),
            EntPos = Vector( 3869.121094, -7295.695313, 67.199905 )
        }
    },
    [2] = {
        [1] = {
            Pos = Vector( 4128.929199, -7328.967285, 112.031250 ),
            Ang = Angle( 23.099907, -90.286964, 0.000000 ),
        },
        [2] = {
            Pos = Vector( 4128.929199, -7328.967285, 112.031250 ),
            Ang = Angle( 23.099907, -90.286964, 0.000000 ),
        },
        [3] = {
            Pos = Vector( 3936.134766, -7328.108887, 112.031250 ),
            Ang = Angle( 35.099907, -90.286964, 0.000000 ),
        },
        [4] = {
            Pos = Vector( 3936.134766, -7328.108887, 112.031250 ),
            Ang = Angle( 35.099907, -90.286964, 0.000000 ),
        },
        [5] = {
            Pos = Vector( 3936.134766, -7328.108887, 112.031250 ),
            Ang = Angle( 35.099907, -90.286964, 0.000000 ),
        },
    }
}

local function MainUI( content )
    content:Clear()
    content.Paint = nil
    local mainPnl = vgui.Create("DPanel", content)
    mainPnl:SetSize( content:GetWide() * 0.4, content:GetTall() * 0.825 )
    mainPnl:SetPos( content:GetWide() * 0.06, content:GetTall() * 0.075 )
    mainPnl.Paint = function( self, w, h )
        local time = os.time()

        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( 0, 0, w, h * 0.07 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h * 0.07 )

        draw.DrawText( "ARMORY", "F20", w * 0.5, h * 0.00325, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )


        local mins = math.floor( (Falcon.Store.Weekly.Delay - time) / 60 )
        local hours = math.floor( mins / 60 )
        local days = math.floor( hours / 24 )

        local t = tostring( days ) .. "d"

        if days < 1 then
            t = tostring( hours ) .. "h"
        elseif hours < 1 then
            t = tostring( mins ) .. "m"
        elseif mins < 1 then
            t = tostring( Falcon.Store.Weekly.Delay - time ) .. "s"
        end

        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( w * 0.0125, h * 0.0725, w * 0.975, h * 0.045 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( w * 0.0125, h * 0.0725, w * 0.975, h * 0.045 )
        draw.DrawText( "WEEKLY ITEMS", "F15", w * 0.5, h * 0.07, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "RESETS IN " .. t, "F11", w * 0.96, h * 0.076125, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )


        local mins = math.floor( (Falcon.Store.Daily.Delay - time) / 60 )
        local hours = math.floor( mins / 60 )
        local t = tostring( hours ) .. "h"

        if hours < 1 then
            t = tostring( mins ) .. "m"
        elseif mins < 1 then
            t = tostring( Falcon.Store.Daily.Delay - time ) .. "s"
        end

        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( w * 0.0125, h * 0.345, w * 0.975, h * 0.045 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( w * 0.0125, h * 0.345, w * 0.975, h * 0.045 )
        draw.DrawText( "DAILY ITEMS", "F15", w * 0.5, h * 0.34325, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "RESETS IN " .. t, "F11", w * 0.96, h * 0.34925, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )


        local ten = math.floor( (Falcon.Store.Minly.Delay - time) / 60 )
        local t = tostring( ten ) .. "m"
        if ten < 1 then
            t = tostring( Falcon.Store.Minly.Delay - time ) .. "s"
        end
        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( w * 0.0125, h * 0.6175, w * 0.975, h * 0.045 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( w * 0.0125, h * 0.6175, w * 0.975, h * 0.045 )
        draw.DrawText( "QUICK LUCK ITEMS", "F15", w * 0.5, h * 0.61625, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "RESETS IN " .. t, "F11", w * 0.96, h * 0.621, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
    end

    local weeklyPnl = vgui.Create("DPanel", mainPnl)
    weeklyPnl:SetSize( mainPnl:GetWide() * 0.975, mainPnl:GetTall() * 0.225 )
    weeklyPnl:SetPos( mainPnl:GetWide() * 0.0125, mainPnl:GetTall() * 0.1185 )
    weeklyPnl.Paint = nil

    local t = {}
    for _, rarity in pairs( Falcon.Store.Weekly.Items ) do
        table.insert( t, { rare = Falcon.Items[rarity].Rarity, item = rarity }  )
    end

    local xAxis = 0
    local yAxis = 0
    for _, e in SortedPairsByMemberValue(t, "rare") do
        local item = e.item
        local i = Falcon.Items[item]

        local itemPnl = vgui.Create("DPanel", weeklyPnl)
        itemPnl:SetSize( weeklyPnl:GetWide() * 0.1225, weeklyPnl:GetWide() * 0.1225 )
        itemPnl:SetPos( weeklyPnl:GetWide() * (0.0575 + (xAxis * 0.1275)), weeklyPnl:GetTall() * (0.025 + (yAxis * 0.4875)) )
        itemPnl.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 225 )
            surface.DrawRect( 2, 2, w - 4, h - 4 )

            surface.SetDrawColor( Falcon.RarityColors[ i.Rarity ] )
            -- TOP LEFT CORNER
            surface.DrawLine( 0, 0, 0, h * 0.2 )
            surface.DrawLine( 0, 0, w * 0.2, 0 )

            -- TOP RIGHT
            surface.DrawLine( w - 1, 0, w - 1, h * 0.2 )
            surface.DrawLine( w, 0, w - (w * 0.2), 0 )

            -- BOTTOM LEFT CORNER
            surface.DrawLine( 0, h - 1, 0, h - (h * 0.2) )
            surface.DrawLine( 0, h - 1, w * 0.2, h - 1 )

            -- BOTTOM RIGHT
            surface.DrawLine( w - 1, h, w - 1, h - (h * 0.2) )
            surface.DrawLine( w, h - 1, w - (w * 0.2), h - 1 )
        end


        local model = vgui.Create("DModelPanel", itemPnl)
        model:SetSize( itemPnl:GetWide(), itemPnl:GetTall())
        model:SetModel( i.Model.String )
        model:SetCamPos( i.Model.Offsets.Pos )
        model:SetLookAng( i.Model.Offsets.Ang )
        model:SetFOV( i.Model.Offsets.FOV ) 

        local btn = vgui.Create("DButton", itemPnl)
        btn:SetSize( itemPnl:GetWide(), itemPnl:GetTall() )
        btn:SetText("")
        btn.Paint = nil
        btn.OnCursorEntered = function( self )
            Falcon.CreateItemDerma( str.MainFrame, self, item )
        end
        local iddddd = Falcon.Planets[game.GetMap()].id

        btn.Think = function( self )
            if self:IsHovered() then
                if itemPos[iddddd][i.Category] then
                    local po = itemPos[iddddd][i.Category]
                    if str.Nexts.pos ~= po.Pos then
                        str.Nexts.pos = po.Pos
                        str.Nexts.ang = po.Ang
                        str.MainFrame.LerpingVector = 0
                    end

                    if str.ProductEnt and str.ProductEnt:IsValid() then
                        str.ProductEnt:Remove()
                    end

                    local clientModel = ents.CreateClientProp()
                    clientModel:SetModel(i.Model.String)
                    clientModel:SetAngles( Angle( 0, 0, 0 ) )
                    clientModel:SetPos( po.EntPos )

                    str.ProductEnt = clientModel
                end
            end
        end

        xAxis = xAxis + 1

        if xAxis == 7 then
            xAxis = 0
            yAxis = yAxis + 1
        end
    end

    local dailyPnl = vgui.Create("DPanel", mainPnl)
    dailyPnl:SetSize( mainPnl:GetWide() * 0.975, mainPnl:GetTall() * 0.225 )
    dailyPnl:SetPos( mainPnl:GetWide() * 0.0125, mainPnl:GetTall() * 0.391 )
    dailyPnl.Paint = nil

    local t = {}
    for _, rarity in pairs( Falcon.Store.Daily.Items ) do
        table.insert( t, { rare = Falcon.Items[rarity].Rarity, item = rarity }  )
    end

    local xAxis = 0
    local yAxis = 0
    for _, e in SortedPairsByMemberValue(t, "rare") do
        local item = e.item
        local i = Falcon.Items[item]

        local itemPnl = vgui.Create("DPanel", dailyPnl)
        itemPnl:SetSize( dailyPnl:GetWide() * 0.1225, dailyPnl:GetWide() * 0.1225 )
        itemPnl:SetPos( dailyPnl:GetWide() * (0.0575 + (xAxis * 0.1275)), dailyPnl:GetTall() * (0.025 + (yAxis * 0.4875)) )
        itemPnl.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 225 )
            surface.DrawRect( 2, 2, w - 4, h - 4 )

            surface.SetDrawColor( Falcon.RarityColors[ i.Rarity ] )
            -- TOP LEFT CORNER
            surface.DrawLine( 0, 0, 0, h * 0.2 )
            surface.DrawLine( 0, 0, w * 0.2, 0 )

            -- TOP RIGHT
            surface.DrawLine( w - 1, 0, w - 1, h * 0.2 )
            surface.DrawLine( w, 0, w - (w * 0.2), 0 )

            -- BOTTOM LEFT CORNER
            surface.DrawLine( 0, h - 1, 0, h - (h * 0.2) )
            surface.DrawLine( 0, h - 1, w * 0.2, h - 1 )

            -- BOTTOM RIGHT
            surface.DrawLine( w - 1, h, w - 1, h - (h * 0.2) )
            surface.DrawLine( w, h - 1, w - (w * 0.2), h - 1 )
        end


        local model = vgui.Create("DModelPanel", itemPnl)
        model:SetSize( itemPnl:GetWide(), itemPnl:GetTall())
        model:SetModel( i.Model.String )
        model:SetCamPos( i.Model.Offsets.Pos )
        model:SetLookAng( i.Model.Offsets.Ang )
        model:SetFOV( i.Model.Offsets.FOV ) 

        local btn = vgui.Create("DButton", itemPnl)
        btn:SetSize( itemPnl:GetWide(), itemPnl:GetTall() )
        btn:SetText("")
        btn.Paint = nil
        btn.OnCursorEntered = function( self )
            Falcon.CreateItemDerma( str.MainFrame, self, item )
        end
        local iddddd = Falcon.Planets[game.GetMap()].id

        btn.Think = function( self )
            if self:IsHovered() then
                if itemPos[iddddd][i.Category] then
                    local po = itemPos[iddddd][i.Category]
                    if str.Nexts.pos ~= po.Pos then
                        str.Nexts.pos = po.Pos
                        str.Nexts.ang = po.Ang
                        str.MainFrame.LerpingVector = 0
                    end

                    if str.ProductEnt and str.ProductEnt:IsValid() then
                        str.ProductEnt:Remove()
                    end

                    local clientModel = ents.CreateClientProp()
                    clientModel:SetModel(i.Model.String)
                    clientModel:SetAngles( Angle( 0, 0, 0 ) )
                    clientModel:SetPos( po.EntPos )

                    str.ProductEnt = clientModel
                end
            end
        end

        xAxis = xAxis + 1

        if xAxis == 7 then
            xAxis = 0
            yAxis = yAxis + 1
        end
    end

    local minlyPnl = vgui.Create("DPanel", mainPnl)
    minlyPnl:SetSize( mainPnl:GetWide() * 0.975, mainPnl:GetTall() * 0.225 )
    minlyPnl:SetPos( mainPnl:GetWide() * 0.0125, mainPnl:GetTall() * 0.6625 )
    minlyPnl.Paint = nil

    local t = {}
    for _, rarity in pairs( Falcon.Store.Minly.Items ) do
        table.insert( t, { rare = Falcon.Items[rarity].Rarity, item = rarity }  )
    end

    local xAxis = 0
    local yAxis = 0
    for _, e in SortedPairsByMemberValue(t, "rare") do
        local item = e.item
        local i = Falcon.Items[item]

        local itemPnl = vgui.Create("DPanel", minlyPnl)
        itemPnl:SetSize( minlyPnl:GetWide() * 0.1225, minlyPnl:GetWide() * 0.1225 )
        itemPnl:SetPos( minlyPnl:GetWide() * (0.0575 + (xAxis * 0.1275)), minlyPnl:GetTall() * (0.025 + (yAxis * 0.4875)) )
        itemPnl.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 225 )
            surface.DrawRect( 2, 2, w - 4, h - 4 )

            surface.SetDrawColor( Falcon.RarityColors[ i.Rarity ] )
            -- TOP LEFT CORNER
            surface.DrawLine( 0, 0, 0, h * 0.2 )
            surface.DrawLine( 0, 0, w * 0.2, 0 )

            -- TOP RIGHT
            surface.DrawLine( w - 1, 0, w - 1, h * 0.2 )
            surface.DrawLine( w, 0, w - (w * 0.2), 0 )

            -- BOTTOM LEFT CORNER
            surface.DrawLine( 0, h - 1, 0, h - (h * 0.2) )
            surface.DrawLine( 0, h - 1, w * 0.2, h - 1 )

            -- BOTTOM RIGHT
            surface.DrawLine( w - 1, h, w - 1, h - (h * 0.2) )
            surface.DrawLine( w, h - 1, w - (w * 0.2), h - 1 )
        end


        local model = vgui.Create("DModelPanel", itemPnl)
        model:SetSize( itemPnl:GetWide(), itemPnl:GetTall())
        model:SetModel( i.Model.String )
        model:SetCamPos( i.Model.Offsets.Pos )
        model:SetLookAng( i.Model.Offsets.Ang )
        model:SetFOV( i.Model.Offsets.FOV ) 

        local btn = vgui.Create("DButton", itemPnl)
        btn:SetSize( itemPnl:GetWide(), itemPnl:GetTall() )
        btn:SetText("")
        btn.Paint = nil
        btn.OnCursorEntered = function( self )
            Falcon.CreateItemDerma( str.MainFrame, self, item )
        end
        local iddddd = Falcon.Planets[game.GetMap()].id

        btn.Think = function( self )
            if self:IsHovered() then
                if itemPos[iddddd][i.Category] then
                    local po = itemPos[iddddd][i.Category]
                    if str.Nexts.pos ~= po.Pos then
                        str.Nexts.pos = po.Pos
                        str.Nexts.ang = po.Ang
                        str.MainFrame.LerpingVector = 0
                    end

                    if str.ProductEnt and str.ProductEnt:IsValid() then
                        str.ProductEnt:Remove()
                    end

                    local clientModel = ents.CreateClientProp()
                    clientModel:SetModel(i.Model.String)
                    clientModel:SetAngles( Angle( 0, 0, 0 ) )
                    clientModel:SetPos( po.EntPos )

                    str.ProductEnt = clientModel
                end
            end
        end

        xAxis = xAxis + 1

        if xAxis == 7 then
            xAxis = 0
            yAxis = yAxis + 1
        end
    end

end

local mapPos = {
    [1] = Vector( 4014.782959, -7131.416016, 112.031250 ),
    [2] = Vector( 8116.959473, 13750.146484, -9530.394531 )
}

local mapAng = {
    [1] = Angle( 6.8, 90, 0.000000 ),
    [2] = Angle( 9.360096, -90, 0.000000 )
}

local function OpenStoreFrame()
    local ply = LocalPlayer()
    local w, h = ScrW(), ScrH()

    local i = Falcon.Planets[game.GetMap()].id

    local frame = vgui.Create("DFrame")
    frame:ShowCloseButton( false )
    frame:SetSize( w, h )
    frame:Center()
    frame.LerpingVector = 1
    frame.LerpingFinished = true

    str.Defaults.pos = mapPos[i]
    str.Defaults.ang = mapAng[i]

    str.CamPos = str.Defaults.pos
    str.CamAng = str.Defaults.ang

    str.Nexts.pos = str.Defaults.pos
    str.Nexts.ang = str.Defaults.ang

    frame.Paint = function( self, w, h )

        local pos = LerpVector(self.LerpingVector, str.CamPos, str.Nexts.pos)
        local ang = LerpAngle(self.LerpingVector, str.CamAng, str.Nexts.ang)

        if pos ~= str.Nexts.pos then
            if self.LerpingFinished then
                self.LerpingFinished = false
                self.LerpingVector = 0
            end
            self.LerpingVector = math.Clamp(self.LerpingVector + (FrameTime() * 3), 0, 1)
        elseif not self.LerpingFinished then
            self.LerpingFinished = true
            str.CamPos = str.Nexts.pos
            str.CamAng = str.Nexts.ang
        end

        local old = DisableClipping( true )
        render.RenderView( {
            origin = pos,
            angles = ang,
            x = x,
            y = y,
            w = w,
            h = h
        } )

        DisableClipping( old )

        surface.SetDrawColor( 8, 8, 8, 255 )
        surface.DrawRect( w * 0.8, h * 0.15, w * 0.175, h * 0.05 )
        surface.SetDrawColor( 255, 255, 65, 255 )
        surface.DrawOutlinedRect( w * 0.8, h * 0.15, w * 0.175, h * 0.05 )
        draw.NoTexture()
        surface.SetMaterial( Material("cwreborn/store/credits.png") )
        surface.DrawTexturedRect( w * 0.805, h * 0.155, h * 0.04, h * 0.04 )

        draw.DrawText( ply:GetCurrency(), "F25", w * 0.83, h * 0.144, Color( 255, 255, 65, 255 ), TEXT_ALIGN_LEFT )

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
        Falcon.HasNPCSpeaking = false
    end

    local content = vgui.Create("DPanel", frame)
    content:SetSize( frame:GetWide() * 1, frame:GetTall() * 0.975 )
    content:SetPos( 0, frame:GetTall() * 0.025 )
    content.Paint = nil

    MainUI( content )

    str.MainFrame = frame

    return frame
end

function OpenStore()
    Falcon.HasNPCSpeaking = 2

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
                self.NextFrame = OpenStoreFrame()
                hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
            end
        else
            self:SetAlpha( math.Clamp(self:GetAlpha() - ((3 * FrameTime()) * 255), 0, 255) )

            if self:GetAlpha() <= 0 then
                self:Remove()
                if not self.NextFrame or not self.NextFrame:IsValid() then return end
                self.NextFrame:MakePopup()
            end
        end
    end
end

net.Receive("Falcon:SendStoreUpdates", function()
    local store = net.ReadTable()

    Falcon.Store = store

    local f = str.MainFrame
    if f and f:IsValid() then
        f:Remove()
        Falcon.HasNPCSpeaking = false

        chat.AddText(Color( 215, 40, 40), "[STORE]", Color( 240, 240, 240 ), " The store items have been update. We apologise for any inconveniences.")
    end

end )

concommand.Add("open_store", function()
    OpenStore()
end)