
-- libs
local Gamestate = require 'lib.hump.gamestate'

require 'utils'

local directions = {'up', 'right', 'down', 'left' }


function turn(direction)
	for i,d in ipairs(directions) do
		if direction == d then
			return directions[i % #directions + 1]
		end
	end
end

local function nextLeft(tubes, tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y - 4]
end

local function nextRight(tubes, tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y + 4]
end

local function nextUp(tubes, tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y - 1]
end

local function nextDown(tubes, tube)
	return tubes[(tube.x - 1 ) * 4 + tube.y + 1]
end

function isConnected(tubes, tube, visited)
	if tube.x == 1 then
		return tube.direction ~= 'right'
	else
		local ind = (tube.x - 1) * 4 + tube.y
		if not inTable(visited, ind) then
			table.insert(visited, ind)
			return (tube.direction ~= 'right' and tube.x > 1 and nextLeft(tubes, tube).direction ~= 'left' and isConnected(tubes, nextLeft(tubes, tube), visited))
				or (tube.direction ~= 'left' and tube.x < 5 and nextRight(tubes, tube).direction ~= 'right' and isConnected(tubes, nextRight(tubes, tube), visited))
				or (tube.direction ~= 'down' and tube.y > 1 and nextUp(tubes, tube).direction ~= 'up' and isConnected(tubes, nextUp(tubes, tube), visited))
				or (tube.direction ~= 'up' and tube.y < 4 and nextDown(tubes, tube).direction ~= 'down' and isConnected(tubes, nextDown(tubes, tube), visited))
		end
	end
end

function tubeRotation(direction)
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

function shuffleTubes(tubes)
	for _,tube in ipairs(tubes) do
		tube.direction = choose(directions)
	end
end

function initialDirection(index)
	if index % 2 == 0 then
		return 'up'
	else
		return 'down'
	end
end

function engineViewUpdate(selected, keypressed, tubes)
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

	return love.keyboard.isDown('up', 'down', 'left', 'right', 'space')	
end

function engineViewLoad(tubes)
	for i=1,5 do -- tube columns
		for j=1,4 do -- tube rows
			table.insert(tubes, {x=i, y=j, direction=initialDirection(j)})
		end
	end
end