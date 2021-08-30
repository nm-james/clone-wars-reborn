

local function DataCheck()
    sql.Query([[CREATE TABLE IF NOT EXISTS Users
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            steamid TEXT
        ) 
    ]])

    sql.Query([[CREATE TABLE IF NOT EXISTS Characters
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            rank NUMBER,
            class NUMBER,
            regiment NUMBER,
            level NUMBER,
            exp NUMBER,
            inventory TEXT,
            attachments TEXT,
            user NUMBER
        ) 
    ]])

    sql.Query([[CREATE TABLE IF NOT EXISTS Temporary
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            minly TEXT,
            daily TEXT,
            weekly TEXT
        ) 
    ]])

    
    local storeItems = sql.Query("SELECT * FROM Temporary") or {}

    if table.IsEmpty( storeItems ) then
        sql.Query( "INSERT INTO Temporary(minly, daily, weekly) VALUES('" .. util.TableToJSON( { Items = {}, Delay = 0 } ) .. "', '" .. util.TableToJSON( { Items = {}, Delay = 0 } ) .. "', '" .. util.TableToJSON( { Items = {}, Delay = 0 } ) .. "')" )
    end
end

DataCheck()

hook.Add("Initialize", "DataCheck", DataCheck)