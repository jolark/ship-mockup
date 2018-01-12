ShipRoom = {}

function ShipRoom:new()
	local object = {
		walls = {},
		lights = {},
		x = 0,
		y = 0
	}
	setmetatable(object, { __index = Ship })
	return object
end

function ShipRoom:update(dt)
	
end

function ShipRoom:draw()
	-- love.graphics.draw(image, x, y)
end

function ShipRoom:addLight(lightworld, light)
	local lite = lightworld:newLight(light.x, light.y, light.r, light.g, light.b, light.range)
	lite:setGlowStrength(light.glow)
	lite:setSmooth(light.smooth)
	table.insert(self.lights, lite)
end

function ShipRoom:addWall(wall)
	table.insert(self.walls, wall)
end

function ShipRoom:lightsOn()
	for _,light in self.lights do
		light:setVisible(true)
	end
end

function ShipRoom:lightsOff()
	for _,light in self.lights do
		light:setVisible(false)
	end
end