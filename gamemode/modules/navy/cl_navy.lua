

Falcon.EnhancedNavy = Falcon.EnhancedNavy or {}
Falcon.EnhancedNavy.CurrentMovements = Falcon.EnhancedNavy.CurrentMovements or {}
Falcon.EnhancedNavy.Planets = Falcon.EnhancedNavy.Planets or {}
Falcon.EnhancedNavy.Data = Falcon.EnhancedNavy.Data or {}
Falcon.EnhancedNavy.Data.Friendly = Falcon.EnhancedNavy.Data.Friendly or {}
Falcon.EnhancedNavy.Data.Hostiles = Falcon.EnhancedNavy.Data.Hostiles or {}

-- NAVY STUFF


net.Receive("Falcon:Navy:SyncData", function()
    local d = net.ReadTable()

    Falcon.EnhancedNavy.Planets = d.planets
end)

net.Receive("Falcon:Navy:Movements", function()
    local d = net.ReadTable()

    Falcon.EnhancedNavy.CurrentMovements = d

end)

net.Receive("Falcon:Navy:SendMessage", function()
    local str = net.ReadString()

    chat.AddText(Color( 255, 30, 30 ), "[Falcon's ENS] ", Color( 230, 230, 230 ), str)
end)



net.Receive("Falcon:Navy:OpenNavigation", function()
    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()

    local f = vgui.Create("DFrame")
    f:SetSize( scrw * 0.85, scrh * 0.8 )
    f:Center()
    f:MakePopup()
    f:SetDraggable( false )
    f:SetTitle( "" )
    f:ShowCloseButton( false )

    local fw, fh = f:GetWide(), f:GetTall()

    f.Paint = nil

    local navPnl = vgui.Create("DPanel", f)
    navPnl:SetSize( fw * 0.2, fh )
    navPnl.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 2, 2, w - 4, h - 4 )

        draw.RoundedBox( 0, w * 0.05,  h * 0.92, w * 0.9, h * 0.0625, Color( 0, 0, 0, 195 ) )

    end

    local nw, nh = navPnl:GetWide(), navPnl:GetTall()
    local planets = vgui.Create("DPanel", navPnl)
    planets:SetSize( nw * 0.9, nh * 0.35 )
    planets:SetPos( nw * 0.05, nh * 0.025 )



    -- Content
    local contentPnl = vgui.Create("DPanel", f)
    contentPnl:SetSize( fw * 0.795, fh )
    contentPnl:SetPos( fw * 0.205, 0 )
    contentPnl.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 2, 2, w - 4, h - 4 )
    end

    local galaxy = vgui.Create("DImage", contentPnl)
    galaxy:SetSize( contentPnl:GetWide() * 1, contentPnl:GetTall() * 1.025 )
    galaxy:SetPos( 0, contentPnl:GetTall() * 0 )
    galaxy:SetMaterial("enhanced_navy/galaxy_map.png")
    galaxy:SetKeepAspect( false )

    local galaxyMap = vgui.Create("DPanel", galaxy)
    galaxyMap:SetSize( galaxy:GetWide(), galaxy:GetTall() )
    
    local planetOffset = Falcon.EnhancedNavy.PlanetOffset
    for id, p in pairs( Falcon.EnhancedNavy.Planets ) do
        if not planetOffset[id] then break end
        local fov = planetOffset[id].fov or 47
        local planet = vgui.Create("DModelPanel", contentPnl)
        planet:SetSize( galaxyMap:GetWide() * 0.04, galaxyMap:GetWide() * 0.04 )
        planet:SetPos( galaxyMap:GetWide() * planetOffset[id].x, galaxyMap:GetTall() * planetOffset[id].y )
        planet:SetModel( "models/immigrant/starwars/planet.mdl" )
        planet:SetLookAt(Vector( 0, 0, 0 ))
        planet:SetCamPos(Vector( 50, 50, 50 ))
        planet:SetFOV( fov )
        planet.Occupation = tonumber( p.faction )
        planetOffset[id].pnl = planet

        local ent = planet:GetEntity()

        ent:SetSkin(id - 1)


        local planetBtn = vgui.Create("DButton", planet)
        planetBtn:SetSize( planet:GetWide(), planet:GetWide() )
        planetBtn:SetPos( 0, 0 )

        planetBtn.W, planetBtn.H = planet:GetWide(), planet:GetWide()
        planetBtn.xX, planetBtn.yY = planet:GetX(), planet:GetY()

        planetBtn:SetText("")
        planetBtn.Anim = 0
        planetBtn.TextAnim = 0

        local col = Falcon.EnhancedNavy.Colors( planet.Occupation )
        local occ = Falcon.EnhancedNavy.DetermineOccupation( planet.Occupation )

        planetBtn.Paint = function( self, w, h )
            if not occ.icon then return end
            local occupation = Falcon.EnhancedNavy.Planets[id].faction
            local col = Falcon.EnhancedNavy.Colors( occupation )
            local occ = Falcon.EnhancedNavy.DetermineOccupation( occupation )

            col.a = math.Clamp((self.Anim * 255) + 100, 0, 255)

            surface.SetDrawColor( col )
            draw.NoTexture()
            surface.SetMaterial( Material(occ.icon .. "_white.png") )
            surface.DrawTexturedRect( w * 0.1325, h * 0.13, w * 0.75, h * 0.75 )
        end
        

        
        planetBtn.Think = function( self )
            if self:IsHovered() then
                self.Anim = math.Clamp(self.Anim + (FrameTime() * 4), 0, 1)

                if self.Anim > 0.75 then
                    self.TextAnim = math.Clamp(self.TextAnim + (FrameTime() * 4), 0, 1)
                end

                if self.SizeUp then return end

                planet:SizeTo( self.W + (self.W * 0.8), self.H + 36, 0.15, 0, 1)
                self:SizeTo( self.W + (self.W * 0.8), self.H + 36, 0.15, 0, 1)

                planet:MoveTo( planet:GetX() - (self.W * 0.4), planet:GetY() - (self.W * 0.25), 0.15, 0, 1)

                self.SizeUp = true

                if self.InfPanel and self.InfPanel:IsValid() then
                    self.InfPanel:Remove()
                end

                self.InfPanel = vgui.Create("DPanel", galaxyMap)
                local i = self.InfPanel
                i:SetSize( self:GetWide() * 3.5, self:GetTall() * 1.125 )
                i:SetPos( planet:GetX() + (planet:GetWide() * 1.4), planet:GetY() + (planet:GetTall() * 0.17) )
                i:MoveToFront()


                i.Paint = function( _, w, h )
                    local occupation = Falcon.EnhancedNavy.Planets[id].faction
                    local animCol = Falcon.EnhancedNavy.Colors( occupation )
                    animCol.a = (255 * self.TextAnim)
                    surface.SetDrawColor( Falcon.EnhancedNavy.Colors( occupation ) )
                    surface.DrawLine( 0, h * 0.5, w * self.Anim, h * 0.5 )
                    draw.DrawText(p.name, "Arial8", 0, h * 0.025, animCol, TEXT_ALIGN_LEFT)
                end

            else
                self.TextAnim = math.Clamp(self.TextAnim - (FrameTime() * 7), 0, 1)

                if self.TextAnim < 0.5 then
                    self.Anim = math.Clamp(self.Anim - (FrameTime() * 8), 0, 1)
                end

                if self.InfPanel and self.Anim == 0 then
                    self.InfPanel:Remove()
                end

                if not self.SizeUp then return end

                planet:SizeTo( self.W, self.H,  0.15, 0, 1)
                self:SizeTo( self.W, self.H,  0.15, 0, 1)
                planet:MoveTo( self.xX, self.yY, 0.15, 0, 1)

                self.SizeUp = false
            end
        end
    end

    
    
    local col = Falcon.EnhancedNavy.Colors( 2 )
    local occ = Falcon.EnhancedNavy.DetermineOccupation( 2 )

    galaxyMap.Paint = function( self, w, h )
    local movements = Falcon.EnhancedNavy.CurrentMovements

        for i, data in pairs( movements ) do
            local duration = data.arrival - data.departure

            local toP = tonumber(data.to)
            local fromP = tonumber(data.from)

            local px, py = planetOffset[fromP].pnl:GetX() + ( planetOffset[fromP].pnl:GetWide() / 2 ), planetOffset[fromP].pnl:GetY() + ( planetOffset[fromP].pnl:GetTall() / 2 )
            local ptx, pty = planetOffset[toP].pnl:GetX() + ( planetOffset[toP].pnl:GetWide() / 2 ), planetOffset[toP].pnl:GetY() + ( planetOffset[toP].pnl:GetTall() / 2 )
            local time = (1 - (px / ptx)) * ((CurTime() - data.departure) / duration)
            local timey = (1 - (py / pty)) * ((CurTime() - data.departure) / duration)
            local x, y = px + (ptx * time), py + (pty * timey)

            if data.arrival < CurTime() then 
                table.remove( movements, i )
                continue
            end
            surface.SetDrawColor( col )

            draw.NoTexture()
            surface.SetMaterial( Material(occ.icon .. "_white.png") )
            surface.DrawTexturedRect( x - w * 0.0075, y -  w * 0.0075, w * 0.015, w * 0.015 )

            surface.DrawLine(px, py, x, y)

        end
    end


    local exit = vgui.Create("DButton", contentPnl)
    exit:SetSize( contentPnl:GetWide() * 0.025, contentPnl:GetWide() * 0.025 )
    exit:SetPos( contentPnl:GetWide() * 0.975, 0 )
    exit:SetText("x")
    exit:SetFont( "Arial8" )
    exit.Paint = nil


    exit.DoClick = function( self )
        f:Close()
    end
