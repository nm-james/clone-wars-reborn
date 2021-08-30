
Falcon = Falcon or {}
Falcon.Inventory = Falcon.Inventory or {}

Falcon.InventoryData = {}
local inv = Falcon.InventoryData

inv.Defaults = {}
inv.Currents = {}
inv.Nexts = {}

local items = {
    {
        Name = "Primary",
        Category = 1,
        GetItem = function( ply )
            local ent = ply:GetActiveWeapon()

            if not ent or not ent:IsValid() then return false end

            local ang = ent:GetAngles() - Angle( 0, -90, 0 )
            local calAng = Angle( 0, ang.y, 0 )
            local pos = ent:GetPos() + (calAng:Forward() * -40) + (calAng:Right() * 20)
            return ent, pos, ang
        end
    },
    {
        Name = "Secondary",
        Category = 2,
        GetItem = function( ply )
            return ply, ply:GetPos(), ply:GetAngles()
        end
    },
    {
        Name = "Grenade",
        Category = 3,
        GetItem = function( ply )
            return ply, ply:GetPos(), ply:GetAngles()
        end
    },
    {
        Name = "Ability",
        Category = 4,
        GetItem = function( ply )
            return ply, ply:GetPos(), ply:GetAngles()
        end
    },
    {
        Name = "Other",
        Category = 5,
        GetItem = function( ply )
            return ply, ply:GetPos(), ply:GetAngles()
        end
    },
    {
        Name = "Inventory Space",
        Category = 6,
        GetItem = function( ply )
            return ply, ply:GetPos(), ply:GetAngles()
        end
    },
    {
        Name = "Inventory Space",
        Category = 6,
        GetItem = function( ply )
            return ply, ply:GetPos(), ply:GetAngles()
        end
    },
}

local selectedPnl = Falcon.ActiveInventoryItem

local equipped = Falcon.Inventory.Equipped or {}
local backpack = Falcon.Inventory.Backpack or {}
local invSpots = {}
local invSelected = {}

local function ServerChangeItem( type, id, tab )
    net.Start("Falcon:Inventory:ChangeItem")
        net.WriteString( type )
        net.WriteUInt( id, 32 )
        net.WriteTable( tab )
    net.SendToServer()
end 

local function CreateInventoryItem( invItem, spot )
    local ply = LocalPlayer()
    local parent = inv.UnitLogger
    local d = backpack[spot]
    local startPos = invSpots[ d.y ][ d.x ]
    local x, y = startPos:GetPos()

    local item = Falcon.Items[ invItem ]
    local endPnl = invSpots[ startPos.yPos + item.Y ][ startPos.xPos + item.X ]
    if not endPnl then return end

    local fx, fy = endPnl:GetPos()
    local fx, fy = (fx - x) + endPnl:GetWide(), (fy - y) + endPnl:GetTall()

    local pt = vgui.Create("DPanel", parent)
    pt:SetSize( fx, fy )
    pt:SetPos( x, y )
    pt.Index = spot
    pt.Item = invItem
    pt.Category = item.Category

    local i = Falcon.Items[invItem]
    local color = Falcon.RarityColors[i.Rarity]

    pt.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 225 )
        surface.DrawRect( 2, 2, w - 4, h - 4 )

        surface.SetDrawColor( color )
        -- TOP LEFT CORNER
        surface.DrawLine( 0, 0, 0, h * 0.3 )
        surface.DrawLine( 0, 0, w * 0.2, 0 )

        -- TOP RIGHT
        surface.DrawLine( w - 1, 0, w - 1, h * 0.3 )
        surface.DrawLine( w, 0, w - (w * 0.2), 0 )

        -- BOTTOM LEFT CORNER
        surface.DrawLine( 0, h - 1, 0, h - (h * 0.3) )
        surface.DrawLine( 0, h - 1, w * 0.2, h - 1 )

        -- BOTTOM RIGHT
        surface.DrawLine( w - 1, h, w - 1, h - (h * 0.3) )
        surface.DrawLine( w, h - 1, w - (w * 0.2), h - 1 )
    end




    local model = vgui.Create("DModelPanel", pt)
    model:SetSize( pt:GetWide(), pt:GetTall())
    model:SetModel( item.Model.String )
    model:SetCamPos( item.Model.Offsets.Pos )
    model:SetLookAng( item.Model.Offsets.Ang )
    model:SetFOV( item.Model.Offsets.FOV ) 

    local p = vgui.Create("DButton", pt)
    p:SetSize( pt:GetWide(), pt:GetTall() )
    p:SetText("")
    p.Paint = nil

    p.DoClick = function( self )
        selectedPnl = pt
        pt:SetSize(0,0)
        pt:SetPos(0,0)
    end
    
    d.Panel = pt

    return pt, startPos, endPos, item
