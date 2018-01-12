local ship_view = { init = false }

-- libs
local Bump   = require 'lib.bump'
local Camera = require 'lib.hump.camera'
local Vector = require 'lib.hump.vector'
local Gamestate = require 'lib.hump.gamestate'
local LightWorld = require 'lib.light'

-- modules
require 'player'
require 'views.asteroids'
require 'views.stars'

local VIEW_SCALE = 1

-- World creation -- bump.lua stuff
local bumpworld = Bump.newWorld()
local lightWorld
local cols_len = 0 -- how many collisions are happening


local asteroids = {}
local stars = {}
local playerShadow
local tilt = false

-- Images

-- Sounds
local engineSound = love.audio.newSource( 'sound/325845__daveshu88__airplane-inside-ambient-cessna-414-condenser.mp3', 'static' )
engineSound:setVolume(0.1)

function playSounds()
	engineSound:play()
end

function updateCamera(player)
	local dx,dy = player.x - camera.x, player.y - camera.y
	camera:move(dx/2, dy/2)
	lightWorld:setTranslation(-camera.x * VIEW_SCALE + love.graphics.getWidth() / 2, -camera.y * VIEW_SCALE + love.graphics.getHeight() / 2, VIEW_SCALE)
	playerShadow.x, playerShadow.y = player.x, player.y
end

local function updateShip(dt, colliding)
	if #colliding > 0 then
		if math.random() > 0.90 then
			tilt = true
			if not ship_view.world.ship.engineLeftBreak and math.random() > 0.90 then
				ship_view.world.ship.engineLeftBreak = true
			end
			if not ship_view.world.ship.engineRightBreak and math.random() > 0.90 then
				ship_view.world.ship.engineRightBreak = true
			end
		end
	end
end

local function fuelUpdate()
	ship_view.world.ship.fuelLevel = ship_view.world.ship.fuelLevel - 0.01 * ship_view.world.ship.speed
end

local function updateEngines()
	if ship_view.world.ship.engineLeftBreak then
		lightsOn({'engine1'})
	else
		lightsOff({'engine1'})
	end
	if ship_view.world.ship.engineRightBreak then
		lightsOn({'engine2'})
	else
		lightsOff({'engine2'})
	end
	local maxSpeed = 8
	if ship_view.world.ship.engineLeftBreak or ship_view.world.ship.engineRightBreak then
		maxSpeed = 4
	end
	if ship_view.world.ship.engineLeftBreak and ship_view.world.ship.engineRightBreak then
		maxSpeed = 1
	end
	ship_view.world.ship.speed = math.min(maxSpeed, ship_view.world.ship.speed)
end


local function drawEngines()
	-- engine right
	if not ship_view.world.ship.engineLeftBreak then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle('fill', 278, 844, 40, 2)
	end
	love.graphics.rectangle('fill', 456, 844, 4, 2)
	-- engine left
	if not ship_view.world.ship.engineRightBreak then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle('fill', 272, 370, 40, 2)
	end
	love.graphics.rectangle('fill', 452, 370, 4, 2)
	-- reset color
	love.graphics.setColor(255,255,255)
end








local function initLights()
	-- FIXME : get light constructor params from somewhere
	local lobbylight = { x=624, y=648, r=155, g=130, b=0, range=1500, glow = 0.25, smooth = 1.5 }
	ship_view.world.ship.rooms[1]:addLight(lightWorld, lobbylight)
	local engineleftlight = { x=272, y=418, r=130, g=0, b=0, range=300, glow=0.5, smooth=1.5 } 
	ship_view.world.ship.rooms[1]:addLight(lightWorld, engineleftlight)
	local enginerightlight = { x=272, y=786, r=130, g=0, b=0, range=300, glow=0.5, smooth=1.5 } 
	ship_view.world.ship.rooms[1]:addLight(lightWorld, enginerightlight)
end


local function initBlocks(ship)
	for _,room in ipairs(ship.rooms) do
		for _,wall in ipairs(room.walls) do
			bumpworld:add(wall, wall[1], wall[2], wall[3], wall[4])
			lightWorld:newRectangle(wall[1], wall[2], wall[3], wall[4])
		end	
	end
end


-- Main LÖVE functions

function ship_view:load(world, player)
	-- player
	bumpworld:add(ship_view.player, ship_view.player.x, ship_view.player.y, ship_view.player.w, ship_view.player.h)
	-- lights
	lightWorld = LightWorld({ambient = {55,55,55}})
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
		ship_view:load(world, player)
	end
	ship_view.init = true
end

function ship_view:update(dt)
	cols_len = 0
	ship_view.player:update(bumpworld, cols_len, dt)
	updateStars(stars, ship_view.world.ship.speed)
	local colliding = updateAsteroids(asteroids, ship_view.world.ship.speed)
	-- updateShip(dt, colliding)
	-- updateEngines()
	-- fuelUpdate()
	ship_view.world:update(dt)
	updateCamera(ship_view.player)
	-- lightWorld:update(dt)
	playSounds()
end


function ship_view:draw()
	camera:attach()
	-- FIXME : lightworld burns memory
	lightWorld:draw(function()
		drawStars(stars)
		ship_view.world.ship:draw()
		drawEngines()
		drawAsteroids(asteroids)
		-- drawBlocks()
		ship_view.player:draw()
	end)
	camera:detach()
end


return ship_view