require 'src.ship.ship_items.ship_item'

Fetcher = {}

local image = love.graphics.newImage('img/fetcher-decor.png')
local imageFetcher = love.graphics.newImage('img/fetcher.png')

function Fetcher:new(posx, posy)
    local item = ShipItem:new(posx, posy, true)
    local object = {
        -- animation ? TODO
        type = 'fetcher',
        rotation = 0,
        block = {name='fetcher'..posx..posy, x=posx, y=posy, w=image:getWidth(), h=image:getHeight()},
        shootVector = {x=1, y=1},
        isShooting = false,
        shootingSpeed = 1,
        isReeling = false,
        reelingSpeed = 0.1
    }
    setmetatable(self, {__index = item })
    setmetatable(object, { __index = Fetcher })
    return object
end

function Fetcher:shoot()
    self.shootVector = {x= -1, y=math.tan(-self.rotation)}
end

local function veclen(vec)
    return math.sqrt(vec.x*vec.x + vec.y*vec.y)
end

function Fetcher:update(dt, player)
    ShipItem.update(self, dt, player)
    player.canSwitchToFetcher = self.nearPlayer
    if player.switchedToFetcher then
        if self.isShooting then
            self.shootVector.x = self.shootVector.x + self.shootVector.x * self.shootingSpeed
            self.shootVector.y = self.shootVector.y + self.shootVector.y * self.shootingSpeed
            if veclen(self.shootVector) > 1000 then
                self.isReeling = true
                self.isShooting = false
            end
        elseif self.isReeling then
            self.shootVector.x = self.shootVector.x - self.shootVector.x * self.reelingSpeed
            self.shootVector.y = self.shootVector.y - self.shootVector.y * self.reelingSpeed
            if veclen(self.shootVector) < 10 then
                self.isReeling = false
                self.isShooting = false
            end
        else
            if love.keyboard.isDown('up') then
                self.rotation = math.min(math.pi / 4, self.rotation + 0.1)
            elseif love.keyboard.isDown('down') then
                self.rotation = math.max(-math.pi / 4, self.rotation - 0.1)
            elseif love.keyboard.isDown('space') then
                self:shoot()
                self.isShooting = true
            end
        end
    end
end

function Fetcher:draw()
    ShipItem.draw(self)
    love.graphics.draw(image, self.x * TILE_SIZE, self.y * TILE_SIZE)
    if self.isShooting or self.isReeling then
        love.graphics.setColor(255,255,255)
        love.graphics.line(self.x * TILE_SIZE, (self.y + 1) * TILE_SIZE, self.x * TILE_SIZE + self.shootVector.x, (self.y + 1) * TILE_SIZE + self.shootVector.y)
    end
    love.graphics.draw(imageFetcher, self.x * TILE_SIZE, (self.y + 1) * TILE_SIZE, self.rotation, 1, 1, imageFetcher:getWidth()/2, imageFetcher:getHeight()/2)
end