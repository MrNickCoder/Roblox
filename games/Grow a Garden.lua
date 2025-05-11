if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 7436755782 then return; end

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
        for _, farm in pairs(game.Workspace["Farm"]:GetChildren()) do
            if not farm:FindFirstChild("Important") then continue; end
            if not farm["Important"]:FindFirstChild("Data") then continue; end
            if not farm["Important"]["Data"]:FindFirstChild("Owner") then continue; end
            if not farm["Important"]["Data"]["Owner"].Value == LocalPlayer.DisplayName then continue; end
            Farm = farm; break;
        end
        if Farm == nil then task.wait(.1); else break; end
    end

    -------------------
    -- [ FUNCTIONS ] --
    -------------------

    ----------------
    -- [ EVENTS ] --
    ----------------
    local Moonlit = 0;
    local Frozen = 0;
    local Shocked = 0;
    for _, crop in pairs(Farm["Important"]["Plants_Physical"]:GetChildren()) do
        if Data["Crops"][crop.Name]["Multi"] then
            for _, fruit in pairs(crop["Fruits"]:GetChildren()) do
                if fruit:GetAttribute("Moonlit") then Moonlit = Moonlit + 1; Utility:Instance("Highlight", { Parent = fruit; }) end
                if fruit:GetAttribute("Frozen") then Frozen = Frozen + 1; end
                if fruit:GetAttribute("Shocked") then Shocked = Shocked + 1; end
            end
        else
            if crop:GetAttribute("Moonlit") then Moonlit = Moonlit + 1; Utility:Instance("Highlight", { Parent = fruit; }) end
            if crop:GetAttribute("Frozen") then Frozen = Frozen + 1; end
            if crop:GetAttribute("Shocked") then Shocked = Shocked + 1; end
        end
    end
    --print("Moonlit: "..tostring(Moonlit))
    --print("Frozen: "..tostring(Frozen))
    --print("Shocked: "..tostring(Shocked))

    print("Loaded Grow a Garden Script!");
end)