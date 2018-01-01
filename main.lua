-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
local ship = require 'ship'


function love.load()
	-- LÖVE settings stuff
	-- love.window.setMode(800, 600)
	love.window.setMode(1366, 768)
	-- love.window.setMode(1440, 900)
	-- love.window.setMode(1920, 1080)
	love.window.setFullscreen(true)
	ship:load()
end

function love.update(dt)
	Gamestate.registerEvents()
    Gamestate.switch(ship)
end


function love.draw()
end
