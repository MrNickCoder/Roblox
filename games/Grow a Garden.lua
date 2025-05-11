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

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Grow a Garden Script!"; });
local Success, Result = pcall(function()
    print("Loading Grow a Garden Script!");
    repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace[LocalPlayer.Name]:FindFirstChild("HumanoidRootPart");
    repeat task.wait(.1) until game.Workspace:FindFirstChild("Farm");
    repeat task.wait(.1) until game.Workspace:FindFirstChild("NPCS");

    ----------------
    -- [ CONFIG ] --
    ----------------

    -------------------
    -- [ UTILITIES ] --
    -------------------
    local Data = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/data/Grow%20a%20Garden.lua"))()
    local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()

    -------------------
    -- [ VARIABLES ] --
    -------------------
    local Farm;
    while Farm == nil do
        for _, v in pairs(game.Workspace["Farm"]:GetChildren()) do
            if not v:FindFirstChild("Important") then continue; end
            if not v["Important"]:FindFirstChild("Data") then continue; end
            if not v["Important"]["Data"]:FindFirstChild("Owner") then continue; end
            if not v["Important"]["Data"]["Owner"].Value == LocalPlayer.DisplayName then continue; end
            Farm = v; break;
        end
        if Farm == nil then task.wait(.1); end
    end

    -------------------
    -- [ FUNCTIONS ] --
    -------------------

    print("Loaded Grow a Garden Script!");
end)