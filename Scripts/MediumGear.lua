MediumGear = class()
MediumGears = {}
MediumGear.maxParentCount = 1
MediumGear.maxChildCount = 1
MediumGear.connectionInput = sm.interactable.connectionType.power
MediumGear.connectionOutput = sm.interactable.connectionType.bearing
MediumGear.colorNormal = sm.color.new( 0xeeeeeeee )
MediumGear.colorHighlight = sm.color.new( 0xffffffff )


function MediumGear.server_onCreate( self )
	sm.gui.chatMessage("New Gear ID "..tostring(self.shape.id))
	MediumGears[#MediumGears+1]=self
end

function MediumGear.server_onFixedUpdate(self, dt)
	print(#LargeGears)
	if #self.interactable:getBearings()> 0 then

		local Body = sm.shape.getBody(self.shape)
		local thisBearing = self:getParentBearing(self)
		
		for _,mediumGear in ipairs(MediumGears) do
			if #mediumGear.interactable:getBearings()> 0 then

				if self:checkIfAdjacent(self.shape,mediumGear.shape) then
					
					local mGear = sm.shape.getBody( mediumGear.shape )
					local mGearBearing = self:getParentBearing(mediumGear)
					local fastBearing = mGearBearing
					local slowBearing = thisBearing
					if math.abs(thisBearing:getAngularVelocity()) > math.abs(mGearBearing:getAngularVelocity()) then
						slowBearing = mGearBearing
						fastBearing = thisBearing
					end
					local targetVelocity = fastBearing:getAngularVelocity()*0.99
					slowBearing:setMotorVelocity(targetVelocity, math.abs(fastBearing:getShapeB():getBody():getMass()*fastBearing:getAngularVelocity()*0.01))
					fastBearing:setMotorVelocity(slowBearing:getAngularVelocity()*0.99,math.abs((slowBearing:getShapeB():getBody():getMass())*slowBearing:getAngularVelocity()*0.01))
				end
			end
		end
	end
end

function MediumGear.server_onDestroy(self)
	for i,mediumGear in ipairs(MediumGears) do
		if mediumGear == self then
			table.remove(MediumGears,i)
		end
	end
end

function MediumGear.compareDirection(self,shape1,shape2)

	local at1 = sm.shape.getAt( shape1 )
	local at2 = sm.shape.getAt( shape2 )
	--sm.gui.chatMessage(tostring(at1.x).." "..tostring(at1.y).." "..tostring(at1.z))
	--sm.gui.chatMessage(tostring(at2.x).." "..tostring(at2.y).." "..tostring(at2.z))
	if math.floor(at1.x) == math.floor(at2.x) and math.floor(at1.y) == math.floor(at2.y) and math.floor(at1.z) == math.floor(at2.z) then
		return true
	else
		return false
	end
end

function MediumGear.compareIDs( self , shape1, shape2 )
	local id1 = sm.shape.getId( shape1 )
	--sm.gui.chatMessage(tostring(id1))
	local id2 = sm.shape.getId( shape2 )
	--sm.gui.chatMessage(tostring(id2))
	if id1 == id2 then
		return true
	else
		return false
	end
end
	
function MediumGear.checkIfAdjacent( self , shape1, shape2 )
	local isAdjacent = false
	if self:compareIDs(shape1,shape2) ~= true then
		
		
		local worldPosition1 = sm.shape.getWorldPosition( shape1 )
		local worldPosition2 = sm.shape.getWorldPosition( shape2 )
		local at1 = self:floorVector(sm.shape.getAt( shape1 ))
		local at2 = self:floorVector(sm.shape.getAt( shape2 ))
		local distance = math.sqrt( (worldPosition1.x-worldPosition2.x)^2 + (worldPosition1.y-worldPosition2.y)^2 + (worldPosition1.z-worldPosition2.z)^2 )

		if(distance < 1) then
			isAdjacent = true
		else
			isAdjacent = false
		end
	end
	return isAdjacent
end

function MediumGear.floorVector( self , vector )
	return sm.vec3.new(math.floor(vector.x),math.floor(vector.y),math.floor(vector.z))
end

function MediumGear.absVector(self, vector )
	return sm.vec3.new(math.abs(vector.x),math.abs(vector.y),math.abs(vector.z))
end

function MediumGear.printVector( self , vector )
	sm.gui.chatMessage(tostring(vector.x).." "..tostring(vector.y).." "..tostring(vector.z))
end

function MediumGear.getParentBearing(self,obj)
	local bearings = obj.interactable:getBearings()
	for _,bearing in ipairs(bearings) do
		if bearing.shapeB.id == obj.shape.id then
			return bearing
		end
	end
end