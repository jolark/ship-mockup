local cockpit_view = {}


-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
local space = require 'space'
local LightWorld = require 'lib.light'
local speed = 1

local image = love.graphics.newImage('img/cockpit-view.png')
local imageShift = love.graphics.newImage('img/speed-shift.png')
local lightWorld
local keypressed = false

function cockpit_view:load()
	space.load()
	lightWorld = LightWorld({ambient = {55,55,55}})
end

function cockpit_view:update(dt)
	space.update(dt, speed)
	lightWorld:update(dt)
	if love.keyboard.isDown('up') and not keypressed then
		speed = math.min(8, speed + 1)
		keypressed = true
	elseif love.keyboard.isDown('down') and not keypressed then
		speed = math.max(0.1, speed - 1)
		keypressed = true
	end
	if not love.keyboard.isDown('up') and not love.keyboard.isDown('down') then
		keypressed = false
	end
end

function cockpit_view:draw()
	space.draw()
	-- lightWorld:draw(function()
		love.graphics.draw(image, 0, 0, 0, 2)
		love.graphics.draw(imageShift, 818, 490 - speed * 10, 0, 2)
		love.graphics.setColor(255,255,255, 30)
		love.graphics.draw(imageShift, 818, 290 + speed * 10, 0, 2, -math.pi / 2)
		love.graphics.setColor(255,255,255)
		for i=1,math.ceil(speed) do
			love.graphics.setColor(0,200,0)
			love.graphics.rectangle('fill', 802, 538 - i*12, 5, 2)
			love.graphics.setColor(0,200,0, 30)
			love.graphics.rectangle('fill', 802, 250 + i*12, 5, 2)
		end
		love.graphics.setColor(255,255,255)
	-- end)
end

return cockpit_view