Falcon.Skins = {}

Falcon.Regiments = {
    [1] = {
        name = "501st Legion",
    },
    [2] = {
        name = "41st Elite Corps",
    },
    [3] = {
        name = "327th Star Core",
    },
    [4] = {
        name = "7th Sky Core",
    },
    [5] = {
        name = "65th Shock Battalion",
    },
    [6] = {
        name = "104th Wolfpack",
    },
    [7] = {
        name = "Republic Commandos",
    },
}

if SERVER then
    SetGlobalInt("FALCON:ACTIVEREGIMENT", math.random(1, #Falcon.Regiments)) 
end

Falcon.CurrentRegiment = GetGlobalInt("FALCON:ACTIVEREGIMENT")


Falcon.CreateSkin = function( name, data )
    if not name or not data or table.IsEmpty(data) then return ErrorNoHalt( "NAME OR DATA IS NOT FOUND - FALCON.SKINS" ) end

    local tbl = data or {}
    tbl.Models = data.Models or {}

    Falcon.CreateItem(name .." [SKIN]", {
        Rarity = data.Rarity or 2,
        X = 1,
        Y = 1,
        Category = 10,
        Cost = data.Price or 35000,
        Model = {
            String = tbl.Models[Falcon.CurrentRegiment],
            Offsets = {
                Pos = Vector(0, -20, 0),
                Ang = Angle(5, 90, 0),
                FOV = 125,
            },
        },
    })

    local count = table.Count( Falcon.Skins ) + 1

    Falcon.Skins[count] = tbl
    
    return count
end

local skin = Falcon.CreateSkin

skin("Rifleman", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/trooper.mdl",
        [2] = "Models/defcon/stan/elitecorps/trooper.mdl",
        [3] = "Models/defcon/loudmantis/327/trooper.mdl",
        [4] = "Models/mayfield/212/trooper.mdl",
        [5] = "Models/defcon/stallion/shock/trooper.mdl",
        [6] = "Models/memeious/104/trooper.mdl",
        [7] = "Models/player/republiccommandosmp/rc_white.mdl",
    },
    Rarity = 1,
})

skin("Ammo Bearer", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/heavy.mdl",
        [2] = "Models/defcon/stan/elitecorps/heavy.mdl",
        [3] = "Models/defcon/loudmantis/327/heavy.mdl",
        [4] = "Models/mayfield/212/heavy.mdl",
        [5] = "Models/defcon/loudmantis/shock/riot_officer.mdl",
        [6] = "Models/stallion/104/heavy.mdl",
        [7] = "Models/player/republiccommandosmp/rc_urbanfighter.mdl",
    },
    Rarity = 1,
})

skin("Medic", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/medic.mdl",
        [2] = "Models/defcon/stan/elitecorps/medic.mdl",
        [3] = "Models/defcon/loudmantis/327/medic.mdl",
        [4] = "Models/mayfield/212/medic.mdl",
        [5] = "Models/defcon/stallion/shock/medic.mdl",
        [6] = "Models/stallion/104/medic.mdl",
        [7] = "Models/player/republiccommandos/rc_cg.mdl",
    },
    Rarity = 1,
})

skin("Marksman", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/marksman.mdl",
        [2] = "Models/defcon/stan/elitecorps/officer.mdl",
        [3] = "Models/defcon/loudmantis/327/marksman.mdl",
        [4] = "Models/mayfield/212/marksman.mdl",
        [5] = "Models/defcon/stallion/shock/jek.mdl",
        [6] = "Models/moose/104/marksmen.mdl",
        [7] = "Models/player/republiccommandosmp/rc_ranger.mdl",
    },
    Rarity = 1,
})

skin("Heavy", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/carnivore_trooper.mdl",
        [2] = "Models/defcon/loudmantis/41/gett.mdl",
        [3] = "Models/defcon/loudmantis/327/castle.mdl",
        [4] = "Models/player/worthy/bf2_reg/212th_heavy/bf2212.mdl",
        [5] = "Models/defcon/mantis/clone_hunter/shock/hunter.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/15_wolfpack_sharpshooter.mdl",
        [7] = "Models/player/republiccommandos/rc_delta_sev.mdl",
    },
    Rarity = 1,
})


