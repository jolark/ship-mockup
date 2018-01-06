-- Stars
local shipSpeed = 3

function initStars(stars)
	for _ = 1,100 do
		table.insert(stars, {x=math.random(love.graphics.getWidth()*2), y=math.random(-love.graphics.getHeight(), love.graphics.getHeight())})
	end
end

function updateStars(stars)
	-- randomly show stars from far right
	local appearing = math.random()
	if appearing > 0.90 then
		table.insert(stars, {x=love.graphics.getWidth()*2, y=math.random(-love.graphics.getHeight(), love.graphics.getHeight())})
	end

	-- moving
	for i,star in ipairs(stars) do
		if star.x == -love.graphics.getWidth() then
			table.remove(stars, i)
		else
			star.x = star.x - shipSpeed
		end
	end
end

function drawStars(stars)
	love.graphics.setBackgroundColor(21, 11, 21)
	love.graphics.clear()
	for _,star in ipairs(stars) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle('fill', star.x, star.y, 1)
	end
end