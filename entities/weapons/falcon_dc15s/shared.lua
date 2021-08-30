
 
SWEP.Author = "Your Name"
SWEP.Contact = "Your Email Address"
SWEP.Purpose = "What your SWep does."
SWEP.Instructions = "How to operate your SWep"
SWEP.RealName = "DC-15A"
 
SWEP.Category = "Falcon's SWEPs"
 
SWEP.Spawnable = true -- Whether regular players can see it
SWEP.AdminSpawnable = true -- Whether Admins/Super Admins can see it
 
SWEP.ViewModel = "models/weapons/v_dc15s.mdl" -- This is the model used for clients to see in first person.
SWEP.WorldModel = "models/weapons/w_dc15s.mdl" -- This is the model shown to all other clients and in third-person.
 
 
SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Delay = 0.125

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

local ShootSound = Sound("Metal.SawbladeStick")
 
function SWEP:Initialize()
	self:SetHoldType("shotgun")
end

function SWEP:Reload()
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
 
		self:DefaultReload( ACT_VM_RELOAD )
		local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
		self.ReloadingTime = CurTime() + AnimationTime
		self:SetNextPrimaryFire(CurTime() + AnimationTime)
		self:SetNextSecondaryFire(CurTime() + AnimationTime)
 
	end
end
 
function SWEP:Think()
	local owner = self:GetOwner()

	if owner:KeyDown( IN_ATTACK2 ) then
		self.IsAiming = true
	else
		self.IsAiming = false
	end

	if owner:Crouching() or owner:IsSprinting() or self.IsAiming then
		self:SetHoldType("ar2")
	else
		self:SetHoldType("shotgun")
	end
end

function SWEP:TakePrimaryAmmo( num )
	
	-- Doesn't use clips
	if ( self:Clip1() <= 0 ) then 
	
		if ( self:Ammo1() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self:GetPrimaryAmmoType() )
	
		return 
	end
	
	self:SetClip1( self:Clip1() - num )	
	
end

function SWEP:ShootBullet( damage )
	local ply = self:GetOwner()

	local bullet = {}
	bullet.Num 		= 1
	bullet.Src 		= self:GetPos()
	bullet.Dir 		= ply:GetAimVector()
	bullet.Spread 	= Vector( 0.02, 0.02, 0 )
	bullet.Tracer	= 1
	bullet.TracerName = "lfs_laser_blue"
	bullet.Force	= 1
	bullet.Damage	= damage
	bullet.AmmoType = self.Primary.Ammo
	
	ply:FireBullets( bullet )
	
	self:ShootEffects()
	self:TakePrimaryAmmo( 1 )
end
 
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local ply = self:GetOwner()

	ply:LagCompensation( true )
	self:ShootBullet( math.random(15, 40) )
	ply:LagCompensation( false )

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

end
 
function SWEP:SecondaryAttack()
end