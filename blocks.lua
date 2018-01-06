-- Block functions


local function addBlock(world, blocks, x,y,w,h)
	local block = {x=x,y=y,w=w,h=h}
	blocks[#blocks+1] = block
	world:add(block, x,y,w,h)
end

function drawBlocks(blocks)
	for _,block in ipairs(blocks) do
		drawBox(block, 255,0,0)
	end
end

function initBlocks(world)
	local blocks = {}
	-- walls
	addBlock(world, blocks,  250, 320, 780, 12)
	addBlock(world, blocks,  250, 320, 12, 574)
	addBlock(world, blocks,  516, 320, 12, 200)
	addBlock(world, blocks,  516, 630, 12, 264)
	addBlock(world, blocks,  248, 884, 778, 12)
	addBlock(world, blocks,  1014, 322, 12, 122)
	addBlock(world, blocks,  1014, 578, 12, 314)
	addBlock(world, blocks,  1026, 404, 232, 12)
	addBlock(world, blocks,  1240, 404, 12, 210)
	addBlock(world, blocks,  1014, 604, 242, 12)
	addBlock(world, blocks,  516, 656, 212, 12)
	addBlock(world, blocks,  852, 656, 162, 12)
	addBlock(world, blocks,  260, 460, 170, 288)
	-- cockpit chair
	addBlock(world, blocks,  1120, 502, 52, 40)
	-- bed
	addBlock(world, blocks,  800, 726, 208, 150)
	addBlock(world, blocks,  954, 672, 60, 60)
	-- engine boards
	addBlock(world, blocks,  264, 338, 210, 44)
	addBlock(world, blocks,  264, 832, 210, 44)
	-- sofa
	-- addBlock(world, blocks,  652, 338, 212, 60)
	-- addBlock(world, blocks,  652, 396, 60, 60)
	-- addBlock(world, blocks,  810, 396, 60, 60)
	addBlock(world, blocks,  692, 506, 124, 6)
	-- table
	addBlock(world, blocks,  528, 336, 60, 160)
	-- plant
	addBlock(world, blocks,  960, 604, 32, 32)
	-- cockpit
	addBlock(world, blocks,  1164, 420, 80, 180)
	return blocks
end