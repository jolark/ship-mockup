ShipRoom = {}

local floorTile = love.graphics.newImage('img/floor-tile.png')
local wallTile = love.graphics.newImage('img/wall-tile.png')
local cornerTile = love.graphics.newImage('img/corner-tile.png')

function ShipRoom:new(name, xpos, ypos, width, height, somelights)
	local object = {
        name = name,
        position = {x=xpos, y=ypos} or {x=0, y=0},
        size = {w=width, h=height} or {w=0, h=0},
		fakeLights = somelights or {},
        realLights = {},
        doors = {up=0, down=0, right=0, left=0},
	}
	setmetatable(object, { __index = ShipRoom })
	return object
end

-- called at creation
function ShipRoom:addLight(light)
    table.insert(self.fakeLights, light)
end

-- called in ship_view : fake lights become real lights --FIXME ?
function ShipRoom:activateLights(lightworld)
    for _,light in ipairs(self.fakeLights) do
        local lite = lightworld:newLight(light.x, light.y, light.r, light.g, light.b, light.range)
        lite:setGlowStrength(light.glow)
        lite:setSmooth(light.smooth)
        table.insert(self.realLights, lite)
    end
end

function ShipRoom:lightsOn()
	for _,light in ipairs(self.realLights) do
		light:setVisible(true)
	end
end

function ShipRoom:lightsOff()
	for _,light in ipairs(self.realLights) do
		light:setVisible(false)
	end
end

function ShipRoom:drawWalls()
    for i=1,self.size.w do
        for j=1,self.size.h do
            if i == 1 and j == 1 then -- upleft corner
                love.graphics.draw(cornerTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
            elseif i == 1 and j == self.size.h then -- downleft corner
                love.graphics.draw(cornerTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), 0, 1, -1, 0, TILE_SIZE)
            elseif i == self.size.w and j == 1 then -- upright corner
                love.graphics.draw(cornerTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), 0, -1, 1, TILE_SIZE)
            elseif i == self.size.w and j == self.size.h then -- downright corner
                love.graphics.draw(cornerTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), 0, -1, -1, TILE_SIZE, TILE_SIZE)
            elseif i % self.size.w == 1 then -- wall left
                if j == self.doors.left then
                    love.graphics.draw(floorTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
                else
                    love.graphics.draw(wallTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), -math.pi/2, 1, 1, TILE_SIZE)
                end
            elseif i == self.size.w then -- wall right
                if j == self.doors.right then
                    love.graphics.draw(floorTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
                else
                    love.graphics.draw(wallTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), math.pi/2, 1, 1, 0, TILE_SIZE)
                end
            elseif j == 1 then -- wall up
                if i == self.doors.up then
                    love.graphics.draw(floorTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
                else
                    love.graphics.draw(wallTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
                end
            elseif j == self.size.h then -- wall down
                if i == self.doors.down then
                    love.graphics.draw(floorTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
                else
                    love.graphics.draw(wallTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), 0, 1, -1, 0, TILE_SIZE)
                end
            else
                love.graphics.draw(floorTile, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1))
            end
        end
    end
end


function ShipRoom:update(dt, player)

end

function ShipRoom:draw()
	self:drawWalls()
end