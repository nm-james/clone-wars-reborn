
Falcon = Falcon or {}

Falcon.RarityColors = {
    Color( 155, 155, 155 ),
    Color( 30, 155, 30 ),
    Color( 75, 75, 155 ),
    Color( 155, 45, 155 ),
    Color( 195, 45, 45 ),
}

Falcon.RarityTitles = {
    "Common",
    "Uncommon",
    "Rare",
    "Legendary",
    "Exotic"
}

Falcon.Items = {}
Falcon.CreateItem = function( name, data )
    if not name or not data or table.IsEmpty(data) then return ErrorNoHalt( "NAME OR DATA IS NOT FOUND - FALCON.ITEMS" ) end

    local tbl = data or {}
    tbl.Name = name

    if type( data.Rarity ) == "number" then
        local c = table.Count(Falcon.Items) + 1
        local cost = data.Cost or 17500
        local cost = cost * data.Rarity
        tbl.Cost = cost


        Falcon.Items[c] = tbl
    elseif type( data.Rarity ) == "table" then
        for i = data.Rarity.Min, data.Rarity.Max do
            local c = table.Count(Falcon.Items) + 1 
            Falcon.Items[c] = table.Copy(tbl)

            Falcon.Items[c].Name = name .. " [" .. Falcon.RarityTitles[ i ] .. "]"

            local cost = data.Cost or 17500
            local cost = cost * i
            Falcon.Items[c].Cost = cost

            Falcon.Items[c].Rarity = i

        end
    end

    return true
end

Falcon.CreateItemDerma = function( parent, hoverParent, item )
    local i = Falcon.Items[ item ]

    local scrw, scrh = ScrW(), ScrH()

    local pnl = vgui.Create("DPanel", parent)
    pnl:SetSize( scrw * 0.16, scrh * 0.125 )
    pnl.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Falcon.RarityColors[  i.Rarity ] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( i.Name, "F13", w * 0.5, h * 0.05, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Rarity | ", "F13", w * 0.1, h * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
        draw.DrawText( Falcon.RarityTitles[ i.Rarity ], "F13", w * 0.3, h * 0.25, Falcon.RarityColors[  i.Rarity ], TEXT_ALIGN_LEFT )
        draw.DrawText( "Cost | ", "F13", w * 0.1, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
        draw.DrawText( i.Cost, "F13", w * 0.26, h * 0.45, Color( 230, 230, 30 ), TEXT_ALIGN_LEFT )
    end
    pnl.Think = function( self )
        if hoverParent:IsHovered() then
            local x, y = gui.MousePos()
            self:SetPos( x + 3, y + 3 )
        else
            self:Remove()
        end
    end
end

local item = Falcon.CreateItem
item("DC-15S", {
    Class = "falcon_dc15a",
    Rarity = {
        Min = 1,
        Max = 5,
    },
    X = 4,
    Y = 1,
    Category = 2,
    Model = {
        String = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        Offsets = {
            Pos = Vector(0, -20, 0),
            Ang = Angle(5, 90, 0),
            FOV = 75,
        },
    },
    Attachments = {
        [1] = { 0.525, 0.46, 0.425, 0.6, true, Vector( 4029.287598, -6731.530273, 101.326828 ), Angle( -4.017696, 94.164642, 0.000000 ) },
        [2] = { 0.65, 0.39, 0.65, 0.16, nil, Vector( 4033.469238, -6727.700195, 107.038795 ), Angle( 12.608532, 59.833843, 0 ) },
        [3] = { 0.285, 0.45, 0.175, 0.275, nil, Vector( 4002.083984, -6725.779785, 104.056274 ), Angle(7.514410, 38.971077, 0.000000) },
        [4] = { 0.65, 0.45, 0.675, 0.64, true, Vector(4042.387939, -6709.256836, 105.499580), Angle(15.246964, -65.752052, 0.000000) },
        -- [5] = { 0.3, 0.9 },
        [8] = { 0, 0, 0.8, 0.85, true, Vector(4006.767090, -6733.615234, 103.126335), Angle(3.808514, 54.892185, 0.000000) },
    }
})

item("DC-15A", {
    Class = "falcon_dc15a",
    Bodygroups = {
        { Name = "Helmet", Value = 2, Default = 0 }
    },
    Rarity = {
        Min = 1,
        Max = 5,
    },
    X = 7,
    Y = 1,
    Category = 1,
    Model = {
        String = "models/weapons/w_dc15a.mdl",
        Offsets = {
            Pos = Vector(0, -20, 0),
            Ang = Angle(5, 90, 0),
            FOV = 125,
        },
    },
})

Falcon.GetItemsByRarity = function( rarity )
    local t = {}
    for _, items in pairs( Falcon.Items ) do
        if items.Rarity == rarity then
            table.insert(t, _)
        end
    end 

    return t
end
