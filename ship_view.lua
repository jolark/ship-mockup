local ship_view = { engineBreak = false, speed = 1 }

-- libs
local Bump   = require 'lib.bump'
local Camera = require 'lib.hump.camera'
local Vector = require 'lib.hump.vector'
local Gamestate = require 'lib.hump.gamestate'
local LightWorld = require 'lib.light'

-- modules
require 'player'
require 'asteroids'
require 'stars'
require 'blocks'
require 'lights'

-- World creation -- bump.lua stuff
local world = Bump.newWorld()
local lightWorld
local cols_len = 0 -- how many collisions are happening

local VIEW_SCALE = 1


local asteroids = {}
local stars = {}
local lights = {}
local playerShadow
local tilt = false

-- Images
local shipImage = love.graphics.newImage('img/ship.png')
local boardAnimation = newAnimation(love.graphics.newImage('img/board-lights.png'), 103, 1, 'down', 5)
local cockpitAnimation = newAnimation(love.graphics.newImage('img/cockpit.png'), 33, 77, 'right', 3)
local tvAnimation = {delay=50, rgba={math.random(100,255), math.random(100,255), math.random(100,255), math.random(50,150)}}

-- Sounds
local engineSound = love.audio.newSource( 'sound/325845__daveshu88__airplane-inside-ambient-cessna-414-condenser.mp3', 'static' )
engineSound:setVolume(0.1)

function playSounds()
	engineSound:play()
end

function updateCamera()
	local dx,dy = player.x - camera.x, player.y - camera.y
	camera:move(dx/2, dy/2)
	lightWorld:setTranslation(-camera.x * VIEW_SCALE + love.graphics.getWidth() / 2, -camera.y * VIEW_SCALE + love.graphics.getHeight() / 2, VIEW_SCALE)
	playerShadow.x, playerShadow.y = player.x, player.y
end

local function updateShip(dt, colliding)
	if #colliding > 0 then
		if math.random() > 0.90 then
			tilt = true
			if math.random() > 0.70 then
				ship_view.engineBreak = true
			end
		end
	end

	-- animations
	animationUpdate(boardAnimation, dt)
	animationUpdate(cockpitAnimation, dt)
	-- tv animation update
	tvAnimation.delay = math.max(0, tvAnimation.delay - 1)
	if tvAnimation.delay == 0 then
		tvAnimation.rgba = {math.random(200, 255), math.random(200, 255), math.random(200, 255), math.random(50, 100)}
		tvAnimation.delay = math.random(1, 50)
	end
end

local function drawShip()
	if tilt then
		love.graphics.draw(shipImage, 2, 2, 0, 2)
		tilt = false
	else
		love.graphics.draw(shipImage, 0, 0, 0, 2)
	end
	-- engine boards animations
	local spriteNum = math.floor(boardAnimation.currentTime / boardAnimation.duration * #boardAnimation.quads) + 1
	love.graphics.draw(boardAnimation.spriteSheet, boardAnimation.quads[spriteNum], 270, 834, 0, 2)
	love.graphics.draw(boardAnimation.spriteSheet, boardAnimation.quads[spriteNum], 264, 378, 0, 2)
	-- tv animation
	love.graphics.setColor(tvAnimation.rgba)
	love.graphics.polygon('fill', 596, 334, 910, 334, 812, 504, 696, 504)
	
	love.graphics.setColor(255,255,255)
end








-- Main LÖVE functions

function ship_view:enter(previous, engineBreak, speed)
	ship_view.engineBreak = engineBreak
	ship_view.speed = speed
end

function ship_view:load()
	-- player
	world:add(player, player.x, player.y, player.w, player.h)
	-- ship walls and objects
	initBlocks(world)
	-- stars
	initStars(stars)
	-- blocks
	local blocks = initBlocks(world)
	-- lights
	lightWorld = LightWorld({ambient = {55,55,55}})
	addShipLights(lightWorld, blocks)
	playerShadow = lightWorld:newRectangle(player.x, player.y, 10, 10)
	-- camera
	camera = Camera(player.x, player.y)
	camera:zoom(VIEW_SCALE)
end

function ship_view:update(dt)
	cols_len = 0
	player:update(world, cols_len, dt)
	updateStars(stars, ship_view.speed)
	local colliding = updateAsteroids(asteroids)
	updateShip(dt, colliding)
	updateCamera()
	lightWorld:update(dt)
	if ship_view.engineBreak then
		lightsOn({'engine1', 'engine2'})
	else
		lightsOff({'engine1', 'engine2'})
	end
	playSounds()
end


function ship_view:draw()
	camera:attach()
	lightWorld:draw(function()
		drawStars(stars)
		drawShip()
		drawAsteroids(asteroids)
		-- drawBlocks()
		player:draw()
	end)
	camera:detach()
end


return ship_view