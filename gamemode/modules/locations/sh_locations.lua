
Falcon = Falcon or {}
Falcon.Locations = {
    [1] = {},
    [2] = {},
}

Falcon.Planets = {
    ["rp_coruscantbelow"] = {
        name = "Coruscant",
        id = 1,
        outside = {
            name = "The Streets",
            quotes = {
                "Into the wild... As they say...",
                "Back into the unknown.",
                "May the force be with you... Or your pokies?",
                "Get on the way, hosay! Ha!",
                "Into the great beyond! *the great beyond*",
                "To infinity, and beyond!",
                "The place was trashed anyways.",
                "There's not a better place than the filthy streets of Coruscant.",
                "Those deathsticks better not be in your line of sight...",
                "You should wonder who you're gonna arrest next...",
                "Next time, you should've just stayed...",
            },
        },
    },
    ["rp_geonosis"] = {
        name = "Geonosis",
        id = 2,
        outside = {
            name = "The Battlefield",
            quotes = {
                "Into the wild... As they say...",
            },
        },
    },
}
Falcon.CreateLocation = function( location, data )
    
    local tbl = data or {}
    tbl.Name = location
    tbl.Alpha = 0
    tbl.Faction = data.Faction or 0
    tbl.Map = data.Map or 1
    

    local c = table.Count(Falcon.Locations[tbl.Map]) + 1
    Falcon.Locations[tbl.Map][c] = tbl
end


local location = Falcon.CreateLocation