end

local function CreateEquipedItem( parent, it )

    local item = Falcon.Items[it]

    local model = vgui.Create("DModelPanel", parent)
    model:SetSize( parent:GetWide(), parent:GetTall() )
    model:SetModel( item.Model.String )
    model:SetCamPos( item.Model.Offsets.Pos )
    model:SetLookAng( item.Model.Offsets.Ang )
    model:SetFOV( item.Model.Offsets.FOV ) 
    model:MoveToBack()
    
    parent.Model = model

end

local function HighlightPosition( position )
    local t = items[ position ]
    local ply = LocalPlayer()

    if not equipped[position].id then return end

    net.Start("Falcon:Inventory:ShowItem")
        net.WriteUInt( equipped[position].id, 32 )
    net.SendToServer()

    timer.Simple(0.1, function()
        local ent, pos, ang = t.GetItem( ply )

        if not ent then return end
    
        inv.Nexts.pos = pos
        inv.Nexts.ang = ang
        inv.Frame.LerpingVector = 0

        hook.Add( "PreDrawHalos", "AddItemInvHalo", function()
            halo.Add( { ent }, Color( 255, 255, 50 ), 5, 5, 2 )
        end )
    end)

end

local function UpdatePanels()
    for spot, d in pairs( backpack ) do
        local p = d.Panel

        if not p or not p:IsValid() then return end

        p.Index = spot
    end
end

local function ResetSlots()
    for _, pnl in pairs( invSelected ) do
        if not pnl or not pnl:IsValid() then continue end
        pnl.IsPotentialPlacement = false
    end
    invSelected = {}

    if selectedPnl and selectedPnl:IsValid() then
        selectedPnl.CanPlace = false
    end
end

local function SlotIsValid( y, x, id, shouldFroce )
    local p = invSpots[y]
    if not p then
        return false
    end

    local p = p[x]
    if not p then
        return false
    end

    if not shouldFroce and (id and p.Inventory and p.Inventory ~= id) then
        return false
    end

    if shouldFroce and (p.Inventory and p.Inventory ~= selectedPnl.Index) then
        return false
    end

    return p
end

local function AssignInventoryItem( curX, curY, id, value )
    local item = backpack[id].item
    local d = Falcon.Items[item]
    local value = value or id
    local plusX, plusY = d.X, d.Y

    for yL = curY, curY + plusY do
        for xL = curX, curX + plusX do
            local p = SlotIsValid( yL, xL, id )
            if not p then continue end

            if value == -1 then
                p.Inventory = false
            else
                p.Inventory = value
            end
        end
    end

    return true
end

local function MoveInventoryItem( newX, newY, id )

    if not id then return end

    local t = backpack[id]
    local item = t.item

    if not t.isEquipped then
        AssignInventoryItem( t.x, t.y, id, -1 )
    end

    t.x = newX
    t.y = newY

    AssignInventoryItem( newX, newY, id )

    CreateInventoryItem( item, id )

    selectedPnl = nil

    -- ServerChangeItem( "Backpack", spot, { item = item, x = newX, y = newY } )
end

local function EquipInventoryItem( spotEquipped, id )
    local e = equipped[spotEquipped]
    local b = backpack[id]

    local pnl = items[spotEquipped].Panel
    
    if pnl.Model then
        pnl.Model:Remove()
    end
    
    CreateEquipedItem( pnl, b.item )
    pnl.Item = b.item
    e.id = id

    b.isEquipped = true

    -- ServerChangeItem( "Equipped", spotEquipped, { item = item } )
end

local function SortEquipRequest( spotBackpack, spotEquipped, nextX, nextY )
    local e = equipped[spotEquipped]

    local b = backpack[spotBackpack]

    if e.id then
        if b and b.id ~= e.id then
            MoveInventoryItem( b.x, b.y, e.id )
            EquipInventoryItem( spotEquipped, spotBackpack )
        else
            MoveInventoryItem( nextX, nextY, e.id )

            local pnl = items[spotEquipped].Panel
    
            if pnl.Model then
                pnl.Model:Remove()
            end


            local b = backpack[e.id]

            b.isEquipped = false

            e.id = nil
        end
    else
        AssignInventoryItem( b.x, b.y, spotBackpack, -1 )
        EquipInventoryItem( spotEquipped, spotBackpack )
    end

    UpdatePanels()
    selectedPnl = nil
