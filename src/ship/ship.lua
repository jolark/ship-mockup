require 'src.ship.ship_room'

Ship = { }

function Ship:new()
	local object = {
		rooms = {},
		speed = 1,
		fuelLevel = 100,
		engineLeftBreak = false,
		engineRightBreak = false,
		image = love.graphics.newImage('img/ship.png')
	}
	setmetatable(object, { __index = Ship })
	return object
end

function Ship:addRoom(shipRoom)
	table.insert(self.rooms, shipRoom)
end


function Ship:getRooms()
    return self.rooms
end

function Ship:update(dt, player)
	for _,room in ipairs(self.rooms) do
		room:update(dt, player)
	end
end

function Ship:draw()
--	love.graphics.draw(self.image, 0, 0, 0, 2)
	for _,room in ipairs(self.rooms) do
		room:draw()
	end
end