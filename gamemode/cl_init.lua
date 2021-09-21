
include( 'shared.lua' )
include( 'config.lua' )

function GM:InitPostEntity()

    net.Start("F:SW:Player:Loaded")
    net.SendToServer()

end


for i = 1, 60 do
	surface.CreateFont( "F" .. tostring(i), {
		font = "Teko",
		size = ScreenScale( i )
	})
end

for i = 1, 60 do
	surface.CreateFont( "F" .. tostring(i) .. "_CAMERA", {
		font = "Teko",
		size = i * (1920 * 0.0016)
	})
end

function ThirdPersonCalc( ply, pos, angles, fov )
	local bn = ply:LookupBone( "ValveBiped.Bip01_Head1" )

	if bn then
		pos = ply:GetBonePosition(bn)
	end

	local view = {
		origin = pos - ( angles:Forward() * 100 ) + ( angles:Right() * 30 ) + ( angles:Up() * 5 ),
		angles = angles,
		fov = fov,
		drawviewer = true
	}

	return view
end

function GM:PlayerButtonDown(ply, key)
    if key == KEY_B then
        if ply.ThirdPersonTimer and ply.ThirdPersonTimer > CurTime() then return end
        if ply.ThirdPersonEnabled then
            hook.Remove("CalcView", "FalconsThirdPerson")
            ply.ThirdPersonEnabled = false
        else
            hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
            ply.ThirdPersonEnabled = true
        end
		ply.ThirdPersonTimer = CurTime() + 0.2
	elseif key == KEY_I then
		OpenInvUI()
	elseif key == KEY_P then
		OpenCharacters( true )
	end
end

Falcon.Inventory = {
	Attachments = {
		Available = {
			[1] = { 1, 2, 10, 11, 12 }
		},
		Equipped = {
			[1] = { 
				[1] = 0, 
				[2] = 10,
				[3] = 0,
				[4] = 0,
				[5] = 0,
				[6] = 0,
				[7] = 0,
				[8] = 26,
			}
		}
	},
	Skin = 25,
    Equipped = {
        [1] = {
            id = 1,
        },
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
        [7] = {},
    },
    Backpack = {
        {
            x = 1,
            y = 4,
            item = 2,
			isEquipped = true,
        },
		{
            x = 1,
            y = 4,
            item = 2,
			isEquipped = false,
        },
    },
}


local plyMeta = FindMetaTable("Player")
function plyMeta:IsValidAttachment( att )
	-- local class = self:GetActiveWeapon():GetClass()
	-- local attachments = atts.Available[class]

	-- if not attachments then return false end


	-- if type(att) == "number" then
	-- 	if attachments[att] then
	-- 		return true
	-- 	end
	-- else
	-- 	for _, a in pairs( attachments ) do
	-- 		local i = Falcon.Attachments[a]
	-- 		if i.Attachment == att or i.Name == att then
	-- 			return true
	-- 		end
	-- 	end
	-- end
	

	-- return false
	return true
end

----------------------------------------------------

for _, ent in pairs( ents.FindByClass("prop_physics")) do
	local p = ent:GetPos()
	print(ent:GetAngles())
	print("{ Model = '" .. ent:GetModel() .. "', Pos = Vector(" .. tostring(p.x) .. ", " .. tostring(p.y) .. ", " .. tostring(p.z) .. "), Ang = Angle( 0, " .. tostring(ent:GetAngles().y) ..", 0 ) },")
end


