AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:Initialize( )
	
	self:SetModel( "models/jellyton/bf2/misc/props/command_post.mdl" )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD) 
	self:SetSolid(  SOLID_BBOX )
	self:DropToFloor()
	self:SetBodygroup(1, 2)

	self.Droids = self.Droids or { "falcon_b1_anaxes_training" }

	self:SetNWString( "Falcon:Desc", "Download the Intel!" )

	self.Delay = CurTime()
	self.Players = self.Players or {}
end

function ENT:OnTakeDamage()
	return false
end 

function ENT:SetEntityToSpawn( class )
	self.Entity = ents.Create(class)
	self.Entity:SetPos( self:GetPos() + Vector( 0, 0, 28 ) )
	if self.SetFair then
		local p = table.Count( self.Players )
		local hp = self.Entity.HP

		self.Entity:SetHealth( math.floor((hp / 3)) * p )
		self.Entity:SetMaxHealth( math.floor((hp / 3)) * p )
		self.Entity.HP = math.floor((hp / 3)) * p

		if class == "falcon_b2_anaxes" then
			local ar = self.Entity:Armor()
			self.Entity.AR = 700 * p
		end

		self.Entity:SetNWBool("FALCON:ISSIM", true)

		self.Entity:SetTargetedPlayers( self.Players )
	end
	self:SetNWString("FALCON:ENTITY", self.Entity.Model)
end

function ENT:SetDroidSpawns( droids )
	self.Droids = droids
end

function ENT:StartSpawning()
	self:SetEntityToSpawn( self.Droids[math.random(1, #self.Droids)] )
end

function ENT:SetFair( bool )
	self.SetFair = bool
end

function ENT:SetPlayers( players )
	local tbl = {}
	for ply, _ in pairs( players ) do
		table.insert( tbl, ply )
	end

	self.Players = tbl
end

function ENT:Think()
	if self.Delay < CurTime() then
		if self:GetNWString("FALCON:ENTITY") ~= "" then
			local rand = math.random(1, 2)
			if rand == 1 then
				self.Entity:Spawn()
				self:SetNWString("FALCON:ENTITY", "")
			else
				self.Delay = CurTime() + 5
				return
			end
		else
			self:SetEntityToSpawn( self.Droids[math.random(1, #self.Droids)] )
		end
		self.Delay = CurTime() + 27
	end
end

