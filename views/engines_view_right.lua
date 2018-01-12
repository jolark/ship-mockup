-- libs
local Gamestate = require 'lib.hump.gamestate'

require 'utils'
require 'views.engine'


local engines_view_right = {}

local engine = Engine:new()

local image = love.graphics.newImage('img/engines-view.png')
local imageTube = love.graphics.newImage('img/tube.png')
local imageTubeFull = love.graphics.newImage('img/tube-full.png')

local selected = {x=1, y=1}
local enginesOk = {false, false, false, false}

local keypressed = false



local function drawTube(tube)
	if engine:isConnected(tube, {}, 1) then
		love.graphics.draw(imageTubeFull, 568 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, engine:tubeRotation(tube.direction), 2, 2, 22, 22)
	else
		love.graphics.draw(imageTube, 568 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, engine:tubeRotation(tube.direction), 2, 2, 22, 22)
	end
end

-- local function fuelUpdate()
-- 	ship_view.fuelLevel = ship_view.fuelLevel - 0.01 * ship_view.speed
-- end

---- LÖVE functions

function engines_view_right:enter(previous, world, player)
	engines_view_right.world = world
	if engines_view_right.world.ship.engineRightBreak then
		engine:shuffleTubes()
	end
end


function engines_view_right:init()
	engine:engineViewLoad()
end

function engines_view_right:update(dt)
	keypressed = engine:engineViewUpdate(selected, keypressed)
	-- are engines ok ?
	local allOK = true
	for i=1,4 do -- ugly access to last column
		enginesOk[i] = engine.tubes[i + 16].direction ~= 'left' and engine:isConnected(engine.tubes[i + 16], {}, 1)
		if not enginesOk[i] then
			allOK = false
		end
	end

	engines_view_right.world.ship.engineRightBreak = not allOK
end


function engines_view_right:draw()
	-- tubes
	love.graphics.draw(image, 0, 0, 0, 2)
	for _,tube in ipairs(engine.tubes) do
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

return engines_view_right