skin("Snow", {
    Models = {
        [1] = "Models/defcon/banks/coldwweather/501st_cold/501st_trooper/501st_trooper.mdl",
        [2] = "Models/defcon/banks/coldwweather/custom/xokeen_cold/xokeen_cold.mdl",
        [3] = "Models/defcon/banks/coldwweather/custom/repcom_cold/repcom_cold.mdl",
        [4] = "Models/defcon/banks/coldwweather/212th_cold/212th_trooper/212th_trooper.mdl",
        [5] = "Models/defcon/banks/coldwweather/cg_cold/cg_trooper/cg_trooper.mdl",
        [6] = "Models/defcon/banks/coldwweather/41st_cold/41st_gree/41st_gree.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 1,
})

skin("Engineer", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/engineer.mdl",
        [2] = "Models/defcon/stan/elitecorps/engineer.mdl",
        [3] = "Models/defcon/loudmantis/327/engineer.mdl",
        [4] = "Models/defcon/loudmantis/212/engineer.mdl",
        [5] = "Models/mayfield/arc/shock.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/9_wolfpack_commander.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 1,
})

skin("Airbourne", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/arf.mdl",
        [2] = "Models/defcon/stan/elitecorps/havokk.mdl",
        [3] = "Models/defcon/loudmantis/327/k_officer.mdl",
        [4] = "Models/loudmantis/212/ab_trooper.mdl",
        [5] = "Models/defcon/stallion/shock/stone.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/11_wolfpack_paratrooper.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 1,
})

skin("BARC", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/barc.mdl",
        [2] = "Models/defcon/loudmantis/41/draa.mdl",
        [3] = "Models/defcon/loudmantis/327/rook.mdl",
        [4] = "Models/player/shader/ghost_company/starwars/clones/13_ghost_company_barc.mdl",
        [5] = "Models/defcon/stallion/shock/k9trooper.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/13_wolfpack_barc.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 2,
})

skin("Scout", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/boomer.mdl",
        [2] = "Models/defcon/stan/scouts/scouthacksaw.mdl",
        [3] = "Models/defcon/loudmantis/327/vex.mdl",
        [4] = "Models/strasser/bf2/p2_212/p2_212_scout_trooper.mdl",
        [5] = "Models/player/ricky/dg/shock/ricky_shockspecialist.mdl",
        [6] = "Models/loudmantis/dire/trooper.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 2,
})

skin("Pilot", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/pilot.mdl",
        [2] = "Models/defcon/loudmantis/41/officer.mdl",
        [3] = "Models/defcon/loudmantis/327/pilot_officer.mdl",
        [4] = "Models/player/shader/ghost_company/starwars/clones/16_ghost_company_pilot.mdl",
        [5] = "Models/defcon/stallion/shock/zero.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/4_wolfpack_2ndlieutenant.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 2,
})

skin("ARF", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/arf.mdl",
        [2] = "Models/defcon/stan/rangerplatoon/rangersparrow.mdl",
        [3] = "Models/defcon/loudmantis/327/green.mdl",
        [4] = "Models/loudmantis/212/gc_trooper.mdl",
        [5] = "Models/defcon/stallion/shock/verticle.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/12_wolfpack_arf.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 2,
})

skin("ARC", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/arc.mdl",
        [2] = "Models/defcon/stan/arcs/arctrooper.mdl",
        [3] = "Models/defcon/loudmantis/327/arc_trooper.mdl",
        [4] = "Models/loudmantis/212/arc.mdl",
        [5] = "Models/defcon/stallion/shock/arc.mdl",
        [6] = "Models/loudmantis/dire/officer.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 2,
})

skin("EVO", {
    Models = {
        [1] = "Models/defcon/stan/arcevo/regimentals/evo501starc.mdl",
        [2] = "Models/defcon/stan/arcevo/regimentals/evo41starc.mdl",
        [3] = "Models/defcon/stan/arcevo/regimentals/evo327tharc.mdl",
        [4] = "Models/defcon/stan/arcevo/regimentals/evo212tharc.mdl",
        [5] = "Models/defcon/stan/arcevo/regimentals/evoshockarc.mdl",
        [6] = "Models/defcon/stan/arcevo/regimentals/evo104tharc.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 2,
})

skin("Specialist 1", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/332/officer.mdl",
        [2] = "Models/defcon/stan/arcs/arcweston.mdl",
        [3] = "Models/defcon/loudmantis/327/hawkbat_trooper.mdl",
        [4] = "Models/player/shader/ghost_company/starwars/clones/9_ghost_company_commander.mdl",
        [5] = "Models/defcon/loudmantis/kamino/trooper.mdl",
        [6] = "Models/memeious/104/jumptrooper.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 3,
})

skin("Specialist 2", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/shadow_tech.mdl",
        [2] = "Models/defcon/loudmantis/41/sarlacc_trooper.mdl",
        [3] = "Models/defcon/loudmantis/327/gunner.mdl",
        [4] = "Models/strasser/bf2/p2_212/p2_212_engineer_leutnant.mdl",
        [5] = "Models/defcon/mantis/shock_k9/trooper.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/10_wolfpack_arc.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 3,
})

