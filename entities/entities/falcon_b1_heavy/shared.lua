AddCSLuaFile()

ENT.Base = "falcon_b1_base" 
ENT.Spawnable		= false
ENT.PrintName 		= "B1 Battledroid (Heavy)"

ENT.WeaponDamage = 6
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5c_blaster.mdl"
ENT.WeaponSpread = Vector( 120, 120, 120 )
ENT.AttackDelayTimer = 0.115

ENT.Model = "models/player/b1battledroids/b1_base_marine.mdl"

ENT.ShootSound = "f_cigg/npcs/b1/e5c.mp3"

ENT.HP = 350

list.Set( "NPC", "falcon_b1_heavy", {
	Name = "B1 Heavy Droid",
	Class = "falcon_b1_heavy",
	Category = "Falcon's NPCs"
})