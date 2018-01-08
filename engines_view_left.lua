-- libs
local Gamestate = require 'lib.hump.gamestate'

require 'utils'
require 'engines_view'


local engines_view_left = {}

local image = love.graphics.newImage('img/engines-view.png')
local imageTube = love.graphics.newImage('img/tube.png')
local imageTubeFull = love.graphics.newImage('img/tube-full.png')

local tubes = {}
local selected = {x=1, y=1}
local enginesOk = {false, false, false, false}

local keypressed = false



local function drawTube(tube)
	if isConnected(tubes, tube, {}) then
		love.graphics.draw(imageTubeFull, 568 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, tubeRotation(tube.direction), 2, 2, 22, 22)
	else
		love.graphics.draw(imageTube, 568 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, tubeRotation(tube.direction), 2, 2, 22, 22)
	end
end

---- LÖVE functions

function engines_view_left:enter(previous, engineBreak)
	engines_view_left.engineBreak = engineBreak
	if engineBreak then
		shuffleTubes(tubes)
	end
end


function engines_view_left:load()
	engineViewLoad(tubes)
end

function engines_view_left:update(dt)
	keypressed = engineViewUpdate(selected, keypressed, tubes)
	-- are engines ok ?
	local allOK = true
	for i=1,4 do -- ugly access to last column
		enginesOk[i] = tubes[i + 16].direction ~= 'left' and isConnected(tubes, tubes[i + 16], {})
		if not enginesOk[i] then
			allOK = false
		end
	end

	engines_view_left.engineBreak = not allOK
end


function engines_view_left:draw()
	-- tubes
	love.graphics.draw(image, 0, 0, 0, 2)
	for _,tube in ipairs(tubes) do
		drawTube(tube)
	end
	-- engines leds
	love.graphics.setColor(0,200,0)
	if enginesOk[1] then
		love.graphics.rectangle('fill', 1075, 228, 26, 14)
		love.graphics.rectangle('fill', 1178, 232, 188, 4)
	end
	if enginesOk[2] then
		love.graphics.rectangle('fill', 1075, 328, 26, 14)
		love.graphics.rectangle('fill', 1178, 334, 188, 4)
	end
	if enginesOk[3] then
		love.graphics.rectangle('fill', 1075, 428, 26, 14)
		love.graphics.rectangle('fill', 1178, 436, 188, 4)
	end
	if enginesOk[4] then
		love.graphics.rectangle('fill', 1075, 528, 26, 14)
		love.graphics.rectangle('fill', 1178, 534, 188, 4)
	end
	-- leds

	-- selected
	love.graphics.setColor(0,200,0, 50)
	love.graphics.rectangle('fill', 567 + (selected.x - 1) * 100, 191 + (selected.y - 1) * 100, 90, 90)
	-- reset colors
	love.graphics.setColor(255,255,255)
end

return engines_view_left