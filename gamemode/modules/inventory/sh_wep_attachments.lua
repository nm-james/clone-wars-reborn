Falcon = Falcon or {}
Falcon.Attachments = {}

Falcon.CreateAttachment = function( att, data )
    if not att or not data or table.IsEmpty(data) then return ErrorNoHalt( "NAME OR DATA IS NOT FOUND - FALCON.ATTACHMENTS" ) end

    local tbl = data or {}
    tbl.Name = att

    local c = table.Count(Falcon.Attachments) + 1

    if data.Category ~= 8 then
        for wep, _ in pairs( data.Offsets ) do
            local w = weapons.Get( wep )
            
            if not w then continue end

            local weapon = w.RealName or wep

            local fuckingFaggot = {}

            fuckingFaggot.X = data.Item.Pos.x or 3
            fuckingFaggot.Y = data.Item.Pos.y or 0
            fuckingFaggot.Rarity = data.Rarity or 1
            fuckingFaggot.Category = 8
            fuckingFaggot.Model = {
                String = data.Model,
                Offsets = data.Item.Offsets or {
                    Pos = Vector(0, -20, 0),
                    Ang = Angle(5, 90, 0),
                    FOV = 75,
                },
            }

            Falcon.CreateItem( att .. " [" .. weapon .. "]", fuckingFaggot  )
        end
    end

    Falcon.Attachments[c] = tbl
end

local att = Falcon.CreateAttachment

-- MUZZLES
att("Suppressor", {
    Model = "models/sw_battlefront/weapons/2019/a280cfe_barrel_mod.mdl",
    Attachment = "training_mod",
    Category = 3,
    Rarity = 5,
    Item = {
        Offsets = {
            Pos = Vector(0, -20, 0),
            Ang = Angle(5, 90, 0),
            FOV = 75,
        },
        Pos = {
            x = 2,
            y = 0,
        },
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -16, -0.2, 4.1 ),
            Ang = Angle( 0, 180, 180 ),
            ID = 6,
        },
    }
})

att("Blurrg-1120 Muzzle", {
    Model = "models/sw_battlefront/weapons/2019/blurrg_barrel_mod.mdl",
    Attachment = "training_mod",
    Category = 3,
    Rarity = 2,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -26.5, 0, 4.425 ),
            Ang = Angle( 0, 180, 180 ),
            ID = 5,
        },
    }
})

att("CR-2 Muzzle", {
    Model = "models/sw_battlefront/weapons/cr2_pistol_barrel_default.mdl",
    Attachment = "training_mod",
    Category = 3,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -20.75, 0, 2.875 ),
            Ang = Angle( 0, 180, 180 ),
            ID = 4,
        },
    }
})

att("CR-2c Muzzle", {
    Model = "models/sw_battlefront/weapons/2019/cr2_barrel_mod.mdl",
    Attachment = "training_mod",
    Category = 3,
    Rarity = 4,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -20, 0, 2.875 ),
            Ang = Angle( 0, 180, 180 ),
            ID = 3,
        },
    }
})

att("DLT-19 Muzzle", {
    Model = "models/sw_battlefront/weapons/2019/dlt19_heavyrifle_muzzle1.mdl",
    Attachment = "training_mod",
    Category = 3,
    Rarity = 1,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 2, -2.35, 1.85 ),
            Ang = Angle( 0, 180, 90 ),
            ID = 2,
        },
    }
})

att("DC-15 Muzzle", {
    Model = "models/sw_battlefront/weapons/2019/dc15_mod_muzzle.mdl",
    Attachment = "training_mod",
    Category = 3,
    Rarity = 1,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 1, -2.35, 1.85 ),
            Ang = Angle( 0, -90, 90 ),
            ID = 1,
        },
    }
})

-- SCOPES
att("DLT-19x Scope", {
    Model = "models/sw_battlefront/weapons/dlt19x_scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 5,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 3.2, 0, -1.125 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 2,
        },
    }
})

