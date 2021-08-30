AddCSLuaFile( "shared.lua" )

include('shared.lua')

if CLIENT then return end

ENT.Model = ENT.Model or "models/npcs/hc/droids/b2_droid.mdl"
ENT.HP = ENT.HP or 2000
ENT.Attack = ENT.Attack or 500
ENT.MoveAround = ENT.MoveAround or 600
ENT.RunSpeed = ENT.RunSpeed or 52
ENT.Stagged = 11

function ENT:Initialize()

	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetBloodColor(BLOOD_COLOR_MECH)
	self:PhysicsInit(  SOLID_VPHYSICS )

	self:SetModel( self.Model )
	
	self:SetHealth( self.HP )
	self:SetMaxHealth( self.HP )

	self:SetArmor( self.AR or 3000 )
	self:SetMaxArmor( self.AR or 3000 )
end

function ENT:SetEnemy( p )
	self.Enemy = p
end

function ENT:GetEnemy()
	return self.Enemy
end


function ENT:SetMaxArmor(ar)
	self:SetNWInt("FALCON:DROID:MAXARMOR", ar)
end

function ENT:SetArmor(ar)
	self:SetNWInt("FALCON:DROID:ARMOR", ar)
end

function ENT:Armor()
	return self:GetNWInt("FALCON:DROID:ARMOR", 0)
end


function ENT:SetNextPos( pos )
	self.HasIdled = false
	self.HasStage = false
	self.NextPos = pos
end

function ENT:GetNextPos()
	return self.NextPos or self:GetEnemy():GetPos()
end

function ENT:FindEnemy()
	local p = self.TargetPlayers or player.GetAll()
	local dist = {}
	dist.range = self.dist or 2000

	for _, ply in pairs( p ) do
		if not self.TargetPlayers and (dist.range < self:GetRangeTo( ply:GetPos() )) then continue end
		if ply:Health() <= 0 then continue end
		if not self:IsAbleToSee( ply, true ) then continue end
		
		dist.range = self:GetRangeTo( ply:GetPos() )
		dist.player = ply
	end

	if dist.player then
		if dist.player == self:GetEnemy() then return true end
		self.HasIdled = false
		self.HasStage = false
		self:SetEnemy( dist.player )
		return true
	else
		return false
	end
end

function ENT:SetTargetedPlayers( players )
	self.TargetPlayers = players
end	


function ENT:HaveEnemy()
	if self.Killed then return false end
	if self:GetEnemy() and self:GetEnemy():IsValid() and self:GetEnemy():Health() > 0 then
		if self:GetRangeTo( self:GetEnemy():GetPos() ) <= 2000 then
			if self:IsAbleToSee( self:GetEnemy(), true ) then
				return true
			else
				return self:FindEnemy()
			end
		else
			return self:FindEnemy()
		end
	else
		return self:FindEnemy()
	end
end

function ENT:RunBehaviour()
	while ( true ) do
		self.loco:SetAcceleration( 600 )
		self.loco:SetDesiredSpeed( self.RunSpeed )

		if self:HaveEnemy() then
			self:MovePosition( {}, self:GetEnemy():GetPos() )
		elseif self.NextPos then
			self:StartActivity(self:GetSequenceActivity(9))
			self:MovePosition( {}, self.NextPos )
		elseif not self.HasIdled then
			self.loco:SetDesiredSpeed( self.RunSpeed )
			self:StartActivity(self:GetSequenceActivity(9))
			self:SetNextPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:MovePosition()
			self.HasIdled = true
		elseif not self.Killed then
			if not self.HasStage then
				self:StartActivity(ACT_IDLE)
				self.HasStage = true
			end
		end
		coroutine.wait(0.1)
	end

end	

function ENT:CalculateNextPos()
	if not self:GetEnemy() then return end
	self:SetNextPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 600 )
end

function ENT:MovePosition( options )
	self:StartActivity(self:GetSequenceActivity(9))

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetNextPos() )

	while ( self.NextPos or self:HaveEnemy() ) do
		if self.Killed then
			if self:GetActivity() ~= self:GetSequenceActivity(10) then
				self:StartActivity(self:GetSequenceActivity(10))
			end 
			self:SetEnemy( nil )
			self:SetNextPos( nil )
			return "killed"
		end

		if self.GotShotNibba then
			self:PlaySequenceAndWait(11)
			self:StartActivity(self:GetSequenceActivity(self.Stagged))
			self.GotShotNibba = false
			return
		end



		if self:HaveEnemy() then
			self.loco:FaceTowards( self:GetEnemy():GetPos() )
			local enemy_range = self:GetRangeTo( self:GetEnemy():GetPos() )
			if enemy_range > 500 then
				if self.IsAttacking then
					self:StartActivity( self:GetSequenceActivity(2) )
				end

				if not self.RandomGenAttack or self.RandomGenAttack < CurTime() then
					local randAttack = math.random(1, 3)
					if randAttack == 1 then
						self:Attack()
						self.RandomGenAttack = CurTime() + 5
					end
				end
			else
				if self:GetActivity() ~= self:GetSequenceActivity(2) then
					self:StartActivity(self:GetSequenceActivity(2))
				end
				if not self.AttackDelay or self.AttackDelay < CurTime() then
					self:Attack()
				end
				return
			end
		else
			self:SetEnemy( nil )
		end


		if not self.IsAttacking then
			if self:GetActivity() ~= self:GetSequenceActivity(9) then
				self:StartActivity(self:GetSequenceActivity(9))
			end
			if ( path:GetAge() > 0.1 ) then
				path:Compute( self, self:GetNextPos() )
			end

			if Falcon.HasNavMesh and path:IsValid() then
				path:Update( self )
			else
				self.loco:Approach( self:GetNextPos(), 1 )
			end
		end

		if self.NextPos then
			self.loco:FaceTowards( self.NextPos )
			local move_range = self:GetRangeTo( self.NextPos )
			local distCheck = (self.prevDistToTarget or 0) - move_range
			if distCheck >= -1 and distCheck <= 1 then
				self:SetNextPos( nil )
			else
				self.prevDistToTarget = move_range
				if move_range <= 75 then
					if self:GetEnemy() then
						self:CalculateNextPos()
					else
						self:SetNextPos( nil )
					end
				end
			end
		end


		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end
