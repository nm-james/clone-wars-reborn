local global = {}

local tutorial = {
    [1] = {
        Title = "INTRODUCTION",
        Dialogue = {
            {
                Text = "Welcome to Thermal Reborn Clone Wars Reborn! This is a tutorial for those who would like to learn about how we run our Star Wars RP server. Unlike traditional Star Wars RP servers, we aim to make SWRP a much more exciting and passive environment for all to roleplay in.",
            },
            {
                Text = "The first thing you might notice is that you will not get a player to train you. For those who have played traditional Star Wars Roleplay, this is something standard for all servers. Here, we like to keep things fun and simple. As you can see, we have automated this system to give you better insight into our server.",
            },
            {
                Text = "With that said, we have carefully picked out the relevant yet important things for our Clone Wars RP server. You will go through the following:\n - Faces (Directions in which you face in)\n - Formations (How you move in a certain format)\n - Interactions and Interactable NPCs (NPCs or items located around the map you can interact with)\n - Passive Events (Random events where players will have to resolve conflicts)",
            },
            {
                Text = "If you are experienced, you may skip certain bits and pieces of this tutorial, but its highly recommended you go through the things you do not know. Otherwise, we wish you good luck and hope you enjoy your stay at Thermal Reborn!",
            },
        },
        Pos = {
            Vector( 0, 0, 0 ),
            Vector( 10135.523438, 14884.431641, -8583.523438 )
        },
        Ang = {
            Angle( 0, 0, 0 ),
            Angle( 16.198673, -144.437546, 0 ),
        },
    },
    [2] = {
        Title = "FACES",
        Dialogue = {
            {
                Text = "To start off, faces are primarily used to determine how far you or other people should turn to look or interact with something. These arent essential to Star Wars RP, but most servers including ours try to encourage you to learn these.",
            },
            {
                Text = "To start off, we will start with the 'Left Face'.",
                NPCs = {
                    {
                        Position = Vector(4555.866699, 12949.814453, -9377.099609),
                        Anim = {
                            y = {
                                min = -180,
                                max = -90,
                                interval = 25,
                            },
                        },
                        Cur = {
                            r = 0,
                            y = -180,
                            p = 0,
                        },
                    },
                },
            },
            {
                Text = "These faces consist of turning to your right or left by 90 degrees, or 2 body 'clicks' (2 45o degree turns). It doesnt matter where you are facing, when you do any faces, you make sure you turn the right amount of degrees from where you are facing. Lets give it a shot.",
            },
        },
        Pos = {
            Vector( 0, 0, 0 ),
            Vector( 4414.109375, 12948.357422, -9316.349609 ),
        },
        Ang = {
            Angle( 0, 0, 0 ),
            Angle( 0, 0, 0 ),
        },
    },
}

local function UpdateAnimationValues()
    if global.NextAnimThink and global.NextAnimThink > CurTime() then return end

    for _, npc in pairs( global.Npcs ) do
        local id = npc.ID or 0

        if id == 0 then continue end

        local d = tutorial[global.ActiveSection].Dialogue[global.ActiveDialogue].NPCs[id]
        local ang = npc:GetAngles()
        local col = npc:GetColor()
        local fadeOut = false
        local aaaa = d.Anim or {}

        for _, a in pairs( aaaa ) do
            if d.Cur[_] == a.max then
                npc:SetColor( Color( 100, 255, 100, math.Clamp( col.a - (500 * FrameTime()), 0, 255 ) ) )
                if col.a == 0 then
                    d.Cur[_] = a.min
                end
                fadeOut = true
            else
                if col.a ~= 255 then
                    print(col.a)
                    npc:SetColor( Color( 100, 255, 100, math.Clamp( col.a + (500 * FrameTime()), 0, 255 ) ) )
                    continue
                end
                d.Cur[_] = math.Clamp(ang[_] + ((a.interval * 10) * FrameTime()), a.min, a.max)
            end

        end

        npc:SetAngles( Angle( d.Cur.r, d.Cur.y, d.Cur.p ) )

    end 

    global.NextAnimThink = CurTime() + 0.025
end

local function MoveOntoNextSection()
    for _, npc in pairs( global.Npcs ) do
        if npc and npc:IsValid() then
            npc:Remove()
        end 
    end 

    local npcData = tutorial[global.ActiveSection].Dialogue[global.ActiveDialogue].NPCs or {}

    for _, d in pairs( npcData ) do
        local clientModel = ents.CreateClientProp()
        clientModel:SetModel( "models/mayfield/212/trooper.mdl" )
        clientModel:Spawn()
        clientModel:SetPos( d.Position )
        clientModel:SetAngles( Angle( d.Cur.r, d.Cur.y, d.Cur.p ) )
        clientModel:SetupBones()
        clientModel:ResetSequence( 0 )
        clientModel:SetSequence( d.Sequence or 2 )
        clientModel:SetRenderMode(RENDERMODE_TRANSCOLOR)
        clientModel:SetMaterial("models/shiny")
        clientModel:SetColor( Color( 100, 255, 100, 255 ) )

        clientModel.ID = _

        table.insert( global.Npcs, clientModel )
    end 
end 

