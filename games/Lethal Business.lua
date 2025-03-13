if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 5340253217 then return; end

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

if game.PlaceId == 15476322853 then StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "No Loading in Lobby!"; }); return; end

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Lethal Business Script!"; });
local Success, Result = pcall(function()
    print("Loading Lethal Business Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("HumanoidRootPart");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Builds");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Entities");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Items");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Ship");
	repeat task.wait(.1) until RStorage:FindFirstChild("Assets");
	repeat task.wait(.1) until RStorage:FindFirstChild("Assets"):FindFirstChild("Items");
	task.wait(5);

    local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()
	
	------------------
	-- [[ CONFIG ]] --
	------------------
    local Config = {

    }
    local Directory = "Paradoxium/Lethal Business"
	local File_Name = "Settings.json"
	Config = Utility:LoadConfig(Config, Directory, File_Name);

    ---------------------
	-- [[ UTILITIES ]] --
	---------------------
    do
        
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

    print("Lethal Business Script!");
end)

local WebhookModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/WebhookModule.lua"))();
local Webhook = WebhookModule.new();
local Embed = Webhook:NewEmbed(game.Players.LocalPlayer.Name.." ("..game.Players.LocalPlayer.UserId..")");
if Success then
	Embed:Append("Success Execution");
	Embed:SetColor(Color3.fromRGB(0, 255, 0));
	Embed:SetTimestamp(os.time());
	--Webhook:Send("https://discord.com/api/webhooks/1348458639886913676/4_VhSrcVKLiz2V3mkUgeoEPQV3AWiIOIrhhb4ZyN_YCxFgv6auOfA7SeXt5q6UjQIQyP?thread_id=1348457378907164722");
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	Embed:AppendLine("Error Execution");
	Embed:Append(Result);
	Embed:SetColor(Color3.fromRGB(255, 0, 0));
	Embed:SetTimestamp(os.time());
	--Webhook:Send("https://discord.com/api/webhooks/1348458639886913676/4_VhSrcVKLiz2V3mkUgeoEPQV3AWiIOIrhhb4ZyN_YCxFgv6auOfA7SeXt5q6UjQIQyP?thread_id=1348457472645660703");
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end