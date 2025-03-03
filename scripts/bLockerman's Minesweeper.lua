---------------------
-- [[ VARIABLES ]] --
---------------------
local Tiles = game:GetService("Workspace").Flags

---------------------
-- [[ FUNCTIONS ]] --
---------------------
function getBlockAtPosition(position)
	for _, v in pairs(Tiles:GetChildren()) do
		if (v.Position - position).Magnitude == 0 then return v; end
	end
	return nil;
end
function getNeighbors(block)
	local blockPos = block.Position;
	local blockSize = block.Size;
	
	return {
		getBlockAtPosition(blockPos + Vector3.new(blockSize.X, 0, blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(blockSize.X, 0, 0));
		getBlockAtPosition(blockPos + Vector3.new(blockSize.X, 0, -blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(0, 0, -blockSize.Z));
		getBlockAtPosition(blackPos + Vector3.new(-blockSize.X, 0, -blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(-blockSize.X, 0, 0));
		getBlockAtPosition(blockPos + Vector3.new(-blockSize.X, 0, blockSize.Z));
		getBlockAtPosition(blockPos + Vector3.new(0, 0, blockSize.Z));
	}
end