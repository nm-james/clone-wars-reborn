
util.AddNetworkString("Falcon:RequestDataInfo")
util.AddNetworkString("Falcon:SendDataInfo")
util.AddNetworkString("Falcon:SENDPLAYERMESSAGE")

function AnnounceServerMessage( title, desc )
    net.Start("Falcon:SENDPLAYERMESSAGE")
        net.WriteString( title )
        net.WriteString( desc )
    net.Broadcast()
end

net.Receive("Falcon:RequestDataInfo", function( len, ply )
    local tbl = {}

    tbl.ClientNPCs = Falcon.ClientNPCs
    tbl.InteractableNPCs = Falcon.InteractableNPCs
    tbl.CurrentRegiment = Falcon.CurrentRegiment

    net.Start("Falcon:SendDataInfo")
        net.WriteTable( tbl )
    net.Send( ply )

    SyncStoreContent()
end)


local meta = FindMetaTable("Player")

function meta:CheckPlayerUserID()
    local hasId = sql.Query('SELECT id FROM Users WHERE steamid = ' .. tostring(self:SteamID64()))

    if not hasId then
        sql.Query("INSERT INTO Users(steamid) VALUES(" .. sql.SQLStr(self:SteamID64()) .. ")")
    end
end

function meta:GetInventorySkin()
    return self:GetNWInt("FALCON:MODELSKIN", 3)
end

function meta:GetModelSkin()
    local m = self:GetInventorySkin()

    local model = Falcon.Skins[m].Models[Falcon.CurrentRegiment]

    return model
end