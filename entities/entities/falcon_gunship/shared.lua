AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Spawnable		= true

if SERVER then
	local names = {
		"Bender",
		"Lynch",
		"Big Papa",
		"Mad Dog",
		"Bowser",
		"O'Doyle",
		"Bruise",
		"Psycho",
		"Cannon",
		"Ranger",
		"Clink",
		"Ratchet",
		"Cobra",
		"Reaper",
		"Colt",
		"Rigs",
		"Crank",
		"Ripley",
		"Creep",
		"Roadkill",
		"Daemon",
		"Ronin",
		"Decay",
		"Rubble",
		"Sasquatch",
		"Doom",
		"Scar",
		"Dracula",
		"Shiver",
		"Dragon",
		"Skinner",
		"Fender",
		"Skull Crusher",
		"Fester",
		"Slasher",
		"Fisheye",
		"Steelshot",
		"Flack",
		"Surge",
		"Gargoyle",
		"Sythe",
		"Grave",
		"Trip",
		"Gunner",
		"Trooper",
		"Hash",
		"Tweek",
		"Hashtag",
		"Vein",
		"Indominus",
		"Void",
		"Ironclad",
		"Wardon",
		"Killer",
		"Wraith",
		"Knuckles",
		"Zero",
	}

	function ENT:Initialize()

		self:SetModel( "models/jellyton/bf2/cis/vehicles/hmp_gunship.mdl" )

		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )

		

		local phys = self:GetPhysicsObject()

		if phys:IsValid() then
			phys:EnableGravity( false )
			phys:SetMass( 25000 )
			phys:Wake()
		end

		self.NextPos = self:GetNWVector( "FALCON:NEXTPOS" )
		self.NextAngles = self:GetNWAngle( "FALCON:NEXTANGLES" )

		self.StartingPos = self:GetPos()
		self.WayBackAngles = self:GetAngles() + Angle( 0, 180, 0 )

		self.VelX = 0
		self.VelZ = 0
		self.VelW = 0

		self.Droids = self.Droids or {}

		self:SetNWString("Falcon:Name", names[math.random(1, #names)])

	end

	function ENT:ToDeploy()
		local nextPos = self.NextPos
		local curPos = self:GetPos()
		local x, y, z = curPos.x - nextPos.x, curPos.y - nextPos.y, curPos.z - (nextPos.z + 100)

		if not self.IdealX and x < 15 and x > -15 then
			self.VelX = 0
			self.IdealX = true
		elseif not self.IdealX then
			self.VelX = (x * 0.525)

			if self.VelX < 0 then
				self.VelX = (self.VelX * -1)
			end

			self.VelX = self.VelX + 350

		end

		if self.IdealX and not self.IdealZ then
			if z < 150 and z > -150 then
				self.IdealZ = true
				self.VelZ = 0
			else
				self.VelZ = (z * 0.3)
			end
			self.VelZ = math.Clamp(self.VelZ, 0, 900)

		end

		if self.IdealX and not self.IdealAngles then
			local w =  self.NextAngles.y - self:GetAngles().y
			if math.Round(w, 0) == 0 then
				self.IdealAngles = true
				self.VelW = 0
			else			
				self.VelW = (w * 0.4)
				if self.VelW < 0 then
					self.VelW = self.VelW * -1
				end
				self.VelW = math.Clamp(self.VelW, 0, 750)

			end

		end

		if self.IdealX and self.IdealZ and self.IdealAngles then
			self:DeployTroops()
		end
	end


	function ENT:FromDeploy()
		local nextPos = self.NextPos
		local curPos = self:GetPos()
		local x, y, z = curPos.x - nextPos.x, curPos.y - nextPos.y,  nextPos.z - curPos.z

		if self.IdealZ and self.IdealAngles then
			self.VelX = 2500
		end


		if z < 150 and z > -150 then
			self.IdealZ = true
			self.VelZ = 0
		else
			self.VelZ = (z * -0.3)
		end
		self.VelZ = math.Clamp(self.VelZ, -900, 900)


		local w = (self:GetAngles().y - self.NextAngles.y) + 360
		if not self.IdealAngles then
			if w > -4 and w < 4 then
				self.IdealAngles = true
				self.VelW = 0
				self:SetAngles(self.NextAngles)
			else			
				self.VelW = (w * 0.4)
				if w < 0 then
					self.VelW = self.VelW * -1
				end

				self.VelW = math.Clamp(self.VelW, -100, 100)
			end
		else
			self.VelW = 0
		end
	end

	function ENT:DeployTroops()
		self:SetNWBool("FALCON:DEPLOYED", true) 
		self.DeployedTroops = CurTime() + 1.5

		self:SetNWVector( "FALCON:NEXTPOS", self.StartingPos )
        self:SetNWAngle( "FALCON:NEXTANGLES", self.WayBackAngles )

		self.NextPos = self:GetNWVector( "FALCON:NEXTPOS" )
		self.NextAngles = self:GetNWAngle( "FALCON:NEXTANGLES" )

		self.IdealX = false
		self.IdealZ = false
		self.IdealAngles = false
		


		for _, droids in pairs( self.Droids ) do
			local e = ents.Create(droids)
			e:SetPos( self:GetPos() + self:GetAngles():Up() * -165 + (Vector( math.random(-400, 400), math.random(-400, 400), 0 ) ) )
			e:FindNewObjective(  )
			e:Spawn()

			constraint.NoCollide( e, self, 0, 0 )


			-- timer.Simple(20, function()
			-- 	e:Remove()
			-- end)
		end
	end

	function ENT:PhysicsCollide()
		self:Remove()

		
	end


	function ENT:PhysicsUpdate( phys )
		if self.DeployedTroops and self.DeployedTroops > CurTime() then return end
		phys:SetVelocityInstantaneous( Vector( 0, 0, 0 ) + (self:GetAngles():Forward() * self.VelX) + (self:GetAngles():Up() * -self.VelZ) )

		phys:SetAngleVelocityInstantaneous( Vector(0, 0, self.VelW) )

		if not self.DeployedTroops then
			self:ToDeploy()
		else
			self:FromDeploy()
		end
	end

else

	function ENT:Draw()
		self:DrawModel()
	end

end