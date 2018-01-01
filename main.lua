-- libs
local Bump   = require 'lib.bump'
local Camera = require 'lib.camera'
local Vector = require 'lib.vector'
local LightWorld = require 'lib.light'

-- modules
require 'player'
require 'asteroids'
require 'stars'
require 'blocks'
require 'lights'


-- World creation -- bump.lua stuff
local world = Bump.newWorld()
local cols_len = 0 -- how many collisions are happening

local VIEW_SCALE = 2

local player = Player:new()
local asteroids = {}
local stars = {}
local lights = {}
local playerShadow

-- Images
local shipImage = love.graphics.newImage('ship.png')

-- Sounds
local engineSound = love.audio.newSource( '325845__daveshu88__airplane-inside-ambient-cessna-414-condenser.mp3', 'static' )
engineSound:setVolume(0.1)

function playSounds()
	engineSound:play()
end

function updateCamera()
	local dx,dy = player.x - camera.x, player.y - camera.y
	camera:move(dx/2, dy/2)

	lightWorld:setTranslation(-player.x * VIEW_SCALE + love.graphics.getWidth() / 2, -player.y * VIEW_SCALE + love.graphics.getHeight() / 2, VIEW_SCALE)
	playerShadow.x, playerShadow.y = player.x, player.y
end




-- Main LÖVE functions

function love.load()
	-- LÖVE settings stuff
	-- love.window.setMode(800, 600)
	love.window.setMode(1440, 900)
	-- love.window.setMode(1920, 1080)
	-- love.window.setFullscreen(true)

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
	addLights(blocks)
	playerShadow = lightWorld:newRectangle(player.x, player.y, 10, 10)
	-- camera
	camera = Camera(player.x, player.y)
	camera:zoom(VIEW_SCALE)
end

local tilt = false

function love.update(dt)
	cols_len = 0
	player:update(world, cols_len, dt)
	updateStars(stars)
	local colliding = updateAsteroids(asteroids)
	if #colliding > 0 then
		if math.random() > 0.90 then
			tilt = true
		end
	end
	updateCamera()
	lightWorld:update(dt)
	playSounds()
end


function love.draw()
	camera:attach()
	lightWorld:draw(function()
		drawStars(stars)
		if tilt then
			love.graphics.draw(shipImage, 2, 2)
			tilt = false
		else
			love.graphics.draw(shipImage, 0, 0)
		end
		drawAsteroids(asteroids)
		-- drawBlocks()
		player:draw()
	end)
	camera:detach()
end
