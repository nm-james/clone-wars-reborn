AddCSLuaFile( "shared.lua" )

include('shared.lua')

if CLIENT then return end

function ENT:Initialize()

	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetModel( Falcon.NPCData.Models[math.random(1, #Falcon.NPCData.Models)] )
	self:SetHealth( 25 )
	self:SetMaxHealth( 25 )

	self.loco:SetStepHeight( 20 )

	self.ExploredPlaces = {}
	self.NextMoveDelay = 0

end

function ENT:HasNextPos()
	if self.NextPos or self.NextHidingSpot then
		return true
	else
		if self.FearDelay and self.FearDelay > CurTime() then return false end
		return self:FindNextPost()
	end
	return false
end

function ENT:GoIntoFear()
	self.NextPos = false
	self.FearDelay = CurTime() + 20

	local spots = self:FindSpots( { type = "hiding", radius = 2200 } )

	local activeNextPos
	for id, places in pairs( spots ) do
		if not activeNextPos or spots[activeNextPos].distance < places.distance then
			activeNextPos = id
		end
	end

	self.NextHidingSpot = spots[activeNextPos].vector
end

function ENT:FindNextPost()
	local area = navmesh.GetNearestNavArea(self:GetPos(), false, 2000)
	local newPos

	if area and area:IsValid() then
		local spot = self:FindSpot( { type = "hiding", radius = 1350 } )
		
		newPos = spot
	else
		local nav = self.ExploredPlaces[math.random(1, #self.ExploredPlaces)]
		newPos = nav

		self.ExploredPlaces = {}
	end

	if newPos then
		self.NextPos = newPos:GetRandomPoint()
		return true
	end

	return false
end

function ENT:RunBehaviour()
	while ( true ) do
		self.loco:SetAcceleration( 600 )
		self.loco:SetDesiredSpeed( 80 )
		if self.FearDelay and self.FearDelay > CurTime() then
			if self.NextHidingSpot then
				self.loco:SetDesiredSpeed( 420 )
				self:StartActivity(ACT_HL2MP_RUN)
			else

			end
		elseif self:HasNextPos() then
			self:StartActivity(ACT_HL2MP_WALK)
			self:MovePosition( {
				tolerance = 110
			} )
		else
			self:StartActivity(ACT_IDLE)
		end
		coroutine.wait(1)
	end

end

function ENT:MovePosition( options )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 1350 )
	path:SetGoalTolerance( options.tolerance or 150 )
	path:Compute( self, self.NextPos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HasNextPos() ) do

		local pos = self.NextPos

		if not pos then
			pos = self.NextHidingSpot
		end

		if self:GetRangeTo(pos) <= 110 then
			if self.NextHidingSpot then
				self.NextHidingSpot = nil
			else
				self.NextPos = nil
			end
			break
		end

		if ( path:GetAge() > 0.1 ) then	
			path:Compute( self, pos )
		end
		path:Update( self )
		
		if ( options.draw ) then path:Draw() end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:OnInjured( dmg )
	for _, nextBots in pairs( ents.FindInSphere(self:GetPos(), 2000) ) do
		if not nextBots:IsNextBot() then continue end
		nextBots:GoIntoFear()
	end
end

function ENT:BodyUpdate()
	self:BodyMoveXY()
end
