ShipItem = {}

function ShipItem:new(posx, posy, isActionnable)
    local object = {
        x = posx or 0,
        y = posy or 0,
        actionnable = isActionnable or false,
        nearPlayer = false,
        -- for now all items have animation even if not actionnalbe FIXME
        switchAnimation = newAnimationFromQuads(love.graphics.newImage('img/switch.png'), {
            love.graphics.newQuad(0, 0, 60, 20, 60, 60),
            love.graphics.newQuad(0, 20, 60, 20, 60, 60),
            love.graphics.newQuad(0, 40, 60, 20, 60, 60),
            love.graphics.newQuad(0, 20, 60, 20, 60, 60),
        }, 0.75),
    }
    setmetatable(object, { __index = ShipItem })
    return object
end

-- FIXME isNear center instead of upleft corner
function ShipItem:isNear(x, y, dist)
    local dx = self.x - x
    local dy = self.y - y
    return math.sqrt(dx*dx + dy*dy) < (dist or 2)
end

function ShipItem:update(dt, player)
    self.nearPlayer = self:isNear(player.x /  TILE_SIZE, player.y /  TILE_SIZE)
    if self.nearPlayer then
        animationUpdate(self.switchAnimation, dt)
    end
end

function ShipItem:draw()
    if self.nearPlayer then
        local spriteNum = math.floor(self.switchAnimation.currentTime / self.switchAnimation.duration * #self.switchAnimation.quads) + 1
        love.graphics.draw(self.switchAnimation.spriteSheet, self.switchAnimation.quads[spriteNum], self.x * TILE_SIZE, self.y * TILE_SIZE, 0, 1, 1, 20, 20)
    end
end