att("A280-CFE Scope", {
    Model = "models/sw_battlefront/weapons/2019/a280cfe_default_scope2.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 2,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 3, 0, -0.8 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 9,
        },
    }
})

att("E-44 Scope", {
    Model = "models/sw_battlefront/weapons/2019/ee4_carbine_scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 2,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 0.4, 0, -3.5 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 8,
        },
    }
})


att("S-5 Scope", {
    Model = "models/sw_battlefront/weapons/s5_default_scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 4,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -1, 0, -1.6 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 7,
        },
    }
})

att("IQA-11 Scope", {
    Model = "models/sw_battlefront/weapons/iqa11_default_scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 5,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 0.4, 0, -0.11 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 6,
        },
    }
})

att("A-280 Scope", {
    Model = "models/sw_battlefront/weapons/scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -1.7, 0, -0.025 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 3,
        },
    }
})

att("Valken Scope", {
    Model = "models/sw_battlefront/weapons/valken_scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 1,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -2.1, 0, 1 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 4,
        },
    }
})

att("E-11 Scope", {
    Model = "models/sw_battlefront/weapons/e11_scope.mdl",
    Attachment = "training_mod",
    Category = 2,
    Rarity = 1,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -7.25, 0, -4.25 ),
            Ang = Angle( 0, -180, 0 ),
            ID = 5,
        },
    }
})

-- MAGAZINES
-- att("Magazine Extension", {
--     Model = "models/sw_battlefront/weapons/2019/dc15s_mag.mdl",
--     Attachment = "training_mod",
--     Category = 4,
--     Rarity = 2,
--     Offsets = {
--         ["falcon_dc15a"] = {
--             Pos = Vector( 2, 0, 0.1 ),
--             Ang = Angle( 0, -180, 0 ),
--             ID = 3,
--         },
--     }
-- })

att("Magazine XL", {
    Model = "models/sw_battlefront/weapons/a280_cell_mod.mdl",
    Attachment = "training_mod",
    Category = 4,
    Rarity = 2,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -10.5, 1.5, 2 ),
            Ang = Angle( 0, 0, 90 ),
            ID = 3,
        },
    }
})

att("Magazine XXL", {
    Model = "models/sw_battlefront/weapons/rt97c_mag_half.mdl",
    Attachment = "training_mod",
    Category = 4,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( 11.5, 0, -4.5 ),
            Ang = Angle( 0, 90, 0 ),
            ID = 2,
        },
    }
})

att("Drum Magazine", {
    Model = "models/sw_battlefront/weapons/rt97c_mag_half.mdl",
    Attachment = "training_mod",
    Category = 4,
    Rarity = 5,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Pos = Vector( -19, 0, -4.5 ),
            Ang = Angle( 0, -90, 0 ),
            ID = 1,
        },
    }
})

-- WEAPON SKINS
att("White Skin", {
    Category = 8,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/white",
        },
    }
})

att("Orange Skin", {
    Category = 8,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/orange",
        },
    }
})

att("Blue Skin", {
    Category = 8,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/blue",
        },
    }
})

att("Green Skin", {
    Category = 8,
    Rarity = 3,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/green",
        },
    }
})

att("Yellow Skin", {
    Category = 8,
    Rarity = 4,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/yellow",
        },
    }
})

att("Pink Skin", {
    Category = 8,
    Rarity = 4,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/redpink",
        },
    }
})

att("Red Skin", {
    Category = 8,
    Rarity = 4,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/red",
        },
    }
})

att("Aqua Skin", {
    Category = 8,
    Rarity = 5,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/aqua",
        },
    }
})

att("Purple Skin", {
    Category = 8,
    Rarity = 5,
    Item = {
        Pos = {},
    },
    Offsets = {
        ["falcon_dc15a"] = {
            Material = "1camo_test/dc15a/l115/purple",
        },
    }
})