end)

local function BombingShip( ship, sussyBaka )
    if Falcon.EnhancedNavy.Data.HasBomberMenu then return end
    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()
    local frame = Falcon.EnhancedNavy.Data.MainPnl

    if not frame or not frame:IsValid() then return end

    local frame = frame:GetParent() 

    local f = vgui.Create("DFrame")
    f:SetSize( scrw * 0.25, scrh * 0.65 )
    f:Center()
    f:MakePopup()
    f:SetDraggable( false )
    f:SetTitle( "" )
    f:ShowCloseButton( false )
    f.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ) )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawOutlinedRect( w * 0.0125, h * 0.0125, w * 0.975, h * 0.9775 )

        draw.DrawText( "Target Ship Component", "Arial16", w * 0.5, h * 0.05, Color( 230, 230, 230, 255 ), TEXT_ALIGN_CENTER )
    end

    frame:SetMouseInputEnabled( false )
    frame:SetKeyBoardInputEnabled( false )

    local fw, fh = f:GetWide(), f:GetTall()


    local exit = vgui.Create("DButton", f)
    exit:SetSize( fw * 0.025, fh * 0.025 )
    exit:SetPos( fw * 0.975, 0 )
    exit:SetText("x")
    exit:SetFont( "Arial8" )
    exit.Paint = nil


    exit.DoClick = function( self )
        frame:SetMouseInputEnabled( true )
        frame:SetKeyBoardInputEnabled( true )

        f:Close()
        Falcon.EnhancedNavy.Data.HasBomberMenu = false
    end

    local s = Falcon.EnhancedNavy.Ships[Falcon.EnhancedNavy.Config.FactionAIFaction][ tonumber( ship.ship ) ]

    local m = vgui.Create("DModelPanel", f)
    m:SetSize( fw * 0.9, fh * 0.825 )
    m:SetPos( fw * 0.05, fh * 0.175 )
    m:SetModel( s.model )
    m:SetFOV( s.topfov )
    m:SetCamPos( Vector( 0, 0, 4150 ) )
    function m:LayoutEntity( ent ) 
        ent:SetAngles( Angle(0, -180, 0))
        ent:SetModelScale( 1 )
    end

    local mm = vgui.Create("DModelPanel", f)
    mm:SetSize( fw * 0.9, fh * 0.825 )
    mm:SetPos( fw * 0.05, fh * 0.175 )
    mm:SetFOV( s.topfov )
    mm:SetCamPos( Vector( 0, 0, 4150 ) )
    function mm:LayoutEntity( ent ) 
        ent:SetAngles( Angle(0, -180, 0))
        ent:SetMaterial( "models/props_combine/stasisshield_sheet" )
        ent:SetModelScale( 1.1 )
    end

    Falcon.EnhancedNavy.Data.HasBomberMenu = true

    local cm = vgui.Create("DPanel", mm)
    cm:SetSize( m:GetWide(), m:GetTall() )
    cm.Paint = nil

    ship.shield = 0
    if tonumber( ship.shield ) > 0 then
        mm:SetModel( s.model )
        local p = vgui.Create("DButton", cm)
        p:SetSize( m:GetWide() * 0.4, m:GetTall() * 0.05 )
        p:SetPos( m:GetWide() * 0.3, m:GetTall() * 0.375 )
        p:SetText("")
        p.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ) )

            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawOutlinedRect( 0, 0, w, h )

            self.Color = Color( 25, 108, 34 )

            if (s.shield / 4) > tonumber( ship.shield ) then
                self.Color = Color( 167, 25, 2 )
            elseif (s.shield / 2) > tonumber( ship.shield ) then
                self.Color = Color( 167, 108, 5 )
            end

            surface.SetDrawColor( self.Color )
            surface.DrawRect( w * 0.02, h * 0.11, (w * 0.9675) * (ship.shield / s.shield), h * 0.8 )
    
            draw.DrawText( "Shields [" .. tostring( ship.shield ) .. " / " .. tostring(s.shield) .. "]", "Arial5", w * 0.5, h * 0.2, Color( 230, 230, 230, 255 ), TEXT_ALIGN_CENTER )
        end
        p.DoClick = function( self )
            net.Start("Falcon:Navy:AttackShip")
                net.WriteUInt( tonumber(ship.id), 32 )
                net.WriteUInt( tonumber(sussyBaka), 32 )
            net.SendToServer()
        end
    else
        local names = {
            ["lifesupport"] = "Life Support",
            ["communications"] = "Comms Relay",
            ["bridge"] = "Bridge",
            ["shieldgenerator"] = "Shield Generator",
            ["engines"] = "Engines",
        }
        for gg, pos in pairs( s.bombingLocations ) do
            local p = vgui.Create("DButton", cm)
            p:SetSize( m:GetWide() * 0.4, m:GetTall() * 0.05 )
            p:SetPos( m:GetWide() * 0.3, m:GetTall() * pos )
            p:SetText("")
            p.Paint = function( self, w, h )
                -- ship[gg] = 250
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ) )
    
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawOutlinedRect( 0, 0, w, h )
    
                self.Color = Color( 25, 108, 34 )
    
                if (s.hp[gg] / 4) > tonumber( ship[gg] ) then
                    self.Color = Color( 167, 25, 2 )
                elseif (s.hp[gg] / 2) > tonumber( ship[gg] ) then
                    self.Color = Color( 167, 108, 5 )
                end
    
                surface.SetDrawColor( self.Color )
                surface.DrawRect( w * 0.02, h * 0.11, (w * 0.9675) * (ship[gg] / s.hp[gg]), h * 0.8 )
        
                draw.DrawText( names[gg] .. " [" .. tostring( ship[gg] ) .. " / " .. tostring(s.hp[gg]) .. "]", "Arial5", w * 0.5, h * 0.2, Color( 230, 230, 230, 255 ), TEXT_ALIGN_CENTER )
            end
        end
    end

    
