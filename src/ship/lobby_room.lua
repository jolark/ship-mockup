require 'src.ship.ship_room'

LobbyRoom = {}

function LobbyRoom:new()
	local room = ShipRoom:new()
	local object = {
		tvAnimation = { delay=50, rgba={ math.random(100,255), math.random(100,255), math.random(100,255), math.random(50,150) } },
		walls = {},
		lights = {
			-- { x=624, y=648, r=155, g=130, b=0, range=1500, glow = 0.25, smooth = 1.5 } -- FIXME
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
	-- tv animation -- FIXME
--	love.graphics.setColor(self.tvAnimation.rgba)
--	love.graphics.polygon('fill', 596, 334, 910, 334, 812, 504, 696, 504)
end

function LobbyRoom:addLight(lightworld, light)
	ShipRoom.addLight(self, lightworld, light)
end