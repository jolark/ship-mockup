require 'src.ship.ship_items.ship_item'

EngineControl = {}

local image = love.graphics.newImage('img/engine-control.png')
local imageOutside = love.graphics.newImage('img/engine-outside.png')

function EngineControl:new(posx, posy)
    local item = ShipItem:new(posx, posy, true)
    local object = {
        -- animation ? TODO
        type = 'engine',
        block = {name='engine'..posx..posy, x=posx, y=posy, w=image:getWidth(), h=image:getHeight() }
    }
    setmetatable(self, {__index = item })
    setmetatable(object, { __index = EngineControl })
    return object
end

function EngineControl:update(dt, player)
    ShipItem.update(self, dt, player)
    player.canSwitchToEngineLeft = self.nearPlayer
end

function EngineControl:animateReactorLight()
    for i=1,10 do
        love.graphics.setColor(math.random(100,200), math.random(100,200), math.random(100,200))
        local x = -math.random(100,200)
        love.graphics.rectangle('fill', x, (self.y - 1.6) * TILE_SIZE + i*5, -x + (self.x - 2.7) * TILE_SIZE, 2)
    end
    love.graphics.setColor(255, 255, 255)
end

function EngineControl:draw()
    love.graphics.draw(image, self.x * TILE_SIZE, self.y * TILE_SIZE + 10) -- +10 = wall size
    love.graphics.draw(imageOutside, (self.x - 3) * TILE_SIZE, (self.y - 2.5) * TILE_SIZE)
    self:animateReactorLight()
    ShipItem.draw(self)
end