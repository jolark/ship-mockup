require 'ship.ship_room'

LobbyRoom = {}

function LobbyRoom:new()
	local room = ShipRoom:new()
	local object = {
		tvAnimation = { delay=50, rgba={ math.random(100,255), math.random(100,255), math.random(100,255), math.random(50,150) } },
		walls = {
			-- sofa
			{692, 506, 124, 6},
			-- table
			{528, 336, 60, 160},
			-- plant
			{960, 604, 32, 32},
			-- bed
			{800, 726, 208, 150},
			{954, 672, 60, 60},
			-- walls
			{250, 320, 780, 12},
			{250, 320, 12, 574},
			{516, 320, 12, 200},
			{516, 630, 12, 264},
			{248, 884, 778, 12},
			{1014, 322, 12, 122},
			{1014, 578, 12, 314},
			{1026, 404, 232, 12},
			{1240, 404, 12, 210},
			{1014, 604, 242, 12},
			{516, 656, 212, 12},
			{852, 656, 162, 12},
			{260, 460, 170, 288}
		},
		lights = {
			-- { x=624, y=648, r=155, g=130, b=0, range=1500, glow = 0.25, smooth = 1.5 }
		}
	}
	setmetatable(self, {__index = room })
	setmetatable(object, { __index = LobbyRoom })
	return object
end

function LobbyRoom:update(dt)
	ShipRoom.update(self, dt)
	-- tv animation update
	self.tvAnimation.delay = math.max(0, self.tvAnimation.delay - 1)
	if self.tvAnimation.delay == 0 then
		self.tvAnimation.rgba = {math.random(200, 255), math.random(200, 255), math.random(200, 255), math.random(50, 100)}
		self.tvAnimation.delay = math.random(1, 50)
	end
end

function LobbyRoom:draw()
	ShipRoom.draw(self)
	-- tv animation
	love.graphics.setColor(self.tvAnimation.rgba)
	love.graphics.polygon('fill', 596, 334, 910, 334, 812, 504, 696, 504)
end

function LobbyRoom:addLight(lightworld, light)
	ShipRoom.addLight(self, lightworld, light)
end