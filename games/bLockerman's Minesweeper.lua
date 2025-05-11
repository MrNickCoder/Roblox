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
	repeat task.wait(.1) until RStorage:FindFirstChild("Info");
	repeat task.wait(.1) until RStorage["Info"]:FindFirstChild("GameRunning");
	task.wait(5);

	local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()

	----------------------
	-- [[ INITIALIZE ]] --
	----------------------
	local Tiles = {}
	local Opened = { Color3.fromRGB(255, 255, 125); Color3.fromRGB(230, 230, 113); }
	local Closed = { Color3.fromRGB(103, 180, 88); Color3.fromRGB(117, 205, 100); }

	do
		function addMark(block, color)
			local mark;
			if not block:FindFirstChild("Paradoxium") then
				mark = Utility:Instance("Part", {
					Name = "Paradoxium";
					Parent = block;
					Color = color;
					Size = Vector3.new(5.01, 2, 2);
					Position = block.Position;
					Rotation = Vector3.new(0, 0, 90);
					Shape = Enum.PartType.Cylinder;
					Material = Enum.Material.SmoothPlastic;
					CanCollide = false;
					CanTouch = false;
					Anchored = true;
				})
			else
				mark = block["Paradoxium"];
				mark.Color = color;
			end

			return mark;
		end
		function isFlagged(block) return block:FindFirstChild("FlagBlock"); end
		function isMarked(block) return block:FindFirstChild("Paradoxium"); end
	end

	---------------------
	-- [[ FUNCTIONS ]] --
	---------------------
	function Initialize()
		Tiles = {};
		for _, block in pairs(game:GetService("Workspace")["Flag"]["Parts"]:GetChildren()) do -- CREATE ALL TILES
			local x = block.Position.X / block.Size.X
			local z = block.Position.Z / block.Size.Z
			if not Tiles[x] then Tiles[x] = {}; end
			Tiles[x][z] = {
				["X"] = x;
				["Z"] = z;
				["Block"] = block;
				["Neighbors"] = {};
				["Marked"] = false;
			}
			task.spawn(function() -- PROCESS TILE
				repeat task.wait(.1) until RStorage["Info"]["GameRunning"].Value;
				while task.wait(1) do
					if not RStorage["Info"]["GameRunning"].Value then break; end
					if Tiles[x][z]["Neighbors"] == {} then continue; end

					if table.find(Opened, block.Color) then
						Tiles[x][z]["Marked"] = true;
						Tiles[x][z]["Safe"] = true;
						for _, neighbor in pairs(Tiles[x][z]["Neighbors"]) do -- REMOVE OPENED NEIGHBORS
							table.remove(neighbor["Neighbors"], table.find(neighbor["Neighbors"], Tiles[x][z]))
						end
						if block.Color == Opened[2] then
							local mines = tonumber(block:FindFirstChild("NumberGui")["TextLabel"].Text)
							if #Tiles[x][z]["Neighbors"] == mines then
								for _, neighbor in pairs(Tiles[x][z]["Neighbors"]) do
									neighbor["Marked"] = true;
									neighbor["Safe"] = false;
								end
								Tiles[x][z]["Neighbors"] = {};
							end
						end
					end
				end
			end)
		end
		for x, _ in pairs(Tiles) do -- PROCESS NEIGHBORS
			for z, _ in pairs(Tiles[x]) do
				local offset = {
					{-1, -1}; {0, -1}; {1, -1};
					{-1,  0};          {1,  0};
					{-1,  1}; {0,  1}; {1,  1};
				};
				for _, v in pairs(offset) do -- ADD NEIGHBORS
					if not Tiles[x + v[1]] then continue; end
					if not Tiles[x + v[1]][z + v[2]] then continue; end
					if table.find(Closed, Tiles[x + v[1]][z + v[2]]["Block"].Color) then
						table.insert(Tiles[x][z]["Neighbors"], Tiles[x + v[1]][z + v[2]]);
					else
						Tiles[x + v[1]][z + v[2]]["Marked"] = true;
						Tiles[x + v[1]][z + v[2]]["Safe"] = true;
					end
				end
			end
		end
	end

	------------------
	-- [[ EVENTS ]] --
	------------------
	RStorage["Info"]["GameRunning"]:GetPropertyChangedSignal("Value"):Connect(function()
		if not RStorage["Info"]["GameRunning"].Value then return; end
		--Initialize();
	end)
	Initialize();

	print("Loaded bLockerman's Minesweeper Script!");
end)

if Success then
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end