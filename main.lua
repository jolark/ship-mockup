-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
require 'player'
require 'world'
require 'ship.ship'
require 'ship.lobby_room'
local ship_view = require 'views.ship_view'
local cockpit_view = require 'views.cockpit_view'
local engines_view_left = require 'views.engines_view_left'
local engines_view_right = require 'views.engines_view_right'

-- main entities
local player = Player:new()
local world = World:new()


-- TEST DATA
local ship = Ship:new()
ship:addRoom(LobbyRoom:new())
world.ship = ship

local keypressed = false
local state = 'ship'

function love.load()
	-- LÖVE settings stuff
	-- love.window.setMode(800, 600)
	love.window.setMode(1366, 768)
	-- love.window.setMode(1440, 900)
	-- love.window.setMode(1920, 1080)
	-- love.window.setFullscreen(true)

	Gamestate.registerEvents()
    Gamestate.switch(ship_view, world, player)
end

function love.update(dt)
	if love.keyboard.isDown('return') and not keypressed then
		if state == 'ship' and player.canSwitchToCockpit then
			Gamestate.switch(cockpit_view, world, player)
			state = 'cockpit'
		elseif state == 'ship' and player.canSwitchToEngineLeft then
			Gamestate.switch(engines_view_left, world, player)
			state = 'engine_left'
		elseif state == 'ship' and player.canSwitchToEngineRight then
			Gamestate.switch(engines_view_right, world, player)
			state = 'engine_right'
		elseif state == 'engine_left' then
			Gamestate.switch(ship_view, world, player)
			state = 'ship'
		elseif state == 'engine_right' then
			Gamestate.switch(ship_view, world, player)
			state = 'ship'
		elseif state == 'cockpit' then
			Gamestate.switch(ship_view, world, player)
			state = 'ship'
		end
		keypressed = true
	elseif not love.keyboard.isDown('return') then
		keypressed = false
	end
end


function love.draw()
end
