require 'src.ship.ship_room'
require 'src.utils'

Ship = {}

function Ship:new()
    local object = {
        rooms = {},
        items = {},
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
    self:addDoors(self.rooms[#self.rooms]) -- or shipRoom ? FIXME
end

function Ship:addItem(shipItem)
    table.insert(self.items, shipItem)
end

-- return relative common offsets
local function commonOffsets(wall1, wall2)
    if wall1.x1 >= wall2.x2 or wall2.x1 >= wall1.x2 then
        -- no wall in common
        return nil
    else
        return { math.max(wall1.x1, wall2.x1) - wall1.x1, math.min(wall1.x2, wall2.x2) - wall1.x1 }
    end
end

function Ship:addDoors(room)
    for _, otherRoom in ipairs(self.rooms) do
        if room.name ~= otherRoom.name then
            -- adjacent up
            if room.position.y == otherRoom.position.y + otherRoom.size.h then
                -- FIXME factorize this
                local commonWalls = commonOffsets({ x1 = room.position.x, x2 = room.position.x + room.size.w },
                    { x1 = otherRoom.position.x, x2 = otherRoom.position.x + otherRoom.size.w })
                if commonWalls then
                    local newDoor = math.random(commonWalls[1], commonWalls[2])
                    table.insert(room.doors.up, newDoor)
                    table.insert(otherRoom.doors.down, newDoor + (room.position.x - otherRoom.position.x))
                end
            end
            -- adjacent down
            if room.position.y + room.size.h == otherRoom.position.y then
                local commonWalls = commonOffsets({ x1 = room.position.x, x2 = room.position.x + room.size.w },
                    { x1 = otherRoom.position.x, x2 = otherRoom.position.x + otherRoom.size.w })
                if commonWalls then
                    local newDoor = math.random(commonWalls[1], commonWalls[2])
                    table.insert(room.doors.down, newDoor)
                    table.insert(otherRoom.doors.up, newDoor + (room.position.x - otherRoom.position.x))
                end
            end
            -- adjacent left
            if room.position.x == otherRoom.position.x + otherRoom.size.w then
                local commonWalls = commonOffsets({ x1 = room.position.y, x2 = room.position.y + room.size.h },
                    { x1 = otherRoom.position.y, x2 = otherRoom.position.y + otherRoom.size.h })
                if commonWalls then
                    local newDoor = math.random(commonWalls[1], commonWalls[2])
                    table.insert(room.doors.left, newDoor)
                    table.insert(otherRoom.doors.right, newDoor + (room.position.y - otherRoom.position.y))
                end
            end
            -- adjacent right
            if room.position.x + room.size.w == otherRoom.position.x then
                local commonWalls = commonOffsets({ x1 = room.position.y, x2 = room.position.y + room.size.h },
                    { x1 = otherRoom.position.y, x2 = otherRoom.position.y + otherRoom.size.h })
                if commonWalls then
                    local newDoor = math.random(commonWalls[1], commonWalls[2])
                    table.insert(room.doors.right, newDoor)
                    table.insert(otherRoom.doors.left, newDoor + (room.position.y - otherRoom.position.y))
                end
            end
        end
    end
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
    for _, room in ipairs(self.rooms) do
        room:update(dt, player)
    end
    for _,item in ipairs(self.items) do
        item:update(dt, player)
    end
    --    self:randomlyBreakEngines(colliding)
end

function Ship:draw()
    for _, room in ipairs(self.rooms) do
        room:draw()
    end
    for _,item in ipairs(self.items) do
        item:draw()
    end
end