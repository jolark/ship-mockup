-- libs
local Gamestate = require 'src.lib.hump.gamestate'

-- modules
require 'src.player'
require 'src.world'
require 'src.ship.ship'
require 'src.ship.ship_room'
require 'src.ship.ship_items.engine_control'
require 'src.ship.ship_items.cockpit'
require 'src.ship.ship_items.fetcher'

-- views
local ship_view = require 'src.views.ship_view'
local cockpit_view = require 'src.views.cockpit_view'
local engines_view_left = require 'src.views.engines_view_left'
local engines_view_right = require 'src.views.engines_view_right'

-- globals
TILE_SIZE = 40

-- main entities
local player = Player:new()
local world = World:new()


-- TEST STUFF

local ship = Ship:new()
ship:addItem(EngineControl:new(5, 5))
ship:addItem(Cockpit:new(30, 10))
ship:addItem(Fetcher:new(0, 15))

local room = ShipRoom:new('room1', 10, 10, 10, 10)
ship:addRoom(room)

ship:addRoom(ShipRoom:new('room2', 14, 20, 15, 5))
ship:addRoom(ShipRoom:new('room3', 20, 10, 10, 5))
ship:addRoom(ShipRoom:new('room4', 0, 10, 10, 10))
ship:addRoom(ShipRoom:new('room5', 4, 5, 10, 5))
ship:addRoom(ShipRoom:new('room6', 20, 15, 10, 5))
ship:addRoom(ShipRoom:new('room7', 14, 5, 5, 5))
ship:addRoom(ShipRoom:new('room8', 27, 0, 5, 5))
ship:addRoom(ShipRoom:new('room9', 27, 5, 3, 5))

world.ship = ship

player:setPosition({x=13, y=13})

-- local bgm = love.audio.newSource("sound/main-menu.ogg", "stream")
-- bgm:setLooping(true)
-- love.audio.play(bgm)

-- TEST STUFF END

local keypressed = false
local state = 'ship'

function love.load()
	-- LÖVE settings stuff
	-- love.window.setMode(800, 600)
	love.window.setMode(1366, 768)
	-- love.window.setMode(1440, 900)
	-- love.window.setMode(1920, 1080)
	-- love.window.setFullscreen(true)

	Gamestate.registerEvents()
    Gamestate.switch(ship_view, world, player)
end

function love.update(dt)
	if love.keyboard.isDown('return') and not keypressed then
		if state == 'ship' and player.canSwitchToCockpit then
			Gamestate.switch(cockpit_view, world, player)
			state = 'cockpit'
		elseif state == 'ship' and player.canSwitchToEngineLeft then
			Gamestate.switch(engines_view_left, world, player)
			state = 'engine_left'
		elseif state == 'ship' and player.canSwitchToEngineRight then
			Gamestate.switch(engines_view_right, world, player)
			state = 'engine_right'
		elseif state == 'engine_left' then
			Gamestate.switch(ship_view, world, player)
			state = 'ship'
		elseif state == 'engine_right' then
			Gamestate.switch(ship_view, world, player)
			state = 'ship'
		elseif state == 'cockpit' then
			Gamestate.switch(ship_view, world, player)
			state = 'ship'
		elseif state == 'ship' and player.canSwitchToFetcher then
            player.switchedToFetcher = true
            state = 'fetcher'
		elseif state == 'fetcher' then
			player.switchedToFetcher = false
			state = 'ship'
		end
		keypressed = true
	elseif not love.keyboard.isDown('return') then
		keypressed = false
	end
end


function love.draw()
end
