-- local function DrawHolstedWeapons( entity )
-- 	local dist = entity:GetPos():Distance( LocalPlayer():GetPos() )
-- 	entity.WeaponHolstered = entity.WeaponHolstered or {}

-- 	if dist > 4000 then
-- 		if not table.IsEmpty( entity.WeaponHolstered ) then
-- 			for _, ent in pairs( entity.WeaponHolstered ) do
-- 				ent:Remove()
-- 				table.remove(entity.WeaponHolstered, _)
-- 			end
-- 		end
-- 	else
-- 		local wep1 = entity:GetNWString("Falcon:FirstWeapon")

-- 		local activeWeapon = entity:GetActiveWeapon()

-- 		if not activeWeapon or not activeWeapon:IsValid() or activeWeapon:GetClass() ~= wep1 then
-- 			if wep1 then
-- 				local t = weapons.Get( wep1 )

-- 				if t then
-- 					if entity.WeaponHolstered[1] and entity.WeaponHolstered[1]:IsValid() then 
-- 						local ent = entity.WeaponHolstered[1]
						
-- 						local bone = entity:LookupBone("ValveBiped.Bip01_Spine2")

-- 						if not bone then
-- 							return
-- 						end

-- 						local matrix = entity:GetBoneMatrix(bone)

-- 						if not matrix then
-- 							return
-- 						end

-- 						local pos = matrix:GetTranslation()
-- 						local ang = matrix:GetAngles()
-- 						local p = HosterCalc(pos, ang, Vector(3, -1, 5))

-- 						local ang = ang
-- 						ent:SetRenderOrigin(p)

-- 						local offAng = Angle(-175, 93, -0)
-- 						ang:RotateAroundAxis(ang:Forward(), offAng.p)
-- 						ang:RotateAroundAxis(ang:Up(), offAng.y)
-- 						ang:RotateAroundAxis(ang:Right(), offAng.r)

-- 						ent:SetRenderAngles(ang + Angle( 0, 0, -30 ))

-- 						if entity:Alive() then
-- 							ent:SetNoDraw( false )
-- 							ent:DrawModel()
-- 						else
-- 							ent:SetNoDraw( true )
-- 						end
-- 					else
-- 						local ent = ClientsideModel(t.WorldModel, RENDERGROUP_OPAQUE)
-- 						ent:Spawn()
-- 						entity.WeaponHolstered[1] = ent
-- 					end

-- 				end
-- 			end
-- 		else
-- 			if entity.WeaponHolstered[1] and entity.WeaponHolstered[1]:IsValid() then 
-- 				entity.WeaponHolstered[1]:SetNoDraw( true )
-- 			end
-- 		end

-- 		local wep2 = entity:GetNWString("Falcon:SecondWeapon")
-- 		if not activeWeapon or not activeWeapon:IsValid() or activeWeapon:GetClass() ~= wep2 then
-- 			if wep2 then
-- 				local t = weapons.Get( wep2 )

-- 				if t then
-- 					if entity.WeaponHolstered[2] and entity.WeaponHolstered[2]:IsValid() then 
-- 						local ent = entity.WeaponHolstered[2]
						
-- 						local bone = entity:LookupBone("ValveBiped.Bip01_Pelvis")

-- 						if not bone then
-- 							return
-- 						end

-- 						local matrix = entity:GetBoneMatrix(bone)

-- 						if not matrix then
-- 							return
-- 						end

-- 						local pos = matrix:GetTranslation()
-- 						local ang = matrix:GetAngles()
-- 						local p = HosterCalc(pos, ang, Vector(-5, -1, -8))

-- 						local ang = ang
-- 						ent:SetRenderOrigin(p)

-- 						local offAng = Angle(-90, 270, 0)
-- 						ang:RotateAroundAxis(ang:Forward(), offAng.p)
-- 						ang:RotateAroundAxis(ang:Up(), offAng.y)
-- 						ang:RotateAroundAxis(ang:Right(), offAng.r)

-- 						ent:SetRenderAngles(ang)

