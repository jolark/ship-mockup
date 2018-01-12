require 'ship.ship_room'
EngineRoom = {}

function EngineRoom:new()
	local room = ShipRoom:new()
	local object = {
		walls = {
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
			-- { x=272, y=418, r=130, g=0, b=0, range=300, glow = 0.5, smooth = 1.5 }
		}
	}
	setmetatable(self, {__index = room })
	setmetatable(object, { __index = EngineRoom })
	return object
end

function EngineRoom:update(dt)
	ShipRoom.update(self)
end

function EngineRoom:draw()
	ShipRoom.draw(self)
end