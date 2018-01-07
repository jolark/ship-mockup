-- Stars
function initStars(stars)
	for _ = 1,100 do
		table.insert(stars, {x=math.random(love.graphics.getWidth()*2), y=math.random(0, love.graphics.getHeight()*2)})
	end
end

function updateStars(stars, speed)
	-- randomly show stars from far right
	local appearing = math.random()
	if appearing > 0.90 then
		table.insert(stars, {x=love.graphics.getWidth()*2, y=math.random(0, love.graphics.getHeight()*2)})
	end

	-- moving
	for i,star in ipairs(stars) do
		if star.x == -love.graphics.getWidth() then
			table.remove(stars, i)
		else
			star.x = star.x - speed
		end
	end
end

function drawStars(stars)
	love.graphics.setBackgroundColor(21, 11, 21)
	love.graphics.clear()
	for _,star in ipairs(stars) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle('fill', star.x, star.y, 2)
	end
end