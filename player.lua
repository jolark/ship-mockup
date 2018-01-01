require 'utils'

Player = {}

-- Player functions
function Player:new()
	local player = { 
		x=550,
		y=250,
		w=10,
		h=10,
		speed = 100,
		charAnimation = newAnimation(love.graphics.newImage('img/char.png'), {
			love.graphics.newQuad(0, 0, 25, 25, 25, 150),
			love.graphics.newQuad(0, 25, 25, 25, 25, 150),
			love.graphics.newQuad(0, 50, 25, 25, 25, 150),
			love.graphics.newQuad(0, 25, 25, 25, 25, 150),
			love.graphics.newQuad(0, 0, 25, 25, 25, 150),
			love.graphics.newQuad(0, 75, 25, 25, 25, 150),
			love.graphics.newQuad(0, 100, 25, 25, 25, 150),
			love.graphics.newQuad(0, 75, 25, 25, 25, 150),
			love.graphics.newQuad(0, 0, 25, 25, 25, 150)
		})
	}
	setmetatable(player, { __index = Player })
	return player
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
		for i=1, cols_len do
			local col = cols[i]
			-- print(('col.other = %s, col.type = %s, col.normal = %d,%d'):format(col.other, col.type, col.normal.x, col.normal.y))
		end
		self.charAnimation.currentTime = self.charAnimation.currentTime + dt
		if self.charAnimation.currentTime >= self.charAnimation.duration then
			self.charAnimation.currentTime = self.charAnimation.currentTime - self.charAnimation.duration
		end
	else
		self.charAnimation.currentTime = 0
	end

	-- near engines
	-- if self.x < 250 then
	-- 	engineSound:setVolume(0.2)
	-- else
	-- 	engineSound:setVolume(0.1)
	-- end
end

function Player:draw()
	local spriteNum = math.floor(self.charAnimation.currentTime / self.charAnimation.duration * #self.charAnimation.quads) + 1
	love.graphics.draw(self.charAnimation.spriteSheet, self.charAnimation.quads[spriteNum], self.x, self.y, self.charAnimation.rot, 1, 1, 12, 12)
end