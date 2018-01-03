local cockpit_view = {}


-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
local space = require 'space'
local LightWorld = require 'lib.light'


local image = love.graphics.newImage('img/cockpit-view.png')
local lightWorld
local keypressed = false

function cockpit_view:load()
	space.load()
	lightWorld = LightWorld({ambient = {55,55,55}})
end

function cockpit_view:update(dt)
	space.update(dt)
	lightWorld:update(dt)
	if love.keyboard.isDown('up') and not keypressed then
		space.speed = math.max(10, space.speed + 0.001)
		keypressed = true
	elseif love.keyboard.isDown('down') and not keypressed then
		space.speed = math.min(0, space.speed - 0.001)
		keypressed = true
	elseif not love.keyboard.isDown('up') and not love.keyboard.isDown('down') then
		keypressed = false
	end
end

function cockpit_view:draw()
	space.draw()
	-- lightWorld:draw(function()
		love.graphics.draw(image, 0, 0, 0, 2)
	-- end)
end

return cockpit_view