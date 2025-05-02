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

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading PETAPETA: School of Nightmares Script!"; });
local Success, Result = pcall(function()
    print("Loading PETAPETA: School of Nightmares Script!");
    repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace[LocalPlayer.Name]:FindFirstChild("HumanoidRootPart");
    repeat task.wait(.1) until game.Workspace:FindFirstChild("Client");
    repeat task.wait(.1) until game.Workspace["Client"]:FindFirstChild("Enemy");
    task.wait(5)

    local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()

    ---------------------
	-- [[ UTILITIES ]] --
	---------------------
    do
        function DelayedHighlight(Model)
            task.wait(0.5)
            return Utility:Instance("Highlight", { Parent = Model; FillColor = Color3.fromRGB(255, 0, 255); })
        end
    end

    ------------------
	-- [[ EVENTS ]] --
	------------------
    game.Workspace.ChildAdded:Connect(function(instance)

    end)

    print("Loaded PETAPETA: School of Nightmares Script!");
end)