skin("Specialist 3", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/jumptrooper.mdl",
        [2] = "Models/defcon/stan/arcs/arcweston.mdl",
        [3] = "Models/defcon/loudmantis/327/cameron.mdl",
        [4] = "Models/player/shader/ghost_company/starwars/clones/6_ghost_company_captain.mdl",
        [5] = "Models/defcon/stallion/shock/thire.mdl",
        [6] = "Models/memeious/104/sinker.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 3,
})

skin("Specialist 4", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/marine.mdl",
        [2] = "Models/defcon/stan/rangerplatoon/rangercooker.mdl",
        [3] = "Models/defcon/loudmantis/327/talon_officer.mdl",
        [4] = "Models/player/shader/ghost_company/starwars/clones/10_ghost_company_arc.mdl",
        [5] = "Models/defcon/stallion/shock/redguard.mdl",
        [6] = "Models/loudmantis/dire/medic.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 3,
})

skin("Specialist 5", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/torrent_trooper.mdl",
        [2] = "Models/defcon/stan/arcs/arcflake.mdl",
        [3] = "Models/defcon/loudmantis/327/tyto.mdl",
        [4] = "Models/loudmantis/212/gc_medic.mdl",
        [5] = "Models/defcon/stallion/shock/riotofficer.mdl",
        [6] = "Models/player/shader/wolfpack_company/starwars/clones/8_wolfpack_colonel.mdl",
        [7] = "Models/player/republiccommandosmp/rc_recon.mdl",
    },
    Rarity = 4,
})

skin("Lore Character 1", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/tup.mdl",
        [2] = "Models/defcon/loudmantis/41/buzz.mdl",
        [3] = "Models/defcon/loudmantis/327/galle.mdl",
        [4] = "Models/mayfield/212/boil.mdl",
        [5] = "Models/defcon/stallion/shock/rys.mdl",
        [6] = "Models/memeious/104/boost.mdl",
        [7] = "Models/player/republiccommandos/rc_delta_scorch.mdl",
    },
    Rarity = 3,
})

skin("Lore Character 2", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/hardcase.mdl",
        [2] = "Models/defcon/stan/greencompany/joker.mdl",
        [3] = "Models/defcon/loudmantis/327/forge.mdl",
        [4] = "Models/mayfield/212/gearshift.mdl",
        [5] = "Models/defcon/stallion/shock/diamond.mdl",
        [6] = "Models/mayfield/104/wildfire.mdl",
        [7] = "Models/player/republiccommandos/rc_delta_fixer.mdl",
    },
    Rarity = 3,
})

skin("Lore Character 3", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/jesse.mdl",
        [2] = "Models/defcon/stan/rangerplatoon/rangersparrow.mdl",
        [3] = "Models/defcon/loudmantis/327/crimson.mdl",
        [4] = "Models/loudmantis/212/ab_officer.mdl",
        [5] = "Models/defcon/stallion/shock/k9hound.mdl",
        [6] = "Models/mayfield/arc/104.mdl",
        [7] = "Models/player/republiccommandos/rc_delta_sev.mdl",
    },
    Rarity = 4,
})

skin("Lore Officer", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/332/vaughn.mdl",
        [2] = "Models/defcon/stan/scouts/scoutfaie.mdl",
        [3] = "Models/defcon/loudmantis/327/deviss.mdl",
        [4] = "Models/loudmantis/212/law.mdl",
        [5] = "Models/defcon/stallion/shock/thorn.mdl",
        [6] = "Models/memeious/104/comet.mdl",
        [7] = "Models/player/republiccommandos/rc_foxtrot_gregor.mdl",
    },
    Rarity = 5,
})

skin("Officer", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/officer.mdl",
        [2] = "Models/defcon/stan/elitecorps/officer.mdl",
        [3] = "Models/defcon/loudmantis/327/officer.mdl",
        [4] = "Models/mayfield/212/officer.mdl",
        [5] = "Models/defcon/stallion/shock/officer.mdl",
        [6] = "Models/moose/104/officer.mdl",
        [7] = "Models/defcon/loudmantis/shadows/vale.mdl",
    },
    Rarity = 4,
})


skin("Commander", {
    Models = {
        [1] = "Models/defcon/loudmantis/501/rex.mdl",
        [2] = "Models/defcon/stan/gree/gree.mdl",
        [3] = "Models/defcon/loudmantis/327/bly.mdl",
        [4] = "Models/defcon/loudmantis/212/cody.mdl",
        [5] = "Models/defcon/stallion/shock/fox.mdl",
        [6] = "Models/stallion/104/wolffe.mdl",
        [7] = "Models/player/republiccommandos/rc_delta_boss.mdl",
    },
    Rarity = 5,
})


