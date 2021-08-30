local upd = {
    {
        Title = "Server Release",
        Date = "27/08/2021",
        Version = 1.1,
        Desc = [[Today, we signify the release of Thermal Reborn's Clone Wars Reborn.

        So fuck the mniggas.
        So fuck the mniggas.
        So fuck the mniggas.
        So fuck the mniggas.
        So fuck the mniggas.
        So fuck the mniggas.
        
        ]],
    },
    {
        Title = "Testttty",
        Date = "27/08/2021",
        Version = 1.1,
        Desc = "Yesssssssssss",
    },
    {
        Title = "Testttty",
        Date = "27/08/2021",
        Version = 1.1,
        Desc = "Yesssssssssss",
    },
}

local function OpenUpdateFrame( data )
    local w, h = ScrW(), ScrH()

    local f = vgui.Create("DFrame")
    f:SetSize( w * 0.6, h * 0.6 )
    f:MakePopup()
    f:Center()

    f.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 205 ) )

        draw.DrawText( "UPDATES", "F45", w * 0.015, h * 0, Color(255,255,255,255), TEXT_ALIGN_LEFT )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawLine( w * 0.01, h * 0.145, w * 0.99, h * 0.145 )
    end

    local cont = vgui.Create("DScrollPanel", f)
    cont:SetSize( f:GetWide() * 0.975, f:GetTall() * 0.725 )
    cont:SetPos( f:GetWide() * 0.0125, f:GetTall() * 0.15 )

    for _, d in pairs( upd ) do
        if type(d) ~= "table" then continue end

        local pnl = vgui.Create("DPanel", cont)
        pnl:SetSize( cont:GetWide(), cont:GetTall() * 0.5 )
        pnl:Dock( TOP )
        pnl.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 205 ) )

            draw.DrawText( d.Title, "F20", w * 0.0125, h * 0.01, Color(235,235,235,255), TEXT_ALIGN_LEFT )
            draw.DrawText( "V" .. d.Version .. " - " .. d.Date, "F11", w * 0.015, h * 0.19, Color(145,145,145,255), TEXT_ALIGN_LEFT )
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawLine( w * 0.01, h * 0.98, w * 0.99, h * 0.98 )

        end

        local readScroll = vgui.Create("DScrollPanel", pnl)
        readScroll:SetSize( pnl:GetWide() * 0.965, pnl:GetTall() * 0.66 )
        readScroll:SetPos( pnl:GetWide() * 0.0125, pnl:GetTall() * 0.3125 )
    
        local text = vgui.Create("DLabel", readScroll)
        text:SetSize( readScroll:GetWide(), readScroll:GetTall() )

        text:Dock( TOP )
        text:SetText( d.Desc )
        text:SetFont("F14")
        -- text:SetColor( Color( 230, 230, 230 ) )
        text:SizeToContents()

        if data[d.Title] then continue end
        data[d.Title] = true
    end
    
    file.Write( "cwreborn_updates.txt", util.TableToJSON(data) )
end

function CheckForUpdates()
    local updates = util.JSONToTable( (file.Read( "cwreborn_updates.txt", "DATA") or "[]") )
    if updates.CompletedTutorial then
        -- Show Tutorial
        if table.Count(updates) ~= #upd then
            OpenUpdateFrame( updates )
        end
    end
end

CheckForUpdates()