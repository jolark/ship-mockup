require 'utils'

Engine = {}

function Engine:new()
	local object = {
		directions = {'up', 'right', 'down', 'left' },
		tubes = {},
		isBroken = false
	}
	setmetatable(object, { __index = Engine })
	return object
end


function Engine:turn(direction)
	for i,d in ipairs(self.directions) do
		if direction == d then
			return self.directions[i % #self.directions + 1]
		end
	end
end

function Engine:nextLeft(tube)
	return self.tubes[(tube.x - 1 ) * 4 + tube.y - 4]
end

function Engine:nextRight(tube)
	return self.tubes[(tube.x - 1 ) * 4 + tube.y + 4]
end

function Engine:nextUp(tube)
	return self.tubes[(tube.x - 1 ) * 4 + tube.y - 1]
end

function Engine:nextDown(tube)
	return self.tubes[(tube.x - 1 ) * 4 + tube.y + 1]
end

function Engine:isConnected(tube, visited, firstcolumn)
	if tube.x == firstcolumn then
		return tube.direction ~= 'right'
	else
		local ind = (tube.x - 1) * 4 + tube.y
		if not inTable(visited, ind) then
			table.insert(visited, ind)
			return (tube.direction ~= 'right' and tube.x > 1 and self:nextLeft(tube).direction ~= 'left' and self:isConnected(self:nextLeft(tube), visited, firstcolumn))
				or (tube.direction ~= 'left' and tube.x < 5 and self:nextRight(tube).direction ~= 'right' and self:isConnected(self:nextRight(tube), visited, firstcolumn))
				or (tube.direction ~= 'down' and tube.y > 1 and self:nextUp(tube).direction ~= 'up' and self:isConnected(self:nextUp(tube), visited, firstcolumn))
				or (tube.direction ~= 'up' and tube.y < 4 and self:nextDown(tube).direction ~= 'down' and self:isConnected(self:nextDown(tube), visited, firstcolumn))
		end
	end
end

function Engine:tubeRotation(direction)
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

function Engine:shuffleTubes()
	for _,tube in ipairs(self.tubes) do
		tube.direction = choose(self.directions)
	end
end

local function initialDirection(index)
	if index % 2 == 0 then
		return 'up'
	else
		return 'down'
	end
end

function Engine:engineViewUpdate(selected, keypressed)
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
		self.tubes[sel].direction = self:turn(self.tubes[sel].direction)
		keypressed = true
	end

	return love.keyboard.isDown('up', 'down', 'left', 'right', 'space')	
end

function Engine:engineViewLoad()
	for i=1,5 do -- tube columns
		for j=1,4 do -- tube rows
			table.insert(self.tubes, {x=i, y=j, direction=initialDirection(j)})
		end
	end
end