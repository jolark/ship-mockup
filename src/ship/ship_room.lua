require 'src.utils'

ShipRoom = {}

local floorTile = love.graphics.newImage('img/floor-tile.png')
local wallTile = love.graphics.newImage('img/wall-tile.png')
local cornerTile = love.graphics.newImage('img/corner-tile.png')
local outsideTile = love.graphics.newImage('img/outside-deco.png')
local outsideCornerTile = love.graphics.newImage('img/outside-deco-corner.png')

function ShipRoom:new(name, xpos, ypos, width, height, somelights)
    local object = {
        name = name,
        position = { x = xpos, y = ypos } or { x = 0, y = 0 },
        size = { w = width, h = height } or { w = 0, h = 0 },
        fakeLights = somelights or {},
        realLights = {},
        doors = { up = {}, down = {}, right = {}, left = {} },
        outside = { up = {}, down = {}, right = {}, left = {} },
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
    for _, light in ipairs(self.fakeLights) do
        local lite = lightworld:newLight(light.x, light.y, light.r, light.g, light.b, light.range)
        lite:setGlowStrength(light.glow)
        lite:setSmooth(light.smooth)
        table.insert(self.realLights, lite)
    end
end

function ShipRoom:lightsOn()
    for _, light in ipairs(self.realLights) do
        light:setVisible(true)
    end
end

function ShipRoom:lightsOff()
    for _, light in ipairs(self.realLights) do
        light:setVisible(false)
    end
end

function ShipRoom:drawTile(tileImage, i, j, rot, sx, sy, ox, oy)
    love.graphics.draw(tileImage, TILE_SIZE * self.position.x + TILE_SIZE * (i - 1), TILE_SIZE * self.position.y + TILE_SIZE * (j - 1), rot or 0, sx or 1, sy or 1, ox or 0, oy or 0)
end

function ShipRoom:drawWalls()
    for i = 1, self.size.w do
        for j = 1, self.size.h do
            if i == 1 and j == 1 then -- upleft corner
                self:drawTile(cornerTile, i, j)
            elseif i == 1 and j == self.size.h then -- downleft corner
                self:drawTile(cornerTile, i, j, 0, 1, -1, 0, TILE_SIZE)
            elseif i == self.size.w and j == 1 then -- upright corner
                self:drawTile(cornerTile, i, j, 0, -1, 1, TILE_SIZE)
            elseif i == self.size.w and j == self.size.h then -- downright corner
                self:drawTile(cornerTile, i, j, 0, -1, -1, TILE_SIZE, TILE_SIZE)
            elseif i % self.size.w == 1 and not inTable(self.doors.left, j) then -- wall left
                self:drawTile(wallTile, i, j, -math.pi / 2, 1, 1, TILE_SIZE)
            elseif i == self.size.w and not inTable(self.doors.right, j) then -- wall right
                self:drawTile(wallTile, i, j, math.pi / 2, 1, 1, 0, TILE_SIZE)
            elseif j == 1 and not inTable(self.doors.up, i) then -- wall up
                self:drawTile(wallTile, i, j)
            elseif j == self.size.h and not inTable(self.doors.down, i) then -- wall down
                self:drawTile(wallTile, i, j, 0, 1, -1, 0, TILE_SIZE)
            else -- everything else is the floor
                self:drawTile(floorTile, i, j)
            end
        end
    end
end

function ShipRoom:drawOutside()
    for _, dir in ipairs({ 'up', 'down', 'left', 'right' }) do
        if #self.outside[dir] > 0 then
            for i = self.outside[dir][1], self.outside[dir][2] do
                if dir == 'up' then
                    self:drawTile(outsideTile, i, 0)
                elseif dir == 'down' then
                    self:drawTile(outsideTile, i, self.size.h + 2, 0, 1, -1)
                elseif dir == 'left' then
                    self:drawTile(outsideTile, 0, i + 1, -math.pi/2)
                elseif dir == 'right' then
                    self:drawTile(outsideTile, self.size.w + 2, i, math.pi/2)
                end
            end
            -- corners
            if dir == 'up' then
                if #self.outside['left'] > 0 then
                    self:drawTile(outsideCornerTile, self.outside[dir][1] - 1, 0)
                end
                if #self.outside['right'] > 0 then
                    self:drawTile(outsideCornerTile, self.outside[dir][2] + 2, 0, 0, -1)
                end
            elseif dir == 'down' then
                if #self.outside['left'] > 0 then
                    self:drawTile(outsideCornerTile, self.outside[dir][1] - 1, self.size.h + 2, 0, 1, -1)
                end
                if #self.outside['right'] > 0 then
                    self:drawTile(outsideCornerTile, self.outside[dir][2] + 2, self.size.h + 2, 0, -1, -1)
                end
            end

        end
    end
end


function ShipRoom:update(dt, player)
end

function ShipRoom:draw()
    self:drawWalls()
    self:drawOutside()
end