end
local function SortHostileTargets( squadron, category )
    local pnl = Falcon.EnhancedNavy.Data.MainPnl
    if not pnl or not pnl:IsValid() then return end

    local pnl = pnl.EnemyPnl
    pnl:Clear()

    local data = Falcon.EnhancedNavy.Data.Hostiles[string.lower(category)]

    if not data then return end
    

    if category == "Squadrons" then
        for _, sq in pairs( data ) do
            local info = Falcon.EnhancedNavy[category][Falcon.EnhancedNavy.Config.FactionWEra][tonumber(sq.starfighter)]

            local sqPnl = vgui.Create("DPanel", pnl)
            sqPnl:SetSize( pnl:GetWide() * 0.95, pnl:GetTall() * 0.2 )
            sqPnl:Dock( TOP )
            sqPnl:DockMargin( pnl:GetWide() * 0.025, pnl:GetTall() * 0.0125, pnl:GetWide() * 0.025, 0 )
            sqPnl.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawOutlinedRect( 0, 0, w, h )
            end
    
            local mdl = vgui.Create("DModelPanel", sqPnl)
            mdl:SetSize( sqPnl:GetWide() * 0.99, sqPnl:GetTall() * 0.75 )
            mdl:SetPos( sqPnl:GetWide() * 0.005, sqPnl:GetTall() * 0.01 )
            mdl:SetModel( info.model )
            mdl:SetFOV( info.sidefov )
            mdl:SetCamPos( Vector( 5, 270, 4150 ) )
            function mdl:LayoutEntity( ent ) 
                ent:SetAngles( Angle(0, 0, 75))
            end

            local btn = vgui.Create("DButton", sqPnl)
            btn:SetSize( sqPnl:GetWide(), sqPnl:GetTall() )
            btn.Paint = function( self, w, h )
       
            end
    
            btn.DoClick = function( self )
               
            end
        end
    elseif category == "Ships" then
        for _, sq in pairs( data ) do
            local info = Falcon.EnhancedNavy[category][Falcon.EnhancedNavy.Config.FactionAIFaction][tonumber( sq.ship )]

            local sqPnl = vgui.Create("DPanel", pnl)
            sqPnl:SetSize( pnl:GetWide() * 0.95, pnl:GetTall() * 0.32 )
            sqPnl:Dock( TOP )
            sqPnl:DockMargin( pnl:GetWide() * 0.025, pnl:GetTall() * 0.0125, pnl:GetWide() * 0.025, 0 )
            sqPnl.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
                draw.RoundedBox( 0, 0, h * 0.825, w, h * 0.175, Color( 100, 30, 30, 200 ) )

                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawOutlinedRect( 0, 0, w, h )
                surface.DrawLine( 0, h * 0.825, w, h * 0.825 )

            end
    
            local mdl = vgui.Create("DModelPanel", sqPnl)
            mdl:SetSize( sqPnl:GetWide() * 0.99, sqPnl:GetTall() * 0.815 )
            mdl:SetPos( sqPnl:GetWide() * 0.005, sqPnl:GetTall() * 0.01 )
            mdl:SetModel( info.model )
            mdl:SetFOV( info.sidefov )
            mdl:SetCamPos( Vector( 5, 270, 4150 ) )
            function mdl:LayoutEntity( ent ) 
                ent:SetAngles( Angle(0, 0, 75))
            end
            

            local btn = vgui.Create("DButton", sqPnl)
            btn:SetSize( sqPnl:GetWide(), sqPnl:GetTall() )
            btn.Paint = function( self, w, h )
       
            end
    
            btn.DoClick = function( self )
                BombingShip( sq, squadron.id )
            end
        end
    end
    
