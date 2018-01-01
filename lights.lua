function addLights(blocks)
	local mainroomlight = lightWorld:newLight(475, 190, 155, 130, 0, 1500)
	mainroomlight:setGlowStrength(0.25)
	mainroomlight:setSmooth(1.5)

	local engineroomlight1 = lightWorld:newLight(250, 215, 55, 130, 0, 100)
	engineroomlight1:setGlowStrength(0.25)
	engineroomlight1:setSmooth(1.5)

	local engineroomlight2 = lightWorld:newLight(255, 380, 55, 130, 0, 100)
	engineroomlight2:setGlowStrength(0.25)
	engineroomlight2:setSmooth(1.5)

	-- SHADOWS
	for _,block in ipairs(blocks) do
		lightWorld:newRectangle(block.x + block.w / 2, block.y + block.h / 2, block.w, block.h)
	end
end