-- WEAPON CUSTOMISATION ROOM
-- { Model = 'models/cire992/props3/n7_mi_counter_end.mdl', Pos = Vector(3991.4375, -7023.59375, 48.4375), Ang = Angle( 0, 0.0384521484375, 0 ) },
-- { Model = 'models/cire992/liq/n7_mi_counter_crn.mdl', Pos = Vector(4031.4375, -6942.75, 48.46875), Ang = Angle( 0, 90.027465820313, 0 ) },
-- { Model = 'models/cire992/liq/n7_mi_floor_cap_1x1.mdl', Pos = Vector(3930.65625, -6882.71875, 48.40625), Ang = Angle( 0, 89.945068359375, 0 ) },
-- { Model = 'models/cire992/props/kitchen07.mdl', Pos = Vector(4132.3125, -6704.5625, 48.34375), Ang = Angle( 0, -89.994506835938, 0 ) },
-- { Model = 'models/cire992/props4/kitchen05.mdl', Pos = Vector(4011.8125, -6704.40625, 48.375), Ang = Angle( 0, -90.137329101563, 0 ) },
-- { Model = 'models/cire992/props4/crateshipping01_a.mdl', Pos = Vector(3869.59375, -6743.15625, 48.5), Ang = Angle( 0, 0.0164794921875, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/fueltank_scarif1_static.mdl', Pos = Vector(3937.5, -6732.34375, 48.40625), Ang = Angle( 0, 0, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/barrel_scarif1_phys.mdl', Pos = Vector(3991.84375, -6718, 68.25), Ang = Angle( 0, -94.010009765625, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/barrel_scarif1_phys.mdl', Pos = Vector(3991.8125, -6746.1875, 68.09375), Ang = Angle( 0, -86.929321289063, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/imp_chair01.mdl', Pos = Vector(3957.34375, -6952, 48.34375), Ang = Angle( 0, 23.433837890625, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/imp_chair01.mdl', Pos = Vector(4141.21875, -6773.21875, 48.34375), Ang = Angle( 0, 44.47265625, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/imp_chair01.mdl', Pos = Vector(4076, -6775.46875, 48.40625), Ang = Angle( 0, 88.621215820313, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/crate_yavin01_phys.mdl', Pos = Vector(3953.71875, -6865.65625, 97.6875), Ang = Angle( 0, -129.49584960938, 0 ) },
-- { Model = 'models/props_wasteland/kitchen_shelf001a.mdl', Pos = Vector(3922.875, -7008.25, 48.375), Ang = Angle( 0, 179.88464355469, 0 ) },
-- { Model = 'models/props_wasteland/kitchen_shelf001a.mdl', Pos = Vector(3856.5, -6950.78125, 48.375), Ang = Angle( 0, 91.411743164063, 0 ) },


-- INVENTORY PURCHASING MAN
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/props/vendor/vendor_armor_stall_wo_flag.mdl', Pos = Vector(3935.59375, -7380.40625, 48.34375), Ang = Angle( 0, 89.994506835938, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/props/vendor/vendor_armor_stall_wo_flag.mdl', Pos = Vector(4108.4375, -7382.25, 48.4375), Ang = Angle( 0, 90, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/imp_holoprojector.mdl', Pos = Vector(3869.34375, -7295.90625, 48.4375), Ang = Angle( 0, 0.24169921875, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/imp_holoprojector.mdl', Pos = Vector(3869.3125, -7185.84375, 48.40625), Ang = Angle( 0, 0.2911376953125, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/hyperfuelbarrel01.mdl', Pos = Vector(3858.09375, -7141.46875, 48.46875), Ang = Angle( 0, -7.20703125, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/hyperfuelbarrel02.mdl', Pos = Vector(3855.78125, -7251.875, 57.125), Ang = Angle( 0, -137.67517089844, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/hyperfuelbarrel01.mdl', Pos = Vector(3849.46875, -7337.84375, 48.71875), Ang = Angle( 0, -0.5712890625, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/fueltank_scarif1_static.mdl', Pos = Vector(4169.46875, -7084.34375, 48.4375), Ang = Angle( 0, 180, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/crate_yavin01_phys.mdl', Pos = Vector(4186.46875, -7121.375, 64.125), Ang = Angle( 0, -179.97253417969, 0 ) },
-- { Model = 'models/lordtrilobite/starwars/props/crate_yavin01_phys.mdl', Pos = Vector(4185.4375, -7143.3125, 64.15625), Ang = Angle( 0, -172.42492675781, 0 ) },
-- { Model = 'models/lt_c/sci_fi/box_crate.mdl', Pos = Vector(3865.625, -7082.1875, 48.15625), Ang = Angle( 0, -90.192260742188, 0 ) },
-- { Model = 'models/lt_c/sci_fi/box_crate.mdl', Pos = Vector(3918.90625, -7089.6875, 48.15625), Ang = Angle( 0, -46.576538085938, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_footlocker_dial.mdl', Pos = Vector(3866, -7082.875, 93.0625), Ang = Angle( 0, -27.476806640625, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_footlocker_dial.mdl', Pos = Vector(3918.625, -7091.1875, 93), Ang = Angle( 0, -72.592163085938, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_footlocker_panel.mdl', Pos = Vector(4186.1875, -7131.125, 81.5), Ang = Angle( 0, -164.76196289063, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_safeboxes_dial.mdl', Pos = Vector(4195.34375, -7313.46875, 48.34375), Ang = Angle( 0, 164.89929199219, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_safeboxes_dial.mdl', Pos = Vector(4186.125, -7336.8125, 48.34375), Ang = Angle( 0, 150.29296875, 0 ) },
-- { Model = 'models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_safeboxes_dial.mdl', Pos = Vector(4166.1875, -7351.8125, 48.40625), Ang = Angle( 0, 100.7666015625, 0 ) },
-- { Model = 'models/props_wasteland/kitchen_shelf001a.mdl', Pos = Vector(4070.28125, -7071.84375, 48.34375), Ang = Angle( 0, 179.97802734375, 0 ) },
-- { Model = 'models/props_wasteland/kitchen_shelf001a.mdl', Pos = Vector(3982.4375, -7071.90625, 48.4375), Ang = Angle( 0, -179.93957519531, 0 ) },
