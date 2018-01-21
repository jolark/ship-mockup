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
    self:addDoors(shipRoom)
    shipRoom:addLight({
        x=(shipRoom.position.x + shipRoom.size.w / 2) * TILE_SIZE,
        y=shipRoom.position.y * TILE_SIZE + 10,
        r=130, g=100, b=0, range=300, glow=0.5, smooth=1.5 })
end

function Ship:addItem(shipItem)
    table.insert(self.items, shipItem)
end

-- FIXME find a better way to access specific items ?
function Ship:getItem(type)
    for _,item in ipairs(self.items) do
        if item.type == type then
            return item
        end
    end
    return nil
end

-- return relative common offsets
local function commonOffsets(wall1, wall2)
    if wall1.x1 >= wall2.x2 or wall2.x1 >= wall1.x2 then
        -- no wall in common
        return nil
    else
        return { math.max(1, math.max(wall1.x1, wall2.x1) - wall1.x1), math.max(1, math.min(wall1.x2, wall2.x2) - wall1.x1) }
    end
end

local function addDoor(room, otherRoom, wallPositions, otherWallPositions, direction, otherDirection, offset)
    local commonWalls = commonOffsets(wallPositions, otherWallPositions)
    local added = false
    if commonWalls and commonWalls[2] - commonWalls[1] >= 2 then
        local newDoor = commonWalls[1] + math.floor((commonWalls[2] - commonWalls[1]) / 2)
        table.insert(room.doors[direction], newDoor)
        table.insert(otherRoom.doors[otherDirection], newDoor + offset)
        added = true
    end
    return added
end

function Ship:addDoors(room)
    local hasAdjacent = {up = false, down = false, left = false, right = false}
    for _, otherRoom in ipairs(self.rooms) do
        if room.name ~= otherRoom.name then
            -- adjacent up
            if room.position.y == otherRoom.position.y + otherRoom.size.h then
                -- FIXME factorize this
                local added = addDoor(room, otherRoom, { x1 = room.position.x, x2 = room.position.x + room.size.w },
                    { x1 = otherRoom.position.x, x2 = otherRoom.position.x + otherRoom.size.w },
                    'up', 'down',
                    (room.position.x - otherRoom.position.x))
                if added then hasAdjacent.up = true end
            end
            -- adjacent down
            if room.position.y + room.size.h == otherRoom.position.y then
                local added = addDoor(room, otherRoom, { x1 = room.position.x, x2 = room.position.x + room.size.w },
                    { x1 = otherRoom.position.x, x2 = otherRoom.position.x + otherRoom.size.w },
                    'down', 'up',
                    (room.position.x - otherRoom.position.x))
                if added then hasAdjacent.down = true end
            end
            -- adjacent left
            if room.position.x == otherRoom.position.x + otherRoom.size.w then
                local added = addDoor(room, otherRoom, { x1 = room.position.y, x2 = room.position.y + room.size.h },
                    { x1 = otherRoom.position.y, x2 = otherRoom.position.y + otherRoom.size.h },
                    'left', 'right',
                    (room.position.y - otherRoom.position.y))
                if added then hasAdjacent.left = true end
            end
            -- adjacent right
            if room.position.x + room.size.w == otherRoom.position.x then
                local added = addDoor(room, otherRoom, { x1 = room.position.y, x2 = room.position.y + room.size.h },
                    { x1 = otherRoom.position.y, x2 = otherRoom.position.y + otherRoom.size.h },
                    'right', 'left',
                    (room.position.y - otherRoom.position.y))
                if added then hasAdjacent.right = true end
            end
        end
    end
    -- update outside info here FIXME naive method : draw outside decoration if no adjacent room
    if not hasAdjacent.up then
        room.outside.up = {1, room.size.w}
    end
    if not hasAdjacent.down then
        room.outside.down = {1, room.size.w}
    end
    if not hasAdjacent.left then
        room.outside.left = {1, room.size.h}
    end
    if not hasAdjacent.right then
        room.outside.right = {1, room.size.h}
    end
end

function Ship:randomlyBreakEngines(colliding)
    if colliding then
        if math.random() > 0.95 then
            if not self.engineLeftBreak and math.random() > 0.95 then
                self.engineLeftBreak = true
            end
            if not self.engineRightBreak and math.random() > 0.95 then
                self.engineRightBreak = true
            end
        end
    end
end

function Ship:fuelUpdate()
    self.fuelLevel = math.max(0, self.fuelLevel - 0.001 * self.speed)
end

function Ship:update(dt, player, colliding)
    if player then
        for _, room in ipairs(self.rooms) do
            room:update(dt, player)
        end
        for _,item in ipairs(self.items) do
            item:update(dt, player)
        end
    end
    self:randomlyBreakEngines(colliding)
    if self.engineLeftBreak or self.engineRightBreak then
        self.speed = math.min(4, self.speed)
        if self.engineLeftBreak and self.engineRightBreak then
            self.speed = math.min(1, self.speed)
        end
    end
    self:fuelUpdate()
end

function Ship:draw()
    for _, room in ipairs(self.rooms) do
        room:draw()
    end
    for _,item in ipairs(self.items) do
        item:draw(self.speed)
    end
end