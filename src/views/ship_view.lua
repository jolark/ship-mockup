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
        return {x=room.position.x + door, y=room.position.y }
    elseif direction == 'down' then
        return {x=room.position.x + door, y=room.position.y + room.size.h }
    elseif direction == 'left' then
        return {x=room.position.x, y=room.position.y + door}
    elseif direction == 'right' then
        return {x=room.position.x + room.size.w, y=room.position.y + door }
    end
end

local function initWallsBlocks(ship)
    for i, room in ipairs(ship.rooms) do
        for j, dir in ipairs { 'up', 'down' } do
            -- wall up
            print(room.doors['up'])
            if #room.doors[dir] > 0 then
                local currentPos = wallPositionUpdate(room, dir, 0)
                for k, door in room.doors do
                    initBlock({ name = room.name .. i .. dir .. k, x = currentPos.x * TILE_SIZE, y = currentPos.y * TILE_SIZE, w = (door - 1) * TILE_SIZE, h = 10 })
                    --                initBlock({name=room.name .. i .. 'up2', x=(room.position.x + room.doors.up) * TILE_SIZE, y=room.position.y* TILE_SIZE, w=(room.size.w - room.doors.up) * TILE_SIZE, h=10})
                    currentPos = wallPositionUpdate(room, dir, door)
                end
            else
                initBlock({ name = room.name .. i .. 'up', x = room.position.x * TILE_SIZE, y = room.position.y * TILE_SIZE, w = room.size.w * TILE_SIZE, h = 10 }) -- 10 = wall size... // FIXME
            end
        end

        -- if room.doors.up ~= 0 then
        --     initBlock({name=room.name .. i .. 'up1', x=room.position.x * TILE_SIZE, y=room.position.y* TILE_SIZE, w=(room.doors.up - 1) * TILE_SIZE, h=10})
        --     initBlock({name=room.name .. i .. 'up2', x=(room.position.x + room.doors.up) * TILE_SIZE, y=room.position.y* TILE_SIZE, w=(room.size.w - room.doors.up) * TILE_SIZE, h=10})
        -- else
        --     initBlock({name=room.name .. i .. 'up', x=room.position.x * TILE_SIZE, y=room.position.y* TILE_SIZE, w=room.size.w * TILE_SIZE, h=10}) -- 10 = wall size... // FIXME
        -- end
        -- -- wall down
        -- if room.doors.down ~= 0 then
        --     initBlock({name=room.name .. i .. 'down1', x=room.position.x * TILE_SIZE, y=(room.position.y + room.size.h) * TILE_SIZE - 10, w=(room.doors.down - 1) * TILE_SIZE, h=10})
        --     initBlock({name=room.name .. i .. 'down2', x=(room.position.x + room.doors.down) * TILE_SIZE, y=(room.position.y + room.size.h) * TILE_SIZE - 10, w=(room.size.w - room.doors.down) * TILE_SIZE, h=10})
        -- else
        --     initBlock({name=room.name .. i .. 'down', x=room.position.x * TILE_SIZE, y=(room.position.y + room.size.h) * TILE_SIZE - 10, w=room.size.w * TILE_SIZE, h=10})
        -- end
        -- -- wall left
        -- if room.doors.left ~= 0 then
        --     initBlock({name=room.name .. i .. 'left1', x=room.position.x * TILE_SIZE, y=room.position.y * TILE_SIZE, w=10, h=(room.doors.left - 1) * TILE_SIZE})
        --     initBlock({name=room.name .. i .. 'left2', x=room.position.x * TILE_SIZE, y=(room.position.y + room.doors.left) * TILE_SIZE, w=10, h=(room.size.h - room.doors.left) * TILE_SIZE})
        -- else
        --     initBlock({name=room.name .. i .. 'left', x=room.position.x * TILE_SIZE, y=room.position.y * TILE_SIZE, w=10, h=room.size.h * TILE_SIZE})
        -- end
        -- -- wall right
        -- if room.doors.right ~= 0 then
        --     initBlock({name=room.name .. i .. 'right1', x=(room.position.x + room.size.w) * TILE_SIZE - 10, y=room.position.y * TILE_SIZE, w=10, h=(room.doors.right - 1) * TILE_SIZE})
        --     initBlock({name=room.name .. i .. 'right2', x=(room.position.x + room.size.w) * TILE_SIZE - 10, y=(room.position.y + room.doors.right) * TILE_SIZE, w=10, h=(room.size.h - room.doors.right) * TILE_SIZE})
        -- else
        --     initBlock({name=room.name .. i .. 'right', x=(room.position.x + room.size.w) * TILE_SIZE - 10, y=room.position.y * TILE_SIZE, w=10, h=room.size.h * TILE_SIZE})
        -- end
    end
end

local function initItemsBlocks(ship)
    for j, item in ipairs(ship.items) do
        initBlock({ name = item.block.name, x = item.block.x * TILE_SIZE, y = item.block.y * TILE_SIZE, w = item.block.w, h = item.block.h })
    end
end


-- Main LÖVE functions

function ship_view:load()
    -- player
    bumpWorld:add(ship_view.player, ship_view.player.x, ship_view.player.y, ship_view.player.w, ship_view.player.h)
    -- lights
    lightWorld = LightWorld({ ambient = { 55, 55, 55 } })
    initLights(ship_view.world.ship)
    playerShadow = lightWorld:newRectangle(ship_view.player.x, ship_view.player.y, 10, 10)
    -- stars
    initStars(stars)
    -- blocks
    initBlocks(ship_view.world.ship)
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
    ship_view.player:update(bumpWorld, dt)
    updateStars(stars, ship_view.world.ship.speed)
    local colliding = updateAsteroids(asteroids, ship_view.world.ship)
    ship_view.world:update(dt, ship_view.player, colliding)
    updateCamera(ship_view.player)
    lightWorld:update(dt)
    playSounds()
end


function ship_view:draw()
    camera:attach()
    lightWorld:draw(function()
        drawStars(stars)
        ship_view.world.ship:draw()
        drawAsteroids(asteroids)
        drawBlocks(world)
        ship_view.player:draw()
    end)
    camera:detach()
end


return ship_view