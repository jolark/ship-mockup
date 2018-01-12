-- libs
local Gamestate = require 'lib.hump.gamestate'

require 'utils'
require 'views.engine'


local engines_view_left = {}

local engine = Engine:new()

local image = love.graphics.newImage('img/engines-view.png')
local imageTube = love.graphics.newImage('img/tube.png')
local imageTubeFull = love.graphics.newImage('img/tube-full.png')

local selected = {x=1, y=1}
local enginesOk = {false, false, false, false}

local keypressed = false



local function drawTube(tube)
	if engine:isConnected(tube, {}, 5) then
		love.graphics.draw(imageTubeFull, 310 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, engine:tubeRotation(tube.direction), 2, 2, 22, 22)
	else
		love.graphics.draw(imageTube, 310 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, engine:tubeRotation(tube.direction), 2, 2, 22, 22)
	end
end

---- LÖVE functions

function engines_view_left:enter(previous, world, player)
	engines_view_left.world = world
	if engines_view_left.world.ship.engineLeftBreak then
		engine:shuffleTubes()
	end
end


function engines_view_left:init()
	engine:engineViewLoad()
end

function engines_view_left:update(dt)
	keypressed = engine:engineViewUpdate(selected, keypressed)
	-- are engines ok ?
	local allOK = true
	for i=1,4 do -- ugly access to last column
		enginesOk[i] = engine.tubes[i].direction ~= 'right' and engine:isConnected(engine.tubes[i], {}, 5)
		if not enginesOk[i] then
			allOK = false
		end
	end

	engines_view_left.world.ship.engineLeftBreak = not allOK
end


function engines_view_left:draw()
	-- tubes
	love.graphics.draw(image, 0, 0, 0, -2, 2, image:getWidth(), 0)
	for _,tube in ipairs(engine.tubes) do
		drawTube(tube)
	end
	-- engines leds
	love.graphics.setColor(0,200,0)
	if enginesOk[1] then
		love.graphics.rectangle('fill', 266, 228, 26, 14)
		love.graphics.rectangle('fill', 0, 232, 188, 4)
	end
	if enginesOk[2] then
		love.graphics.rectangle('fill', 266, 328, 26, 14)
		love.graphics.rectangle('fill', 0, 334, 188, 4)
	end
	if enginesOk[3] then
		love.graphics.rectangle('fill', 266, 428, 26, 14)
		love.graphics.rectangle('fill', 0, 436, 188, 4)
	end
	if enginesOk[4] then
		love.graphics.rectangle('fill', 266, 528, 26, 14)
		love.graphics.rectangle('fill', 0, 534, 188, 4)
	end
	-- leds

	-- selected
	love.graphics.setColor(0,200,0, 50)
	love.graphics.rectangle('fill', 310 + (selected.x - 1) * 100, 191 + (selected.y - 1) * 100, 90, 90)
	-- reset colors
	love.graphics.setColor(255,255,255)
end

return engines_view_left