end
local function SortFriendlySquadrons( data )

    local pnl = Falcon.EnhancedNavy.Data.MainPnl
    if not pnl or not pnl:IsValid() then return end

    local pnl = pnl.FriendlyPnl
    Falcon.EnhancedNavy.Data.MainPnl.EnemyPnl:Clear()
    pnl:Clear()

    for _, sq in pairs( data ) do
        local info = Falcon.EnhancedNavy.Squadrons[Falcon.EnhancedNavy.Config.FactionWEra][tonumber(sq.starfighter)]
        local sqPnl = vgui.Create("DPanel", pnl)
        sqPnl:SetSize( pnl:GetWide() * 0.95, pnl:GetTall() * 0.2 )
        sqPnl:Dock( TOP )
        sqPnl:DockMargin( pnl:GetWide() * 0.025, pnl:GetTall() * 0.0125, pnl:GetWide() * 0.025, 0 )
        sqPnl.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end

        local mdl = vgui.Create("DModelPanel", sqPnl)
        mdl:SetSize( sqPnl:GetWide() * 0.99, sqPnl:GetTall() * 0.75 )
        mdl:SetPos( sqPnl:GetWide() * 0.005, sqPnl:GetTall() * 0.01 )
        mdl:SetModel( info.model )
        mdl:SetFOV( info.sidefov )
        mdl:SetCamPos( Vector( 5, 270, 4150 ) )
        function mdl:LayoutEntity( ent ) 
            ent:SetAngles( Angle(0, 0, 75) )
        end

        local btn = vgui.Create("DButton", sqPnl)
        btn:SetSize( sqPnl:GetWide(), sqPnl:GetTall() )
        btn.Paint = function( self, w, h )
   
        end

        btn.DoClick = function( self )
            if info.type == 3 then
                SortHostileTargets( sq, "Ships" )
            else
                SortHostileTargets( sq, "Squadrons" )
            end

        end
    end
