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

function World:update(dt, player)
	self.ship:update(dt, player)
	-- station:update(dt)
end

function World:draw()
	self.ship:draw()
	-- station:draw()
end