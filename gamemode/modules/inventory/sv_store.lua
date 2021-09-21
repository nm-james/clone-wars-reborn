-- TEL
Falcon = Falcon or {}
Falcon.Store = Falcon.Store or {}
Falcon.Store.Minly = Falcon.Store.Minly or {}
Falcon.Store.Daily = Falcon.Store.Daily or {}
Falcon.Store.Weekly = Falcon.Store.Weekly or {}

local d = sql.Query("SELECT minly, daily, weekly FROM Temporary")[1]
Falcon.Store.Minly = util.JSONToTable( d.minly )
Falcon.Store.Daily = util.JSONToTable( d.daily )
Falcon.Store.Weekly = util.JSONToTable( d.weekly )

local function CalculateRarity( chances )
    local total = 0

    for _, chance in pairs( chances ) do
        total = total + chance
    end 

    local item = math.random(1, total)

    if item <= chances[5] then
        return 5
    elseif item <= (chances[4] + chances[5]) then
        return 4
    elseif item <= (chances[3] + chances[4] + chances[5]) then
        return 3
    elseif item <= (chances[2] + chances[3] + chances[4] + chances[5]) then
        return 2
    else
        return 1
    end

    return 1
end

util.AddNetworkString("Falcon:SendStoreUpdates")
function SyncStoreContent()
    net.Start("Falcon:SendStoreUpdates")
        net.WriteTable( Falcon.Store )
    net.Broadcast()
end 

function UpdateClientStoreInfo( type, starting, common, uncommon, rare, legendary, exotic )
    local items = {}
    local itemCheck = {}
    local max = math.random(starting or 6, 14)
    local rItems = {
        [1] = Falcon.GetItemsByRarity( 1 ),
        [2] = Falcon.GetItemsByRarity( 2 ),
        [3] = Falcon.GetItemsByRarity( 3 ),
        [4] = Falcon.GetItemsByRarity( 4 ),
        [5] = Falcon.GetItemsByRarity( 5 ),
    }

    print("items", #rItems[1])
    

    for i = 1, max do
        local rarity = CalculateRarity( {
            [1] = common or 2250,
            [2] = uncommon or 300,
            [3] = rare or 75,
            [4] = legendary or 20,
            [5] = exotic or 1
        } )

        local rarityItems = rItems[ rarity ]

        local id = math.random(1, #rarityItems)
        if itemCheck[rarityItems[id]] then continue end
        
        table.insert(items, rarityItems[id])

        itemCheck[rarityItems[id]] = true
    end
    Falcon.Store[type].Items = items

    sql.Query("UPDATE Temporary SET " .. string.lower( type ) .. " = '" .. util.TableToJSON( Falcon.Store[type] ) .. "' WHERE id  = 1")

    SyncStoreContent()
    return items
end
UpdateClientStoreInfo( "Weekly", 7, 750, 1300, 750, 300, 65 )

local function CheckResetTime()
	local minly = tonumber( Falcon.Store.Minly.Delay )
	local daily = tonumber( Falcon.Store.Daily.Delay )
	local weekly = tonumber( Falcon.Store.Weekly.Delay )
	local time = os.time()


 
	if time > minly then
        Falcon.Store.Minly.Delay = time + 1800
        UpdateClientStoreInfo( "Minly" )
        AnnounceServerMessage( "[ITEM STORE]", "'Quick Luck' Items have reset!")
	end
    
    if time > daily then
        Falcon.Store.Daily.Delay = time + 86400
        UpdateClientStoreInfo( "Daily", 5, nil, 750, 125, 30, 3 )
        AnnounceServerMessage( "[ITEM STORE]", "Daily Items have reset!")
	end

    if time > weekly then
        Falcon.Store.Weekly.Delay = time + 604800
        UpdateClientStoreInfo( "Weekly", 7, 750, 1300, 750, 300, 65 )
        AnnounceServerMessage( "[ITEM STORE]", "Weekly Items have reset!")
	end
end


hook.Add("Think", "CheckTimingForResetInStoreThisIsLongLol", CheckResetTime)