end
local function SortFriendlyShips( data )
    local shipsPnl = Falcon.EnhancedNavy.Data.MainPnl
    if not shipsPnl or not shipsPnl:IsValid() then return end
    for a, ship in pairs( data ) do
        local info = Falcon.EnhancedNavy.Ships[Falcon.EnhancedNavy.Config.FactionWEra][tonumber(ship.ship)]
        local shipPnl = vgui.Create("DPanel", shipsPnl)
        shipPnl:SetSize( shipsPnl:GetWide() * 0.95, shipsPnl:GetTall() * 0.2 )
        shipPnl:Dock( TOP )
        shipPnl:DockMargin( shipsPnl:GetWide() * 0.025, shipsPnl:GetTall() * 0.0125, shipsPnl:GetWide() * 0.025, 0 )
        shipPnl.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
            draw.RoundedBox( 0, 0, h * 0.75, w, h * 0.25, Color( 30, 30, 100, 200 ) )

            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawOutlinedRect( 0, 0, w, h )
            surface.DrawLine( 0, h * 0.75, w, h * 0.75 )
        end

        local mdl = vgui.Create("DModelPanel", shipPnl)
        mdl:SetSize( shipPnl:GetWide() * 0.99, shipPnl:GetTall() * 0.74 )
        mdl:SetPos( shipPnl:GetWide() * 0.005, shipPnl:GetTall() * 0.01 )
        mdl:SetModel(info.model)
        mdl:SetFOV( info.sidefov )
        mdl:SetCamPos( Vector( 5, 270, 4150 ) )
        function mdl:LayoutEntity( ent ) 
            ent:SetAngles( Angle(0, 0, 75))
        end

        local btn = vgui.Create("DButton", shipPnl)
        btn:SetSize( shipPnl:GetWide(), shipPnl:GetTall() )
        btn.Paint = function( self, w, h )
            draw.DrawText( tostring(ship.countShips.Fighter), "Arial8", w * 0.19, h * 0.775, Color( 230, 230, 230, 255 ), TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(ship.countShips.Intercepter), "Arial8", w * 0.39, h * 0.775, Color( 230, 230, 230, 255 ), TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(ship.countShips.Bomber), "Arial8", w * 0.59, h * 0.775, Color( 230, 230, 230, 255 ), TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(ship.countShips.Gunship), "Arial8", w * 0.79, h * 0.775, Color( 230, 230, 230, 255 ), TEXT_ALIGN_LEFT )

        end

        btn.DoClick = function( self )
            net.Start("Falcon:Navy:SquadronsRequest")
                net.WriteUInt( tonumber( ship.id ), 32 )
            net.SendToServer()
        end
    end
