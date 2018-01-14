require 'src.ship.ship_room'
require 'src.utils'

Ship = { }

function Ship:new()
	local object = {
		rooms = {},
		speed = 1,
		fuelLevel = 100,
		engineLeftBreak = false,
		engineRightBreak = false,
	}
	setmetatable(object, { __index = Ship })
	return object
end

function Ship:addRoom(shipRoom)
	table.insert(self.rooms, shipRoom)
	self:updateAccesses()
end

function Ship:updateAccesses()
    -- FIXME not really optimized
    for _,room in ipairs(self.rooms) do
        local commonWalls = self:commonWalls(room)
--        room:updateAccesses(commonWalls)
    end
end

-- return relative common offsets
local function commonOffsets(wall1, wall2)
    if wall1.x1 > wall2.x2 or wall2.x1 > wall1.x2 then
        return {0, 0}
    else
        return {math.max(0, wall1.x1 - wall2.x1), math.min(wall1.x2, wall2.x2 - wall1.x1)}
    end
end

function Ship:commonWalls(room)
    local commonWalls = {up={}, down={}, left={}, right={}}
    for _,otherRoom in ipairs(self.rooms) do
        if room.name ~= otherRoom.name then
            -- adjacent up
            if room.position.y == otherRoom.position.y + otherRoom.size.h then
                commonWalls.up = commonOffsets({x1=room.position.x, x2=room.position.x + room.size.w}, {x1=otherRoom.position.x, x2=otherRoom.position.x + otherRoom.size.w})
            end
            -- adjacent down
            if room.position.y + room.size.h == otherRoom.position.y then
                commonWalls.down = commonOffsets({x1=room.position.x, x2=room.position.x + room.size.w}, {x1=otherRoom.position.x, x2=otherRoom.position.x + otherRoom.size.w})
            end
            -- adjacent left
            if room.position.x == otherRoom.position.x + otherRoom.size.w then
                commonWalls.left = commonOffsets({x1=room.position.y, x2=room.position.y + room.size.h}, {x1=otherRoom.position.y, x2=otherRoom.position.y + otherRoom.size.h})
            end
            -- adjacent right
            if room.position.y + room.size.h == otherRoom.position.y then
                commonWalls.right = commonOffsets({x1=room.position.y, x2=room.position.y + room.size.h}, {x1=otherRoom.position.y, x2=otherRoom.position.y + otherRoom.size.h})
            end
        end
    end
    print('walls')
    tablePrint(commonWalls.up)
    tablePrint(commonWalls.down)
    tablePrint(commonWalls.left)
    tablePrint(commonWalls.right)
    return commonWalls
end

function Ship:randomlyBreakEngines(colliding)
    if colliding then
        if math.random() > 0.90 then
            if not self.engineLeftBreak and math.random() > 0.90 then
                self.engineLeftBreak = true
            end
            if not self.engineRightBreak and math.random() > 0.90 then
                self.ship.engineRightBreak = true
            end
        end
    end
end

function Ship:fuelUpdate()
    self.fuelLevel = self.fuelLevel - 0.01 * self.speed
end

function Ship:update(dt, player, colliding)
	for _,room in ipairs(self.rooms) do
		room:update(dt, player)
    end
--    self:randomlyBreakEngines(colliding)
end

function Ship:draw()
	for _,room in ipairs(self.rooms) do
		room:draw()
	end
end