function newAnimation(image, quadwidth, quadheight, direction, duration)
	local quads = {}
	if direction == 'right' then
		for i=0,image:getWidth()-quadwidth,quadwidth do
			table.insert(quads, love.graphics.newQuad(i, 0, quadwidth, quadheight, image:getWidth(), image:getHeight()))
		end
	elseif direction == 'down' then
		for i=0,image:getHeight()-quadheight,quadheight do
			table.insert(quads, love.graphics.newQuad(0, i, quadwidth, quadheight, image:getWidth(), image:getHeight()))
		end
	end

    local animation = {}
    animation.spriteSheet = image;
    animation.quads = quads;
    animation.duration = duration or 1
    animation.currentTime = 0
 	animation.rot = 0
    return animation
end

function newAnimationFromQuads(image, quads, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = quads;
    animation.duration = duration or 1
    animation.currentTime = 0
 	animation.rot = 0
    return animation
end

function choose(tabl, weights)
	if weights == nil then
		return tabl[math.random(#tabl)]
	else
		local s = 0
		for _,v in ipairs(weights) do
			s = s + v 
		end
		local r = math.random(s)
		local sum = 0
		for i=1,#weights do
			sum = sum + weights[i]
			if r <= sum then
				return tabl[i]
			end
		end
	end
end

function drawBox(box, r,g,b)
	love.graphics.setColor(r,g,b,70)
	love.graphics.rectangle('fill', box.x, box.y, box.w, box.h)
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle('line', box.x, box.y, box.w, box.h)
end