local function OpenTutorialFrame()
    hook.Add("Think", "UpdateAnimationValues", UpdateAnimationValues)

    if global.Npcs and #global.Npcs ~= 0 then
        for _, npc in pairs( global.Npcs ) do
            if npc and npc:IsValid() then
                npc:Remove()
            end 
        end 
    end 
    global.Npcs = {}

    global.ActiveSection = 1
    global.ActiveDialogue = false

    global.Defaults = {}
    global.CamPos = {}
    global.Nexts = {}

    local w, h = ScrW(), ScrH()
    local f = vgui.Create("DFrame")
    f:SetSize( w, h )
    f:ShowCloseButton( false )

    local exit = vgui.Create("DButton", f)
    exit:SetSize( f:GetWide() * 0.025, f:GetTall() * 0.025 )
    exit:SetPos( f:GetWide() * 0.975, f:GetTall() * 0.004 )
    exit:SetFont( "F15" )
    exit:SetText( "X" )
    exit:SetColor( Color( 255, 255, 255 ) )
    exit.Paint = nil
    exit.DoClick = function( self )
        f:Close()

        for _, npc in pairs( global.Npcs ) do
            if npc and npc:IsValid() then
                npc:Remove()
            end 
        end 
    end

    f.Think = function( self )
        for _, ply in pairs( player.GetAll() ) do
            if ply == LocalPlayer() then continue end
            ply:SetNoDraw( true )
        end
    end

    f.LerpingVector = 1
    f.LerpingFinished = true

    local mapInt = Falcon.Planets[game.GetMap()].id

    global.Defaults.pos = tutorial[1].Pos[mapInt] or Vector( 0, 0, 0 )
    global.Defaults.ang = tutorial[1].Ang[mapInt] or Angle( 0, 0, 0 )

    global.CamPos = global.Defaults.pos
    global.CamAng = global.Defaults.ang

    global.Nexts.pos = global.Defaults.pos
    global.Nexts.ang = global.Defaults.ang


    f.Paint = function( self, w, h )
        local pos = LerpVector(self.LerpingVector, global.CamPos, global.Nexts.pos)
        local ang = LerpAngle(self.LerpingVector, global.CamAng, global.Nexts.ang)

        if pos ~= global.Nexts.pos then
            if self.LerpingFinished then
                self.LerpingFinished = false
                self.LerpingVector = 0
            end
            self.LerpingVector = math.Clamp(self.LerpingVector + (FrameTime() * 3), 0, 1)
        elseif not self.LerpingFinished then
            self.LerpingFinished = true
            global.CamPos = global.Nexts.pos
            global.CamAng = global.Nexts.ang
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

    local info = vgui.Create("DButton", f)
    info:SetSize( f:GetWide() * 0.55, f:GetTall() * 0.275 )
    info:SetPos( f:GetWide() * 0.225, f:GetTall() * 0.65 )
    info:SetText("")
    info.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( tutorial[global.ActiveSection].Title, "F28", w * 0.5, h * 0.05, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER )

        draw.DrawText( "Click to Skip/Continue", "F11", w * 0.5, h * 0.9, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER )
    end

    local lbl = vgui.Create("DLabel", info)
    lbl:SetSize( info:GetWide() * 0.95, info:GetTall() * 0.7 )
    lbl:SetPos( info:GetWide() * 0.025, info:GetTall() * 0.275 )
    lbl:SetText( "" )
    lbl:SetWrap( true )
    lbl:SetFont( "F10" )

    lbl.Think = function( self )
        if self.NextAddition and self.NextAddition > CurTime() then return end
        if self.NextWrite and self.NextWrite >= #self.AnimStrings then return end

        if not global.ActiveDialogue and not tutorial[global.ActiveSection].Dialogue[global.ActiveDialogue] then
            global.ActiveDialogue = 1
            self.AnimStrings = string.Split(tutorial[global.ActiveSection].Dialogue[global.ActiveDialogue].Text, "")
            self.NextWrite = 1
        end


        self:SetText( self:GetText() .. self.AnimStrings[self.NextWrite] )
        self.NextWrite = self.NextWrite + 1
        self.NextAddition = CurTime() + 0.025
    end

    local skipInfoBtn = vgui.Create("DButton", info)
    skipInfoBtn:Dock( FILL )
    skipInfoBtn:SetText("")
    skipInfoBtn.Paint = nil

    skipInfoBtn.DoClick = function( self )
        if lbl.NextWrite < #lbl.AnimStrings then
            local text = ""
            for _, t in pairs( lbl.AnimStrings ) do
                text = text .. t
            end
            lbl.NextWrite = #lbl.AnimStrings

            lbl:SetText(text)
        else
            lbl:SetText("")
            if global.ActiveDialogue == #tutorial[global.ActiveSection].Dialogue then
                global.ActiveSection = global.ActiveSection + 1
                global.ActiveDialogue = 1

                local d = tutorial[global.ActiveSection]
                global.Nexts.pos = d.Pos[mapInt]
                global.Nexts.ang = d.Ang[mapInt]

                f.LerpingVector = 0

            else
                global.ActiveDialogue = global.ActiveDialogue + 1
            end
            
            lbl.AnimStrings = string.Split(tutorial[global.ActiveSection].Dialogue[global.ActiveDialogue].Text, "")
            lbl.NextWrite = 1

            MoveOntoNextSection( global.ActiveDialogue )
        end
    end
    return f
end


local function OpenOpeningFrame( rip )
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

                if rip and rip:IsValid() then
                    rip:Remove()
                end
                
                if self.Delay > CurTime() then return end

                self.FadeIn = false
                self.NextFrame = OpenTutorialFrame()
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

function OpenTutorial( cur )
    OpenOpeningFrame( cur )
end