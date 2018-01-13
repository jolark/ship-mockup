require 'src.utils'

Player = {}

-- Player functions
function Player:new()
	local player = { 
		x=0,
		y=0,
		w=10,
		h=10,
		speed = 250,
		charAnimation = newAnimationFromQuads(love.graphics.newImage('img/char.png'), {
			love.graphics.newQuad(0, 0, 50, 50, 50, 300),
			love.graphics.newQuad(0, 50, 50, 50, 50, 300),
			love.graphics.newQuad(0, 100, 50, 50, 50, 300),
			love.graphics.newQuad(0, 50, 50, 50, 50, 300),
			love.graphics.newQuad(0, 0, 50, 50, 50, 300),
			love.graphics.newQuad(0, 150, 50, 50, 50, 300),
			love.graphics.newQuad(0, 200, 50, 50, 50, 300),
			love.graphics.newQuad(0, 150, 50, 50, 50, 300),
			love.graphics.newQuad(0, 0, 50, 50, 50, 300)
		}),
		switchAnimation = newAnimationFromQuads(love.graphics.newImage('img/switch.png'), {
			love.graphics.newQuad(0, 0, 30, 10, 30, 30),
			love.graphics.newQuad(0, 10, 30, 10, 30, 30),
			love.graphics.newQuad(0, 20, 30, 10, 30, 30),
			love.graphics.newQuad(0, 10, 30, 10, 30, 30),
		}, 0.75),
		canSwitchToCockpit = false,
		canSwitchToEngineLeft = false,
		canSwitchToEngineRight = false
	}
	setmetatable(player, { __index = Player })
	return player
end

function Player:isNear(x, y, dist)
	local dx = self.x - x 
	local dy = self.y - y
	return math.sqrt(dx*dx + dy*dy) < (dist or 50) 
end

function Player:setPosition(position)
    self.x = position.x
    self.y = position.y
end

-- LÖVE functions

function Player:update(world, cols_len, dt)
	-- movement
	local dx, dy = 0, 0
	if love.keyboard.isDown('right') then
		dx = self.speed * dt
		self.charAnimation.rot = math.pi / 2
		if love.keyboard.isDown('down') then
			self.charAnimation.rot = math.pi * 3 / 4
		elseif love.keyboard.isDown('up') then
			self.charAnimation.rot = math.pi / 4
		end
	elseif love.keyboard.isDown('left') then
		dx = -self.speed * dt
		self.charAnimation.rot = -math.pi / 2
		if love.keyboard.isDown('down') then
			self.charAnimation.rot = -math.pi * 3 / 4
		elseif love.keyboard.isDown('up') then
			self.charAnimation.rot = -math.pi / 4
		end
	end
	if love.keyboard.isDown('down') then
		dy = self.speed * dt
		if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
			self.charAnimation.rot = math.pi
		end
	elseif love.keyboard.isDown('up') then
		dy = -self.speed * dt
		if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
			self.charAnimation.rot = 0
		end
	end

	-- animation sprite
	if dx ~= 0 or dy ~= 0 then
		local cols
		self.x, self.y, cols, cols_len = world:move(self, self.x + dx, self.y + dy)
		animationUpdate(self.charAnimation, dt)
	else
		self.charAnimation.currentTime = 0
	end

	-- is player near engines or cockpit ? -- FIXME
--	self.canSwitchToEngineLeft = self:isNear(380, 400)
--	self.canSwitchToEngineRight = self:isNear(380, 820)
--	self.canSwitchToCockpit = self:isNear(1150, 500)

	if self.canSwitchToCockpit or self.canSwitchToEngineLeft or self.canSwitchToEngineRight then
		animationUpdate(self.switchAnimation, dt)
	end
end

function Player:draw()
	local spriteNum = math.floor(self.charAnimation.currentTime / self.charAnimation.duration * #self.charAnimation.quads) + 1
	love.graphics.draw(self.charAnimation.spriteSheet, self.charAnimation.quads[spriteNum], self.x, self.y, self.charAnimation.rot, 1, 1, 25, 25)
	
	if self.canSwitchToCockpit or self.canSwitchToEngineLeft or self.canSwitchToEngineRight then
		local spriteNum = math.floor(self.switchAnimation.currentTime / self.switchAnimation.duration * #self.switchAnimation.quads) + 1
	love.graphics.draw(self.switchAnimation.spriteSheet, self.switchAnimation.quads[spriteNum], self.x, self.y, 0, 1, 1, 20, 20)
	end
end