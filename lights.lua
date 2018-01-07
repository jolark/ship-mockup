local mainroomlight
local engineroomlight1
local engineroomlight2
local cockpitroomlight

function addShipLights(lightWorld, blocks)
	mainroomlight = lightWorld:newLight(624, 648, 155, 130, 0, 1500)
	mainroomlight:setGlowStrength(0.25)
	mainroomlight:setSmooth(1.5)

	engineroomlight1 = lightWorld:newLight(272, 786, 130, 0, 0, 300)
	engineroomlight1:setGlowStrength(0.5)
	engineroomlight1:setSmooth(1.5)

	engineroomlight2 = lightWorld:newLight(272, 418, 130, 0, 0, 300)
	engineroomlight2:setGlowStrength(0.5)
	engineroomlight2:setSmooth(1.5)

	-- cockpitroomlight = lightWorld:newLight(538, 212, 155, 130, 0, 200)
	-- cockpitroomlight:setGlowStrength(0.1)
	-- cockpitroomlight:setSmooth(2)
	-- cockpitroomlight:setDirection(-math.pi * 3 / 2)

	-- SHADOWS
	for _,block in ipairs(blocks) do
		lightWorld:newRectangle(block.x + block.w / 2, block.y + block.h / 2, block.w, block.h)
	end
end

function lightsOn(rooms)
	for _,room in ipairs(rooms) do
		if room == 'main' then
			mainroomlight:setVisible(true)
		elseif room == 'engine1' then
			engineroomlight1:setVisible(true)
		elseif room == 'engine2' then
			engineroomlight2:setVisible(true)
		elseif room == 'cockpit' then
			cockpitroomlight:setVisible(true)
		end
	end
end

function lightsOff(rooms)
	for _,room in ipairs(rooms) do
		if room == 'main' then
			mainroomlight:setVisible(false)
		elseif room == 'engine1' then
			engineroomlight1:setVisible(false)
		elseif room == 'engine2' then
			engineroomlight2:setVisible(false)
		elseif room == 'cockpit' then
			cockpitroomlight:setVisible(false)
		end
	end
end