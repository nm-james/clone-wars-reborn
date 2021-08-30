include('shared.lua') 
local mat_lightcone = Material( "models/Jellyton/BF2/Misc/Props/Command_Post/M_LightCone_01_Hi_D" )
local mat_lightcone = Material( "models/Jellyton/BF2/Misc/Props/Command_Post/M_LightCone_01_Hi_D" )

function ENT:Draw()
	self:DrawModel()

	if self:GetNWString("FALCON:ENTITY") ~= "" then
        mat_lightcone:SetVector( "$color2", Vector(0.2, 0.45, 1) )

		local pos = self:GetPos() - Vector(0, 0, 2)
        render.SetAmbientLight( 0, 0, 1 )
        render.SetMaterial( mat_lightcone )
        render.SetModelLighting( BOX_FRONT, 0,0,255 )
        render.DrawBeam(pos, pos + Vector(0, 0, 130), 90, 0, 1)
	end
end

function ENT:Think()
	if self:GetNWString("FALCON:ENTITY") then
		if not self.ModelEntity or self:GetNWString("FALCON:ENTITY") ~= self.ModelEntity.Model then
			if self.ModelEntity then
				self.ModelEntity:Remove()
			end

			local ent = ents.CreateClientProp()
			ent:SetModel(self:GetNWString("FALCON:ENTITY"))
			ent:SetPos( self:GetPos() + Vector( 0, 0, 28 ) )
			ent:SetAngles( self:GetAngles() )
			ent:SetMaterial("models/debug/debugwhite")
			ent:SetColor( Color( 45, 120, 235, 75 ) )
			ent:SetRenderMode( RENDERMODE_TRANSCOLOR )
			ent.Model = self:GetNWString("FALCON:ENTITY")
			ent:SetSequence( 106 )
			-- PrintTable(ent:GetSequenceList())
			self.ModelEntity = ent
		elseif self.ModelEntity then
			self.ModelEntity:SetPos( self:GetPos() + Vector( 0, 0, 25 ) )
			self.ModelEntity:SetAngles( self:GetAngles() )
		end
	end
end

function ENT:OnRemove()
	if self.ModelEntity then
		self.ModelEntity:Remove()
	end
end
	