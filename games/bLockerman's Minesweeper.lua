if not game:IsLoaded() then game.Loaded:Wait() end

--------------------
-- [[ SERVICES ]] --
--------------------
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local Lighting = game:GetService("Lighting");
local RStorage = game:GetService("ReplicatedStorage");
local UserIS = game:GetService("UserInputService");
local RService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");

local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
local Mouse = LocalPlayer:GetMouse();

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading bLockerman's Minesweeper Script!"; });
local Success, Result = pcall(function()
	print("Loading bLockerman's Minesweeper Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace[LocalPlayer.Name]:FindFirstChild("HumanoidRootPart");
	task.wait(5);

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
			{-1, -1}; {0, -1}; {1, -1};
			{-1,  0};          {1,  0};
			{-1,  1}; {0,  1}; {1,  1};
		};
		local neighbors = {}
		for _, v in pairs(offset) do
			local block = getBlockAtPosition(blockPos + Vector3.new(blockSize.X * v[0], 0, blockSize.Z * v[1]));
			table.insert(neighbors, block);
		end
		return neighbors
	end
	function isSafe()
	end
end)