end


local doors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true
}
function ENT:OnContact( ent )
	if ent:IsNextBot() then
	elseif doors[ent:GetClass()] then
		ent:Fire("Open")
	end
end

function ENT:MakeSparks( explode )
	local effectdataspk = EffectData()
	effectdataspk:SetOrigin(self:GetPos())
	effectdataspk:SetScale( 90 )
	util.Effect( "ManhackSparks", effectdataspk )

	if explode then
		local effectdataexp = EffectData()
		effectdataexp:SetOrigin(self:GetPos())
		effectdataexp:SetScale(7)
		util.Effect( "Explosion", effectdataexp )
	end
end

function ENT:OnTakeDamage( data )
	if self.Killed then return end
	local attacker = data:GetAttacker()
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true

		if not self:GetEnemy() and not self.NextPos then
			self:SetNextPos( attacker:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 50 )

			local droids = ents.FindInSphere( self:GetPos(), 750 )

			for _, droid in pairs( droids ) do
				if not droid:IsNextBot() then continue end
				droid:SetNextPos( attacker:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 250 )
			end
		end

		if self:Armor() > 0 then
			local dmg = data:GetMaxDamage()
	
			self:SetArmor( math.Round(math.Clamp( self:Armor() - dmg, 0, 9999999 ))  )
	
			data:SetDamage( 0 )
		end

		local chanceOfHurt = math.random(1, 15)
		if chanceOfHurt == 1 then
			self:EmitSound( "f_cigg/npcs/b2/hurt" .. tostring(math.random(1, 9)) .. ".mp3", 900, 100, 1, CHAN_AUTO )
			self:MakeSparks()
		end

		self:TakeDamageInfo( data )
		self.m_bApplyingDamage = false

		if not self.IsInjured and self:Armor() <= 0 then
			self:SetModel("models/npcs/hc/droids/b2_droid_wounded.mdl")
			self:SetBodygroup(1, 1)
			self:EmitSound( "f_cigg/npcs/b2/hurt" .. tostring(math.random(1, 9)) .. ".mp3", 900, 100, 1, CHAN_AUTO )

			self:MakeSparks( true )

			self.GotShotNibba = true
			self.IsInjured = true
		elseif self.IsInjured then
			data:ScaleDamage(1.25)
		end

		if not self.GotShotNibba and self:Health() > (self.HP / 3) then
			local chance = math.random(1, 31)
			if chance == 16 then
				self:EmitSound( "f_cigg/npcs/b2/hurt" .. tostring(math.random(1, 9)) .. ".mp3", 900, 100, 1, CHAN_AUTO )

				self.GotShotNibba = true
			end
		end
	end
end

function ENT:OnKilled( data )
	self.Killed = true

	self:MakeSparks( true )

	self:EmitSound( "f_cigg/npcs/b2/hurt" .. tostring(math.random(1, 9)) .. ".mp3", 900, 100, 1, CHAN_AUTO )

	self:BecomeRagdoll( data )

	timer.Simple( 5, function()
		if not self or not self:IsValid() then return end
		self:Remove()
	end)
end

function ENT:Attack()
	-- local chanceToHit = 
	if chanceToHit == 1 then

	else
		self:FireWeapon( 0 )
		self.AttackDelay = CurTime() + 2
	end
	self.IsAttacking = true
end

function ENT:FireWeapon( count )
	if self.GotShotNibba then return end
	self:StartActivity(self:GetSequenceActivity(2))
	local enem = self:GetEnemy()

	if not self or not self:IsValid() then return end
	if not enem or not enem:IsValid() then return end
	
    local bullet = {}
    bullet.Num         = 1
    bullet.Src         = self:GetBonePosition(17)  
    bullet.Dir         = enem:LocalToWorld(enem:OBBCenter()) - self:GetBonePosition(17)
    bullet.Spread     = Vector( 65, 65, 20 ) 
    bullet.Tracer    = 1
    bullet.TracerName = "lfs_laser_red_large"
    bullet.Force    = 0                        
    bullet.Damage    = 25
    bullet.AmmoType = "Pistol"
    bullet.Callback = function(att, tr, dmginfo)
      dmginfo:SetDamageType(DMG_BULLET)
    end
    self:EmitSound("f_cigg/npcs/b2/fire_bullet.wav", 150, 100, 1, CHAN_AUTO)
    self:FireBullets( bullet )

	
	if not count or count < 2 then
		timer.Simple(0.25, function()
			if not self or not self:IsValid() then return end
			if self.GotShotNibba then return end

			self:FireWeapon( count + 1 )
		end)
	else
		self.IsAttacking = false
	end
end

-- function ENT:BodyUpdate()
-- 	self:BodyMoveXY()
-- end



