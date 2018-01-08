local cockpit_view = { speed = 1 }


-- libs
local Gamestate = require 'lib.hump.gamestate'

-- modules
local space = require 'space'

require 'utils'

local keypressed = false

local image = love.graphics.newImage('img/cockpit-view.png')
local imageShift = love.graphics.newImage('img/speed-shift.png')
local font = love.graphics.newFont('img/Pixeled.ttf', 8)
local scrollingText
local scrollingTextStrs = { 'DESTINATION : TRT-9123', 'ARRIVAL IN : 92 DAYS' }
local currentStr = 1
local scrollingTextOffset = 0

local leds = {
	-- left
	-- first column
	{ color={0,200,0}, position={96, 568}, size={8, 3}, mirror={-60, -150}, delay=1 },
	{ color={0,200,0}, position={108, 588}, size={8, 3}, mirror={-84, -190}, delay=1 },
	{ color={0,200,0}, position={120, 608}, size={8, 3}, mirror={-108, -230}, delay=1 },
	{ color={200,0,0}, position={136, 636}, size={8, 3}, mirror={-136, -286}, delay=1 },
	-- second column
	{ color={0,200,0}, position={138, 546}, size={8, 3}, mirror={-60, -150}, delay=1 },
	{ color={0,200,0}, position={150, 564}, size={8, 3}, mirror={-84, -190}, delay=1 },
	{ color={0,200,0}, position={162, 588}, size={8, 3}, mirror={-108, -230}, delay=1 },
	{ color={200,0,0}, position={176, 614}, size={8, 3}, mirror={-136, -286}, delay=1 },
	-- third column
	{ color={0,200,0}, position={204, 510}, size={8, 3}, mirror={-60, -150}, delay=1 },
	{ color={0,200,0}, position={216, 532}, size={8, 3}, mirror={-84, -190}, delay=1 },
	{ color={0,200,0}, position={228, 552}, size={8, 3}, mirror={-108, -230}, delay=1 },
	{ color={200,0,0}, position={240, 582}, size={8, 3}, mirror={-136, -286}, delay=1 }
}




-- draw led with fixed size
local function drawLed(led)
	love.graphics.setColor(led.color)
	love.graphics.polygon('fill', led.position[1], led.position[2], led.position[1] + led.size[1], led.position[2] - led.size[2], led.position[1] + led.size[1], led.position[2], led.position[1], led.position[2] + led.size[2])
	love.graphics.setColor(led.color[1], led.color[2], led.color[3], 30)
	love.graphics.polygon('fill', led.position[1] + led.mirror[1], led.position[2] + led.mirror[2], led.position[1] + led.size[1] + led.mirror[1], led.position[2] - led.size[2] + led.mirror[2], led.position[1] + led.size[1] + led.mirror[1], led.position[2] + led.mirror[2], led.position[1] + led.mirror[1], led.position[2] + led.size[2] + led.mirror[2])
end




-- LÖVE functions

function cockpit_view:load()
	space.load()
	love.graphics.setFont(font)
	scrollingText = love.graphics.newText(font, '')
end

function cockpit_view:update(dt)
	space.update(dt, cockpit_view.speed)
	if love.keyboard.isDown('up') and not keypressed then
		cockpit_view.speed = math.min(8, cockpit_view.speed + 1)
		keypressed = true
	elseif love.keyboard.isDown('down') and not keypressed then
		cockpit_view.speed = math.max(0.1, cockpit_view.speed - 1)
		keypressed = true
	end
	if not love.keyboard.isDown('up') and not love.keyboard.isDown('down') then
		keypressed = false
	end
	-- text
	local scrollingSpeed = 3
	scrollingTextOffset = scrollingTextOffset + dt * scrollingSpeed
	if math.floor(scrollingTextOffset) == #scrollingTextStrs[currentStr] + 50 then
		scrollingTextOffset = 0
		currentStr = currentStr % #scrollingTextStrs + 1
	end
	scrollingText:set(string.sub(scrollingTextStrs[currentStr], 0, math.min(#scrollingTextStrs[currentStr], scrollingTextOffset)))
	--leds
	for _,led in ipairs(leds) do
		led.delay = led.delay - dt
		if led.delay < 0 then
			led.color = choose({{0,200,0}, {0,0,200}, {200,0,0}})
			led.delay = math.random(1,5)
		end
	end
end

function cockpit_view:draw()
	-- space outside
	space.draw()
	-- cockpit
	love.graphics.draw(image, 0, 0, 0, love.graphics.getWidth() / image:getWidth(), love.graphics.getHeight() / image:getHeight())
	love.graphics.draw(imageShift, 818, 490 - cockpit_view.speed * 10, 0, 2)
	love.graphics.setColor(255,255,255, 30)
	love.graphics.draw(imageShift, 818, 290 + cockpit_view.speed * 10, 0, 2, -math.pi / 2)
	love.graphics.setColor(255,255,255)
	-- leds
	for i=1,math.ceil(cockpit_view.speed) do
		love.graphics.setColor(0,200,0)
		love.graphics.rectangle('fill', 802, 538 - i*12, 5, 2)
		love.graphics.setColor(0,200,0, 30)
		love.graphics.rectangle('fill', 802, 250 + i*12, 5, 2)
	end
	for _,led in ipairs(leds) do
		drawLed(led)
	end

	-- text
	love.graphics.setColor(0,200,0)
	love.graphics.draw(scrollingText, math.max(440, 676 - scrollingTextOffset * 7), 495)
	love.graphics.setColor(0,200,0, 30)
	love.graphics.draw(scrollingText, math.max(440, 676 - scrollingTextOffset * 7), 295, 0, 1, -1)
	-- reset colors
	love.graphics.setColor(255,255,255)
end

return cockpit_view