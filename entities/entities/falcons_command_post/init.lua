AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("Falcon:CommandPost:EventMenu")
util.AddNetworkString("Falcon:CommandPost:SendEffect")
util.AddNetworkString("Falcon:CommandPost:ChangeState")
util.AddNetworkString("Falcon:CommandPost:ChangeName")

function ENT:SpawnFunction(ply, tr, ClassName)
    if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16
    
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
    ent:DropToFloor()
	ent:Spawn()

    ent:SetNWInt("Falcon:Faction", 1)
    ent:SetNWString("Falcon:Name", "[NO NAME]")
    ent:SetNWInt("Falcon:Faction:Hostile", 0)

	return ent
end

function ENT:Think()
    local ents = ents.FindInSphere( self:GetPos(), 350 )
    local isNear

    for _, e in pairs( ents ) do
        if e:IsWorld() then continue end
        if e:IsPlayer() and e:Alive() then
            -- if the player is in a certain team
            isNear = e
            break
        elseif e:IsNextBot() or e:IsNPC() and e:Health() >= 1 then
            isNear = e
            break
        end
    end

    local friendlyPoints = self:GetNWInt("Falcon:Faction:Friendly", 0)
    local hostilePoints = self:GetNWInt("Falcon:Faction:Hostile", 0)

    if not isNear and friendlyPoints == 0 and hostilePoints == 0 then
        return self:SetBodygroup(1, 2)
    elseif isNear and isNear:IsPlayer() then
        if hostilePoints > 0 then
            self:SetNWInt("Falcon:Faction:Hostile", math.Clamp( self:GetNWInt("Falcon:Faction:Hostile", 0) - 1, 0, 100) )
        else
            if friendlyPoints < 100 then
                self:SetNWInt("Falcon:Faction:Friendly", math.Clamp( self:GetNWInt("Falcon:Faction:Friendly", 0) + 1, 0, 100) )
            end
        end
    elseif isNear and isNear:IsNextBot() then
        if friendlyPoints > 0 then
            self:SetNWInt("Falcon:Faction:Friendly", math.Clamp( self:GetNWInt("Falcon:Faction:Friendly", 0) - 1, 0, 100) )
        else
            if hostilePoints < 100 then
                self:SetNWInt("Falcon:Faction:Hostile", math.Clamp( self:GetNWInt("Falcon:Faction:Hostile", 0) + 1, 0, 100) )
            end
        end
    end

    if friendlyPoints == 100 then 
        if not self.HasPlayedSound then
            self.HasPlayedSound = true
            net.Start("Falcon:CommandPost:SendEffect")
                net.WriteBool( true )
                net.WriteUInt( math.random(1, 3), 32 )
            net.Broadcast()
        end
        self:SetNWInt("Falcon:Faction", 2)
        return self:SetBodygroup(1, 0)
    elseif hostilePoints == 100 then
        self:SetNWInt("Falcon:Faction", 3)
        return self:SetBodygroup(1, 1)
    else
        if friendlyPoints == 0 then
            if self.HasPlayedSound then
                self.HasPlayedSound = false
                net.Start("Falcon:CommandPost:SendEffect")
                    net.WriteBool( false )
                    net.WriteUInt( math.random(1, 1), 32 )
                    net.WriteEntity( self )
                net.Broadcast()
            end
        end
        self:SetNWInt("Falcon:Faction", 1)
        return self:SetBodygroup(1, 2)
    end
end

function ENT:Use(ply)
    net.Start("Falcon:CommandPost:EventMenu")
        net.WriteEntity( self )
    net.Send( ply )
end

hook.Add("PlayerSay", "AddEventMenuIdk", function( ply, text, team )

    if text == "/posts" then
        net.Start("Falcon:CommandPost:EventMenu")
        net.Send( ply )
    end
    
end)

net.Receive("Falcon:CommandPost:ChangeState", function( len, ply )

    -- check if player isnt em

    local ent = net.ReadEntity()
    local change = net.ReadInt( 5 )

    ent:SetNWInt("Falcon:Faction:Friendly", 0 )
    ent:SetNWInt("Falcon:Faction:Hostile", 0 )

    if change == 1 then
        ent:SetBodygroup(1, 2)
        if not ent.HasPlayedSound then return end
        ent.HasPlayedSound = false
        net.Start("Falcon:CommandPost:SendEffect")
            net.WriteBool( false )
            net.WriteUInt( math.random(1, 1), 32 )
        net.Broadcast()
    elseif change == 2 then 
        ent:SetNWInt("Falcon:Faction:Friendly", 100 )
        ent:SetBodygroup(1, 0)
    elseif change == 3 then
        ent:SetNWInt("Falcon:Faction:Hostile", 100 )
        ent:SetBodygroup(1, 1)
    end

    ent:SetNWInt("Falcon:Faction", change)


end)

net.Receive("Falcon:CommandPost:ChangeName", function( len, ply )
    -- if player isnt em
    local ent = net.ReadEntity()
    local name = net.ReadString()

    ent:SetNWString("Falcon:Name", name)
end)