-- 						if entity:Alive() then
-- 							ent:SetNoDraw( false )
-- 							ent:DrawModel()
-- 						else
-- 							ent:SetNoDraw( true )
-- 						end
-- 					else
-- 						local ent = ClientsideModel(t.WorldModel, RENDERGROUP_OPAQUE)
-- 						ent:Spawn()
-- 						entity.WeaponHolstered[2] = ent
-- 					end

-- 				end
-- 			end
-- 		else
-- 			if entity.WeaponHolstered[2] and entity.WeaponHolstered[2]:IsValid() then 
-- 				entity.WeaponHolstered[2]:SetNoDraw( true )
-- 			end
-- 		end

-- 	end
-- end

local function HosterCalc(pos, ang, off)
	return pos + ang:Right() * off.x + ang:Forward() * off.y + ang:Up() * off.z
end

local function CreateWeapon( player, pos, model, offset )
    local ent = ClientsideModel( model, RENDERGROUP_OPAQUE )
    player.WeaponHolstered[pos] = ent
    ent:Spawn()
    return ent
end

local function DrawWeapon( player, pe, model, bone, offset, offang )
    local ent = player.WeaponHolstered[pe]

    if not ent or not ent:IsValid() then
        ent = CreateWeapon( player, pe, model)
    else
        if ent:GetModel() ~= model then
            ent:Remove()
            ent = CreateWeapon( player, pe, model)
        end
    end

    local active = player:GetActiveWeapon()

    if not player:Alive() or (player == LocalPlayer() and not LocalPlayer().ThirdPersonEnabled) or (active:GetModel() == ent:GetModel())then
        ent:SetNoDraw( true )
        return
    else
        ent:SetNoDraw( false )
    end
    
    local bone = player:LookupBone(bone)
    if not bone then
        return
    end

    local matrix = player:GetBoneMatrix(bone)
    if not matrix then
        return
    end

    local pos = matrix:GetTranslation()
    local ang = matrix:GetAngles()
    local p = HosterCalc(pos, ang, offset)

    ent:SetRenderOrigin(p)

    ang:RotateAroundAxis(ang:Forward(), offang.p)
    ang:RotateAroundAxis(ang:Up(), offang.y)
    ang:RotateAroundAxis(ang:Right(), offang.r)


    if pe == 1 then
        ang = ang + Angle( 0, 0, -30 )
    end

    ent:SetRenderAngles(ang)
end

local function DrawHolstedWeapons( ply )
	local l = LocalPlayer()

    ply.WeaponHolstered = ply.WeaponHolstered or {}
    
    if ply:GetPos():Distance( l:GetPos() ) < 3000 then
        local first = ply:GetNWString("Falcon:FirstWeapon")
        local t = weapons.Get( first )

        if t then
            DrawWeapon( ply, 1, t.WorldModel, "ValveBiped.Bip01_Spine2", Vector(3, -1, 5), Angle(-175, 93, -0) )
        else
            local ent = ply.WeaponHolstered[1]
            if ent and ent:IsValid() then
                ent:Remove()
            end
        end

        local second = ply:GetNWString("Falcon:SecondWeapon")
        local t = weapons.Get( second )
        if t then
            DrawWeapon( ply, 2, t.WorldModel, "ValveBiped.Bip01_Pelvis", Vector(-5, -1, -8), Angle(-90, 270, 0) )
        else
            local ent = ply.WeaponHolstered[2]
            if ent and ent:IsValid() then
                ent:Remove()
            end
        end
    else
        if ply.WeaponEntities then
            for _, wep in pairs( ply.WeaponEntities ) do
                if not wep or not wep:IsValid() then continue end
                wep:Remove()
                ply.WeaponEntities[_] = nil
            end
            ply.WeaponEntities = {}
        end
    end
end

function DrawHolsters()
    local ply = LocalPlayer()
	local players = player.GetAll()

	for _, player in pairs( players ) do
		DrawHolstedWeapons( player )
	end
end
-- hook.Add("Think", "DrawHosteredItems", DrawHolsters)
