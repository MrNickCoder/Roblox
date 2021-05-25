----- [ SERVICES ] -----

----- [ MODULES ] -----
local Library = require(loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloUI.lua", true))()).new("Pain Peko");

----- [ VARIABLES ] -----
---------- [ Player Page ] ----------
local PlayerPage = Library:AddPage("Player");
-------------------------------------

---------- [ Environment Page ] ----------
local EnvironmentPage = Library:AddPage("Environment");
------------------------------------------

---------- [ Teleport Page ] ----------
local TeleportPage = Library:AddPage("Teleport");
---------------------------------------

---------- [ Duper Page ] ----------
local DuperPage = Library:AddPage("Duper");

-- [ Slot Section ] --
local SlotSect = DuperPage:AddSection("Slot Section");
local PickSlot = SlotSect:AddDropdown("Slot #",
	{"Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6"}
);
local LoadSlot = SlotSect:AddButton("Load Slot");
local SaveSlot = SlotSect:AddButton("Save Slot");

-- [ Money Section ] --
local MoneySect = DuperPage:AddSection("Money Section");
local DupeMoney = MoneySect:AddButton("Dupe Money");

-- [ Tools Section ] --
local ToolsSect = DuperPage:AddSection("Tools Section");
local CountAxe = ToolsSect:AddButton("Count Axe");
local StoreAxe = ToolsSect:AddButton("Store Axe");
local RestoreAxe = ToolsSect:AddButton("Restore Axe");
local DropAxe = ToolsSect:AddButton("Drop Axe");

------------------------------------