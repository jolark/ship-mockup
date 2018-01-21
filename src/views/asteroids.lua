local Vector = require 'src.lib.hump.vector'

-- Asteroids

local crashSound1 = love.audio.newSource('sound/207930__klankbeeld__bang-prison-door-loop-130903-00-1.mp3', 'static')
local crashSound2 = love.audio.newSource('sound/207930__klankbeeld__bang-prison-door-loop-130903-00-2.mp3', 'static')
local crashSound3 = love.audio.newSource('sound/207930__klankbeeld__bang-prison-door-loop-130903-00-3.mp3', 'static')
local crashSound4 = love.audio.newSource('sound/207930__klankbeeld__bang-prison-door-loop-130903-00-4.mp3', 'static')


local function sign(p1, p2, p3)
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
end

local function pointInTriangle(pt, trgl)
    local b1 = sign(pt, trgl[1], trgl[2]) < 0
    local b2 = sign(pt, trgl[2], trgl[3]) < 0
    local b3 = sign(pt, trgl[3], trgl[1]) < 0
    return (b1 == b2) and (b2 == b3)
end

-- v1----v2
-- |     |
-- |     |
-- v3----(v4)
local function pointInRectangle(pt, rect)
    return pt.x >= rect[1].x and pt.x <= rect[2].x and pt.y >= rect[1].y and pt.y <= rect[3].y
end

local function onShip(asteroid, ship)
    for _, room in ipairs(ship.rooms) do
        local rect = { { x = room.position.x * TILE_SIZE, y = room.position.y * TILE_SIZE}, { x = (room.position.x + room.size.w) * TILE_SIZE, y = room.position.y * TILE_SIZE }, { x = room.position.x * TILE_SIZE, y = (room.position.y + room.size.h) * TILE_SIZE } }
        if pointInRectangle(asteroid, rect) then
            return true
        end
    end
    return false
end

function updateAsteroids(asteroids, ship)
    -- randomly create a falling asteroid
    local fall = math.random()
    if fall > 1 - 0.001 * ship.speed then
        -- asteroid can come from up, down or right
        local side = love.math.random(3)
        local origin = {}
        if side == 1 then
            origin = { love.graphics.getWidth() * 2, love.math.random(love.graphics.getHeight()) }
        elseif side == 2 then
            origin = { love.math.random(love.graphics.getWidth()), 0 }
        elseif side == 3 then
            origin = { love.math.random(love.graphics.getWidth()), love.graphics.getHeight() }
        end
        local destination = { 0, love.math.random(love.graphics.getHeight()) }
        local newSpeed = love.math.random(3, 10)
        table.insert(asteroids, { x = origin[1], y = origin[2], xdest = destination[1], ydest = destination[2], speed = newSpeed })
    end
    -- asteroid movement
    local colliding = {}
    local lostInSpace = {}
    for i, asteroid in ipairs(asteroids) do
        if (asteroid.x == asteroid.xdest and asteroid.y == asteroid.ydest) then
            table.insert(lostInSpace, i)
        elseif onShip(asteroid, ship) then
            table.insert(colliding, i)
        else
            local diff = Vector(asteroid.xdest - asteroid.x, asteroid.ydest - asteroid.y)
            diff:normalizeInplace()
            if diff.x < 0 then
                asteroid.x = math.max(asteroid.xdest, asteroid.x + asteroid.speed * diff.x)
            elseif diff.x > 0 then
                asteroid.x = math.min(asteroid.xdest, asteroid.x + asteroid.speed * diff.x)
            end
            if diff.y < 0 then
                asteroid.y = math.max(asteroid.ydest, asteroid.y + asteroid.speed * diff.y)
            elseif diff.y > 0 then
                asteroid.y = math.min(asteroid.ydest, asteroid.y + asteroid.speed * diff.y)
            end
        end
    end
    -- colliding asteroids
    for _, x in ipairs(colliding) do
        crashSound1:stop()
        crashSound2:stop()
        crashSound3:stop()
        crashSound4:stop()
        love.audio.play(choose({ crashSound1, crashSound2, crashSound3, crashSound4 }))
        table.remove(asteroids, x)
    end
    for _,x in ipairs(lostInSpace) do
        table.remove(asteroids, x)
    end
    return #colliding > 0
end

function drawAsteroids(asteroids)
    for _, asteroid in ipairs(asteroids) do
        love.graphics.rectangle('fill', asteroid.x, asteroid.y, 10, 10)
    end
end