-- Coruscant
location("Hangars", {
    Position = Vector( -7791, 2831, 24 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 1000,
    Icon = "cwreborn/hud/hangar_icon.png",
})

location("Transport Station", {
    Position = Vector( -3152, -2985, 544 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 750,
    Icon = "cwreborn/hud/station_icon.png",
})

location("Waste Facility", {
    Position = Vector( 2500, 2647, 214 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 3000,
    Icon = "cwreborn/hud/industry_icon.png",
})

location("Warehouse", {
    Position = Vector( 2653, 6928, 32 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 1000,
    Icon = "cwreborn/hud/warehouse_icon.png",
})

location("Casino", {
    Position = Vector( 9223, 512, 80 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 1500,
    Icon = "cwreborn/hud/casino_icon.png",
})

location("Pub Restaurant", {
    Position = Vector( 4443, -5337, 32 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 500,
    Icon = "cwreborn/hud/pub_icon.png",
})

location("Unknown", {
    Position = Vector( 3325, -2146, 50 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 1,
    Enter = 1000,
    Icon = "cwreborn/hud/gang_icon.png",
})

location("Bar", {
    Position = Vector( 12477, 4570, 360 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 1,
    Enter = 1600,
    Icon = "cwreborn/hud/bar_icon.png",
})

location("Plaza", {
    Position = Vector( 7717, 4649, 272 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 1000,
    Icon = "cwreborn/hud/plaza_icon.png",
})


location("Manufacture Platform", {
    Position = Vector( 3531, 11650, 32 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 600,
    Icon = "cwreborn/hud/manufacture_icon.png",
})

location("Food Court", {
    Position = Vector( 5281, 7002, 512 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 550,
    Icon = "cwreborn/hud/foodcourt_icon.png",
})

location("Credit Bank", {
    Position = Vector( 10834, -3648, 64 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 1000,
    Icon = "cwreborn/hud/bank_icon.png",
})

location("Hospital", {
    Position = Vector( 6440, -1999, 20 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 0,
    Enter = 600,
    Icon = "cwreborn/hud/hospital_icon.png",
})


-- REPUBLIC HELD
location("Republic HQ", {
    Position = Vector( 4686, -7076, 50 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 2,
    Enter = 1000,
    Icon = "cwreborn/hud/rep_hq_icon.png",
})



-- HOSTILE HELD
location("Deathsticks Trades", {
    Position = Vector( 8441, -6562, 16 ),
    Description = "A PLACE WHERE ALL PEOPLE DIE",
    Faction = 3,
    Icon = "cwreborn/hud/deathsticks_icon.png",
    Enter = 400,
})


-- GEONOSIS
location("Courtyard", {
    Position = Vector( 893.314087, -1024.479614, -9761.254883 ),
    Description = "THE MASSIVELY OPEN AREA",
    Faction = 1,
    Icon = "cwreborn/hud/plaza_icon.png",
    Enter = 1750,
    Map = 2,
})

-- FRIENDLY HELD
location("Republic HQ", {
    Position = Vector( 7683.729492, 12557.453125, -9537.968750 ),
    Description = "THE FIELD HQ OF THE REPUBLIC",
    Faction = 2,
    Icon = "cwreborn/hud/rep_hq_icon.png",
    Enter = 4500,
    Map = 2,
})

location("Grounded Turbo Tank", {
    Position = Vector( -8186.538574, 12211.895508, -9434.945313 ),
    Description = "THE UNFORTUNATE EVENTS OF THE NOW DECEASED 244TH BATTALION",
    Faction = 2,
    Icon = "cwreborn/hud/hospital_icon.png",
    Enter = 1200,
    Map = 2,
})

-- HOSTILE HELD
location("Arena", {
    Position = Vector(-7081.724121, 2717.890137, -9713.198242),
    Description = "A PLACE WHERE CLONES COME TO DIE",
    Faction = 3,
    Icon = "cwreborn/hud/rep_hq_icon.png",
    Enter = 3000,
    Map = 2,
})

location("Factory", {
    Position = Vector(14134.725586, -2533.547852, -8513.240234),
    Description = "THE BIRTH PLACE OF ALL CIS DROIDS",
    Faction = 3,
    Icon = "cwreborn/hud/manufacture_icon.png",
    Enter = 2000,
    Map = 2,
})

location("Geonosian Hive", {
    Position = Vector( -6468.749512, -5321.486816, -5406.115723 ),
    Description = "THE SCARIEST PLACE OF THE DESERT ROCK",
    Faction = 3,
    Icon = "cwreborn/hud/gang_icon.png",
    Enter = 4500,
    Map = 2,
})

location("CIS Hangar", {
    Position = Vector( -6830.470703, -11183.158203, -8143.486328 ),
    Description = "THE SUPPLY OF ENEMY FIGHTERS",
    Faction = 3,
    Icon = "cwreborn/hud/hangar_icon.png",
    Enter = 1600,
    Map = 2,
})

location("CIS HQ", {
    Position = Vector( -9993.793945, -706.694153, -7911.968750 ),
    Description = "A PLACE OF STRATEGIC PLANNING OF THE CIS",
    Faction = 3,
    Icon = "cwreborn/hud/rep_hq_icon.png",
    Enter = 750,
    Map = 2,
})

location("Cave", {
    Position = Vector( 12922.357422, 1958.932861, -8132.987305 ),
    Description = "THE SCARY PART OF GEONOSIANS",
    Faction = 3,
    Icon = "cwreborn/hud/hangar_icon.png",
    Enter = 1500,
    Map = 2,
})

location("CIS Landing Zone", {
    Position = Vector( 131.727097, -12391.048828, -9680.342773 ),
    Description = "THE MAIN SUPPLY ROUTE OF CIS FORCES",
    Faction = 3,
    Icon = "cwreborn/hud/hangar_icon.png",
    Enter = 3500,
    Map = 2,
})

location("CIS Manufacturing Bridge", {
    Position = Vector( 12971.116211, -12279.263672, -8216.562500 ),
    Description = "THE MANUFACTURE BRIDGE OF THE DROID FACTORY",
    Faction = 3,
    Icon = "cwreborn/hud/hangar_icon.png",
    Enter = 2500,
    Map = 2,
})

location("CIS Fluid Supply Pipes", {
    Position = Vector( 9049.310547, -6254.189453, -9412.546875 ),
    Description = "THE MANUFACTURE BRIDGE OF THE DROID FACTORY",
    Faction = 3,
    Icon = "cwreborn/hud/hangar_icon.png",
    Enter = 2000,
    Map = 2,
})

location("Ancient Temple", {
    Position = Vector( -2315.919678, 7730.416016, -9855.620117 ),
    Description = "THE ANCIENT TEMPLE OF DECADES OF HISTORY",
    Faction = 3,
    Icon = "cwreborn/hud/hangar_icon.png",
    Enter = 1500,
    Map = 2,
})