end
net.Receive("Falcon:Navy:OpenSquadrons", function()
    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()

    local f = vgui.Create("DFrame")
    f:SetSize( scrw * 0.8, scrh * 0.75 )
    f:Center()
    f:MakePopup()
    f:SetDraggable( false )
    f:SetTitle( "" )
    f:ShowCloseButton( true )

    local fw, fh = f:GetWide(), f:GetTall()

    f.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawOutlinedRect( w * 0.00625, h * 0.0125, w * 0.9875, h * 0.975 )

        draw.DrawText( "Squadron Management", "Arial16", w * 0.025, h * 0.05, Color( 230, 230, 230, 255 ), TEXT_ALIGN_LEFT )
    end

    local shipsPnl = vgui.Create("DScrollPanel", f)
    shipsPnl:SetSize( fw * 0.23, fh * 0.775 )
    shipsPnl:SetPos( fw * 0.025, fh * 0.175 )
    shipsPnl.Selected = false
    shipsPnl.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    local sbar = shipsPnl:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ) )

    end



    local enemPnl = vgui.Create("DScrollPanel", f)
    enemPnl:SetSize( fw * 0.355, fh * 0.775 )
    enemPnl:SetPos( fw * 0.62, fh * 0.175 )
    enemPnl.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    local sbar = enemPnl:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ) )

    end



    local friendlyPnl = vgui.Create("DScrollPanel", f)
    friendlyPnl:SetSize( fw * 0.355, fh * 0.775 )
    friendlyPnl:SetPos( fw * 0.26, fh * 0.175 )
    friendlyPnl.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    local sbar = friendlyPnl:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ) )

    end

    shipsPnl.FriendlyPnl = friendlyPnl
    shipsPnl.EnemyPnl = enemPnl


    Falcon.EnhancedNavy.Data.MainPnl = shipsPnl

    SortFriendlyShips( Falcon.EnhancedNavy.Data.Friendly.ships )
