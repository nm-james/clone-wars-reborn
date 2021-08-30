Falcon = Falcon or {}

local col = {
    [0] = Color( 255, 255, 255 ),
    [1] = Color( 0, 145, 0 ),
    [2] = Color( 102, 102, 210 ),
    [3] = Color( 125, 0, 0 ),
    [4] = Color( 125, 0, 0 ),
}

local function AnimateEnter( id )
    if id == Falcon.Location then return end
    local i = Falcon.Planets[game.GetMap()]
    local location = Falcon.Locations[i.id][id]

    local locName = Falcon.Planets[game.GetMap()].outside.name

    local descPhrases = Falcon.Planets[game.GetMap()].outside.quotes
    local locDescription = descPhrases[math.random(1, #descPhrases)]

    if location then
        locName = location.Name
        locDescription = location.Description
    end

    if Falcon.LocationFrame and Falcon.LocationFrame:IsValid() then
        Falcon.LocationFrame:Remove()
        Falcon.LocationFrame = nil
    end

    local w, h = ScrW(), ScrH()

    local animationFrame = vgui.Create("DFrame")
    animationFrame:SetSize( w * 0.3, h * 0.15 )
    animationFrame:SetPos( w * 0.35, h * 0.025 )
    animationFrame:SetDraggable( false )
    animationFrame:SetTitle("")
    animationFrame:ShowCloseButton( false )
    animationFrame.Delay = CurTime() + 4
    animationFrame.Alpha = 0
    animationFrame.Paint = function( self, w, h )
        draw.DrawText( locName, "F38", w * 0.5, h * 0.3, Color( 255, 255, 255, self.Alpha ), TEXT_ALIGN_CENTER )
        draw.DrawText( locDescription, "F12", w * 0.5, h * 0.78, Color( 255, 255, 255, self.Alpha ), TEXT_ALIGN_CENTER )
        
        -- surface.SetDrawColor( 255, 255, 255, self.Alpha )
        -- surface.DrawLine( w * 0.05, h * 0.81, w * 0.95, h * 0.81 )

    end

    animationFrame.Think = function( self )
        if self.Delay > CurTime() then
            self.Alpha = math.Clamp( self.Alpha + ((FrameTime() * 4) * 255), 0, 255 )
        else
            self.Alpha = math.Clamp( self.Alpha - ((FrameTime() * 4) * 255), 0, 255 )
            if self.Alpha == 0 then
                self:Remove()
            end
        end
    end

    Falcon.Location = id
    Falcon.LocationFrame = animationFrame
end

hook.Add("HUDPaint", "IdentifyLocations", function()
    local ply = LocalPlayer()
    local w, h = ScrW(), ScrH()
    local id = Falcon.Planets[game.GetMap()].id
    for id, d in pairs( Falcon.Locations[id] ) do
        local pos = d.Position + Vector( 0, 0, 50 )
        local dist = pos:Distance(ply:GetPos())

        if (dist > 5500 or dist < 600) and (d.Faction ~= 4 and d.Faction ~= 2) then 
            d.Alpha = math.Clamp(d.Alpha - (FrameTime() * 4), 0, 1)
            if d.Alpha == 0 then
                continue 
            end
        else
            d.Alpha = math.Clamp(d.Alpha + (FrameTime() * 4), 0, 1)
        end

        if dist < d.Enter then
            AnimateEnter(id)
        elseif (dist > d.Enter + 600) and Falcon.Location == id then
            AnimateEnter(0)
        end

        local col = col[d.Faction]

        col.a = 255 * d.Alpha

        local s = pos:ToScreen()

        draw.NoTexture()
        surface.SetDrawColor( col )
        surface.SetMaterial(Material(d.Icon))
        surface.DrawTexturedRect( s.x - (w * 0.025 / 2), s.y - (w * 0.025 / 2) + (h * 0.0175), w * 0.025, w * 0.025 )

        draw.DrawText( d.Name .. " | " .. tostring(math.Round(dist / 38, 0)) .. "m", "F10", s.x, s.y - (h * 0.025), col, TEXT_ALIGN_CENTER )
        -- draw.DrawText( d.Description, "F6", s.x, s.y + (h * 0.03), Color( 255, 255, 255, (255 * d.Alpha) ), TEXT_ALIGN_CENTER )

    end

end)



