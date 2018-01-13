require 'src.ship.ship_items.ship_item'

Cockpit = {}

local image = love.graphics.newImage('img/cockpit-control.png')

function Cockpit:new(posx, posy)
    local item = ShipItem:new(posx, posy, true)
    local object = {
        -- animation ? TODO
    }
    setmetatable(self, {__index = item })
    setmetatable(object, { __index = Cockpit })
    return object
end

function Cockpit:update(dt, player)
    ShipItem.update(self, dt, player)
    player.canSwitchToCockpit = self.nearPlayer
end

function Cockpit:draw()
    ShipItem.draw(self)
    love.graphics.draw(image, self.x, self.y)
end