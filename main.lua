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
local tilt = false


-- Images
local shipImage = love.graphics.newImage('img/ship.png')
local boardAnimation = newAnimation(love.graphics.newImage('img/board-lights.png'), {
			love.graphics.newQuad(0, 0, 103, 1, 103, 5),
			love.graphics.newQuad(0, 1, 103, 1, 103, 5),
			love.graphics.newQuad(0, 2, 103, 1, 103, 5),
			love.graphics.newQuad(0, 3, 103, 1, 103, 5),
			love.graphics.newQuad(0, 4, 103, 1, 103, 5)
		}, 5)
local tvAnimation = newAnimation(love.graphics.newImage('img/tv.png'), {
			love.graphics.newQuad(0, 0, 158, 86, 158, 344),
			love.graphics.newQuad(0, 87, 158, 86, 158, 344),
			love.graphics.newQuad(0, 173, 158, 86, 158, 344),
			love.graphics.newQuad(0, 258, 158, 86, 158, 344)
		})

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
		end
	end

	boardAnimation.currentTime = boardAnimation.currentTime + dt
	if boardAnimation.currentTime >= boardAnimation.duration then
		boardAnimation.currentTime = boardAnimation.currentTime - boardAnimation.duration
	end
	tvAnimation.duration = math.random(5)
	tvAnimation.currentTime = tvAnimation.currentTime + dt
	if tvAnimation.currentTime >= tvAnimation.duration then
		tvAnimation.currentTime = tvAnimation.currentTime - tvAnimation.duration
	end
end

local function drawShip()
	if tilt then
		love.graphics.draw(shipImage, 2, 2)
		tilt = false
	else
		love.graphics.draw(shipImage, 0, 0)
	end
	local spriteNum = math.floor(boardAnimation.currentTime / boardAnimation.duration * #boardAnimation.quads) + 1
	love.graphics.draw(boardAnimation.spriteSheet, boardAnimation.quads[spriteNum], 135, 417)
	love.graphics.draw(boardAnimation.spriteSheet, boardAnimation.quads[spriteNum], 132, 189)
	local spriteNum = math.floor(tvAnimation.currentTime / tvAnimation.duration * #tvAnimation.quads) + 1
	love.graphics.draw(tvAnimation.spriteSheet, tvAnimation.quads[spriteNum], 298, 167)
end

-- Main LÖVE functions

function love.load()
	-- LÖVE settings stuff
	-- love.window.setMode(800, 600)
	love.window.setMode(1366, 768)
	-- love.window.setMode(1440, 900)
	-- love.window.setMode(1920, 1080)
	love.window.setFullscreen(true)

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

function love.update(dt)
	cols_len = 0
	player:update(world, cols_len, dt)
	updateStars(stars)
	local colliding = updateAsteroids(asteroids)
	updateShip(dt, colliding)
	updateCamera()
	lightWorld:update(dt)
	playSounds()
end


function love.draw()
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