end)

net.Receive("Falcon:Navy:SquadronsReceive", function()
    local tbl = net.ReadTable()

    SortFriendlySquadrons( tbl )
end)
net.Receive("Falcon:Navy:SendHostilePresenceActive", function()
    local t = net.ReadTable()

    Falcon.EnhancedNavy.Data = t
    SortFriendlyShips( Falcon.EnhancedNavy.Data.Friendly.ships )
end)






net.Receive("Falcon:Navy:OpenBuy", function()
    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()

    local f = vgui.Create("DFrame")
    f:SetSize( scrw * 0.75, scrh * 0.65 )
    f:Center()
    f:MakePopup()
    f:SetDraggable( false )
    f:SetTitle( "" )
    f:ShowCloseButton( true )

    local fw, fh = f:GetWide(), f:GetTall()

    f.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawOutlinedRect( w * 0.00625, h * 0.0125, w * 0.9875, h * 0.975 )

        draw.DrawText( "Ship Funding", "Arial16", w * 0.025, h * 0.05, Color( 230, 230, 230, 255 ), TEXT_ALIGN_LEFT )
    end


    local p1 = vgui.Create("DPanel", f)
    p1:SetSize( fw * 0.175, fh * 0.775 )
    p1:SetPos( fw * 0.025, fh * 0.175 )
    p1.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 155 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    local p2 = vgui.Create("DPanel", f)
    p2:SetSize( fw * 0.175, fh * 0.775 )
    p2:SetPos( fw * 0.2, fh * 0.175 )
    p2.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 155 ) )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

   
    local cov = vgui.Create("DPanel", p2)
    cov:SetSize( p2:GetWide(), p2:GetTall() )
    cov:Center()
    cov.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )
    end
    p2.Cover = cov

    local p3 = vgui.Create("DPanel", f)
    p3:SetSize( fw * 0.175, fh * 0.775 )
    p3:SetPos( fw * 0.375, fh * 0.175 )
    p3.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    local cov = vgui.Create("DPanel", p3)
    cov:SetSize( p3:GetWide(), p3:GetTall() )
    cov:Center()
    cov.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )
    end
    p3.Cover = cov


    local p4 = vgui.Create("DPanel", f)
    p4:SetSize( fw * 0.425, fh * 0.775 )
    p4:SetPos( fw * 0.55, fh * 0.175 )
    p4.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    local cov = vgui.Create("DPanel", p4)
    cov:SetSize( p4:GetWide(), p4:GetTall() )
    cov:Center()
    cov.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ) )
    end
    p4.Cover = cov


    local bt = {
        [1] = "Ships",
        [2] = "Squadrons",
    }
    for i = 1, #bt do
        local b = vgui.Create("DButton", p1)
        b:SetSize( p1:GetWide(), p1:GetTall() * 0.1 )
        b:Dock( TOP )
        b:SetFont( "Arial8" )
        b:SetText( bt[i] )

        b.DoClick = function( self )
            p1.Planet = planet.id
            p2.Cover:Remove()

            p2:Clear()
            for type, name in pairs( Falcon.EnhancedNavy.ShipTypes ) do
                if tonumber( planet.shipcreation ) < type then break end
                local b = vgui.Create("DButton", p2)
                b:SetSize( p1:GetWide(), p1:GetTall() * 0.1 )
                b:Dock( TOP )
                b:SetFont( "Arial8" )
                b:SetText( name )
        
                b.DoClick = function( self )
                    p3.Cover:Remove()
                    
                    -- for _
                end
            end
        
        end

    end
end)
