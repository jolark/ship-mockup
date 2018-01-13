require 'src.ship.ship_items.ship_item'

Television = {}

local image = love.graphics.newImage('img/television.png')

function Television:new(posx, posy)
    local item = ShipItem:new(posx, posy, false)
    local object = {
        tvAnimation = { delay=50, rgba={ math.random(100,255), math.random(100,255), math.random(100,255), math.random(50,150) } },
    }
    setmetatable(self, {__index = item })
    setmetatable(object, { __index = Television })
    return object
end

function Television:update(dt)
    ShipItem.update(self)
    -- tv animation update
    self.tvAnimation.delay = math.max(0, self.tvAnimation.delay - 1)
    if self.tvAnimation.delay == 0 then
        self.tvAnimation.rgba = {math.random(200, 255), math.random(200, 255), math.random(200, 255), math.random(50, 100)}
        self.tvAnimation.delay = math.random(1, 50)
    end
end

function Television:draw()
    ShipItem.draw(self)
    love.graphics.draw(image, self.x, self.y)
end