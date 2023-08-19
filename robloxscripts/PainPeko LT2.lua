----- [ SERVICES ] -----
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StartGui = game:GetService("StarterGui");
------------------------

----- [ MODULES ] -----
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloUI.lua", true))().new("Pain Peko");
-----------------------

----- [ PUBLIC VARIABLES ] -----
local Player = Players.LocalPlayer;
local Character = Player.Character;
--------------------------------

----- [ PUBLIC FUNCTIONS ] -----

--------------------------------


-----[[====================================================================================================]]-----


--[[====== [ Player Page ] ======]]--
local PlayerPage = Library:AddPage("Player");

--[[=============================]]--

--[[====== [ Design Page ] ======]]--
local DesignPage = Library:AddPage("Design");

--[[=============================]]--

--[[====== [ Environment Page ] ======]]--
local EnvironmentPage = Library:AddPage("Environment");

--[[==================================]]--

--[[====== [ Teleport Page ] ======]]--
local TeleportPage = Library:AddPage("Teleport");

-- [ Players Section ] --
local PlayerTeleportSect = TeleportPage:AddSection("Player Teleport");
--[[===============================]]--

--[[====== [ Duper Page ] ======]]--
local DuperPage = Library:AddPage("Duper");
----- [ PRIVATE VARIABLE ] -----
DuperPage.MoneyCooldown = false;
DuperPage.CurrentSlot = Player:WaitForChild("CurrentSaveSlot").Value;
DuperPage.ScriptLoadOrSave = false;
DuperPage.CurrentlySavingOrLoading = Player:WaitForChild("CurrentlySavingOrLoading");
--------------------------------

----- [ PRIVATE FUNCTIONS ] -----
function DuperPage.CheckIfSlotAvailable(Slot)
	for a, b in pairs(ReplicatedStorage.LoadSaveRequests.GetMetaData:InvokeServer(Player)) do
		if a == Slot then
			for c,d in pairs(b) do
				if c == "NumSaves" and d ~= 0 then
					return true
				else
					return false
				end
			end
		end
	end
end
---------------------------------

-- [ Slot Section ] --
local SlotSect = DuperPage:AddSection("Slot Section");
local PickSlot = SlotSect:AddRadio("Slot No.", nil,
	{"Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6"}
);
local LoadSlot = SlotSect:AddButton("Load Slot", function()
	DuperPage.ScriptLoadOrSave = true;
	
	if DuperPage.CheckIfSlotAvailable(tonumber(string.sub(PickSlot.GetSelected(), 6, 6))) == true then
		local LoadSlot = ReplicatedStorage.LoadSaveRequests.RequestLoad:InvokeServer(tonumber(string.sub(PickSlot.GetSelected(), 6, 6)));
		if LoadSlot == false then
			Library:Notification("Cooldown Notification", "You aren't abled to load now", "None", 1);
		end
		if LoadSlot == true then
			Library:Notification("Reload Notification", "Loaded Your Slot", "None", 2);
			DuperPage.CurrentSlot = tonumber(string.sub(PickSlot.GetSelected(), 6, 6));
		end
	else
		Library:Notification("Slot not Available", "This Slot is not Available, please choose another slot", "None", 2);
	end
	
	DuperPage.ScriptLoadOrSave = false;
end);
local SaveSlot = SlotSect:AddButton("Save Slot", function()
	DuperPage.ScriptLoadOrSave = true;
	local SaveSlot = ReplicatedStorage.LoadSaveRequests.RequestSave:InvokeServer(tonumber(string.sub(PickSlot.GetSelected(), 6, 6)));
	if SaveSlot == true then
		Library:Notification("Save Notification", "Saved your Slot", "None", 2);
		wait(.5)
		DuperPage.ScriptLoadOrSave = false;
	elseif SaveSlot == false then
		Library:Notification("Already Saving", "Saving/Loading is currently in Progress", "None", 1);
		wait(.5)
		DuperPage.ScriptLoadOrSave = false;
	end
end);

-- [ Money Section ] --
local MoneySect = DuperPage:AddSection("Money Section");
local DupeMoney = MoneySect:AddButton("Dupe Money", function()
	if DuperPage.MoneyCooldown == true then
		Library:Notification("Cooldown Notification", "Wait for your Money to come back", "None", 2);
		return
	elseif DuperPage.MoneyCooldown == false then
		DuperPage.MoneyCooldown = true;
		Library:Notification("Money Sent", "Wait about 2 minutes for your Money to come back", "None", 5);
		ReplicatedStorage.Transactions.ClientToServer.Donate:InvokeServer(Player, Player.leaderstats.Money.Value, 1);
		Library:Notification("Money Received", "You received your money that you have sent earlier", "None", 5);
		DuperPage.MoneyCooldown = false;
	end
end);
local AutoDupeMoney = MoneySect:AddTimer("Auto Dupe Money", false, {HH = 0; MM = 2; SS = 30;});

-- [ Tools Section ] --
local ToolsSect = DuperPage:AddSection("Tools Section");
local CountAxe = ToolsSect:AddButton("Count Axe");
local StoreAxe = ToolsSect:AddButton("Store Axe");
local RestoreAxe = ToolsSect:AddButton("Restore Axe");
local DropAxe = ToolsSect:AddButton("Drop Axe");

----- [ PRIVATE EVENTS ] -----
coroutine.resume(coroutine.create(function()
	while wait(.15) do
		if DuperPage.CurrentlySavingOrLoading.Value == true and DuperPage.ScriptLoadOrSave == false then
			repeat
				wait(1)
			until DuperPage.CurrentlySavingOrLoading.Value == false;
			wait(1)
			DuperPage.CurrentSlot = Player.CurrentSaveSlot.Value;
			print(DuperPage.CurrentSlot)
		end
	end
end))
------------------------------

--[[============================]]--