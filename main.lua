-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
local ship_view = require 'ship_view'
local cockpit_view = require 'cockpit_view'

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

	Gamestate.registerEvents()
    Gamestate.switch(ship_view)
end

function love.update(dt)
	if love.keyboard.isDown('return') and not keypressed then
		if state == 'ship' then
			Gamestate.switch(cockpit_view)
			state = 'cockpit'
		elseif state == 'cockpit' then
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
