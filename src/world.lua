require 'src.ship.ship'

World = { }

function World:new()
	local object = {
		ship = {},
		station = {}
	}
	setmetatable(object, { __index = World })
	return object
end

function World:update(dt, player, colliding)
	self.ship:update(dt, player, colliding)
	-- station:update(dt)
end

function World:draw()
	self.ship:draw()
	-- station:draw()
end