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
		canSwitchToCockpit = false,
		canSwitchToEngineLeft = false,
		canSwitchToEngineRight = false
	}
	setmetatable(player, { __index = Player })
	return player
end

function Player:setPosition(position)
    self.x = position.x * TILE_SIZE
    self.y = position.y * TILE_SIZE
end

-- LÖVE functions

function Player:update(bumpworld, dt)
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
		local cols, cols_len
		self.x, self.y, cols, cols_len = bumpworld:move(self, self.x + dx, self.y + dy)
		animationUpdate(self.charAnimation, dt)
	else
		self.charAnimation.currentTime = 0
	end
end

function Player:draw()
	local spriteNum = math.floor(self.charAnimation.currentTime / self.charAnimation.duration * #self.charAnimation.quads) + 1
	love.graphics.draw(self.charAnimation.spriteSheet, self.charAnimation.quads[spriteNum], self.x, self.y, self.charAnimation.rot, 1, 1, 25, 25)
end