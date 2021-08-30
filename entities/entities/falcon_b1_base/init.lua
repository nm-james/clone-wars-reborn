AddCSLuaFile( "shared.lua" )

include('shared.lua')

if CLIENT then return end

ENT.Model = ENT.Model or "models/player/b1battledroids/b1_base.mdl"
ENT.HP = ENT.HP or 250
ENT.Attack = ENT.Attack or 1000
ENT.AttackDelayTimer = ENT.AttackDelayTimer or 0.3

ENT.MoveAround = ENT.MoveAround or 600
ENT.RunSpeed = ENT.RunSpeed or 250
ENT.WeaponModel = ENT.WeaponModel or "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"
ENT.WeaponDamage = ENT.WeaponDamage or 15
ENT.WeaponSpread = ENT.WeaponSpread or Vector( 40, 40, 40 )
ENT.ShouldMoveAround = ENT.ShouldMoveAround or true
ENT.ShootWhilstRunning = ENT.ShootWhilstRunning or true
ENT.TracerType = ENT.TracerType or 1

function ENT:Initialize()

	local players = table.Count( player.GetAll() )

	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetBloodColor(BLOOD_COLOR_MECH)
	self:SetCollisionGroup(COLLISION_GROUP_NPC)

	self:SetModel( self.Model )
	self:SetHealth( self.HP )
	self:SetMaxHealth( self.HP )

	self.loco:SetStepHeight( 35 )

	self:GiveWeapon()

end

function ENT:SetNextObjective( obj )

	self.NextPos = obj:GetPos()

	self.NextObjective = obj
end

function ENT:SetEnemy( p )
	self.Enemy = p
end

function ENT:GetEnemy()
	if not self.Enemy or not self.Enemy:IsValid() then
		self:SetEnemy( nil )
		return false
    else
		if self:GetPos():Distance( self.Enemy:GetPos() ) > 1500 then
			self:SetEnemy( nil )
			return false
		end
		return self.Enemy
	end
end

function ENT:SetNextPos( pos )
	self.HasIdled = false
	self.HasStage = false
	self.NextPos = pos
end

