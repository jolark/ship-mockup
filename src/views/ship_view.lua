local ship_view = { init = false }

-- libs
local Bump = require 'src.lib.bump'
local Camera = require 'src.lib.hump.camera'
local LightWorld = require 'src.lib.light'

-- modules
require 'src.player'
require 'src.views.asteroids'
require 'src.views.stars'

local VIEW_SCALE = 1

-- bump.lua stuff
local bumpWorld = Bump.newWorld()
-- light.lua stuff
local lightWorld
local playerShadow
-- hump.camera stuff
local camera

-- background objects
local asteroids = {}
local stars = {}


-- DEBUG TOOLS
local blocks = {}
local function drawBox(box, r, g, b)
    love.graphics.setColor(r, g, b, 70)
    love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

local function drawBlocks()
    for _, block in ipairs(blocks) do
        drawBox(block, 255, 0, 0)
    end
    love.graphics.setColor(255, 255, 255)
end

-- DEBUG TOOLS END

-- Sounds
local engineSound = love.audio.newSource('sound/325845__daveshu88__airplane-inside-ambient-cessna-414-condenser.mp3', 'static')
engineSound:setVolume(0.1)

function playSounds()
    engineSound:play()
end

function updateCamera(player)
    local dx, dy = player.x - camera.x, player.y - camera.y
    camera:move(dx / 2, dy / 2)
    lightWorld:setTranslation(-camera.x * VIEW_SCALE + love.graphics.getWidth() / 2, -camera.y * VIEW_SCALE + love.graphics.getHeight() / 2, VIEW_SCALE)
    playerShadow.x, playerShadow.y = player.x, player.y
end


local function initLights(ship)
    for _, room in ipairs(ship.rooms) do
        room:activateLights(lightWorld)
    end
end

local function initBlock(block)
    bumpWorld:add(block.name, block.x, block.y, block.w, block.h)
    lightWorld:newRectangle(block.x + block.w / 2, block.y + block.h / 2, block.w, block.h)
    -- DEBUG
    table.insert(blocks, block)
end

local function wallPositionUpdate(room, direction, door)
    if direction == 'up' then
        return {x=(room.position.x + door) * TILE_SIZE, y=room.position.y * TILE_SIZE}
    elseif direction == 'down' then
        return {x=(room.position.x + door) * TILE_SIZE, y=(room.position.y + room.size.h) * TILE_SIZE - 10}
    elseif direction == 'left' then
        return {x=room.position.x * TILE_SIZE, y=(room.position.y + door) * TILE_SIZE}
    elseif direction == 'right' then
        return {x=(room.position.x + room.size.w) * TILE_SIZE - 10, y=(room.position.y + door) * TILE_SIZE }
    end
end

local function initWallsBlocks(ship)
    -- 10 = fixed wall size... // FIXME
    for i, room in ipairs(ship.rooms) do
        for j, dir in ipairs({ 'up', 'down', 'left', 'right' }) do
            local dirIsUpOrDown = (dir == 'up' or dir == 'down')
            local currentPos = wallPositionUpdate(room, dir, 0)
            local lastdoor = 0
            table.sort(room.doors[dir])
            for k, door in ipairs(room.doors[dir]) do
                initBlock({
                    name = room.name .. i .. dir .. k, 
                    x = currentPos.x, 
                    y = currentPos.y, 
                    w = dirIsUpOrDown and (door - 1 - lastdoor) * TILE_SIZE or 10,
                    h = dirIsUpOrDown and 10 or (door - 1 - lastdoor) * TILE_SIZE
                    })
                currentPos = wallPositionUpdate(room, dir, door)
                lastdoor = door
            end
            initBlock({
                name = room.name .. i .. dir, 
                x = currentPos.x, 
                y = currentPos.y,
                w = dirIsUpOrDown and (room.size.w - lastdoor) * TILE_SIZE or 10,
                h = dirIsUpOrDown and 10 or (room.size.h - lastdoor) * TILE_SIZE
                })
        end
    end
end

local function initItemsBlocks(ship)
    for j, item in ipairs(ship.items) do
        initBlock({ name = item.block.name, x = item.block.x * TILE_SIZE, y = item.block.y * TILE_SIZE, w = item.block.w, h = item.block.h })
    end
end

local function printRoomNames(ship)
    love.graphics.setColor(0, 0, 0)
    for i, room in ipairs(ship.rooms) do
        love.graphics.print(room.name, (room.position.x + room.size.w / 2) * TILE_SIZE, (room.position.y + room.size.h / 2) * TILE_SIZE)
    end
    love.graphics.setColor(255, 255, 255)
end


-- Main LÖVE functions

function ship_view:load()
    -- player
    bumpWorld:add(ship_view.player, ship_view.player.x, ship_view.player.y, ship_view.player.w, ship_view.player.h)
    -- lights
    lightWorld = LightWorld({ ambient = { 75, 75, 75 } })
    initLights(ship_view.world.ship)
    playerShadow = lightWorld:newRectangle(ship_view.player.x, ship_view.player.y, 10, 10)
    -- stars
    initStars(stars)
    -- blocks
    initWallsBlocks(ship_view.world.ship)
    initItemsBlocks(ship_view.world.ship)
    -- camera
    camera = Camera(ship_view.player.x, ship_view.player.y)
    camera:zoom(VIEW_SCALE)
end

function ship_view:enter(previous, world, player)
    ship_view.world = world
    ship_view.player = player
    if not ship_view.init then
        ship_view:load()
    end
    ship_view.init = true
end

function ship_view:update(dt)
    updateStars(stars, ship_view.world.ship.speed)
    local colliding = updateAsteroids(asteroids, ship_view.world.ship)
    ship_view.world:update(dt, ship_view.player, colliding)
    if ship_view.player.switchedToFetcher then
       -- camera:move(1000, 0)
       updateCamera({x=ship_view.player.x - love.graphics.getWidth()/3, y=ship_view.player.y})
    else
        ship_view.player:update(bumpWorld, dt)
        updateCamera(ship_view.player)
    end
    lightWorld:update(dt)
    playSounds()
end


function ship_view:draw()
    camera:attach()
    lightWorld:draw(function()
        drawStars(stars)
        ship_view.world.ship:draw()
        drawAsteroids(asteroids)
        -- debug
        printRoomNames(ship_view.world.ship)
--        drawBlocks(world)
        -- debug end
        ship_view.player:draw()
    end)
    camera:detach()
end


return ship_view