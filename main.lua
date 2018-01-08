-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
require 'player'
local ship_view = require 'ship_view'
local cockpit_view = require 'cockpit_view'
local engines_view_left = require 'engines_view_left'
local engines_view_right = require 'engines_view_right'

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
	engines_view_left:load()
	engines_view_left.engine = 'left'
	engines_view_right:load()
	engines_view_right.engine = 'right'

	Gamestate.registerEvents()
    Gamestate.switch(ship_view, {false, false}, 1)
end

function love.update(dt)
	if love.keyboard.isDown('return') and not keypressed then
		if state == 'ship' and player.canSwitchToCockpit then
			Gamestate.switch(cockpit_view, ship_view.speed)
			state = 'cockpit'
		elseif state == 'ship' and player.canSwitchToEngineLeft then
			Gamestate.switch(engines_view_left, ship_view.engineBreak[1])
			state = 'engines'
		elseif state == 'ship' and player.canSwitchToEngineRight then
			Gamestate.switch(engines_view_right, ship_view.engineBreak[2])
			state = 'engines'
		elseif state == 'cockpit' or state == 'engines' then
			Gamestate.switch(ship_view, {engines_view_left.engineBreak, engines_view_right.engineBreak}, cockpit_view.speed)
			state = 'ship'
		end
		keypressed = true
	elseif not love.keyboard.isDown('return') then
		keypressed = false
	end
end


function love.draw()
end
