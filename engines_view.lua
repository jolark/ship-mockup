local engines_view = {}


-- libs
local Gamestate = require 'lib.hump.gamestate'

require 'utils'

local image = love.graphics.newImage('img/engines-view.png')
local imageTube = love.graphics.newImage('img/tube.png')
local imageTubeFull = love.graphics.newImage('img/tube-full.png')

local directions = {'up', 'right', 'down', 'left' }

local tubes = {}
local selected = {x=1, y=1}
local enginesOk = {false, false, false, false}

local keypressed = false


local function turn(direction)
	for i,d in ipairs(directions) do
		if direction == d then
			return directions[i % #directions + 1]
		end
	end
end

local function nextLeft(tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y - 4]
end

local function nextRight(tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y + 4]
end

local function nextUp(tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y - 1]
end

local function nextDown(tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y + 1]
end

local function isConnected(tube, visited)
	if tube.x == 1 then
		return tube.direction ~= 'right'
	else
		local ind = (tube.x - 1) * 4 + tube.y
		if not inTable(visited, ind) then
			table.insert(visited, ind)
			return (tube.direction ~= 'right' and tube.x > 1 and nextLeft(tube).direction ~= 'left' and isConnected(nextLeft(tube), visited))
				or (tube.direction ~= 'left' and tube.x < 5 and nextRight(tube).direction ~= 'right' and isConnected(nextRight(tube), visited))
				or (tube.direction ~= 'down' and tube.y > 1 and nextUp(tube).direction ~= 'up' and isConnected(nextUp(tube), visited))
				or (tube.direction ~= 'up' and tube.y < 4 and nextDown(tube).direction ~= 'down' and isConnected(nextDown(tube), visited))
		end
	end
end

local function tubeRotation(direction)
	if direction == 'up' then
		return 0
	elseif direction == 'down' then
		return math.pi
	elseif direction == 'left' then
		return -math.pi / 2
	elseif direction == 'right' then
		return math.pi / 2
	end
end

local function drawTube(tube)
	if isConnected(tube, {}) then
		love.graphics.draw(imageTubeFull, 568 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, tubeRotation(tube.direction), 2, 2, 22, 22)
	else
		love.graphics.draw(imageTube, 568 + 44 + (tube.x - 1) * 100, 192 + 44 + (tube.y - 1) * 100, tubeRotation(tube.direction), 2, 2, 22, 22)
	end
end



---- LÖVE functions


function engines_view:load()
	for i=1,5 do -- tube columns
		for j=1,4 do -- tube rows
			table.insert(tubes, {x=i, y=j, direction=choose(directions)})
		end
	end
end

function engines_view:update(dt)
	if love.keyboard.isDown('up') and not keypressed then
		selected.y = math.max(1, selected.y - 1)
		keypressed = true
	elseif love.keyboard.isDown('down') and not keypressed then
		selected.y = math.min(4, selected.y + 1)
		keypressed = true
	elseif love.keyboard.isDown('left') and not keypressed then
		selected.x = math.max(1, selected.x - 1)
		keypressed = true
	elseif love.keyboard.isDown('right') and not keypressed then
		selected.x = math.min(5, selected.x + 1)
		keypressed = true
	elseif love.keyboard.isDown('space') and not keypressed then
		local sel = (selected.x - 1) * 4 + selected.y
		tubes[sel].direction = turn(tubes[sel].direction)
		keypressed = true
	end
	if not love.keyboard.isDown('up', 'down', 'left', 'right', 'space') then
		keypressed = false
	end

	-- are engines ok ?
	for i=1,4 do -- ugly access to last column
		enginesOk[i] = tubes[i + 16].direction ~= 'left' isConnected(tubes[i + 16], {})
	end
end


function engines_view:draw()
	-- tubes
	love.graphics.draw(image, 0, 0, 0, 2)
	for _,tube in ipairs(tubes) do
		drawTube(tube)
	end
	-- engines leds
	love.graphics.setColor(0,200,0)
	if enginesOk[1] then
		love.graphics.rectangle('fill', 1074, 228, 26, 14)
		love.graphics.rectangle('fill', 1178, 232, 188, 4)
	end
	if enginesOk[2] then
		love.graphics.rectangle('fill', 1074, 328, 26, 14)
		love.graphics.rectangle('fill', 1178, 334, 188, 4)
	end
	if enginesOk[3] then
		love.graphics.rectangle('fill', 1074, 428, 26, 14)
		love.graphics.rectangle('fill', 1178, 436, 188, 4)
	end
	if enginesOk[4] then
		love.graphics.rectangle('fill', 1074, 528, 26, 14)
		love.graphics.rectangle('fill', 1178, 534, 188, 4)
	end
	-- leds

	-- selected
	love.graphics.setColor(0,200,0, 50)
	love.graphics.rectangle('fill', 567 + (selected.x - 1) * 100, 191 + (selected.y - 1) * 100, 90, 90)
	-- reset colors
	love.graphics.setColor(255,255,255)
end

return engines_view