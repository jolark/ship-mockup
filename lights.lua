local mainroomlight
local engineroomlight1
local engineroomlight2
local cockpitroomlight

function addLights(blocks)
	mainroomlight = lightWorld:newLight(312, 324, 155, 130, 0, 1500)
	mainroomlight:setGlowStrength(0.25)
	mainroomlight:setSmooth(1.5)

	engineroomlight1 = lightWorld:newLight(136, 393, 130, 0, 0, 300)
	engineroomlight1:setGlowStrength(0.5)
	engineroomlight1:setSmooth(1.5)

	engineroomlight2 = lightWorld:newLight(136, 209, 130, 0, 0, 300)
	engineroomlight2:setGlowStrength(0.5)
	engineroomlight2:setSmooth(1.5)

	cockpitroomlight = lightWorld:newLight(538, 212, 155, 130, 0, 200)
	cockpitroomlight:setGlowStrength(0.1)
	cockpitroomlight:setSmooth(2)
	cockpitroomlight:setDirection(-math.pi * 3 / 2)

	-- SHADOWS
	for _,block in ipairs(blocks) do
		lightWorld:newRectangle(block.x + block.w / 2, block.y + block.h / 2, block.w, block.h)
	end
end

function lightsOn()
	mainroomlight:setVisible(true)
	engineroomlight1:setVisible(true)
	engineroomlight2:setVisible(true)
	cockpitroomlight:setVisible(true)
end

function lightsOff()
	mainroomlight:setVisible(false)
	engineroomlight1:setVisible(false)
	engineroomlight2:setVisible(false)
	cockpitroomlight:setVisible(false)
end