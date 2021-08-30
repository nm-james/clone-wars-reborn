local global = {}
local loc = {
    [1] = {
        {
            Pos = Vector( 3583.349121, -3512.943359, 330.031250 ),
            Ang = Angle( 11, -36, 0 )
        },
        {
            Pos = Vector( 7050.627441, -3659.885986, 56.031250 ),
            Ang = Angle( 0, -49, 0 )
        }
    },
    [2] = {
        {
            Pos = Vector( 9132.760742, -5491.991699, 275.031250 ),
            Ang = Angle( 12.825981, 178.604172, 0.000000 )
        },
        {
            Pos = Vector( 7371.549805, -5490.040527, 218.441559 ),
            Ang = Angle( 12.825981, 178.604172, 0.000000 )
        }
    },
    [3] = {
        {
            Pos = Vector( -4540.224609, 3883.916748, 849.459045 ),
            Ang = Angle( 14.939979, -53.079262, 0.000000 )
        },
        {
            Pos = Vector( -1710.901001, 3212.837402, 543.122070 ),
            Ang = Angle( 11.859964, -109.179420, 0.000000 )
        }
    },
    [4] = {
        {
            Pos = Vector( 10200.050781, -2552.360596, 809.201111 ),
            Ang = Angle( 19.119877, 127.980438, 0.000000 )
        },
        {
            Pos = Vector( 8574.345703, -1656.259277, 107.678955 ),
            Ang = Angle( 2.179859, 179.240707, 0.000000 )
        }
    },
    
}

local function MainUI()

end

local function Tutorial( fr )
    local w, h = ScrW(), ScrH()

    local button = vgui.Create("DButton", fr)
    button.Color = Color( 140, 140, 140 )
    button:SetSize( w * 0.3, h * 0.05 )
    button:SetPos( w * 0.35, h * 0.55 )
    button:SetFont("F11")
    button:SetContentAlignment( 5 )
    button:SetText( "Get Started" )
    button:SetColor( button.Color )

    button.Think = function( self )
        if self:IsHovered() then
            self.Color = Color( 255, 175, 0 )
        else
            self.Color = Color( 140, 140, 140 )
        end
        self:SetColor( self.Color )
    end
    button.Paint = function( self, w, h )
        draw.RoundedBox( 7.5, 0, 0, w, h, self.Color )
        draw.RoundedBox( 7.5, h * 0.04, h * 0.04, w - (h * 0.08025), h - (h * 0.08025), Color( 17, 17, 17 ) )
    end

    button.DoClick = function( self )
        OpenTutorial( fr )
    end

end


local function OpenMainFrame()
    local w, h = ScrW(), ScrH()
    local f = vgui.Create("DFrame")
    f:SetSize( w, h )
    f.Movement = 0
    f.TransitionInt = 0
    f.StartingInt = 1

    f.Paint = function( self, w, h )
        local old = DisableClipping( true )
        render.RenderView( {
            origin = LerpVector(math.Clamp(self.Movement, 0, 1), loc[self.StartingInt][1].Pos, loc[self.StartingInt][2].Pos),
            angles = LerpAngle(math.Clamp(self.Movement, 0, 1), loc[self.StartingInt][1].Ang, loc[self.StartingInt][2].Ang),
            x = x, y = y,
            w = w, h = h
        } )
        DisableClipping( old )

        if self.Movement >= 1 then
            self.Movement = 0
            self.Transition = false
            self.StartingInt = self.StartingInt + 1
            if not loc[self.StartingInt] then
                self.StartingInt = 1
            end
        elseif self.Movement >= 0.85 then
            self.Transition = true
        end

        if self.Transition then
            self.TransitionInt = math.Clamp(self.TransitionInt + (2 * FrameTime()), 0, 1)
        else
            self.TransitionInt = math.Clamp(self.TransitionInt - (2 * FrameTime()), 0, 1)
        end

        surface.SetDrawColor( 0, 0, 0, self.TransitionInt * 255)
        surface.DrawRect(0, 0, w, h)

        self.Movement = self.Movement + (FrameTime() * 0.1)
    end

    local logoImg = vgui.Create("DPanel", f)
    logoImg:SetSize( w * 0.4, h * 0.2 )
    logoImg:SetPos( w * 0.3, h * 0.21 )

    if not Falcon.Characters or #Falcon.Characters == 0 then
        Tutorial( f )
    else

    end

    return f
end

local function OpenOpeningFrame()
    if global.curFrame and global.curFrame:IsValid() then return end
    Falcon.IsLoaded = true

    local w, h = ScrW(), ScrH()
    local f = vgui.Create("DFrame")
    f:SetSize( w, h )
    f:MakePopup()
    f.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( 0, 0, w, h )
    end

    local logoImg = vgui.Create("DPanel", f)
    logoImg:SetSize( w * 0.6, h * 0.3 )
    logoImg:SetPos( w * 0.2, h * 0.275 )


    f.Think = function( self )
        if not self.HasAnimation and Falcon.IsLoaded then
            global.nextF = OpenMainFrame()
            self.HasAnimation = true

            logoImg:SizeTo( w * 0.4, h * 0.2, 3, 1.5, 0.325 )
            logoImg:MoveTo( w * 0.3, h * 0.21, 3, 1.5, 0.325 )

        elseif self.HasAnimation then
            local weee, hiii = logoImg:GetSize()
            if weee == math.floor(w * 0.4) and hiii == math.floor(h * 0.2) then
                self:SetAlpha( math.Clamp( self:GetAlpha() - ((FrameTime() * 2.5) * 255), 0, 255) )
                if self:GetAlpha() == 0 then
                    self:Remove()
                    global.nextF:MakePopup()
                    global.curFrame = global.nextF
                end
            end
        end
    end

    global.curFrame = f
end

function OpenCharacters( shouldStart )
    if shouldStart then
        OpenOpeningFrame()
    else
        OpenMainFrame()
    end
end