Debris = {}

local image = love.graphics.newImage('img/debris.png')

function Debris:new(xpos, ypos, width, height, speed, scale)
    local object = {
        position = { x = xpos, y = ypos },
        size = { w = width, h = height },
        speed = speed,
        rotation = 0,
        scale = scale or 1,
        caught = false,
        reelingVector = {},
        reelingSpeed = 1
    }
    setmetatable(object, { __index = Debris })
    return object
end

function Debris:update(dt)
    if not self.caught then
        self.position.x = self.position.x - self.speed
        self.rotation = self.rotation + dt * 0.1 * self.speed
    else
        self.position.x = self.position.x - self.reelingVector.x * self.reelingSpeed
        self.position.y = self.position.y - self.reelingVector.y * self.reelingSpeed
    end
end

function Debris:draw()
    love.graphics.draw(image, self.position.x, self.position.y, self.rotation, self.scale, self.scale, image:getWidth()/2, image:getHeight()/2)
end