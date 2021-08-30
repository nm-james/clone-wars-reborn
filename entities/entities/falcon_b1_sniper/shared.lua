AddCSLuaFile()

ENT.Base = "falcon_b1_base" 
ENT.Spawnable		= false
ENT.PrintName 		= "B1 Battledroid (Sniper)"

ENT.WeaponDamage = 175
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5s_blaster.mdl"
ENT.WeaponSpread = Vector( 10, 10, 10 )

ENT.Model = "models/player/b1battledroids/b1_base_security.mdl"
ENT.ShouldMoveAround = false
ENT.Attack = 1800
ENT.AttackDelayTimer = 3

ENT.ShootSound = "f_cigg/npcs/b1/e5s.mp3"

ENT.HP = 125

list.Set( "NPC", "falcon_b1_sniper", {
	Name = "B1 Sniper Droid",
	Class = "falcon_b1_sniper",
	Category = "Falcon's NPCs"
})