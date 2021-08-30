include('shared.lua')

surface.CreateFont("F_TABS", {
    font = "Arial",
    size = ScreenScale( 5 )
})

surface.CreateFont("F_TITLE", {
    font = "Arial",
    size = ScreenScale( 7 )
})

surface.CreateFont("F_COMMAND_POST", {
    font = "Arial",
    size = ScreenScale( 10 )
})


ENT.Factions[1] = Vector(1, 1, 1)
ENT.Factions[2] = Vector(0.2, 0.45, 1)
ENT.Factions[3] = Vector(1, 0, 0)

local mat_lightcone = Material( "models/Jellyton/BF2/Misc/Props/Command_Post/M_LightCone_01_Hi_D" )
local mat_postbase = Material( "models/Jellyton/BF2/Misc/Props/Command_Post/M_REP_CommandPost_01" )
local mat_sepinsignia = Material( "models/Jellyton/BF2/Misc/Props/Command_Post/M_SEP_Insignia" )
local mat_repinsignia = Material( "models/Jellyton/BF2/Misc/Props/Command_Post/M_REP_Insignia" )

function ENT:Draw()
    self:DrawModel()

    local faction = self:GetNWInt("Falcon:Faction", 1)

    local color = self.Factions[faction]
    
    if faction ~= 1 then
        mat_lightcone:SetVector( "$color2", color )
        if faction == 2 then
            mat_repinsignia:SetVector( "$color2", color )
        elseif faction == 3 then
            mat_sepinsignia:SetVector( "$color2", color )
        end

        local pos = self:GetPos() + Vector(0, 0, 15)
        render.SetAmbientLight( 0, 0, 1 )
        render.SetMaterial( mat_lightcone )
        render.SetModelLighting( BOX_FRONT, 0,0,255 )
        render.DrawBeam(pos, pos + Vector(0, 0, 130), 90, 0, 1)
    end

    mat_postbase:SetVector( "$emissiveBlendTint", color )


    local ang = self:GetAngles()

    local mins, maxs = self:GetModelBounds()
    local pos = self:LocalToWorld(self:OBBCenter()) - Vector( 0, 0, 80 ) + ang:Right() * 37 + ang:Forward() * 35

    cam.Start3D2D( pos + (ang:Up() * 47), ang, 1 )
        surface.DrawCircle(mins.x, mins.y, 350, color:ToColor())
	cam.End3D2D()
end




