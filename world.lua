require 'ship.ship'

World = { }

function World:new()
	local object = {
		ship = {},
		station = {}
	}
	setmetatable(object, { __index = World })
	return object
end

function World:update(dt)
	self.ship:update(dt)
	-- station:update(dt)
end

function World:draw()
	self.ship:draw()
	-- station:draw()
end