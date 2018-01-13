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

function Ship:randomlyBreakEngines(colliding)
    if colliding then
        if math.random() > 0.90 then
            if not self.engineLeftBreak and math.random() > 0.90 then
                self.engineLeftBreak = true
            end
            if not self.engineRightBreak and math.random() > 0.90 then
                self.ship.engineRightBreak = true
            end
        end
    end
end

function Ship:fuelUpdate()
    self.fuelLevel = self.fuelLevel - 0.01 * self.speed
end

function Ship:update(dt, player, colliding)
	for _,room in ipairs(self.rooms) do
		room:update(dt, player)
    end
    self:randomlyBreakEngines(colliding)
end

function Ship:draw()
--	love.graphics.draw(self.image, 0, 0, 0, 2)
	for _,room in ipairs(self.rooms) do
		room:draw()
	end
end