end

local function ShowAvailableSlots( curX, curY, id, shouldFroce )
    if not selectedPnl then return end
    local item = selectedPnl.Item
    local d = Falcon.Items[item]

    local plusX, plusY =  d.X, d.Y

    local canPlace = true
    for yL = curY, curY + plusY do
        for xL = curX, curX + plusX do
            local p = SlotIsValid( yL, xL, id, shouldFroce )
            if not p then canPlace = false continue end
            p.IsPotentialPlacement = true
            table.insert(invSelected, p)
        end
    end

    selectedPnl.CanPlace = canPlace
end

local function OpenFrame()
    local scrw, scrh = ScrW(), ScrH()
    local ply = LocalPlayer()
    selectedPnl = nil

    local frame = vgui.Create("DFrame")
    frame:SetSize( scrw, scrh )
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable( false )
    frame:ShowCloseButton( true )
    frame.LerpingVector = 1
    frame.LerpingFinished = true

    local plyAng = ply:GetAngles()
    local ang = Angle( 0, plyAng.y, 0)

    local forward = ang:Forward() * 100
    local pos = ply:EyePos() + Vector( forward.x, forward.y, 0 ) + (ang:Up() * -22) + (ang:Right() * -4)
    local angle = ang - Angle( 0, 180, 0 )

    inv.Defaults.pos = pos
    inv.Defaults.ang = angle

    inv.Currents.pos = pos
    inv.Currents.ang = angle

    inv.Nexts.pos = pos
    inv.Nexts.ang = angle

    frame.Paint = function( self, w, h )
        local x, y = self:GetPos()

        local pos = LerpVector(self.LerpingVector, inv.Currents.pos, inv.Nexts.pos)
        local ang = LerpAngle(self.LerpingVector, inv.Currents.ang, inv.Nexts.ang)

        if pos ~= inv.Nexts.pos then
            if self.LerpingFinished then
                self.LerpingFinished = false
                self.LerpingVector = 0
            end
            self.LerpingVector = math.Clamp(self.LerpingVector + (FrameTime() * 3), 0, 1)
        elseif not self.LerpingFinished then
            self.LerpingFinished = true
            inv.Currents.pos = inv.Nexts.pos
            inv.Currents.ang = inv.Nexts.ang
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
    end

    local backbagInv = vgui.Create("DPanel", frame)
    backbagInv:SetSize( frame:GetWide() * 0.34, frame:GetTall() * 0.1875 )
    backbagInv:SetPos( frame:GetWide() * 0.595, frame:GetTall() * 0.58 )
    backbagInv.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 197 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 35, 35, 35, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end


    local backbagActInv = vgui.Create("DScrollPanel", backbagInv)
    backbagActInv:SetSize( backbagInv:GetWide() * 0.9925, backbagInv:GetTall() * 0.9825 )
    backbagActInv:SetPos( backbagInv:GetWide() * 0.005, backbagInv:GetTall() * 0.01 )
    backbagActInv.Paint = nil

    inv.UnitLogger = backbagActInv

    for i = 1, 5 do
        local itemPnl = vgui.Create("DPanel", frame)
        itemPnl:SetSize( frame:GetWide() * 0.06, frame:GetWide() * 0.06 )
        itemPnl:SetPos( frame:GetWide() * (0.525 + (i * 0.07)), frame:GetTall() * 0.2125 )

        local d = items[i]
        local ent, pos, ang = d.GetItem( ply )

        itemPnl.Paint = function( self, w, h )
            surface.SetDrawColor( 45, 45, 45, 155 )
            surface.DrawRect( 0, 0, w, h )

            if not equipped[i].id then
                draw.NoTexture()
                surface.SetMaterial(Material("cwreborn/inventory/empty.png"))
                surface.SetDrawColor( 60, 60, 60, 102 )
                surface.DrawTexturedRect( w * 0.2, h * 0.1, w * 0.6, h * 0.8 )
            else
                draw.RoundedBox( 2.5, 0, 0, w, h, Color( 0, 0, 0, 180 ))
            end

            surface.SetDrawColor( itemPnl.NewColLol or Color( 35, 35, 35, 185 ) )
            surface.DrawRect( 0, 0, w * 0.04, h )
            surface.DrawRect( w * 0.97, 0, w * 0.04, h )
            surface.DrawRect( 0, 0, w, w * 0.04 )
            surface.DrawRect( 0, h - (w * 0.03), w, w * 0.04 )
        end

        itemPnl.Index = i
        itemPnl.IsEquiped = true

        if equipped[i].id then
            itemPnl.Item = backpack[equipped[i].id].item
            itemPnl.Category = items[i].Category
            
            CreateEquipedItem( itemPnl, itemPnl.Item )
        end

        local itemBtn = vgui.Create("DButton", itemPnl)
        itemBtn:SetSize( frame:GetWide() * 0.06, frame:GetWide() * 0.06 )
        itemBtn:SetText("")

        itemBtn.Paint = function( self, w, h )
            surface.SetDrawColor( self.CanPlaceCol or Color( 0, 0, 0, 0 ) )
            surface.DrawRect( 0, 0, w, h )
        end

        itemBtn.DoClick = function( self )
            if not selectedPnl then
                if not equipped[i].id then return end
                selectedPnl = itemPnl
            else
                if selectedPnl == itemPnl then
                    selectedPnl = nil
                else
                    if not selectedPnl.CanPlace then return end
                    SortEquipRequest( selectedPnl.Index, i, nil, nil )
                end
            end
        end

        itemBtn.Think = function( self )
            if self.CanPlaceCol then
                if self:IsHovered() then
                    self.CanPlaceCol.a = math.Clamp(self.CanPlaceCol.a + ((5 * FrameTime()) * 255), 0, 105)
                else
                    if selectedPnl == itemPnl then return end
                    self.CanPlaceCol.a = math.Clamp(self.CanPlaceCol.a - ((5 * FrameTime()) * 255), 0, 105)
                end
            end
        end

        itemBtn.OnCursorEntered = function( self )
            HighlightPosition( i )

            if not selectedPnl or not selectedPnl:IsValid() then 
                self.CanPlaceCol = Color( 235, 235, 235, 0 )
                return 
            end
            if selectedPnl == itemPnl then return end
            local index = selectedPnl.Index

            local b = backpack[index]

            local backPackItem = Falcon.Items[b.item]

            if backPackItem.Category ~= items[i].Category then
                selectedPnl.CanPlace = false
            else
                if equipped[i].id then
                    ShowAvailableSlots( b.x, b.y, itemPnl.Index, true )
                else
                    selectedPnl.CanPlace = true
                end
            end


            if selectedPnl.CanPlace then
                self.CanPlaceCol = Color( 45, 155, 45, 0 )
            else
                self.CanPlaceCol = Color( 155, 45, 45, 0 )
            end
        end

        itemBtn.OnCursorExited = function( self )
            inv.Nexts.pos = inv.Defaults.pos
            inv.Nexts.ang = inv.Defaults.ang
            inv.Frame.LerpingVector = 0
            
            hook.Remove( "PreDrawHalos", "AddItemInvHalo")

            if not selectedPnl or not selectedPnl:IsValid() then return end
            
            ResetSlots()
        end
        

        d.Panel = itemPnl
    end

    for i = 6, 7 do
        local itemPnl = vgui.Create("DPanel", frame)
        itemPnl:SetSize( frame:GetWide() * 0.05, frame:GetWide() * 0.05 )
        itemPnl:SetPos( frame:GetWide() * 0.6, frame:GetTall() * (0.36  + ((i - 6) * 0.1025)) )

        local d = items[i]
        local ent, pos, ang = d.GetItem( ply )

        itemPnl.Paint = function( self, w, h )
            surface.SetDrawColor( 45, 45, 45, 155 )
            surface.DrawRect( 0, 0, w, h )

            draw.NoTexture()
            surface.SetMaterial(Material("cwreborn/inventory/empty.png"))
            surface.SetDrawColor( 60, 60, 60, 102 )
            surface.DrawTexturedRect( w * 0.2, h * 0.1, w * 0.6, h * 0.8 )

            surface.SetDrawColor( 35, 35, 35, 185 )
            surface.DrawRect( 0, 0, w * 0.04, h )
            surface.DrawRect( w * 0.97, 0, w * 0.04, h )
            surface.DrawRect( 0, 0, w, w * 0.04 )
            surface.DrawRect( 0, h - (w * 0.03), w, w * 0.04 )
        end
    end


    local itemsInv = vgui.Create("DPanel", frame)
    itemsInv:SetSize( frame:GetWide() * 0.26875, frame:GetTall() * 0.2375 )
    itemsInv:SetPos( frame:GetWide() * 0.66, frame:GetTall() * 0.34 )
    itemsInv.Paint = function( self, w, h )
        surface.SetDrawColor( 45, 45, 45, 65 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 35, 35, 35, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end


    -- CRAFTABLES
    local x = 0
    local y = 0
    for i = 1, 18 do
        local itemPnl = vgui.Create("DPanel", itemsInv)
        itemPnl:SetSize( itemsInv:GetWide() * 0.15, itemsInv:GetWide() * 0.15 )
        itemPnl:SetPos( itemsInv:GetWide() * (0.01625 + (x * 0.16325)), itemsInv:GetTall() * (0.03 + (y * 0.32)) )

        x = x + 1
        if x == 6 or x == 12 then
            x = 0
            y = y + 1
        end
    end


    -- MASSIVE BACKPACK WITH THE UNITS THING

    invSpots[ 0 ] = {}

    local x = 1
    local y = 0
    local nextInt = 15

    for i = 1, 150 do
        local itemPnl = vgui.Create("DButton", backbagActInv)
        itemPnl:SetSize( backbagActInv:GetWide() * 0.0645, backbagActInv:GetWide() * 0.0645 )
        itemPnl:SetPos( backbagActInv:GetWide() * (0.005 + ((x - 1) * 0.0645)), 0 + (backbagActInv:GetWide() * (0.005 + (y * 0.0645))) )
        itemPnl:SetText("")
        itemPnl.xPos = x
        itemPnl.yPos = y
        itemPnl.Paint = function( self, w, h )
            if self.IsPotentialPlacement and selectedPnl then
                if selectedPnl.CanPlace then
                    surface.SetDrawColor( 45, 165, 45, 110 )
                else
                    surface.SetDrawColor( 165, 45, 45, 110 )
                end
                surface.DrawRect( w * 0.025, h * 0.025, w * 0.95, h * 0.95 )
            else
                surface.SetDrawColor( 95, 95, 95, 110 )
                surface.DrawRect( w * 0.025, h * 0.025, w * 0.95, h * 0.95 )
            end 
        end
        itemPnl.OnCursorEntered = function( self )
            if not selectedPnl or not selectedPnl:IsValid() then return end
            ShowAvailableSlots( itemPnl.xPos, itemPnl.yPos, nil, true )
        end

        itemPnl.OnCursorExited = function( self )
            ResetSlots()
        end

        itemPnl.DoClick = function( self )
            if not selectedPnl or not selectedPnl:IsValid() then return end
            if not selectedPnl.CanPlace then return end
            if selectedPnl.IsEquiped then
                SortEquipRequest( nil, selectedPnl.Index, itemPnl.xPos, itemPnl.yPos )
            else
                MoveInventoryItem( itemPnl.xPos, itemPnl.yPos, selectedPnl.Index )
            end
        end

        x = x + 1

        table.insert( invSpots[ y ], itemPnl )

        if i == nextInt then
            nextInt = nextInt + 15
            x = 1
            y = y + 1
            invSpots[ y ] = {}
        end
    end

    for spot, d in pairs( backpack ) do
        local isSpot = false
        for i = 1, 7 do
            local id = equipped[i].id

            if not id then continue end
            if spot == id then
                isSpot = true
            end
        end
        if isSpot then continue end
        local p, startPos, endPos, item = CreateInventoryItem( d.item, spot )
        AssignInventoryItem( d.x, d.y, spot )
        d.Panel = p
    end


    return frame
end

function OpenInvUI()
    if inv.Frame and inv.Frame:IsValid() then return end
    inv.SelectedSpotsBackpack = {}

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
                self.NextFrame = OpenFrame()
                hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
            end
        else
            self:SetAlpha( math.Clamp(self:GetAlpha() - ((3 * FrameTime()) * 255), 0, 255) )

            if self:GetAlpha() <= 0 then
                self:Remove()
                self.NextFrame:MakePopup()
                inv.Frame = self.NextFrame
            end
        end
    end

    inv.Frame = fade
end