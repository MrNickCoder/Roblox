----- [ SERVICES ] -----
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StartGui = game:GetService("StarterGui");
------------------------

----- [ MODULES ] -----
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloUI.lua", true))().new("Pettan");
-----------------------

----- [ PUBLIC VARIABLES ] -----
local Player = Players.LocalPlayer;
local Character = Player.Character;
local PlayerGui = Player.PlayerGui;

local DeliveryPoints = game:GetService("Workspace").GameLogic.DeliveryPoints;

local RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes");
local SellPackage = RemotesFolder:FindFirstChild("SellBox");
--------------------------------

----- [ PUBLIC FUNCTIONS ] -----

--------------------------------


-----[[====================================================================================================]]-----


--[[====== [ Player Page ] ======]]--
local PlayerPage = Library:AddPage("Player");

--[[=============================]]--

--[[====== [ Game Page ] ======]]--
local GamePage = Library:AddPage("Game");

-- [ Delivery ] --
local DeliverySect = GamePage:AddSection("Delivery");
local FastDelivery = DeliverySect:AddTimer("Fast Delivery(Need a package on hand)", false, {HH = 0, MM = 0, SS = 0, MS = 100}, function()
	local Boxes = Character:FindFirstChild("Boxes");
	if Boxes then
		if #Boxes:GetChildren() >= 1 then
			local NextDelivery = PlayerGui.Main.NextDelivery.Body;
			local Buyer = string.split(NextDelivery.Text, ",");
			
			SellPackage:InvokeServer(DeliveryPoints[Buyer[1]]);
		end
	end
end);

--[[==================================]]--

--[[====== [ Teleport Page ] ======]]--
local TeleportPage = Library:AddPage("Teleport");

-- [ Players Section ] --
local DeliveryTeleportSect = TeleportPage:AddSection("Delivery Teleport");
--[[===============================]]--