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
	addBlock(world, blocks,  125, 160, 390, 6)
	addBlock(world, blocks,  125, 160, 6, 287)
	addBlock(world, blocks,  258, 160, 6, 100)
	addBlock(world, blocks,  258, 315, 6, 132)
	addBlock(world, blocks,  124, 442, 389, 6)
	addBlock(world, blocks,  507, 289, 6, 157)
	addBlock(world, blocks,  507, 161, 6, 61)
	addBlock(world, blocks,  513, 202, 115, 6)
	addBlock(world, blocks,  620, 202, 6, 105)
	addBlock(world, blocks,  507, 302, 121, 6)
	addBlock(world, blocks,  258, 328, 106, 6)
	addBlock(world, blocks,  426, 328, 81, 6)
	addBlock(world, blocks,  130, 230, 85, 144)
	-- bed
	addBlock(world, blocks,  400, 363, 104, 75)
	addBlock(world, blocks,  477, 336, 30, 30)
	-- engine boards
	addBlock(world, blocks,  132, 169, 105, 22)
	addBlock(world, blocks,  132, 416, 105, 22)
	-- sofa
	-- addBlock(world, blocks,  326, 169, 106, 30)
	-- addBlock(world, blocks,  326, 198, 30, 30)
	-- addBlock(world, blocks,  405, 198, 30, 30)
	addBlock(world, blocks,  346, 253, 62, 3)
	-- table
	addBlock(world, blocks,  264, 168, 30, 80)
	-- plant
	addBlock(world, blocks,  480, 302, 16, 16)
	-- cockpit
	addBlock(world, blocks,  582, 210, 40, 90)
	return blocks
end