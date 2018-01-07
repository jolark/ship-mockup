-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
require 'player'
local ship_view = require 'ship_view'
local cockpit_view = require 'cockpit_view'
local engines_view = require 'engines_view'

-- globals
player = Player:new()

local keypressed = false 
local state = 'ship'

function love.load()
	-- LÖVE settings stuff
	-- love.window.setMode(800, 600)
	love.window.setMode(1366, 768)
	-- love.window.setMode(1440, 900)
	-- love.window.setMode(1920, 1080)
	-- love.window.setFullscreen(true)
	
	-- load states
	ship_view:load()
	cockpit_view:load()
	engines_view:load()

	Gamestate.registerEvents()
    Gamestate.switch(ship_view)
end

function love.update(dt)
	if love.keyboard.isDown('return') and not keypressed then
		if state == 'ship' and player.canSwitchToCockpit then
			Gamestate.switch(cockpit_view)
			state = 'cockpit'
		elseif state == 'ship' and player.canSwitchToEngines then
			Gamestate.switch(engines_view)
			state = 'engines'
		elseif state == 'cockpit' or state == 'engines' then
			Gamestate.switch(ship_view)
			state = 'ship'
		end
		keypressed = true
	elseif not love.keyboard.isDown('return') then
		keypressed = false
	end
end


function love.draw()
end
