ShipRoom = {}

local floorTile = love.graphics.newImage('img/floor-tile.png')
local wallTile = love.graphics.newImage('img/wall-tile.png')
local cornerTile = love.graphics.newImage('img/corner-tile.png')

function ShipRoom:new(name, xpos, ypos, width, height, someaccess, somelights)
	local object = {
        name = name,
        position = {x=xpos, y=ypos} or {x=0, y=0},
        size = {w=width, h=height} or {w=0, h=0},
        access = someaccess or {up=false, down=false, right=false, left=false},
		lights = somelights or {}
	}
	setmetatable(object, { __index = ShipRoom })
	return object
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


function ShipRoom:update(dt)
end

function ShipRoom:draw()
	for i=1,self.size.w do
		for j=1,self.size.h do
            if i == 1 and j == 1 then -- upleft corner
                love.graphics.draw(cornerTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1))
            elseif i == 1 and j == self.size.h then -- downleft corner
                love.graphics.draw(cornerTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1), 0, 1, -1, 0, TILE_SIZE)
            elseif i == self.size.w and j == 1 then -- upright corner
                love.graphics.draw(cornerTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1), 0, -1, 1, TILE_SIZE)
            elseif i == self.size.w and j == self.size.h then -- downright corner
                love.graphics.draw(cornerTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1), 0, -1, -1, TILE_SIZE, TILE_SIZE)
            elseif i % self.size.w == 1 then -- wall left
                love.graphics.draw(wallTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1), -math.pi/2, 1, 1, TILE_SIZE)
            elseif i == self.size.w then -- wall right
                love.graphics.draw(wallTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1), math.pi/2, 1, 1, 0, TILE_SIZE)
            elseif j == 1 then -- wall up
                love.graphics.draw(wallTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1))
            elseif j == self.size.h then -- wall down
                love.graphics.draw(wallTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1), 0, 1, -1, 0, TILE_SIZE)
            else
                love.graphics.draw(floorTile, self.position.x + TILE_SIZE * (i - 1), self.position.y + TILE_SIZE * (j - 1))
            end
        end
	end
end