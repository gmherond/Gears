LargeGear = class()
LargeGears = {}
--local previousAngularVelocity

function LargeGear.server_onCreate( self )
	sm.gui.chatMessage("hello world1")
	LargeGears[#LargeGears+1]=self
end

function LargeGear.server_onFixedUpdate(self, dt)
	local Body = sm.shape.getBody( self.shape )
	local angvel = -sm.body.getAngularVelocity( Body ) /3
	for _,largeGear in ipairs(LargeGears) do
        local lGear = sm.shape.getBody( largeGear.shape )
		sm.physics.applyTorque( lGear, angvel )
		
	end
	
end

function LargeGear.server_onDestroy(self)
	for i,LargeGear in ipairs(LargeGears) do
		if LargeGear == self then
			table.remove(LargeGears,i)
		end
	end
end

