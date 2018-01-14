require 'src.ship.ship_items.ship_item'

EngineControl = {}

local image = love.graphics.newImage('img/engine-control.png')

function EngineControl:new(posx, posy)
    local item = ShipItem:new(posx, posy, true)
    local object = {
        -- animation ? TODO
        block = {name='engine'..posx..posy, x=posx, y=posy, w=image:getWidth(), h=image:getHeight()}
    }
    setmetatable(self, {__index = item })
    setmetatable(object, { __index = EngineControl })
    return object
end

function EngineControl:update(dt, player)
    ShipItem.update(self, dt, player)
    player.canSwitchToEngineLeft = self.nearPlayer
end

function EngineControl:draw()
    ShipItem.draw(self)
    love.graphics.draw(image, self.x * TILE_SIZE, self.y * TILE_SIZE)
end