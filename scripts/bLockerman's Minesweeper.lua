---------------------
-- [[ VARIABLES ]] --
---------------------
local Tiles = game:GetService("Workspace").Flag.Parts

local Opened = { Color3.fromRGB(255, 255, 125); Color3.fromRGB(230, 230, 113); }
local Closed = { Color3.fromRGB(103, 180, 88); Color3.fromRGB(117, 205, 100); }

---------------------
-- [[ FUNCTIONS ]] --
---------------------
function getBlockAtPosition(position)
	for _, v in pairs(Tiles:GetChildren()) do
		if (v.Position - position).Magnitude <= 1 then return v; end
	end
	return nil;
end
function getNeighbors(block)
	local blockPos = block.Position;
	local blockSize = block.Size;
	
	local offset = {
		[-1, -1]; [0, -1]; [1, -1];
		[-1,  0];          [1,  0];
		[-1,  1]; [0,  1]; [1,  1];
	};
	
	local neighbors = {}
	for _, v in pairs(offset) do
		local block = getBlockAtPosition(blockPos + Vector3.new(blockSize.X * v[0], 0, blockSize.Z * v[1]));
		table.insert(neighbors, block);
	end
	
	return neighbors
	--[[return {
		getBlockAtPosition(blockPos + Vector3.new(blockSize.X, 0, blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(blockSize.X, 0, 0));
		getBlockAtPosition(blockPos + Vector3.new(blockSize.X, 0, -blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(0, 0, -blockSize.Z));
		getBlockAtPosition(blackPos + Vector3.new(-blockSize.X, 0, -blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(-blockSize.X, 0, 0));
		getBlockAtPosition(blockPos + Vector3.new(-blockSize.X, 0, blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(0, 0, blockSize.Z));
	}]]
end
function isSafe()
	
end