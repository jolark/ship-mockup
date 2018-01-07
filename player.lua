require 'utils'

Player = {}

-- Player functions
function Player:new()
	local player = { 
		x=850,
		y=450,
		w=10,
		h=10,
		speed = 250,
		charAnimation = newAnimationFromQuads(love.graphics.newImage('img/char.png'), {
			love.graphics.newQuad(0, 0, 25, 25, 25, 150),
			love.graphics.newQuad(0, 25, 25, 25, 25, 150),
			love.graphics.newQuad(0, 50, 25, 25, 25, 150),
			love.graphics.newQuad(0, 25, 25, 25, 25, 150),
			love.graphics.newQuad(0, 0, 25, 25, 25, 150),
			love.graphics.newQuad(0, 75, 25, 25, 25, 150),
			love.graphics.newQuad(0, 100, 25, 25, 25, 150),
			love.graphics.newQuad(0, 75, 25, 25, 25, 150),
			love.graphics.newQuad(0, 0, 25, 25, 25, 150)
		}),
		switchAnimation = newAnimationFromQuads(love.graphics.newImage('img/switch.png'), {
			love.graphics.newQuad(0, 0, 30, 10, 30, 30),
			love.graphics.newQuad(0, 10, 30, 10, 30, 30),
			love.graphics.newQuad(0, 20, 30, 10, 30, 30),
			love.graphics.newQuad(0, 10, 30, 10, 30, 30),
		}, 0.75),
		canSwitchToCockpit = false,
		canSwitchToEngines = false
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
		animationUpdate(self.charAnimation, dt)
	else
		self.charAnimation.currentTime = 0
	end

	-- near engines
	local x1 = player.x - 380 -- right engine x 
	local y1 = player.y - 820 -- right engine y
	local x2 = player.x - 380 -- left engine x 
	local y2 = player.y - 400 -- left engine y
	if math.sqrt(x1*x1 + y1*y1) < 50 or math.sqrt(x2*x2 + y2*y2) < 50 then
		self.canSwitchToEngines = true
	else
		self.canSwitchToEngines = false
	end
	if self.canSwitchToEngines then
		animationUpdate(self.switchAnimation, dt)
	end

	-- near cockpit
	local x = player.x - 1150 -- cockpit x
	local y = player.y - 500 -- cockpit y
	if math.sqrt(x*x + y*y) < 30 then
		self.canSwitchToCockpit = true
	else
		self.canSwitchToCockpit = false
	end
	if self.canSwitchToCockpit then
		animationUpdate(self.switchAnimation, dt)
	end
end

function Player:draw()
	local spriteNum = math.floor(self.charAnimation.currentTime / self.charAnimation.duration * #self.charAnimation.quads) + 1
	love.graphics.draw(self.charAnimation.spriteSheet, self.charAnimation.quads[spriteNum], self.x, self.y, self.charAnimation.rot, 2, 2, 12, 12)
	
	if self.canSwitchToCockpit or self.canSwitchToEngines then
		local spriteNum = math.floor(self.switchAnimation.currentTime / self.switchAnimation.duration * #self.switchAnimation.quads) + 1
	love.graphics.draw(self.switchAnimation.spriteSheet, self.switchAnimation.quads[spriteNum], self.x, self.y, 0, 2, 2, 20, 20)
	end
end