function ENT:FindNewObjective()
	local tbl = Falcon.AI.Objectives

	local obj = math.random(1, #tbl)
	local o = tbl[obj]

	if not o or not o:IsValid() then return false end

	self:SetNextObjective( o )
end



function ENT:HasObjective()
	if self.NextObjective and self.NextObjective:IsValid() then
		if self:GetRangeTo( self.NextPos ) > 100 then
			return true
		end
		self:SetNextPos( nil )
		return self:FindNewObjective()
	else
		return self:FindNewObjective()
	end
end



function ENT:FindEnemy()
	local p = player.GetAll()
	local dist = {}
	dist.range = 1500

	for _, ply in pairs( p ) do
		-- if dist.range < self:GetRangeTo( ply:GetPos() ) or not self:IsAbleToSee( ply, true ) then continue end
		if not ply:Alive() then continue end
		if self:GetRangeTo( ply:GetPos() ) > 1500 then continue end
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

function ENT:HaveEnemy()
	if self:GetEnemy() and self:GetEnemy():IsValid() and self:GetEnemy():Health() > 0 then
		if self:GetRangeTo( self:GetEnemy():GetPos() ) > 1500 and self:HasObjective() then
			self:SetEnemy( false )
			return false
		end
		return true
	else
		self:SetEnemy( false )
	end
	return self:FindEnemy()
end

local stopBehaviour = { ACT_HL2MP_IDLE_AR2, ACT_HL2MP_IDLE_CROUCH_AR2, ACT_HL2MP_IDLE_CROUCH_SHOTGUN, ACT_HL2MP_IDLE_SHOTGUN }
function ENT:RunBehaviour()

	while ( true ) do
		self.loco:SetAcceleration( 600 )
		if self:HasObjective() then
			self.loco:SetDesiredSpeed( self.RunSpeed )
			self:StartActivity(ACT_HL2MP_RUN_SHOTGUN)
			self:MovePosition( {} )
		elseif self:HaveEnemy() then
			self.loco:SetDesiredSpeed( self.RunSpeed )
			self:StartActivity(ACT_HL2MP_RUN_SHOTGUN)
			self:MovePosition( {} )
		else
			self.loco:SetDesiredSpeed( self.RunSpeed / 3 )
			if not self.HasStage then
				local stopAnim = math.random(1, #stopBehaviour)
				self:StartActivity(stopBehaviour[stopAnim])
				self.HasStage = true
			end
		end
		coroutine.wait(1)
	end

end

function ENT:CalculateNextPos()
	if not self:GetEnemy() then return end
	self:SetNextPos( self:GetEnemy():GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 350 )
end

function ENT:MovePosition( options )
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 100 )
	path:Compute( self, self.NextPos or self:GetEnemy():GetPos() )

	while ( self:HaveEnemy() or self:HasObjective() ) do
		local pos = self.NextPos or self:GetEnemy():GetPos()

		if self:GetEnemy() and self:GetPos():Distance( self:GetEnemy():GetPos() ) < 1250 then
			self.loco:FaceTowards( self:GetEnemy():GetPos() )
			self.loco:Approach( pos, 200 )
		else
			if ( path:GetAge() > 1 ) then
				path:Compute( self, pos )
			end
			
			path:Update( self )
		end


		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end
end



function ENT:OnTakeDamage( data )
	local attacker = data:GetAttacker()

	local chanceOfHurt = math.random(1, 10)
	if chanceOfHurt == 1 then
		self:EmitSound( "f_cigg/npcs/b1/pain" .. tostring(math.random(1, 47)) .. ".mp3", 900, 100, 1, CHAN_AUTO )
	end

	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo( data )
		self.m_bApplyingDamage = false
	end
end

function ENT:GiveWeapon()
	if CLIENT then return end
    self.Weapon = ents.Create("prop_physics")
    local pos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
    self.Weapon:SetOwner(self)
    up = 0
    forward = 9
    right = 0
    aforward = 0
    aup = 0
	aright = 11
    local AttachmentTab = self:GetAttachment(self:LookupAttachment("anim_attachment_RH"))
    self.Weapon:SetPos(AttachmentTab.Pos + AttachmentTab.Ang:Up()*up + AttachmentTab.Ang:Forward()*forward + AttachmentTab.Ang:Right()*right )
    -- self.Weapon:SetModel(self.WeaponModel)
    self.Weapon:SetModel("models/weapons/w_dc15a.mdl")
    self.Weapon:Spawn() 
    self.Weapon:PhysicsInit(SOLID_NONE)    
    self.Weapon:SetSolid(SOLID_NONE)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Forward(),aforward)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Up(),aup)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Right(),aright)

    self.Weapon:SetAngles( AttachmentTab.Ang )
    self.Weapon:SetParent(self, self:LookupAttachment("anim_attachment_RH")) 
end

function ENT:FireWeapon()
    local bullet = {}
    bullet.Num         = 1
    bullet.Src         = self.Weapon:GetPos()  
    bullet.Dir         = self:GetEnemy():LocalToWorld(self:GetEnemy():OBBCenter()) - self:GetBonePosition(11)
    bullet.Spread     = Vector( 45, 45, 0 ) * 1       
    bullet.Tracer    = 1
    bullet.TracerName = "lfs_laser_red_large"
    bullet.Force    = 0                        
    bullet.Damage    = 1
    bullet.AmmoType = "Pistol"
    bullet.Callback = function(att, tr, dmginfo)
      dmginfo:SetDamageType(DMG_BULLET)
    end

	if self.ShootSound then
		self:EmitSound( self.ShootSound, 900, 100, 1, CHAN_AUTO )
	end

    -- self:FireBullets( bullet )

	self.AttackDelay = CurTime() + self.AttackDelayTimer
end

function ENT:BodyUpdate()
	self:BodyMoveXY()
end
