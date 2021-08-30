Falcon = Falcon or {}
Falcon.Personalities = {
    { 
        [1] = "Piss off you dirty bug.",
        [2] = "If you dont wanna get hurt, then get lost.",
        [3] = "People get mad when you treat them how they treat you.",
        [4] = "Didn't you hear? Leave or else.",
        [5] = "Wraith is one of my many traits. Don't be the first one to witness it.",
        [6] = "God, you are difficult.",
        [7] = "No one asked you here.",
        [8] = "I am so close to pulling out my blaster on you right now.",
        [9] = "We may be brothers, but i'll still treat you like a punching bag any day.",
        [10] = "I heard you joined a regiment. I also heard you are an achor.",
        [11] = "Weren't you told to follow orders? Follow this one, piss off.",
        [12] = "I'm not in the mood for you right now. Get lost.",
    },
}

function NPCPopupSpeech( npc )
    Falcon.HasNPCSpeaking = 1

    local frame = vgui.Create("DFrame")
    frame:SetSize( ScrW() * 0.25, ScrH() * 0.1 )
    frame:SetPos( ScrW() * 0.375, ScrH() * 0.65 )
    frame:SetDraggable( false )
    frame:SetTitle("")
    frame:ShowCloseButton( false )
    frame:SetAlpha( 0 )
    frame.Opening = true
    frame.Delay = CurTime() + 3
    frame.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 200 )
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(0, 75, 175, 255)
        surface.DrawOutlinedRect(2, 2, w - 4, h - 4)

        draw.DrawText(npc.Name, "F16", w * 0.5, h * 0.03, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    frame.Think = function( self )
        if self.Opening then
            self:SetAlpha( math.Clamp(self:GetAlpha() + ((FrameTime() * 2) * 255), 0, 255) )
            if self:GetAlpha() == 255 then
                self.Opening = false
            end
        elseif CurTime() > self.Delay and not self.Opening then
            self:SetAlpha( math.Clamp(self:GetAlpha() - ((FrameTime() * 2) * 255), 0, 255) )
            if self:GetAlpha() == 0 then
                Falcon.HasNPCSpeaking = false
                self:Remove()
            end
        end
    end

    local textDerma = vgui.Create("DLabel", frame)
    textDerma:SetSize( frame:GetWide() * 0.95, frame:GetTall() * 0.65)
    textDerma:SetPos( frame:GetWide() * 0.025, frame:GetTall() * 0.33)
    textDerma:SetFont("F10")
    textDerma:SetWrap( true )
    textDerma:SetContentAlignment( 8 )
    textDerma:SetText(Falcon.Personalities[npc.Personality][math.random(1, #Falcon.Personalities[npc.Personality])])
end


local function MainUI( npc, content )
    local uis = {
        [1] = OpenAttachments,
        [2] = OpenStore,
    }

    local talkPnl = vgui.Create("DPanel", content)
    talkPnl:SetSize( content:GetWide() * 0.55, content:GetTall() * 0.275 )
    talkPnl:SetPos( content:GetWide() * 0.225, content:GetTall() * 0.675 )
    talkPnl.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( npc.Name, "F28", w * 0.13, h * 0.075, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
        draw.DrawText( npc.Desc, "F13", w * 0.13, h * 0.255, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
    end

    local optionsPnl = vgui.Create("DScrollPanel", talkPnl)
    optionsPnl:SetSize( talkPnl:GetWide() * 0.5, talkPnl:GetTall() * 0.98 )
    optionsPnl:SetPos( talkPnl:GetWide() * 0.5, talkPnl:GetTall() * 0.01 )

    for _, d in pairs(npc.Options) do
        local opt = vgui.Create("DButton", optionsPnl)
        opt.Color = Color( 140, 140, 140 )
        opt:SetSize( optionsPnl:GetWide() * 0.9, optionsPnl:GetTall() * 0.2 )
        opt:Dock( TOP )
        opt:SetFont("F11")
        opt:SetContentAlignment( 5 )
        opt:SetText(d.Text)
        opt:SetColor( opt.Color )
        opt.Think = function( self )
            if self:IsHovered() then
                self.Color = Color( 255, 175, 0 )
            else
                self.Color = Color( 140, 140, 140 )
            end
            self:SetColor( self.Color )
        end
        opt.Paint = function( self, w, h )
            draw.RoundedBox( 7.5, 0, 0, w, h, opt.Color )
            draw.RoundedBox( 7.5, h * 0.04, h * 0.04, w - (h * 0.08025), h - (h * 0.08025), Color( 17, 17, 17 ) )
        end
        opt.DoClick = function( self )
            content:GetParent():Close()
            Falcon.HasNPCSpeaking = false

            if d.Menu then
                uis[d.Menu]()
            end
        end
        if _ == #npc.Options then
            opt:DockMargin( optionsPnl:GetWide() * 0.05, optionsPnl:GetTall() * 0.025, optionsPnl:GetWide() * 0.025, optionsPnl:GetTall() * 0.025 )
        else
            opt:DockMargin( optionsPnl:GetWide() * 0.05, optionsPnl:GetTall() * 0.025, optionsPnl:GetWide() * 0.025, 0 )
        end
    end

    local imgPnl = vgui.Create("DPanel", talkPnl)
    imgPnl:SetSize( content:GetWide() * 0.06, content:GetWide() * 0.06 )
    imgPnl:SetPos( content:GetTall() * 0.016, content:GetTall() * 0.015 )
    imgPnl.Paint = function( self, w, h )
        draw.RoundedBox( 7.5, 0, 0, w, h, Color( 255, 255, 255 ) )
        draw.RoundedBox( 7.5, h * 0.02, h * 0.02, w - (h * 0.04), h - (h * 0.04), Color( 42, 42, 42, 255 ) )
        draw.RoundedBox( 7.5, h * 0.1, h * 0.095, w - (h * 0.205), h - (h * 0.2), Color( 55, 55, 55, 255 ) )
    end

    local msgPnl = vgui.Create("DLabel", talkPnl)
    msgPnl:SetSize( talkPnl:GetWide() * 0.48, talkPnl:GetWide() * 0.135 )
    msgPnl:SetPos( content:GetTall() * 0.016, talkPnl:GetTall() * 0.475 )
    msgPnl:SetText("WElcome to deez. I like trains. Boby Marley. I am your father. This is just to make a very prolonged message. I hope this worked")
    msgPnl:SetFont("F15")
    msgPnl:SetWrap( true )
end

local function OpenTalkFrame( npc )
    local w, h = ScrW(), ScrH()
    local frame = vgui.Create("DFrame")
    frame:SetSize( w, h )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:SetTitle("")
    frame:Center()
    frame.Paint = function( self, w, h )
        local old = DisableClipping( true )
        local ang = Angle( 15, npc:GetAngles().y, 0 )
        render.RenderView( {
            origin = npc:GetPos() + (ang:Forward() * 40) + (ang:Up() * 82),
            angles = ang - Angle( 0, 180, 0 ),
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
        Falcon.HasNPCSpeaking = false
    end

    local content = vgui.Create("DPanel", frame)
    content:SetSize( frame:GetWide() * 1, frame:GetTall() * 0.975 )
    content:SetPos( 0, frame:GetTall() * 0.025 )
    content.Paint = nil

    MainUI( npc, content )

    return frame
end

function OpenNPCStart( npc )
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
                self.NextFrame = OpenTalkFrame( npc )
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


function OpenNPCTalk( npc )
    Falcon.HasNPCSpeaking = 2
    OpenNPCStart( npc )
end



