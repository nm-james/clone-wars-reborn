local global = {}

local tutorial = {
    [1] = {
        Title = "INTRODUCTION"
        Dialogue = {
            {
                Text = [[Welcome to Thermal Reborn Clone Wars Reborn!
                This is a tutorial for those who would like to learn about how we run our Star Wars RP server.
                Unlike traditional Star Wars RP servers, we aim to make SWRP a much more exciting and passive environment for all to roleplay in.]],
            },
            {
                Text = [[The first thing you might notice is that you will not get a player to train you.
                We have carefully picked out the relevant yet important things for our Clone Wars RP server.
                You will go through the following:
                 - Faces (Directions in which you face in)
                 - Formations (How you move in a certain format)
                 - Interactions and Interactable NPCs (NPCs or items located around the map you can interact with)
                 - Passive Events (Random events where players will have to resolve conflicts)]],
            },
            {
                Text = [[If you are experienced, you may skip certain bits and pieces of this tutorial,
                but its highly recommended you go through the things you do not know. Otherwise, we wish you good luck
                and hope you enjoy your stay at Thermal Reborn!]],
            },
        },
    },
    [2] = {
        Title = "FACES"
        Dialogue = {
            {
                Text = [[Faces are primarily used to determine how far you or other people should turn to look
                or interact with something. These arent essential to Star Wars RP, but most servers including ours
                try to encourage you to learn these.]],
            },
            {
                Text = [[The faces that are easiest to learn are what is known to be the Left and Right faces.]],
            },
            {
                Text = [[The faces consist of turning to your right or left by 90 degrees, or 2 body 'clicks' (2 45o degree turns).
                It doesnt matter where you are facing, when you do any faces, you make sure you turn the right amount of degrees
                from where you are facing. Lets give it a shot.]],
            },
        },
    },
}

local function OpenTutorialFrame()
    local w, h = ScrW(), ScrH()
    local f = vgui.Create("DFrame")
    f:SetSize( w, h )

    f.Think = function( self )
        for _, ply in pairs( player.GetAll() ) do
            if ply == LocalPlayer() then continue end
            ply:SetNoDraw( true )
        end
    end

    f.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( 0, 0, w, h )
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

                rip:Remove()
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