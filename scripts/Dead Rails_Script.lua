if not game:IsLoaded() then game.Loaded:Wait() end

--------------------
-- [[ SERVICES ]] --
--------------------
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui");
local Lighting = game:GetService("Lighting");
local RStorage = game:GetService("ReplicatedStorage");
local UserIS = game:GetService("UserInputService");
local RService = game:GetService("RunService");

local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;

if game.PlaceId == 116495829188952 then StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "No Loading in Lobby!"; }); return; end

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Dead Rails Script!"; });
local Success, Result = pcall(function()
	print("Loading Dead Rails Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("HumanoidRootPart");
	task.wait(5)
	
	local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()

	------------------
	-- [[ CONFIG ]] --
	------------------
	local Config = {
		["Fullbright"] = false;
		
		["NoClip"] = false;
		
		["ESP"] = false;
		
		["Status"] = false;
		["Status Scale"] = "1";
	}
	Config = Utility:LoadConfig(Config, "Paradoxium/Dead Rails", "Settings.json");
	
	---------------------
	-- [[ UTILITIES ]] --
	---------------------
	do
		function CreateSettings()
			
		end
		function CreateESP()
			
		end
	end
	
	----------------------
	-- [[ INITIALIZE ]] --
	----------------------
	
	
	--------------------------
	-- [[ USER INTERFACE ]] --
	--------------------------
	
	
	------------------
	-- [[ EVENTS ]] --
	------------------
	local UpdaterThread = Utility:Thread("Updater", function()
		while task.wait() do
			
		end
	end):Start();
	
	UserIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.RightControl then
			if UserIS.MouseBehavior == Enum.MouseBehavior.LockCenter then print("Open")
			else print("Close") end
		end
	end)
	
	print("Dead Rails Script!");
end)

if Success then
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end