local function CreateContent( content, hasEntity )
    content:Clear()
    content.Paint = nil

    local w, h = content:GetWide(), content:GetTall()

    local cmdName = vgui.Create("DTextEntry", content)
    cmdName:SetSize(w * 0.425, h * 0.1) 
    cmdName:SetPos(w * 0.155, h * 0.8675)
    cmdName:SetUpdateOnType( true )
    cmdName.Paint = function(self, width, height)
        surface.SetDrawColor(32, 32, 32)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))

        surface.SetDrawColor( Color( 0, 255, 0 ) )
        surface.DrawRect(0, height * 0.925, width, height * 0.1)
    end

    local neturalBtn = vgui.Create("DButton", content)
    neturalBtn:SetSize( w * 0.0825, h * 0.1 )
    neturalBtn:SetPos( w * 0.6, h * 0.8675 )
    neturalBtn:SetTextColor( Color( 255, 255, 255 ) )
    neturalBtn:SetText( "N" )
    neturalBtn.Paint = function( self, width, height )
        surface.SetDrawColor(32, 32, 32)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        surface.SetDrawColor( Color( 195, 195, 195 ) )
        surface.DrawRect(0, height * 0.925, width, height * 0.1)
    end
    neturalBtn.DoClick = function()
        if not hasEntity then return end
        net.Start("Falcon:CommandPost:ChangeState")
            net.WriteEntity( hasEntity )
            net.WriteInt( 1, 5 )
        net.SendToServer()
    end

    local repBtn = vgui.Create("DButton", content)
    repBtn:SetSize( w * 0.0825, h * 0.1 )
    repBtn:SetPos( w * 0.685, h * 0.8675 )
    repBtn:SetTextColor( Color( 255, 255, 255 ) )
    repBtn:SetText( "R" )
    repBtn.Paint = function( self, width, height )
        surface.SetDrawColor(32, 32, 32)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        surface.SetDrawColor( Color( 65, 65, 118555 ) )
        surface.DrawRect(0, height * 0.925, width, height * 0.1)
    end
    repBtn.DoClick = function()
        if not hasEntity then return end
        net.Start("Falcon:CommandPost:ChangeState")
            net.WriteEntity( hasEntity )
            net.WriteInt( 2, 5 )
        net.SendToServer()
    end

    local cisBtn = vgui.Create("DButton", content)
    cisBtn:SetSize( w * 0.0825, h * 0.1 )
    cisBtn:SetPos( w * 0.77, h * 0.8675 )
    cisBtn:SetTextColor( Color( 255, 255, 255 ) )
    cisBtn:SetText( "C" )
    cisBtn.Paint = function( self, width, height )
        surface.SetDrawColor(32, 32, 32)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        surface.SetDrawColor( Color( 155, 55, 55 ) )
        surface.DrawRect(0, height * 0.925, width, height * 0.1)
    end
    cisBtn.DoClick = function()
        if not hasEntity then return end
        net.Start("Falcon:CommandPost:ChangeState")
            net.WriteEntity( hasEntity )
            net.WriteInt( 3, 5 )
        net.SendToServer()
    end

    if not hasEntity or not hasEntity:IsValid() then return end
    cmdName:SetText( hasEntity:GetNWString("Falcon:Name") )
    cmdName.OnValueChange = function( val )
        net.Start("Falcon:CommandPost:ChangeName")
            net.WriteEntity( hasEntity )
            net.WriteString( val:GetValue() )
        net.SendToServer()
    end
    content.Paint = function( self )
        draw.DrawText(hasEntity:GetNWString("Falcon:Name"), "F_COMMAND_POST", w * 0.5, h * 0.035, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        draw.DrawText("Name", "F_TITLE", w * 0.235, h * 0.225, Color(255,255,255,255), TEXT_ALIGN_CENTER)


        local old = DisableClipping( true )
        local ang = hasEntity:GetAngles()
        ang:RotateAroundAxis(ang:Right(), -25)

        render.RenderView( {
            origin = hasEntity:GetPos() - ang:Forward() * 200 + ang:Up() * 75,
            angles = ang,
            drawviewmodel = false,

            x = w * 0.835, y = h * 1.15,
            w = w * 0.7, h = h * 0.7
        } )

        DisableClipping( old )
    end
end


local function CreateOptions( navigationBar, content, start, ending )
    navigationBar:Clear()

    local count = table.Count( navigationBar.Posts )
    if navigationBar.Posts[start - 1] then
        local backBtn = vgui.Create("DButton", navigationBar)
        backBtn:Dock( LEFT )
        backBtn:SetSize( navigationBar:GetWide() * 0.02725, navigationBar:GetTall() )
        backBtn:SetTextColor( Color( 255, 255, 255 ) )
        backBtn:SetText( "<" )
        backBtn.Paint = function( self, width, height )
            surface.SetDrawColor( 37, 37, 37 )
            surface.DrawRect( 0, 0, width, height )

            surface.SetDrawColor( navigationBar.Posts[1].Factions[1]:ToColor() )
            surface.DrawRect(0, height * 0.875, width, height * 0.15)
        end

        backBtn.DoClick = function()
            start = start - 5
            ending = ending - 5
            CreateOptions( navigationBar, content, start, ending )
        end
    end
    
    for i = start, ending do
        if not navigationBar.Posts[i] then break end
        local ent = navigationBar.Posts[i]
        local commandPostBtn = vgui.Create("DButton", navigationBar)
        commandPostBtn:Dock( LEFT )
        commandPostBtn:SetSize( navigationBar:GetWide() * 0.19, navigationBar:GetTall() )
        commandPostBtn:SetTextColor( Color( 255, 255, 255 ) )
        commandPostBtn:SetText( "" )

        commandPostBtn.Paint = function( self, width, height )
            surface.SetDrawColor( 37, 37, 37 )
            surface.DrawRect( 0, 0, width, height )

            surface.SetDrawColor( ent.Factions[ent:GetNWInt("Falcon:Faction", 1)]:ToColor() )
            surface.DrawRect(0, height * 0.875, width, height * 0.15)

            surface.SetDrawColor( 80, 80, 80 )
            surface.DrawLine( 0, 0, 0, height )

            draw.DrawText( ent:GetNWString("Falcon:Name"), "F_TABS", width * 0.5, height * 0.1, Color(255,255,255,255), TEXT_ALIGN_CENTER )

            if i == 5 then
                surface.DrawLine( width * 0.999, 0, width * 0.999, height )
            end
        end

        commandPostBtn.DoClick = function( self )
            commandPost = ent
            CreateContent( content, commandPost )
        end
    end

    if count - ending > 0 then
        local nextBtn = vgui.Create("DButton", navigationBar)
        nextBtn:Dock( LEFT )
        nextBtn:SetSize( navigationBar:GetWide() * 0.027, navigationBar:GetTall() )
        nextBtn:SetTextColor( Color( 255, 255, 255 ) )
        nextBtn:SetText( ">" )
        nextBtn.Paint = function( self, width, height )
            surface.SetDrawColor( 40, 40, 40 )
            surface.DrawRect( 0, 0, width, height )

            surface.SetDrawColor( navigationBar.Posts[1].Factions[1]:ToColor() )
            surface.DrawRect(0, height * 0.875, width, height * 0.15)
        end

        nextBtn.DoClick = function()
            start = start + 5
            ending = ending + 5
            CreateOptions( navigationBar, content, start, ending )
        end
    end
end


local function OpenMenu( commandPost )
    local ply = LocalPlayer()

    if ply.OpenedEventMenu then return end

    ply.OpenedEventMenu = true

    local frame = vgui.Create("DFrame")
    frame:SetSize( ScrW() * 0.45, ScrH() * 0.4 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:SetAlpha( 0 )

    frame.Fade = true

    frame.Paint = function( self, width, height )
        surface.SetDrawColor( 55, 55, 55, 255 )
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor( 78, 78, 78, 255 )
        surface.DrawRect(width * 0.9, 0, width * 0.11, height)

        surface.SetDrawColor( 25, 25, 25, 255 )
        surface.DrawRect(0, 0, width, height * 0.075)

        draw.DrawText( "Falcon | Command Posts", "F_TITLE", width * 0.01, height * 0.01, Color(255,255,255,255), TEXT_ALIGN_LEFT )
    end
    frame.Think = function( self )
        if frame.Fade then
            self:SetAlpha( math.Clamp( self:GetAlpha() + ((5 * FrameTime()) * 255), 0, 255 ) )
        else
            self:SetAlpha( math.Clamp( self:GetAlpha() - ((5 * FrameTime()) * 255), 0, 255 ) )
            if self:GetAlpha() == 0 then
                self:Close()
            end
        end
    end

    local w, h = frame:GetWide(), frame:GetTall()

    local exit = vgui.Create("DButton", frame)
    exit:SetSize( w * 0.04, h * 0.075 )
    exit:SetPos( w * 0.961, 0 )
    exit:SetTextColor( Color( 255, 255, 255 ) )
    exit:SetText( "x" )
    exit.Paint = nil
    exit.DoClick = function( self )
        ply.OpenedEventMenu = false
        frame.Fade = false
    end

    local navigationBar = vgui.Create("DPanel", frame)
    navigationBar:SetSize( w * 0.9, h * 0.055 )
    navigationBar:SetPos( 0, h * 0.075 )
    navigationBar.Paint = nil
    navigationBar.Think = function( self )
        self.Posts = ents.FindByClass("falcons_command_post")
    end

    local content = vgui.Create("DPanel", frame)
    content:SetSize( w * 0.9, h - (h * 0.13) )
    content:SetPos( 0, h * 0.13 )
    content.Paint = nil


    timer.Simple(0.1, function()

        CreateOptions( navigationBar, content, 1, 5 )

    end)
     

    CreateContent( content, commandPost )
end

net.Receive("Falcon:CommandPost:SendEffect", function()
    local bool = net.ReadBool()
    local int = net.ReadInt( 32 )
    local ent = net.ReadEntity()

    if bool then
        sound.PlayFile( "sound/falcons_command/friendly_taken_" .. tostring( int ) .. ".mp3", "noplay", function( station, errCode, errStr )
            if ( IsValid( station ) ) then
                station:Play()
            end
        end )
        chat.AddText(Vector( 0.2, 0.45, 1 ):ToColor(), "[Republic HQ] ", Color( 255, 255, 255 ), " The Republic has captured command post '" .. ent:GetNWString("Falcon:Name") .. "'.")
    else
        sound.PlayFile( "sound/falcons_command/friendly_lost_" .. tostring( int ) .. ".mp3", "noplay", function( station, errCode, errStr )
            if ( IsValid( station ) ) then
                station:Play()
            end
        end )
        chat.AddText(Vector( 0.2, 0.45, 1 ):ToColor(), "[Republic HQ] ", Color( 255, 255, 255 ), " The Republic has lost command post '" .. ent:GetNWString("Falcon:Name") .. "'.")
    end
end)

net.Receive("Falcon:CommandPost:EventMenu", function()
    local ent = net.ReadEntity()

    OpenMenu( ent )
end)

hook.Add("HUDPaint", "CreateCommandPostCaptureTHingy", function()
    local ply = LocalPlayer()
    local ents = ents.FindInSphere(ply:GetPos(), 300)

    for _, ent in pairs( ents ) do
        if ent:GetClass() == "falcons_command_post" then
            local scrw, scrh = ScrW(), ScrH()
            ply.HasACommandPost = true

            local faction = ent:GetNWInt("Falcon:Faction", 1)
            local color = ent.Factions[1]:ToColor()

            local hostile = ent:GetNWInt("Falcon:Faction:Hostile")
            local friendly = ent:GetNWInt("Falcon:Faction:Friendly")

            local color = ent.Factions[1]:ToColor()
            local activePoints

            if hostile == 0 then
                color = ent.Factions[2]:ToColor()
                activePoints = friendly
            else
                color = ent.Factions[3]:ToColor()
                activePoints = hostile
            end

            local textColor = ent.Factions[faction]:ToColor()

            surface.SetDrawColor( 15, 15, 15, 195 )
            surface.DrawRect(scrw * 0.34375, scrh * 0.11825, scrw * 0.3125, scrh * 0.04)

            surface.SetDrawColor( color )
            surface.DrawOutlinedRect(scrw * 0.347, scrh * 0.1225, scrw * 0.306, scrh * 0.031)

            if hostile ~= 100 and friendly ~= 100 then
                surface.SetDrawColor( color, 255 )
                surface.DrawRect(scrw * 0.348, scrh * 0.1245, (activePoints / 100) * scrw * 0.304, scrh * 0.027)
            end
            draw.DrawText(ent:GetNWString("Falcon:Name"), "F_TITLE", scrw * 0.5, scrh * 0.12675, textColor, TEXT_ALIGN_CENTER)

            return
        end
    end

    ply.HasACommandPost = false
end)