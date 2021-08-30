
util.AddNetworkString("Falcon:Inventory:ShowItem")
util.AddNetworkString("Falcon:Inventory:ChangeItem")

local playerInventory = {
    Equipped = {
        [1] = {
            item = 2,
        },
        [2] = {
            item = 1
        },
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
        [7] = {},
    },
	Skin = 25,
    Backpack = {
        {
            x = 1,
            y = 4,
            item = 3,
        }
    },
}


net.Receive("Falcon:Inventory:ChangeItem", function( len, ply )
    local whereDaItemGoe = net.ReadString()
    local index = net.ReadUInt( 32 )
    local d = net.ReadTable()
    local t = playerInventory[whereDaItemGoe]
        
    if whereDaItemGoe == "Equipped" then
        if table.IsEmpty(d) then
            local item = Falcon.Items[ t[index].item ]

            if item.Class then
                ply:StripWeapon( item.Class )
                if item.Category == 1 then
                    ply:SetNWString("Falcon:FirstWeapon", "")
                elseif item.Category == 2 then
                    ply:SetNWString("Falcon:SecondWeapon", "")
                end
            end

            if item.Bodygroups then
                for _, bodygr in pairs( item.Bodygroups ) do
                    local bg = ply:FindBodygroupByName( bodygr.Name )

                    if not bg then continue end
                    ply:SetBodygroup(bg, bodygr.Default)
                end
            end
        end

        t[index] = d
    elseif whereDaItemGoe == "Backpack" then
        if table.IsEmpty( d ) then
            local item = Falcon.Items[ t[index].item ]

            if item.Class then
                ply:Give( item.Class )
                if item.Category == 1 then
                    ply:SetNWString("Falcon:FirstWeapon", item.Class)
                elseif item.Category == 2 then
                    ply:SetNWString("Falcon:SecondWeapon", item.Class)
                end
            end

            if item.Bodygroups then
                for _, bodygr in pairs( item.Bodygroups ) do
                    local bg = ply:FindBodygroupByName( bodygr.Name )

                    if not bg then continue end
                    ply:SetBodygroup(bg, bodygr.Value)
                end
            end
            table.remove( t, index )
        else
            t[index] = d
        end
    end
end)

net.Receive("Falcon:Inventory:ShowItem", function( len, ply )
    local item = net.ReadUInt( 32 )

    local class = Falcon.Items[item].Class

    if not class then return end

    ply:SelectWeapon( class )
end)