--------------------------
----- [ UPDATE FIX ] -----
--------------------------
local Version = "v1.0.0b01"

-------------------------------
----- [ LOADING SECTION ] -----
-------------------------------
if game.GameId ~= 3183403065 then return end
repeat task.wait() until game:IsLoaded()
if game.PlaceId == 8304191830 then
	repeat task.wait() until game:GetService("Workspace"):FindFirstChild(game.Players.LocalPlayer.Name)
	repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("collection"):FindFirstChild("grid"):FindFirstChild("List"):FindFirstChild("Outer"):FindFirstChild("UnitFrames")
	repeat task.wait() until game:GetService("ReplicatedStorage").packages:FindFirstChild("assets")
	repeat task.wait() until game:GetService("ReplicatedStorage").packages:FindFirstChild("StarterGui")
else
	repeat task.wait() until game:GetService("Workspace"):FindFirstChild(game:GetService("Players").LocalPlayer.Name)
	game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
end

------------------------
----- [ SERVICES ] -----
------------------------
local HttpService			= game:GetService("HttpService")
local Workspace				= game:GetService("Workspace")
local ReplicatedStorage		= game:GetService("ReplicatedStorage")
local Players				= game:GetService("Players")
local RunService			= game:GetService("RunService")
local UserInputService		= game:GetService("UserInputService")
local TeleportService		= game:GetService("TeleportService")

--------------------------
----- [ INITIALIZE ] -----
--------------------------
local Player				= Players.LocalPlayer
local Mouse					= Player:GetMouse()
local Lobby_ID				= 8304191830

local UILibrary				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloLib.lua"))()
local AAData				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/data/AnimeAdventures.lua"))()
local Utility				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/modules/UtilityModule.lua"))()
local Webhook				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/modules/WebhookModule.lua"))()
local Executor				= tostring(identifyexecutor())

local Threads				= {}
local BufferContainer		= {}
local Getter				= {}
local UISetup				= {}
local Functions				= {}
local MacroData				= {}

local Loader				= require(ReplicatedStorage.src.Loader)
local UnitsData				= require(ReplicatedStorage.src.Data.Units)
local ItemsFolder			= ReplicatedStorage.src.Data.Items
local ItemInventoryService	= Loader.load_client_service(script, "ItemInventoryServiceClient")
local PlacementService		= Loader.load_client_service(script, "PlacementServiceClient")

local Count_Portal_List			= 0
local Table_All_Items_Old_data	= {}
local Table_All_Items_New_data	= {}
local CurrentMap				= nil

-------------------------
----- [ PRE-SETUP ] -----
-------------------------
do
	----- [ Common ] -----
	function InLobby() return (game.PlaceId == Lobby_ID) end

	----- [ Game ] -----
	function Started() repeat task.wait() until Workspace:WaitForChild("_waves_started").Value == true; return game:GetService("Workspace")["_waves_started"].Value end
	function Ended() return Workspace:WaitForChild("_DATA"):WaitForChild("GameFinished").Value end

	----- [ Map Getter ] -----
	function Getter:GetLevelData() local List = {}; for Index, Value in pairs(Workspace._MAP_CONFIG:WaitForChild("GetLevelData"):InvokeServer()) do List[Index] = Value end return List end
	function Getter:GetCurrentLevelId() if Workspace._MAP_CONFIG then return Getter:GetLevelData()["id"] end end
	function Getter:GetCurrentLevelName() if Workspace._MAP_CONFIG then return Getter:GetLevelData()["name"] end end
	function Getter:GetCurrentLevelTier() if Workspace._MAP_CONFIG then end end
	function Getter:GetCurrentMap()
		for Map, Identifiers in pairs(AAData["Identifiers"]["Map"]) do
			if Getter:GetLevelData()["map"] then
				if table.find(Identifiers, Getter:GetLevelData()["map"]) then
					return tostring(Map)
				end
			end
		end
		return nil
	end
	--------------------------

	----- [ Item Getter ] -----
	function Getter:GetInventoryItemsUniqueItems() return ItemInventoryService["session"]["inventory"]["inventory_profile_data"]["unique_items"] end
	function Getter:GetInventoryItems() return ItemInventoryService["session"]["inventory"]["inventory_profile_data"]["normal_items"] end
	---------------------------

	----- [ Unit Getter ] -----
	function Getter:GetUnitsEquipped() return ItemInventoryService["session"]["collection"]["collection_profile_data"]["equipped_units"] end
	function Getter:GetUnitsOwned() return ItemInventoryService["session"]["collection"]["collection_profile_data"]["owned_units"] end
	---------------------------

end

if not InLobby() then Getter:GetLevelData() end
if not InLobby() then CurrentMap = Getter:GetCurrentMap(); end

---------------------------------
----- [ SETTINGS / CONFIG ] -----
---------------------------------
local MainDirectory = "Astral_V1_Anime_Adventures/"..Players.LocalPlayer.Name -- Main Directory
local MacrosDirectory = MainDirectory.."/Macros"
local UnitsDirectory = MainDirectory.."/Units"
local SettingsFile = "Settings.json"

Settings = {}
function SaveSettings() Settings = Utility:SaveConfig(Settings, MainDirectory, SettingsFile); warn("Settings Saved!") end
function LoadSettings() return Utility:LoadConfig(Settings, MainDirectory, SettingsFile) end
function SaveUnitPosition(UnitSlot, Positions, Reset)
	if not Settings["World Positions"] then Settings["World Positions"] = {} end
	if not Settings["World Positions"][CurrentMap] then Settings["World Positions"][CurrentMap] = {} end
	if not Settings["World Positions"][CurrentMap][UnitSlot] then Settings["World Positions"][CurrentMap][UnitSlot] = {} end
	if Reset then Settings["World Positions"][CurrentMap][UnitSlot] = {} end

	for Index, Values in pairs(Positions) do
		if not Settings["World Positions"][CurrentMap][UnitSlot][Index] then Settings["World Positions"][CurrentMap][UnitSlot][Index] = {} end
		Settings["World Positions"][CurrentMap][UnitSlot][Index]["x"] = Values.Position.X
		Settings["World Positions"][CurrentMap][UnitSlot][Index]["y"] = Values.Position.Y
		Settings["World Positions"][CurrentMap][UnitSlot][Index]["z"] = Values.Position.Z
	end
	SaveSettings()
end
Settings = LoadSettings()

---------------------------------
----- [ ITEM DROP RESULTS ] -----
---------------------------------
if not InLobby() then
	Started()
	for _, Items in pairs(ItemsFolder:GetDescendants()) do
		if Items:IsA("ModuleScript") then
			for Index, Item in pairs(require(Items)) do
				Table_All_Items_Old_data[Index] = {}
				Table_All_Items_Old_data[Index]["Name"] = Item["name"]
				Table_All_Items_Old_data[Index]["Count"] = 0
				Table_All_Items_New_data[Index] = {}
				Table_All_Items_New_data[Index]["Name"] = Item["name"]
				Table_All_Items_New_data[Index]["Count"] = 0
			end
		end
	end
	for Index, Unit in pairs(UnitsData) do
		if Unit["rarity"] then
			Table_All_Items_Old_data[Index] = {}
			Table_All_Items_Old_data[Index]["Name"] = Unit["name"]
			Table_All_Items_Old_data[Index]["Count"] = 0
			Table_All_Items_Old_data[Index]["Count Shiny"] = 0
			Table_All_Items_New_data[Index] = {}
			Table_All_Items_New_data[Index]["Name"] = Unit["name"]
			Table_All_Items_New_data[Index]["Count"] = 0
			Table_All_Items_New_data[Index]["Count Shiny"] = 0
		end
	end
	for Index, Item in pairs(Getter:GetInventoryItems()) do Table_All_Items_Old_data[Index]["Count"] = Item end
	for _, Item in pairs(Getter:GetInventoryItemsUniqueItems()) do
		if string.find(Item["item_id"], "portal") or string.find(Item["item_id"], "disc") then
			Count_Portal_List = Count_Portal_List + 1
			Table_All_Items_Old_data[Item["item_id"]]["Count"] = Table_All_Items_Old_data[Item["item_id"]]["Count"] + 1
		end
	end
	for _, Unit in pairs(Getter:GetUnitsOwned()) do
		Table_All_Items_Old_data[Unit["unit_id"]]["Count"] = Table_All_Items_Old_data[Unit["unit_id"]]["Count"] + 1
		if Unit["shiny"] then
			Table_All_Items_Old_data[Unit["unit_id"]]["Count"] = Table_All_Items_Old_data[Unit["unit_id"]]["Count"] - 1
			Table_All_Items_Old_data[Unit["unit_id"]]["Count Shiny"] = Table_All_Items_Old_data[Unit["unit_id"]]["Count Shiny"] + 1
		end
	end
end

------------------------------
----- [ USER INTERFACE ] -----
------------------------------
local Window; -- Window
local PHome, PFarm, PUnit, PMacro, PShopNItems, PMisc, PDebug; -- Pages
do
	if game.CoreGui:FindFirstChild("HoloLibUI") then
		if getgenv().SHUTDOWN then getgenv().SHUTDOWN() end
		game.CoreGui["HoloLibUI"]:Destroy()
	end
	Window = UILibrary.new("[Astral V1] Anime Adventures "..Version.." - "..Executor, {
		Size = UDim2.new(0, 700, 0, 400),
		ToggleKey = Enum.KeyCode.P,
	})

	----- [ Home Page ] -----
	function UISetup:Home()
		PHome = Window:AddPage("Home", "🏠")
		local SDevelopers = PHome:AddSection("Anime Adventures")
		SDevelopers:AddLabel("📝 Scripted by: Arpon AG#6612 & Forever4D#0001 & HOLYSHz#3819")
		SDevelopers:AddLabel("📝 Also thanks to Trapstar#7845, bytenode#9646 for the help!")
		SDevelopers:AddLabel("📝 Improved by: NickCoder")
		SDevelopers:AddLabel("📝 UI By: NickCoder")
		SDevelopers:AddLabel("🔧 To toggle the UI press \" P \"")

		local SHelp = PHome:AddSection("❓ Help ❓")
		SHelp:AddLabel("double_cost = 'High Cost'")
		SHelp:AddLabel("short_range = 'Short Range'")
		SHelp:AddLabel("fast_enemies = 'Fast Enemies'")
		SHelp:AddLabel("regen_enemies = 'Regen Enemies'")
		SHelp:AddLabel("tank_enemies = 'Tank Enemies'")
		SHelp:AddLabel("shield_enemies = 'Shield Enemies'")
		SHelp:AddLabel("triple_cost = 'Triple Cost'")
		SHelp:AddLabel("hyper_regen_enemies = 'Hyper-Regen Enemies'")
		SHelp:AddLabel("hyper_shield_enemies = 'Steel-Plated Enemies'")
		SHelp:AddLabel("godspeed_enemies = 'Godspeed Enemies'")
		SHelp:AddLabel("flying_enemies = 'Flying Enemies'")
		SHelp:AddLabel("mini_range = 'Mini-Range'")
	end
	-----------------------

	----- [ Auto Farm Config ] -----
	local SFarmSplits;
	local FarmCategory;
	local AutoStart, AutoReplay, AutoPortalReplay, AutoNextStory, AutoLeave;
	function UISetup:AutoFarm()
		PFarm = Window:AddPage("Auto Farm", "🤖")
		SFarmSplits = PFarm:AddSplit()
		if Settings and not Settings["Farm Config"] then Settings["Farm Config"] = {} end
		if Settings and not Settings["Farm Config"].Auto then Settings["Farm Config"].Auto = {} end
		if Settings and not Settings["World Config"] then Settings["World Config"] = {} end
		local SFarmConfig = PFarm:AddSection("⚙️ Auto Farm Configuration ⚙️", {Split = SFarmSplits, Side = "Left"})

		SFarmConfig:AddLabel("🔱 Farm Category")
		FarmCategory = SFarmConfig:AddDropdown("", function(value)
			if Settings["Farm Config"]["Category"] == value then return end
			Settings["Farm Config"]["Category"] = value
			Settings["World Config"]["Type"] = AAData["World Type"]["Type"][value]["Worlds"][1]
			warn("Changed Farming Type to "..value)
			getgenv().UpdateOptions(value)
			getgenv().UpdateWorldType(value)

			SaveSettings()
		end, {
			Options = AAData["World Type"]["Types"],
			Value = Settings["Farm Config"]["Category"] or AAData["World Type"]["Types"][1],
			ExpandLimit = 5
		})

		SFarmConfig:AddLabel()
		AutoStart = SFarmConfig:AddToggle("🌾 Auto Start", function(value) Settings["Farm Config"].Auto["Start"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Start"] or false})
		AutoReplay = SFarmConfig:AddToggle("🏃 Auto Replay", function(value) Settings["Farm Config"].Auto["Replay"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Replay"] or false})
		AutoPortalReplay = SFarmConfig:AddToggle("🏃 Auto Pick Portal [Replay]", function(value) Settings["Farm Config"].Auto["Replay Portal"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Replay Portal"] or false})
		AutoNextStory = SFarmConfig:AddToggle("🏃 Auto Next Story", function(value) Settings["Farm Config"].Auto["Next Story"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Next Story"] or false})
		AutoLeave = SFarmConfig:AddToggle("🏃 Auto Leave", function(value) Settings["Farm Config"].Auto["Leave"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Leave"] or false})

		SFarmConfig:AddLabel()
		SFarmConfig:AddToggle("⭐️ Sell Units At Wave", function(value) Settings["Farm Config"].Auto["Wave Sell"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Wave Sell"] or false})
		SFarmConfig:AddToggle("⭐️ Leave At Wave", function(value) Settings["Farm Config"].Auto["Wave Leave"] = value; SaveSettings() end, {Active = Settings["Farm Config"].Auto["Wave Leave"] or false})
		SFarmConfig:AddTextbox("🏃 Sell or Leave At Wave", function(value) Settings["Farm Config"].Auto["Wave Sell or Leave"] = value; SaveSettings() end, {Placeholder = "Value", Text = Settings["Farm Config"].Auto["Wave Sell or Leave"] or "", Pattern = "[%d-]+"})

		-----------------------------------------

		getgenv().UpdateOptions = function(value)
			AutoReplay.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Replay"]
			AutoPortalReplay.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Portal Replay"]
			AutoNextStory.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Next Story"]
		end

		getgenv().UpdateOptions(FarmCategory.Data.Value)

		UISetup:WorldConfig()
	end
	-------------------------

	----- [ World Config ] -----
	local WorldType, WorldLevel, WorldDifficulty, IgnoredMap, IgnoredDamageModifier, IgnoredTier, IgnoredChallenge;
	function UISetup:WorldConfig()
		if Settings and not Settings["World Config"].Ignored then Settings["World Config"].Ignored = {} end
		local SWorldConfig = PFarm:AddSection("🌏 World Config 🌏", {Split = SFarmSplits, Side = "Right"})

		local WorldTypeLabel = SWorldConfig:AddLabel("🌏 Select World")
		WorldType = SWorldConfig:AddDropdown("", function(value)
			if Settings["World Config"]["Type"] == value then return end
			Settings["World Config"]["Type"] = value
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value] then
				Settings["World Config"]["Level"] = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"][1]
			end
			getgenv().UpdateWorldLevel(value)
			warn("World Type Changed to "..value)

			SaveSettings()
		end, {ExpandLimit = 5})

		local WorldLevelSeparator = SWorldConfig:AddLabel()
		local WorldLevelLabel = SWorldConfig:AddLabel("🎚️ Select Level")
		WorldLevel = SWorldConfig:AddDropdown("", function(value)
			if Settings["World Config"]["Level"] == value then return end
			Settings["World Config"]["Level"] = value
			if string.find(Settings["World Config"]["Level"], "_infinite") or table.find({"Legend Stages", "Raid Worlds"}, Settings["Farm Config"]["Category"]) then
				Settings["World Config"]["Difficulty"] = "Hard"
			elseif table.find({"Portals", "Dungeon", "Secret Portals"}, Settings["Farm Config"]["Category"]) then
				Settings["World Config"]["Difficulty"] = "Default"
			else
				Settings["World Config"]["Difficulty"] = "Normal"
			end
			if FarmCategory.Data.Value == "Story Worlds" then
				if string.find(Settings["World Config"]["Level"], "_infinite") then AutoNextStory.Toggle.Visible = false
				else AutoNextStory.Toggle.Visible = true end
			end

			warn("World Level Changed to "..value)
			getgenv().UpdateWorldDifficulty(value)
			getgenv().UpdateIgnoredMap(value)
			getgenv().UpdateIgnoredDamageModifier(value)
			getgenv().UpdateIgnoredTier(value)
			getgenv().UpdateIgnoredChallenge(value)

			SaveSettings()
		end, {})

		local WorldDifficultySeparator = SWorldConfig:AddLabel()
		local WorldDifficultyLabel = SWorldConfig:AddLabel("🔫 Select Difficulty")
		WorldDifficulty = SWorldConfig:AddDropdown("", function(value)
			if Settings["World Config"]["Difficulty"] == value then return end
			Settings["World Config"]["Difficulty"] = value
			warn("Changed World Difficulty to "..value)

			SaveSettings()
		end, {})

		local IgnoredSeperator = SWorldConfig:AddLabel()

		IgnoredMap = SWorldConfig:AddDropdown("🗺️ Ignored Maps", function(value)
			if Settings["World Config"].Ignored["Map"] == value then return end
			Settings["World Config"].Ignored["Map"] = value
			warn("Ignored World Map Changed to "..table.concat(value, ", "))

			SaveSettings()
		end, {MultiValue = true, ExpandLimit = 5})
		IgnoredDamageModifier = SWorldConfig:AddDropdown("🩸 Ignored Damage Modifier", function(value)
			if Settings["World Config"].Ignored["Damage Modifier"] == value then return end
			Settings["World Config"].Ignored["Damage Modifier"] = value
			warn("Ignored World Damage Modifier Changed to "..table.concat(value, ", "))

			SaveSettings()
		end, {MultiValue = true, ExpandLimit = 5})
		IgnoredTier = SWorldConfig:AddDropdown("🧱 Ignored Tier", function(value)
			if Settings["World Config"].Ignored["Tier"] == value then return end
			Settings["World Config"].Ignored["Tier"] = value
			warn("Ignored World Tier Changed to "..table.concat(value, ", "))

			SaveSettings()
		end, {MultiValue = true, ExpandLimit = 5})
		IgnoredChallenge = SWorldConfig:AddDropdown("💀 Ignored Challenge", function(value)
			if Settings["World Config"].Ignored["Challenge"] == value then return end
			Settings["World Config"].Ignored["Challenge"] = value
			warn("Ignored World Challenge Changed to "..table.concat(value, ", "))

			SaveSettings()
		end, {MultiValue = true, ExpandLimit = 5})

		-------------------------------------------

		getgenv().UpdateWorldType = function(value)
			WorldType.Functions:Hide()
			local visible = false
			if AAData["World Type"]["Type"][value]["Worlds"] then
				WorldType.Data.Options = AAData["World Type"]["Type"][value]["Worlds"]
				if not Settings["World Config"]["Type"] or
					not table.find(AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"], Settings["World Config"]["Type"]) then
					Settings["World Config"]["Type"] = AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"][1]
				end
				WorldType.Data.Value = Settings["World Config"]["Type"]
				WorldType.Section:UpdateDropdown(WorldType, nil, {Value = WorldType.Data.Value})

				getgenv().UpdateWorldLevel(WorldType.Data.Value)

				visible = true
			end
			local List = {
				WorldTypeLabel.Label, WorldType.Dropdown,
				WorldLevelSeparator.Label,
				WorldLevelLabel.Label, WorldLevel.Dropdown,
				WorldDifficultySeparator.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Dropdown
			}; Utility:Show(List, visible)
		end
		getgenv().UpdateWorldLevel = function(value)
			WorldLevel.Functions:Hide()
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"] then
						WorldLevel.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"]
						if not Settings["World Config"]["Level"] or
							not table.find(AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"], Settings["World Config"]["Level"]) then
							Settings["World Config"]["Level"] = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"][1]
						end
						if FarmCategory.Data.Value == "Story Worlds" then
							if string.find(Settings["World Config"]["Level"], "_infinite") then AutoNextStory.Toggle.Visible = false
							else AutoNextStory.Toggle.Visible = true end
						end
						WorldLevel.Data.Value = Settings["World Config"]["Level"]
						WorldLevel.Section:UpdateDropdown(WorldLevel, nil, {Value = WorldLevel.Data.Value})

						getgenv().UpdateWorldDifficulty(value)
						getgenv().UpdateIgnoredMap(WorldLevel.Data.Value)
						getgenv().UpdateIgnoredDamageModifier(WorldLevel.Data.Value)
						getgenv().UpdateIgnoredTier(WorldLevel.Data.Value)
						getgenv().UpdateIgnoredChallenge(WorldLevel.Data.Value)

						visible = true
					end
				end
			end
			local List = {
				WorldLevelSeparator.Label,
				WorldLevelLabel.Label, WorldLevel.Dropdown,
				WorldDifficultySeparator.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Dropdown
			}; Utility:Show(List, visible)
		end
		getgenv().UpdateWorldDifficulty = function(value)
			WorldDifficulty.Functions:Hide()
			local List = {
				WorldDifficultySeparator.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Dropdown,
			};
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Levels"] then
						if (Settings["World Config"]["Level"] and string.find(Settings["World Config"]["Level"], "_infinite")) or
							(Settings["Farm Config"]["Category"] and table.find({"Legend Stages", "Raid Worlds"}, Settings["Farm Config"]["Category"])) then
							WorldDifficulty.Data.Options = {"Hard"}
							Settings["World Config"]["Difficulty"] = "Hard"
						elseif (Settings["Farm Config"]["Category"] and table.find({"Portals", "Dungeon", "Secret Portals"}, Settings["Farm Config"]["Category"])) then
							WorldDifficulty.Data.Options = {"Default"}
							Settings["World Config"]["Difficulty"] = "Default"
						else
							WorldDifficulty.Data.Options = {"Normal", "Hard"}
							Settings["World Config"]["Difficulty"] = "Normal"
						end
						WorldDifficulty.Data.Value = Settings["World Config"]["Difficulty"]
						WorldDifficulty.Section:UpdateDropdown(WorldDifficulty, nil, {Value = WorldDifficulty.Data.Value})

						local ignoring = false
						for _, v in pairs({"Maps","Damage Modifiers","Tiers","Challenges"}) do
							if not AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"] then break end
							if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][WorldLevel.Data.Value][v] then ignoring = true; break end
						end

						if ignoring then IgnoredSeperator.Label.Visible = true
						else IgnoredSeperator.Label.Visible = false end

						visible = true
					end
				end
			end
			Utility:Show(List, visible)
		end
		getgenv().UpdateIgnoredMap = function(value)
			local List = {IgnoredMap.Dropdown}
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Maps"] then
						IgnoredMap.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Maps"]
						if not Settings["World Config"].Ignored["Map"] then
							Settings["World Config"].Ignored["Map"] = {}
						end
						IgnoredMap.Data.Value = Settings["World Config"].Ignored["Map"]
						IgnoredMap.Section:UpdateDropdown(IgnoredMap, nil, {Value = IgnoredMap.Data.Value})

						visible = true
					end
				end
			end
			Utility:Show(List, visible)
		end
		getgenv().UpdateIgnoredDamageModifier = function(value)
			local List = {IgnoredDamageModifier.Dropdown};
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Damage Modifiers"] then
						IgnoredDamageModifier.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Damage Modifiers"]
						if not Settings["World Config"].Ignored["Damage Modifier"] then
							Settings["World Config"].Ignored["Damage Modifier"] = {}
						end
						IgnoredDamageModifier.Data.Value = Settings["World Config"].Ignored["Damage Modifier"]
						IgnoredDamageModifier.Section:UpdateDropdown(IgnoredDamageModifier, nil, {Value = IgnoredDamageModifier.Data.Value})

						visible = true
					end
				end
			end
			Utility:Show(List, visible)
		end
		getgenv().UpdateIgnoredTier = function(value)
			local List = {IgnoredTier.Dropdown};
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Tiers"] then
						IgnoredTier.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Tiers"]
						if not Settings["World Config"].Ignored["Tier"] then
							Settings["World Config"].Ignored["Tier"] = {}
						end
						IgnoredTier.Data.Value = Settings["World Config"].Ignored["Tier"]
						IgnoredTier.Section:UpdateDropdown(IgnoredTier, nil, {Value = IgnoredTier.Data.Value})

						visible = true
					end
				end
			end
			Utility:Show(List, visible)
		end
		getgenv().UpdateIgnoredChallenge = function(value)
			local List = {IgnoredChallenge.Dropdown};
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Challenges"] then
						IgnoredChallenge.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Level"][value]["Challenges"]
						if not Settings["World Config"].Ignored["Challenge"] then
							Settings["World Config"].Ignored["Challenge"] = {}
						end
						IgnoredChallenge.Data.Value = Settings["World Config"].Ignored["Challenge"]
						IgnoredChallenge.Section:UpdateDropdown(IgnoredChallenge, nil, {Value = IgnoredChallenge.Data.Value})

						visible = true
					end
				end
			end
			Utility:Show(List, visible)
		end

		getgenv().UpdateWorldType(FarmCategory.Data.Value)
		getgenv().UpdateWorldLevel(WorldType.Data.Value)
		getgenv().UpdateWorldDifficulty(WorldType.Data.Value)
		getgenv().UpdateIgnoredMap(WorldLevel.Data.Value)
		getgenv().UpdateIgnoredDamageModifier(WorldLevel.Data.Value)
		getgenv().UpdateIgnoredTier(WorldLevel.Data.Value)
		getgenv().UpdateIgnoredChallenge(WorldLevel.Data.Value)
	end
	----------------------------

	----- [ Unit Config ] -----
	local LoadUnitConfig, CreateUnitConfig, TeamSelect;
	local UnitSettings = {};
	function UISetup:UnitConfig()
		PUnit = Window:AddPage("Unit Config", "🧙")
		if Settings and not Settings["Unit Config"] then Settings["Unit Config"] = {} end
		if Settings and not Settings["Unit Config"].Config then Settings["Unit Config"].Config = {} end
		if Settings and not Settings["Unit Config"].Configs then Settings["Unit Config"].Configs = {} end
		if Settings and not Settings["Unit Config"].Auto then Settings["Unit Config"].Auto = {} end
		local STeamConfig = PUnit:AddSection("🧙 Team Configuration 🧙")
		if not InLobby() then STeamConfig:Enabled(false) end
		local SUnitConfig = PUnit:AddSection("⚙️ Unit Configuration ⚙️")
		local SUnitSplits = PUnit:AddSplit()

		TeamSelect = STeamConfig:AddDropdown("🧙 Select Team: ", function(value)

		end, {Options = {"Team 1","Team 2","Team 3","Team 4","Team 5"}})

		if not Settings["Unit Config"].Config.Value then Settings["Unit Config"].Config.Value = "Default" end
		LoadUnitConfig = SUnitConfig:AddDropdown("🧙 Load Unit Config: ", function(value)
			Settings["Unit Config"].Config.Options = LoadUnitConfig.Data.Options
			Settings["Unit Config"].Config.Value = value;
			SaveSettings()

			getgenv().UpdateUnitConfig()
		end, {Options = Settings["Unit Config"].Config.Options or {"Default"}, Value = Settings["Unit Config"].Config.Value or "Default"})
		CreateUnitConfig = SUnitConfig:AddTextbox("💾 Create Unit Config", function(value)
			table.insert(LoadUnitConfig.Data.Options, value)
			Settings["Unit Config"].Config.Options = LoadUnitConfig.Data.Options
			SaveSettings()

			CreateUnitConfig.Data.Text = ""
			CreateUnitConfig.Section:UpdateTextbox(CreateUnitConfig, nil, {Text = CreateUnitConfig.Data.Text})
		end, {Placeholder = "Config Name", RequireEntered = true})
		SUnitConfig:AddButton("🔥 Delete Unit Config", function()
			Settings["Unit Config"].Config.Options = table.remove(Settings["Unit Config"].Config.Options, table.find(Settings["Unit Config"].Config.Options, LoadUnitConfig.Data.Value))

			SaveSettings()
		end)
		SUnitConfig:AddButton("💽 Reset Unit Config", function() getgenv().ResetUnitConfig() end)
		SUnitConfig:AddLabel()
		if not InLobby() then SUnitConfig:AddToggle("🚩 Modify Units Positions", function(value) getgenv().PositionChange(value) end, {Active = false}) end
		SUnitConfig:AddToggle("👨‍🌾 Auto Place Unit", function(value) Settings["Unit Config"].Auto["Place"] = value; SaveSettings() end, {Active = Settings["Unit Config"].Auto["Place"] or false})
		SUnitConfig:AddToggle("⭐️ Auto Upgrade Units", function(value) Settings["Unit Config"].Auto["Upgrade"] = value; SaveSettings() end, {Active = Settings["Unit Config"].Auto["Upgrade"] or false})
		SUnitConfig:AddDropdown("🧙 Auto Buff 100%", function(value)
			Settings["Unit Config"].Auto["Buff"] = value; SaveSettings()

			for i, _ in pairs(AAData["Game Setting"]["Buffers"]) do
				if table.find(Settings["Unit Config"].Auto["Buff"], i) then
					if not BufferContainer[i] then
						BufferContainer[i] = Functions:AutoBuff(i)
						BufferContainer[i]:Start();
					end
				else
					if BufferContainer[i] then
						BufferContainer[i]:Stop();
						BufferContainer[i] = nil
					end
				end
			end

		end, {MultiValue = true, Options = {"Orwin/Erwin", "Wenda/Wendy", "Leafy/Leafa"}, Value = Settings["Unit Config"].Auto["Buff"] or {}})

		if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value] then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value] = {} end
		if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units = {} end
		for UnitSlot = 1, 6 do
			task.spawn(function()
				if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)] then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)] = {} end
				if not UnitSettings[UnitSlot] then UnitSettings[UnitSlot] = {} end
				local USettings = UnitSettings[UnitSlot]
				if UnitSlot % 2 ~= 0 then USettings["Section"] = PUnit:AddSection("🧙⚙️ Unit "..UnitSlot..": ", {Split = SUnitSplits, Side = "Left"})
				else USettings["Section"] = PUnit:AddSection("🧙⚙️ Unit "..UnitSlot..": ", {Split = SUnitSplits, Side = "Right"}) end

				USettings["Active"] = USettings["Section"]:AddToggle("⚙️ Use Unit Settings", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Active"] = value; SaveSettings()
				end, {Active = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Active"] or false})

				if not InLobby() then
					USettings["Section"]:AddToggle("📍 Show Position", function(value) getgenv().VisualizePosition("Unit "..tostring(UnitSlot), value) end)
					USettings["Selected Position"] = USettings["Section"]:AddDropdown("📍 Select [Single]: ", function() end, {Options = {"Position 1","Position 2","Position 3","Position 4","Position 5","Position 6"}, Value = "Position 1"})
					USettings["Single"] = USettings["Section"]:AddButton("🚩 Set Position [Single]", function() Functions:PositionUnit("Unit "..tostring(UnitSlot), "Single", USettings["Selected Position"].Data.Value) end)
					USettings["Delete"] = USettings["Section"]:AddButton("📀 Delete Positions [Single]", function() end)
					USettings["Single Group Separator"] = USettings["Section"]:AddLabel()
					USettings["Group"] = USettings["Section"]:AddButton("🚩 Set Positions [Group]", function() Functions:PositionUnit("Unit "..tostring(UnitSlot), "Group") end)
					USettings["Spread"] = USettings["Section"]:AddButton("🚩 Get Positions [Spread]", function() Functions:PositionUnit("Unit "..tostring(UnitSlot), "Spread") end)
					USettings["Clear"] = USettings["Section"]:AddButton("📀 Clear Positions 📀", function() SaveUnitPosition("Unit "..tostring(UnitSlot), {}, true) end)
				end

				USettings["Target Priority"] = USettings["Section"]:AddDropdown("🎯 Target Priority: ", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Target Priority"] = value; SaveSettings()
				end, {Options = AAData["Unit Setting"]["Target Priority"], Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Target Priority"] or "First"})
				USettings["Place Start"] = USettings["Section"]:AddTextbox("Place from wave: ", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Place Start"] = value; SaveSettings()
				end, {Placeholder = "Wave", Text = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Place Start"] or 1, Pattern = "[%d-]+"})
				USettings["Upgrade Start"] = USettings["Section"]:AddTextbox("Upgrade from wave: ", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Start"] = value; SaveSettings()
				end, {Placeholder = "Wave", Text = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Start"] or 1, Pattern = "[%d-]+"})
				USettings["Sell Start"] = USettings["Section"]:AddTextbox("Auto Sell at wave: ", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Sell Start"] = value; SaveSettings()
				end, {Placeholder = "Wave", Text = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Sell Start"] or 99, Pattern = "[%d-]+"})
				USettings["Unit Limit"] = USettings["Section"]:AddSlider("Total Units: ", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Unit Limit"] = value; SaveSettings()
				end, {Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Unit Limit"] or 6, Min = 0, Max = 6})
				USettings["Upgrade Limit"] = USettings["Section"]:AddSlider("Upgrade Cap: ", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Limit"] = value; SaveSettings()
				end, {Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Limit"] or 15, Min = 0, Max = 15})
				USettings["Auto Ability"] = USettings["Section"]:AddDropdown("🔥 Auto Ability", function(value)
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Auto Ability"] = value; SaveSettings()
				end, {Options = {"Disable","Cooldown","On Attack [All]","On Attack [Ground]","On Attack [Air]"}, Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Auto Ability"] or "Disable"})
			end)
		end

		-------------------------------------------

		getgenv().UpdateUnitConfig = function()
			if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value] then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value] = {} end
			if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units = {} end
			for UnitSlot = 1, 6 do
				task.spawn(function()
					if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)] then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)] = {} end
					repeat task.wait() until Utility:Length(UnitSettings[UnitSlot]) >= 16

					local USettings = UnitSettings[UnitSlot]
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Active"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Active"] or false
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Target Priority"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Target Priority"] or "First"
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Place Start"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Place Start"] or 1
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Start"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Start"] or 1
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Sell Start"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Sell Start"] or 99
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Unit Limit"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Unit Limit"] or 6
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Limit"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Limit"] or 15
					Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Auto Ability"] = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Auto Ability"] or "Disable"

					if USettings["Selected Position"] then
						USettings["Selected Position"].Section:UpdateDropdown(USettings["Selected Position"], nil, {Value = "Position 1"})
					end

					USettings["Active"].Data.Active = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Active"]
					USettings["Active"].Section:UpdateToggle(USettings["Active"], nil, {Active = USettings["Active"].Data.Active})
					USettings["Target Priority"].Data.Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Target Priority"]
					USettings["Target Priority"].Section:UpdateDropdown(USettings["Target Priority"], nil, {Value = USettings["Target Priority"].Data.Value})
					USettings["Place Start"].Data.Text = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Place Start"]
					USettings["Upgrade Start"].Data.Text = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Start"]
					USettings["Sell Start"].Data.Text = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Sell Start"]
					USettings["Unit Limit"].Data.Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Unit Limit"]
					USettings["Unit Limit"].Section:UpdateSlider(USettings["Unit Limit"], nil, {Value = USettings["Unit Limit"].Data.Value, Min = USettings["Unit Limit"].Data.Min, Max = USettings["Unit Limit"].Data.Max})
					USettings["Upgrade Limit"].Data.Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Upgrade Limit"]
					USettings["Upgrade Limit"].Section:UpdateSlider(USettings["Upgrade Limit"], nil, {Value = USettings["Upgrade Limit"].Data.Value, Min = USettings["Upgrade Limit"].Data.Min, Max = USettings["Upgrade Limit"].Data.Max})
					USettings["Auto Ability"].Data.Value = Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)]["Auto Ability"]
					USettings["Auto Ability"].Section:UpdateDropdown(USettings["Auto Ability"], nil, {Value = USettings["Auto Ability"].Data.Value})
				end)
			end
		end
		getgenv().ResetUnitConfig = function()
			Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units = {};
			SaveSettings()

			getgenv().UpdateUnitConfig()
		end

		getgenv().VisualizePosition = function(UnitSlot, Enabled)
			if not Settings["World Positions"][CurrentMap] then return end
			if not Settings["World Positions"][CurrentMap][UnitSlot] then return end
			local Render;
			if Enabled then
				if _G[UnitSlot.." Visualizer"] then _G[UnitSlot.." Visualizer"]:Destroy() end
				_G[UnitSlot.." Visualizer"] = Instance.new("Model", Workspace)
				local Blocks = {}
				for Pos = 1, 6 do
					if not Settings["World Positions"][CurrentMap][UnitSlot]["Position "..Pos] then continue end

					Blocks[Pos] = Instance.new("Part", _G[UnitSlot.." Visualizer"])
					Blocks[Pos].Size = Vector3.new(1, 1, 1)
					Blocks[Pos].Material = Enum.Material.Neon
					Blocks[Pos].Anchored = true
					Blocks[Pos].CanCollide = false
				end

				Render = RunService.RenderStepped:Connect(function()
					pcall(function()
						if Enabled then
							for Pos = 1, 6 do
								if not Settings["World Positions"][CurrentMap][UnitSlot]["Position "..Pos] then continue end

								local Position = Settings["World Positions"][CurrentMap][UnitSlot]["Position "..Pos]
								Blocks[Pos].CFrame = CFrame.new(Vector3.new(Position["x"], Position["y"], Position["z"]))
							end
						end
					end)
				end)
			else
				if _G[UnitSlot.." Visualizer"] then _G[UnitSlot.." Visualizer"]:Destroy() end
				_G[UnitSlot.." Visualizer"] = nil
				Render:Disconnect()
			end
		end

		if not InLobby() then
			getgenv().PositionChange = function(value)
				for UnitSlot = 1, 6 do
					task.spawn(function()
						repeat task.wait() until Utility:Length(UnitSettings[UnitSlot]) >= 16
						local USettings = UnitSettings[UnitSlot]
						Utility:Show({
							USettings["Selected Position"].Dropdown,
							USettings["Single"].Button,
							USettings["Delete"].Button,
							USettings["Single Group Separator"].Label,
							USettings["Group"].Button,
							USettings["Spread"].Button,
							USettings["Clear"].Button,
						}, value)
					end)
				end
			end

			getgenv().PositionChange(false)
		end

		getgenv().UpdateUnitConfig()
	end
	---------------------------

	----- [ Macro Config ] -----
	local MacroConfig, CreateMacro;
	local MacroMaps = {};
	function UISetup:Macro()
		if Settings and not Settings["Macro"] then Settings["Macro"] = {} end
		if Settings and not Settings["Macro"].Maps then Settings["Macro"].Maps = {} end
		PMacro = Window:AddPage("Macro", "🕹️")
		local SMacroSplits = PMacro:AddSplit()
		local SMacroStatus = PMacro:AddSection("🕹️ Macro Information 🕹️", {Split = SMacroSplits, Side = "Left"})
		local SMacroOptions = PMacro:AddSection("⚙️ Macro Options ⚙️", {Split = SMacroSplits, Side = "Left"})
		local SMacroUnits = PMacro:AddSection("🧙 Macro Units 🧙", {Split = SMacroSplits, Side = "Left"})
		local SMacroMaps = PMacro:AddSection("🌏 Macro Maps 🌏", {Split = SMacroSplits, Side = "Right"})

		local InfoStatus = SMacroStatus:AddLabel("Status: Stopped")
		local InfoAction = SMacroStatus:AddLabel("Action: N/A")
		local InfoType = SMacroStatus:AddLabel("Type: N/A")
		local InfoUnit = SMacroStatus:AddLabel("Unit: N/A")
		local InfoWaiting = SMacroStatus:AddLabel("Waiting For (None): N/A")

		MacroConfig = SMacroOptions:AddDropdown("🕹️ Macro: ", function(value)
			Settings["Macro"].Selected = value;
			SaveSettings();
		end, {Value = Settings["Macro"].Selected or ""})
		CreateMacro = SMacroOptions:AddTextbox("💾 Create Macro", function(value)
			CreateMacro.Data.Text = ""; CreateMacro.Section:UpdateTextbox(CreateMacro, nil, {Text = CreateMacro.Data.Text});
			local Success = pcall(function() writefile(MacrosDirectory.."/"..value..".json", HttpService:JSONEncode({})) end)
			if Success then Window:Notify("Macro Update", "Successfully created "..value.." Macro!")
			else Window:Notify("Macro Update", "Error while creating "..value.." Macro!") end

			getgenv().RefeshMacroList()
		end, {Placeholder = "Macro Name", RequireEntered = true})
		SMacroOptions:AddButton("🔄 Refresh Macro List", function() getgenv().RefeshMacroList() end)
		SMacroOptions:AddButton("🔥 Delete Macro", function()
			local Success = pcall(function() readfile(MacrosDirectory.."/"..Settings["Macro"].Selected..".json") end)
			if Success then
				delfile(MacrosDirectory.."/"..Settings["Macro"].Selected..".json")
				Window:Notify("Macro Update", "Successfully deleted "..value.." Macro!")
			end
			SaveSettings()

			getgenv().RefeshMacroList()
		end)
		SMacroOptions:AddToggle("▶️ Play Macro", function(value)
			Settings["Macro"].Play = value;
			SaveSettings();
		end, {Active = Settings["Macro"].Play or false})
		SMacroOptions:AddToggle("⏺️ Record", function(value) end)
		SMacroOptions:AddToggle("⚡ Record Abilities", function(value) end)

		SMacroUnits:AddButton("🧙 Equip Macro Units", function() getgenv().EquipMacroUnits() end)

		for _, Map in pairs(AAData["Maps"]) do
			MacroMaps[Map] = SMacroMaps:AddDropdown(Map..": ", function(value)
				Settings["Macro"].Maps[Map] = value;
				SaveSettings();
			end, {Options = {"None"}, Value = Settings["Macro"].Maps[Map] or "None", ExpandLimit = 5})
		end

		-------------------------------------------

		getgenv().RefeshMacroList = function()
			local Files = Utility:GetFiles(MacrosDirectory)
			local Temp = {}
			for _, File in pairs(Files) do
				if string.sub(File, #File - 4) ~= ".json" then continue end
				table.insert(Temp, string.sub(File, #MacrosDirectory + 2, #File - 5))
			end
			MacroConfig.Data.Options = Temp
			if Settings["Macro"].Selected and Settings["Macro"].Selected ~= "" then
				local Success = pcall(function() readfile(MacrosDirectory.."/"..Settings["Macro"].Selected..".json") end)
				if not Success then
					Settings["Macro"].Selected = ""
					MacroConfig.Data.Value = Settings["Macro"].Selected
					MacroConfig.Section:UpdateDropdown(MacroConfig, nil, {Value = MacroConfig.Data.Value})
				else
					MacroConfig.Section:UpdateDropdown(MacroConfig, nil, {})
				end
			end
			for Map, _ in pairs(MacroMaps) do
				MacroMaps[Map].Data.Options = Utility:Combine_Table({"None"}, Temp)
				if Settings["Macro"].Maps[Map] and Settings["Macro"].Maps[Map] ~= "None" then
					local Success = pcall(function() readfile(MacrosDirectory.."/"..Settings["Macro"].Maps[Map]..".json") end)
					if not Success then
						Settings["Macro"].Maps[Map] = "None"
						MacroMaps[Map].Data.Value = Settings["Macro"].Maps[Map]
					end
					MacroMaps[Map].Section:UpdateDropdown(MacroMaps[Map], nil, {Value = MacroMaps[Map].Data.Value})
					continue;
				end
				MacroMaps[Map].Section:UpdateDropdown(MacroMaps[Map], nil, {})
			end

			SaveSettings()
		end

		getgenv().EquipMacroUnits = function()
			local Macro;
			if Settings["Macro"].Maps then
				local Success, Result = pcall(function() return HttpService:JSONDecode(readfile(MacrosDirectory.."/"..Settings["Macro"].Maps[CurrentMap]..".json")) end)
				if Success then Macro = Result; end
			end

			if Macro then

			end
		end

		if not InLobby() then
			RunService.RenderStepped:Connect(function()
				pcall(function()
					if MacroData ~= {}  then
						if MacroData["Macro"] and MacroData["Status"] and MacroData["Status"] ~= "" then InfoStatus.Section:UpdateLabel(InfoStatus, "Status: "..MacroData["Status"]) else InfoStatus.Section:UpdateLabel(InfoStatus, "Status: Stopped") end
						if MacroData["Macro"] and MacroData["Action"] and MacroData["Action"] ~= 0 then InfoAction.Section:UpdateLabel(InfoAction, "Action: "..MacroData["Action"].." / "..Utility:Length(MacroData["Macro"])) else InfoAction.Section:UpdateLabel(InfoAction, "Action: N/A") end
						if MacroData["Macro"] and MacroData["Type"] and MacroData["Type"] ~= "" then InfoType.Section:UpdateLabel(InfoType, "Type: "..MacroData["Type"]) else InfoType.Section:UpdateLabel(InfoType, "Type: N/A") end
						if MacroData["Macro"] and MacroData["Unit"] and MacroData["Unit"] ~= "" then InfoUnit.Section:UpdateLabel(InfoUnit, "Unit: "..MacroData["Unit"]) else InfoUnit.Section:UpdateLabel(InfoUnit, "Unit: N/A") end
						if MacroData["Macro"] and MacroData["Waiting"] and MacroData["Waiting"] ~= {} then
							if MacroData["Waiting"]["Type"] and MacroData["Waiting"]["Value"] then
								if MacroData["Waiting"]["Type"] == "Money" then
									InfoWaiting.Section:UpdateLabel(InfoWaiting, "Waiting For (Cash): "..tostring(MacroData["Waiting"]["Value"]))
								elseif MacroData["Waiting"]["Type"] == "Wave" then
									InfoWaiting.Section:UpdateLabel(InfoWaiting, "Waiting For (Wave): "..tostring(MacroData["Waiting"]["Value"]))
								else InfoWaiting.Section:UpdateLabel(InfoWaiting, "Waiting For (None): N/A") end
							else InfoWaiting.Section:UpdateLabel(InfoWaiting, "Waiting For (None): N/A") end
						else InfoWaiting.Section:UpdateLabel(InfoWaiting, "Waiting For (None): N/A") end
					end
				end)
			end)
		end

		getgenv().RefeshMacroList()
	end
	----------------------------

	----- [ Shoop and Item Page ] -----
	function UISetup:ShopNItem()
		PShopNItems = Window:AddPage("Shop & Items", "💰")
		local SShopSplit = PShopNItems:AddSplit()
		local SAutoPull = PShopNItems:AddSection("💸 Auto Pull Unit 💸", {Split = SShopSplit, Side = "Left"})
		local SAutoBuyBulma = PShopNItems:AddSection("🏪 Auto Buy Bulma 🏪", {Split = SShopSplit, Side = "Left"})
		local SAutoBuyEscanor = PShopNItems:AddSection("🛒 Auto Buy Escanor 🛒", {Split = SShopSplit, Side = "Left"})
		local SAutoCraftRelic = PShopNItems:AddSection("🗡️ Auto Craft Relic 🗡️", {Split = SShopSplit, Side = "Left"})
		local SAutoSellPortals = PShopNItems:AddSection("🌀 Auto Sell Portals 🌀", {Split = SShopSplit, Side = "Right"})
		local SAutoSellSkins = PShopNItems:AddSection("👗 Auto Sell Skins 👗", {Split = SShopSplit, Side = "Right"})
	end
	-----------------------------------

	----- [ Misc Page ] -----
	function UISetup:Misc()
		PMisc = Window:AddPage("Misc [BETA]", "🛠️")
		if Settings and not Settings["Misc"] then Settings["Misc"] = {} end
		if Settings and not Settings["Misc"].Discord then Settings["Misc"].Discord = {} end
		if Settings and not Settings["Misc"].Device then Settings["Misc"].Device = {} end
		if Settings and not Settings["Misc"].Laggy then Settings["Misc"].Laggy = {} end
		if Settings and not Settings["Misc"].UI then Settings["Misc"].UI = {} end
		if Settings and not Settings["Misc"].Map then Settings["Misc"].Map = {} end
		if Settings and not Settings["Misc"].Script then Settings["Misc"].Script = {} end
		if Settings and not Settings["Misc"].Players then Settings["Misc"].Players = {} end

		local SDiscordWebhook = PMisc:AddSection("🌐 Discord Webhook 🌐")
		local SMiscSplit = PMisc:AddSplit()
		local SDevicePerformance = PMisc:AddSection("🖥️ Device Performance 🖥️", {Split = SMiscSplit, Side = "Left"})
		local SLaggyBETA = PMisc:AddSection("LAGGY Config (BETA)", {Split = SMiscSplit, Side = "Left"})
		local SUserInterface = PMisc:AddSection("🖼️ User Interface 🖼️", {Split = SMiscSplit, Side = "Left"})
		local SMapPerformance = PMisc:AddSection("🌏 Map Performance 🌏", {Split = SMiscSplit, Side = "Right"})
		local SScriptSettings = PMisc:AddSection("⌛ Script Settings ⌛", {Split = SMiscSplit, Side = "Right"})
		local SPlayersModification = PMisc:AddSection("🐱 Players Modification 🐱", {Split = SMiscSplit, Side = "Right"})
		local SOtherConfig = PMisc:AddSection("⚙️ Other Config ⚙️", {Split = SMiscSplit, Side = "Right"})
		local SReset = PMisc:AddSection("🤖 Reset 🤖", {Split = SMiscSplit, Side = "Right"})

		--- [ Discord ] ---
		SDiscordWebhook:AddTextbox("Webhook Urls", function(value) Settings["Misc"].Discord["Webhook"] = value; SaveSettings() end, {Text = Settings["Misc"].Discord["Webhook"] or "", Placeholder = "URL", MultiLine = true})
		if InLobby() then
			SDiscordWebhook:AddTextbox("Sniper Webhook Urls", function(value) Settings["Misc"].Discord["Sniper Webhook"] = value; SaveSettings() end, {Text = Settings["Misc"].Discord["Sniper Webhook"] or "", Placeholder = "URL", MultiLine = true})
			SDiscordWebhook:AddTextbox("Baby Webhook Urls", function(value) Settings["Misc"].Discord["Baby Webhook"] = value; SaveSettings() end, {Text = Settings["Misc"].Discord["Baby Webhook"] or "", Placeholder = "URL", MultiLine = true})
		end
		SDiscordWebhook:AddToggle("Enable Webhook", function(value) Settings["Misc"].Discord["Enabled"] = value; SaveSettings() end, {Active = Settings["Misc"].Discord["Enabled"] or false})
		SDiscordWebhook:AddButton("Test Webhook", function() Functions:Webhook(true) end)

		--- [ Device Performance ] ---
		SDevicePerformance:AddToggle("🖥️ Low CPU Mode", function(value) Settings["Misc"].Device["Low CPU Mode"] = value; SaveSettings() end, {Active = Settings["Misc"].Device["Low CPU Mode"] or false})
		SDevicePerformance:AddToggle("🔫 Boost FPS Mode", function(value) Settings["Misc"].Device["Boost FPS Mode"] = value; SaveSettings() end, {Active = Settings["Misc"].Device["Boost FPS Mode"] or false})

		--- [ LAGGY ] ---

		--- [ User Interface ] ---
		SUserInterface:AddToggle("🖼️ Hide Alert Message 🖼️", function(value)
			Settings["Misc"].UI["Hide Alert Message"] = value;
			SaveSettings()

			Functions:AlertMessage(not Settings["Misc"].UI["Hide Alert Message"])
		end, {Active = Settings["Misc"].UI["Hide Alert Message"] or false})

		--- [ Map Performance ] ---
		SMapPerformance:AddToggle("🗺️ Delete Map", function(value)
			Settings["Misc"].Map["Delete Map"] = value;
			SaveSettings()

			if not InLobby() then Functions:DeleteMap(Workspace["_terrain"].terrain, true); Functions:DeleteMap(Workspace["_map"]) end
		end, {Active = Settings["Misc"].Map["Delete Map"] or false})
		SMapPerformance:AddToggle("👇 Place Anywhere", function(value)
			Settings["Misc"].Map["Place Anywhere"] = value;
			SaveSettings()

			if not InLobby() then Functions:PlaceAnywhere(); Functions:RemoveUnitsHitbox() end
		end, {Active = Settings["Misc"].Map["Place Anywhere"] or false})
		SMapPerformance:AddButton("Activate Place Anywhere", function() if not InLobby() then Functions:PlaceAnywhere(); Functions:RemoveUnitsHitbox() end end)
		SMapPerformance:AddToggle("⛰️ Delete Hill [Disable hill placing]", function(value)
			Settings["Misc"].Map["Delete Hill"] = value;
			SaveSettings()

			if not InLobby() then Functions:DeleteMap(Workspace["_terrain"].hill, true) end
		end, {Active = Settings["Misc"].Map["Delete Hill"] or false})
		SMapPerformance:AddButton("Activate Delete Hill", function() if not InLobby() then Functions:DeleteMap(Workspace["_terrain"].hill, true) end end)

		--- [ Script Settings ] ---
		SScriptSettings:AddToggle("⌛ Auto Load Script", function(value) Settings["Misc"].Script["Auto Load Script"] = value; SaveSettings() end, {Active = Settings["Misc"].Script["Auto Load Script"] or false})

		--- [ Players Modification ] ---
		SPlayersModification:AddToggle("🐱 Hide Name Player", function(value) Settings["Misc"].Players["Hide Name"] = value; SaveSettings() end, {Active = Settings["Misc"].Players["Hide Name"] or false})

		--- [ Other Config ] ---
		if InLobby() then
			SOtherConfig:AddButton("Redeem All Codes", function()
				for _, code in pairs(AAData["Codes"]) do
					pcall(function() ReplicatedStorage.endpoints["client_to_server"]["redeem_code"]:InvokeServer(code)() end)
				end
				Window:Notify("Info", "Done Collecting Codes")
			end)
		end
		SOtherConfig:AddButton("Return To Lobby", function() end)

		--- [ Reset ] ---

	end
	-------------------------

	----- [ Debug Page ] -----
	function UISetup:Debug()
		PDebug = Window:AddPage("Debug", "🎚️")
		local SDebugSplits = PDebug:AddSplit()

		if not InLobby() then
			local SWorldData = PDebug:AddSection("World Data", {Split = SDebugSplits, Side = "Left"})
			SWorldData:AddLabel("Current Map : "..CurrentMap)
			for i, v in pairs(Getter:GetLevelData()) do
				if typeof(v) == "string" then
					SWorldData:AddLabel(i.." : "..v)
				end
			end
		end

		local SEquippedUnit = PDebug:AddSection("Equipped Unit", {Split = SDebugSplits, Side = "Right"})
		local UnitSlots = {}
		for slot = 1, 6 do UnitSlots[tostring(slot)] = SEquippedUnit:AddLabel(slot.." - ") end
		RunService.RenderStepped:Connect(function()
			pcall(function()
				for slot = 1, 6 do
					local name;
					if Getter:GetUnitsEquipped()[tostring(slot)] then
						local uuid = Getter:GetUnitsEquipped()[tostring(slot)]
						local unit_id = Getter:GetUnitsOwned()[uuid]["unit_id"]
						name = UnitsData[unit_id]["name"]
					end

					UnitSlots[tostring(slot)].Section:UpdateLabel(UnitSlots[tostring(slot)], slot.." - "..(name or ""))
				end
			end)
		end)
		-------------------------------------------
	end
	--------------------------
end

-------------------------
----- [ FUNCTIONS ] -----
-------------------------
do
	----- [ Get Unit ] -----
	function Functions:GetUnit(Data)
		if Data[1] == "Equipped" then
			local Unit_ID = Data[2]
			local AlternativeList;
			for _, v in pairs(AAData["Alternatives"]["Units"]) do
				if table.find(v, Unit_ID) then AlternativeList = v; break; end
			end
			for Slot = 1, Utility:Length(Getter:GetUnitsEquipped()) do
				if Getter:GetUnitsEquipped()[tostring(Slot)] then
					local uuid = Getter:GetUnitsEquipped()[tostring(Slot)]
					local unit_id = Getter:GetUnitsOwned()[uuid]["unit_id"]
					if AlternativeList then
						for _, v in pairs(AlternativeList) do
							if unit_id == v then return Getter:GetUnitsOwned()[uuid] end
						end
					end
					if unit_id == Unit_ID then return Getter:GetUnitsOwned()[uuid] end
				end
			end
		elseif Data[1] == "Workspace" then
			if typeof(Data[2]) == "Vector3" or typeof(Data[2]) == "CFrame" then
				repeat task.wait() until Workspace:WaitForChild("_UNITS")
				for _, Unit in ipairs(Workspace["_UNITS"]:GetChildren()) do
					repeat task.wait() until Unit:WaitForChild("_stats")
					if Unit:FindFirstChild("_stats"):FindFirstChild("player").Value == Players.LocalPlayer then
						local magnitude = (Unit.PrimaryPart.Position - Data[2]).magnitude
						if math.floor(magnitude) == 0 then
							return Unit
						end
					end
				end
			end
		end
		return nil
	end
	------------------------

	----- [ Place Unit ] -----
	function Functions:PlaceUnit(UUID, Position)
		local args = {
			[1] = UUID,
			[2] = CFrame.new(Position),
		}
		local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.spawn_unit:InvokeServer(unpack(args)) end)
		if Success then return true end
		return false
	end
	--------------------------

	----- [ Upgrade Unit ] -----
	function Functions:UpgradeUnit(Unit)
		local args = {
			[1] = Unit;
		}
		local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(unpack(args)) end)
		if Success then return true end
		return false
	end
	----------------------------

	----- [ Sell Unit ] -----
	function Functions:SellUnit(Unit)
		local args = {
			[1] = Unit;
		}
		local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.sell_unit_ingame:InvokeServer(unpack(args)) end)
		if Success then return true end
		return false
	end
	-------------------------

	----- [ Target Priority ] -----
	function Functions:TargetPriority(Unit)
		local args = {
			[1] = Unit;
		}
		local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.cycle_priority:InvokeServer(unpack(args)) end)
		if Success then return true end
		return false
	end
	-------------------------------

	----- [ Position Unit ] -----
	function Functions:PositionUnit(UnitSlot, Type, Specific)
		if Type == "Group" then
			print("[Setting Position] Type: Group")
			local RaycastParameters = RaycastParams.new()
			RaycastParameters.FilterType = Enum.RaycastFilterType.Whitelist
			RaycastParameters.FilterDescendantsInstances = {Workspace["_terrain"]}
			_G.ModifyingPosition = true
			task.wait(0.5)
			local Visualize = Instance.new("Model", Workspace)
			local Blocks = {}
			for Pos = 1, 6 do
				Blocks[Pos] = Instance.new("Part", Visualize)
				Blocks[Pos].Size = Vector3.new(1, 1, 1)
				Blocks[Pos].Material = Enum.Material.Neon
				Blocks[Pos].Anchored = true
				Blocks[Pos].CanCollide = false
			end

			RunService.RenderStepped:Connect(function()
				pcall(function()
					if _G.ModifyingPosition then
						Mouse.TargetFilter = Visualize
						local x = Mouse.Hit.Position.X
						local z = Mouse.Hit.Position.Z
						local distance = {
							{0.75, 0}, {0.75, 1.5}, {0.75, -1.5},
							{-0.75, -0}, {-0.75, 1.5}, {-0.75, -1.5},
						}
						for Pos = 1, 6 do
							local RayOrigin = CFrame.new(x + distance[Pos][1], 1000, z + distance[Pos][2]).p
							local RayDestination = CFrame.new(x + distance[Pos][1], -500, z + distance[Pos][2]).p
							local RayDirection = (RayDestination - RayOrigin)
							local RaycastResult = Workspace:Raycast(RayOrigin, RayDirection, RaycastParameters)
							Blocks[Pos].CFrame = CFrame.new(RaycastResult.Position) * CFrame.Angles(0, -0, -0)
						end
					end
				end)
			end)

			ClickDetection = Mouse.Button1Down:Connect(function()
				ClickDetection:Disconnect()
				print("[Saving Position] Type: Group")
				SaveUnitPosition(UnitSlot, {
					["Position 1"] = Blocks[1],
					["Position 2"] = Blocks[2],
					["Position 3"] = Blocks[3],
					["Position 4"] = Blocks[4],
					["Position 5"] = Blocks[5],
					["Position 6"] = Blocks[6],
				}, true)
				_G.ModifyingPosition = false
				for transparency = 0, 1, 0.1 do -- Fade Animation
					for Pos = 1, 6 do Blocks[Pos].Transparency = transparency end
					task.wait()
				end
				Visualize:Destroy()
			end)
		elseif Type == "Single" then
			print("[Setting Position] Type: Single")
			local RaycastParameters = RaycastParams.new()
			RaycastParameters.FilterType = Enum.RaycastFilterType.Whitelist
			RaycastParameters.FilterDescendantsInstances = {Workspace["_terrain"]}
			_G.ModifyingPosition = true
			task.wait(0.5)
			local Block = Instance.new("Part", Workspace)
			Block.Size = Vector3.new(1, 1, 1)
			Block.Material = Enum.Material.Neon
			Block.Anchored = true
			Block.CanCollide = false

			RunService.RenderStepped:Connect(function()
				pcall(function()
					if _G.ModifyingPosition then
						Mouse.TargetFilter = Block
						local x = Mouse.Hit.Position.X
						local z = Mouse.Hit.Position.Z

						local RayOrigin = CFrame.new(x, 1000, z).p
						local RayDestination = CFrame.new(x, -500, z).p
						local RayDirection = (RayDestination - RayOrigin)
						local RaycastResult = Workspace:Raycast(RayOrigin, RayDirection, RaycastParameters)
						Block.CFrame = CFrame.new(RaycastResult.Position) * CFrame.Angles(0, -0, -0)
					end
				end)
			end)

			ClickDetection = Mouse.Button1Down:Connect(function()
				ClickDetection:Disconnect()
				print("[Saving Position] Type: Single")
				SaveUnitPosition(UnitSlot, {
					[Specific] = Block
				})
				_G.ModifyingPosition = false
				for transparency = 0, 1, 0.1 do -- Fade Animation
					Block.Transparency = transparency
					task.wait()
				end
				Block:Destroy()
			end)
		elseif Type == "Spread" then
			print("[Setting Position] Type: Spread")

		end
	end
	-----------------------------

    ----- [ Auto Buff ] -----
    function Functions:AutoBuff(Buffer)
        return Utility:Thread(Buffer.." Buffer", function()
			print(Buffer.." Auto Buff Started")
            local LocalPlayer = Players.LocalPlayer
            local Data = AAData["Game Setting"]["Buffers"][Buffer]

            local Container = {}
            local function RemoveBuffer()
				if #Container <= 0 then return end
                local Temp = {}
                for _, unit in pairs(Workspace._UNITS:GetChildren()) do
					task.wait()
                    if table.find(Data["Name"], unit.Name) then
						if unit:FindFirstChild("_stats") and unit:FindFirstChild("_stats"):FindFirstChild("player").Value == LocalPlayer then
							if not table.find(Temp, unit) then
                        		table.insert(Temp, unit)
							end
						end
                    end
                end
                for pos, unit in pairs(Container) do -- Removing Deleted Buffer
					task.wait()
                    if not table.find(Temp, unit) then
                        --table.remove(Container, table.find(Container, unit))
						table.remove(Container, pos)
                        --print(""..Buffer.." Left: "..#Container)
                    end
                end
            end
            local function AddBuffer() -- Adding Newer Buffer
				if #Container >= 4 then return end
                for _, unit in pairs(Workspace._UNITS:GetChildren()) do
					task.wait()
					if table.find(Data["Name"], unit.Name) then
						if unit:FindFirstChild("_stats") and unit:FindFirstChild("_stats"):FindFirstChild("player").Value == LocalPlayer then
							if not table.find(Container, unit) then
								table.insert(Container, unit)
								--print(""..Buffer.." Left: "..#Container)
							end
						end
					end
                end
            end

            repeat
                task.wait()
                if not table.find(Settings["Unit Config"].Auto["Buff"], Buffer) then break end

                RemoveBuffer()
                AddBuffer()

                for count = 1, 4 do
					task.wait()
                    if #Container < 4 then break end
                    RemoveBuffer()
                    if Container[count] ~= nil and Container[count].Parent == Workspace._UNITS then
                        ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(Container[count])
                        --print(Buffer..": Buffing")
                        task.wait(Data["Delay"])
                    end
                end
            until not table.find(Settings["Unit Config"].Auto["Buff"], Buffer)
			print(Buffer.." Auto Buff Ended")
        end)
    end
	-------------------------

	----- [ Get Portal ] -----
	function Functions:GetPortals(ID, Ignored)
		local Portals = {}
		for _, Item in pairs(Getter:GetInventoryItemsUniqueItems()) do
			if Item["item_id"]:match(ID) then
				if Ignored then
					if Item["_unique_item_data"]["_unique_portal_data"]["level_id"] then
						local Map = Item["_unique_item_data"]["_unique_portal_data"]["level_id"]
						if Ignored["Maps"] and Utility:Length(Ignored["Maps"]) > 0 then
							if table.find(Ignored["Maps"], AAData["Identifiers"]["Level"][ID][Map]) then continue end
						end
					end
					if Item["_unique_item_data"]["_unique_portal_data"]["_weak_against"] then
						local Weakness = Item["_unique_item_data"]["_unique_portal_data"]["_weak_against"]
						if Ignored["Damage Modifiers"] and Utility:Length(Ignored["Damage Modifiers"]) > 0 then
							local skip = false
							for _, Damage in pairs(Weakness) do
								if table.find(Ignored["Damage Modifiers"], AAData["Identifiers"]["Damage Modifier"][Damage["damage_type"]]) then
									skip = true; return
								end
							end
							if skip then continue end
						end
					end
					if Item["_unique_item_data"]["_unique_portal_data"]["portal_depth"] then
						local Tier = Item["_unique_item_data"]["_unique_portal_data"]["portal_depth"]
						if Ignored["Tiers"] and Utility:Length(Ignored["Tiers"]) > 0 then
							if table.find(Ignored["Tiers"], tostring(Tier)) then continue end
						end
					end
					if Item["_unique_item_data"]["_unique_portal_data"]["challenge"] then
						local Challenge = Item["_unique_item_data"]["_unique_portal_data"]["challenge"]
						if Ignored["Challenges"] and Utility:Length(Ignored["Challenges"]) > 0 then
							if table.find(Ignored["Challenges"], AAData["Identifiers"]["Challenge"][Challenge]) then continue end
						end
					end
				end
				table.insert(Portals, Item)
			end
		end
		return Portals
	end
	-----------------------------

	----- [ Auto Replay ] -----
	function Functions:AutoReplay(Type, Data)
		if Type == "Portals" then
			if not Data then return false end
			local args = {
				[1] = "replay";
				[2] = {["item_uuid"] = Data["uuid"]};
			}
			local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer(unpack(args)) end)
			if Success then return true end
		elseif Type == "Story Worlds" then
			local args = {
				[1] = "replay";
			}
			local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer(unpack(args)) end)
			if Success then return true end
		end
		return false
	end
	---------------------------

	----- [ Auto Next ] -----
	function Functions:AutoNext(Type)
		if Type == "Story Worlds" then
			local args = {
				[1] = "next_story";
			}
			local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer(unpack(args)) end)
			if Success then return true end
		elseif Type == "Infinity Castle" then
			local args = {
				[1] = "NextRetry";
			}
			local Success = pcall(function() ReplicatedStorage.endpoints.client_to_server.request_start_infinite_tower_from_game:InvokeServer(unpack(args)) end)
			if Success then return true end
		end
		return false
	end
	-------------------------

	----- [ Webhooks ] -----
	function Functions:Webhook(Testing)
		if Settings["Misc"].Discord["Webhook"] == "" then warn("Webhook URL is empty!"); return; end
		local Drops = {}

		local Player = Players.LocalPlayer
		local PlayerLevel = string.split(Player.PlayerGui:FindFirstChild("spawn_units"):FindFirstChild("Lives"):FindFirstChild("Main"):FindFirstChild("Desc"):FindFirstChild("Level").Text, " ")
		local LevelData = Getter:GetLevelData()

		local ResultHolder = Player.PlayerGui:FindFirstChild("ResultsUI"):FindFirstChild("Holder")
		local GameResult = ResultHolder:FindFirstChild("Title").Text
		local XP = string.split(ResultHolder:FindFirstChild("LevelRewards"):FindFirstChild("ScrollingFrame"):FindFirstChild("XPReward"):FindFirstChild("Main"):FindFirstChild("Amount").Text, " ")
		local Time = string.split(ResultHolder:FindFirstChild("Middle"):FindFirstChild("Timer").Text, " ")
		local Waves = string.split(ResultHolder:FindFirstChild("Middle"):FindFirstChild("WavesCompleted").Text, " ")

		do
			for i, v in pairs(Getter:GetInventoryItems()) do
				Table_All_Items_New_data[i]["Count"] = v
			end
			for _, v in pairs(Getter:GetInventoryItemsUniqueItems()) do
				if string.find(v["item_id"],"portal") or string.find(v["item_id"],"disc") then
					Table_All_Items_New_data[v["item_id"]]["Count"] = Table_All_Items_New_data[v["item_id"]]["Count"] + 1
				end
			end
			for _, v in pairs(Getter:GetUnitsOwned()) do
				Table_All_Items_New_data[v["unit_id"]]["Count"] = Table_All_Items_New_data[v["unit_id"]]["Count"] + 1
				if v["shiny"] then
					Table_All_Items_New_data[v["unit_id"]]["Count"] = Table_All_Items_New_data[v["unit_id"]]["Count"] - 1
					Table_All_Items_New_data[v["unit_id"]]["Count Shiny"] = Table_All_Items_New_data[v["unit_id"]]["Count Shiny"] + 1
				end
			end
			for i, v in pairs(Table_All_Items_New_data) do
				if v["Count"] > 0 and (v["Count"] - Table_All_Items_Old_data[i]["Count"]) > 0 then
					if v["Count Shiny"] and v["Count"] then
						if v["Count"] > 0 or v["Count Shiny"] > 0 then
							if v["Count"] > 0 and (v["Count"] - Table_All_Items_Old_data[i]["Count"]) > 0 then
								table.insert(Drops, tostring(v["Name"]).." ("..tostring(v["Count"] - Table_All_Items_Old_data[i]["Count"])..")")
								if v["Count Shiny"] > 0 and (v["Count Shiny"] - Table_All_Items_Old_data[i]["Count Shiny"]) > 0 then
									table.insert(Drops, "Shiny "..tostring(v["Name"]).." ("..tostring(v["Count Shiny"] - Table_All_Items_Old_data[i]["Count Shiny"])..")")
								end
							end
						end
					elseif v["Count Shiny"] and v["Count Shiny"] > 0 and (v["Count Shiny"] - Table_All_Items_Old_data[i]["Count Shiny"]) > 0 then
						table.insert(Drops, "Shiny "..tostring(v["Name"]).." ("..tostring(v["Count Shiny"] - Table_All_Items_Old_data[i]["Count Shiny"])..")")
					elseif string.find(i, "portal") or string.find(i, "disc") then
						Count_Portal_List = Count_Portal_List + 1
						if string.gsub(i, "%D", "") == "" then
							table.insert(Drops, tostring(v["Name"]).." ("..tostring(v["Count"] - Table_All_Items_Old_data[i]["Count"])..")")
						else
							table.insert(Drops, tostring(v["Name"]).." Tier "..tostring(string.gsub(i, "%D", "")).." ("..tostring(v["Count"] - Table_All_Items_Old_data[i]["Count"])..")")
						end
					else
						table.insert(Drops, tostring(v["Name"]).." ("..tostring(v["Count"] - Table_All_Items_Old_data[i]["Count"])..")")
					end
				end
			end
		end

		local Message = Webhook.new()
		Message:Append("<@>")
		local Embed = Message:NewEmbed()
		task.spawn(function()
			Embed:SetTitle("Anime Adventures")
			Embed:SetColor(13531135)
			Embed:AppendFooter(tostring(identifyexecutor()))
			Embed:SetTimestamp(os.time())
		end)

		Embed:NewField("Username: ", "||".. Player.Name .."||", true)
		Embed:NewField("Level: ", PlayerLevel[2] .." ||(".. string.sub(PlayerLevel[3], 2, #PlayerLevel[3] - 1) ..")||", true)

		local CurrentStats = Embed:NewField("Current Stats")
		CurrentStats:AppendLine("Total Gems: `".. Player["_stats"].gem_amount.Value .."`")
		CurrentStats:AppendLine("Total Gold: `".. Player["_stats"].gold_amount.Value .."`")
		CurrentStats:AppendLine("Total Summer Pearls: `".. Player["_stats"]._resourceSummerPearls.Value .."`")

		local Results = Embed:NewField("Results")
		if LevelData["_gamemode"] == "raid" then
			if LevelData["_portal_map_item_uuid"] then
				Results:AppendLine("Portal - "..GameResult)
				Results:AppendLine(LevelData["name"])
				if LevelData["_location_name"] and LevelData["_challengename"] then 
					Results:AppendLine(LevelData["_location_name"].." - "..LevelData["_challengename"]) -- Portal With Challenge
				else Results:AppendLine(LevelData["_location_name"]) end -- Portal No Challenge
				if Loader.LevelData._portal_depth then Results:AppendLine("Tier: ".. tostring(Loader.LevelData._portal_depth)) end -- Portal Tier
				--Results:AppendLine("Dark: 90% | Light: 50%")
			else
				Results:AppendLine("Raid - "..GameResult)
				Results:AppendLine(LevelData["_location_name"])
				Results:AppendLine(LevelData["name"])
			end
		elseif LevelData["_gamemode"] == "story" then
			Results:AppendLine("Story - "..GameResult)
			Results:AppendLine(LevelData["_location_name"].." ("..LevelData["_difficulty"]..")")
			Results:AppendLine(LevelData["name"])
		elseif LevelData["_gamemode"] == "challenge" then
			Results:AppendLine("Challenge - "..GameResult)
			Results:AppendLine(LevelData["_location_name"].." - "..LevelData["_challengename"])
			Results:AppendLine(LevelData["name"])
		elseif LevelData["_gamemode"] == "infinite" and LevelData["name"] == "Infinite Mode" then
			Results:AppendLine("Infinite - "..GameResult)
			Results:AppendLine(LevelData["_location_name"])
		elseif LevelData["_gamemode"] == "infinite_tower" then
			Results:AppendLine("Infinity Castle - "..GameResult)
			Results:AppendLine(LevelData["_location_name"])
			Results:AppendLine(LevelData["name"])
		end

		Embed:NewField("Waves Beaten", Waves[3] .." (".. Time[2] .." ".. Time[3] ..")")

		local Rewards = Embed:NewField("Rewards")
		if Utility:Length(XP) > 0 and tonumber(string.sub(XP[1], 2)) > 0 then
			if string.sub(XP[1], 2) ~= "99999" then Rewards:AppendLine("+ "..string.sub(XP[1], 2).." XP") end
		end
		for _, v in pairs(Drops) do Rewards:AppendLine("+ "..v) end

		Message:Send(string.split(Settings["Misc"].Discord["Webhook"], "\n"))
	end
	------------------------

    ----- [ Teleport ] -----
    function Functions:Teleport()
        while task.wait() do
            pcall(function()
                Utility:Teleporter(Lobby_ID)
                if Utility.FoundAnything ~= "" then
                    Utility:Teleporter(Lobby_ID)
                end
            end)
        end
    end
    --------------------------

    ----- [ Connection ] -----
    function Functions:CheckInternet()
        warn("Auto Reconnect Loaded")
        while task.wait(5) do
            game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(a)
                if a.Name == 'ErrorPrompt' then
                    task.wait(10)
                    warn("Trying to Reconnect")
                    Utility:Teleporter(Lobby_ID)
                end
            end)
        end
    end
    --------------------------

	----- [ Delete Map ] -----
	function Functions:DeleteMap(Location, IncludeFolder)
		for _, v in pairs(Location:GetChildren()) do
			task.spawn(function()
				if v.ClassName == "MeshPart" then v:Remove() end
				if v.ClassName == "Model" then v:Remove() end
				if v.ClassName == "Part" then v:Remove() end
				if v.ClassName == "Folder" then
					if IncludeFolder then v:Remove()
					else Functions:DeleteMap(v) end
				end
			end)
		end
	end
	--------------------------

	----- [ Place Anywhere ] -----
	function Functions:PlaceAnywhere()
		task.spawn(function() while task.wait() do PlacementService.can_place = true end end)
	end
	------------------------------

	----- [ Remove Units Hitbox ] -----
	function Functions:RemoveUnitsHitbox()
		repeat task.wait() until Workspace:WaitForChild("_UNITS")
		for _, Unit in ipairs(Workspace:FindFirstChild("_UNITS"):GetChildren()) do
			repeat task.wait() until Unit:WaitForChild("_stats")
			if Unit:FindFirstChild("_hitbox") then
				Unit["_hitbox"]:Destroy()
			end
		end
		Workspace:FindFirstChild("_UNITS").ChildAdded:Connect(function(Unit)
			if not Settings["Misc"].Map["Place Anywhere"] then return end
			repeat task.wait() until Unit:WaitForChild("_stats")
			if Unit:FindFirstChild("_hitbox") then
				Unit["_hitbox"]:Destroy()
			end
		end)
	end
	-----------------------------------

	----- [ Alert Message ] -----
	function Functions:AlertMessage(Enabled)
		Players.LocalPlayer.PlayerGui:WaitForChild("MessageGui").Enabled = Enabled
	end
	----------------------------------
end

---------------------
----- [ SETUP ] -----
---------------------
--if not InLobby() then Started() end

if InLobby() then
	UISetup:Home()
	UISetup:AutoFarm()
	UISetup:UnitConfig()
	UISetup:Macro()
	UISetup:ShopNItem()
	UISetup:Misc()
	warn("Loaded Lobby UI")
else
	UISetup:Home()
	UISetup:AutoFarm()
	UISetup:UnitConfig()
	UISetup:Macro()
	UISetup:Misc()
	warn("Loaded Game UI")
end
if Players.LocalPlayer.UserId == 82468271 then UISetup:Debug() end
Window:SelectPage(PHome, true)
if not InLobby() and Settings and Settings["Macro"] and Settings["Macro"].Play then Window:SelectPage(PMacro, true) end

Threads["Macro"] = Utility:Thread("Macro", function()
	task.spawn(function()
		if InLobby() then return end -- Stop Thread in Lobby
		----- [ Get Macro ] -----
		if Settings["Macro"].Maps then
			local Success, Result = pcall(function() return HttpService:JSONDecode(readfile(MacrosDirectory.."/"..Settings["Macro"].Maps[CurrentMap]..".json")) end)
			if Success then MacroData["Macro"] = Result; end
		end

		----- [ Get Units ] -----
		local Units = {}
		for Slot = 1, Utility:Length(Getter:GetUnitsEquipped()) do
			if Getter:GetUnitsEquipped()[tostring(Slot)] then
				local uuid = Getter:GetUnitsEquipped()[tostring(Slot)]
				local unit_id = Getter:GetUnitsOwned()[uuid]["unit_id"]
				local name = UnitsData[unit_id]["name"]

				Units[unit_id] = {["unit_id"] = unit_id, ["uuid"] = uuid, ["name"] = name}
			end
		end

		----- [ Start Macro ] -----
		if MacroData["Macro"] then
			warn("Starting Macro")
			for Index = 1, Utility:Length(MacroData["Macro"]) do
				if not Settings["Macro"].Play then
					repeat task.wait(); MacroData["Status"] = "Stopped"
					until Settings["Macro"].Play
				end
				MacroData["Status"] = "Running"
				MacroData["Action"] = Index
				local Action = MacroData["Macro"][tostring(Index)]

				if Action["type"] == "spawn_unit" then
					MacroData["Type"] = "Placing Unit"
					local split = string.split(Action["cframe"], ",")
					local pos = Vector3.new(tonumber(split[1]), tonumber(split[2]), tonumber(split[3]))
					local unit = Functions:GetUnit({"Equipped", Action["unit"]})

					if unit ~= nil then
						MacroData["Unit"] = UnitsData[unit["unit_id"]]["name"]
						print("Placing "..UnitsData[unit["unit_id"]]["name"])

						-- [ Condition Holder ] --
						if Action["money"] then
							repeat task.wait(); MacroData["Waiting"] = {["Type"] = "Money", ["Value"] = Action["money"]}
							until Players.LocalPlayer:WaitForChild("_stats"):WaitForChild("resource").Value >= Action["money"]
						end

						local Result = false
						task.spawn(function() Result = Functions:PlaceUnit(unit["uuid"], pos) end)
						repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:PlaceUnit(unit["uuid"], pos) end) end
						until Result
					end
				elseif Action["type"] == "upgrade_unit_ingame" then
					MacroData["Type"] = "Upgrading Unit"
					local split = string.split(Action["pos"], ",")
					local pos = Vector3.new(tonumber(split[1]), tonumber(split[2]), tonumber(split[3]))
					local unit = Functions:GetUnit({"Workspace", pos})

					if unit ~= nil then
						MacroData["Unit"] = UnitsData[unit["_stats"]["id"].Value]["name"]
						print("Upgrading "..UnitsData[unit["_stats"]["id"].Value]["name"])

						-- [ Condition Holder ] --
						if Action["money"] then
							repeat task.wait(); MacroData["Waiting"] = {["Type"] = "Money", ["Value"] = Action["money"]}
							until Players.LocalPlayer:WaitForChild("_stats"):WaitForChild("resource").Value >= Action["money"]
						end

						local Result = false
						task.spawn(function() Result = Functions:UpgradeUnit(unit) end)
						repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:UpgradeUnit(unit) end) end
						until Result
					end
				elseif Action["type"] == "sell_unit_ingame" then
					MacroData["Type"] = "Selling Unit"
					local split = string.split(Action["pos"], ",")
					local pos = Vector3.new(tonumber(split[1]), tonumber(split[2]), tonumber(split[3]))
					local unit = Functions:GetUnit({"Workspace", pos})

					if unit ~= nil then
						MacroData["Unit"] = UnitsData[unit["_stats"]["id"].Value]["name"]
						print("Selling "..UnitsData[unit["_stats"]["id"].Value]["name"])

						local Result = false
						task.spawn(function() Result = Functions:SellUnit(unit) end)
						repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:SellUnit(unit) end) end
						until Result
					end
				elseif Action["type"] == "cycle_priority" then
					MacroData["Type"] = "Change Unit Target Priority"
					local split = string.split(Action["pos"], ",")
					local pos = Vector3.new(tonumber(split[1]), tonumber(split[2]), tonumber(split[3]))
					local unit = Functions:GetUnit({"Workspace", pos})

					if unit ~= nil then
						MacroData["Unit"] = UnitsData[unit["_stats"]["id"].Value]["name"]
						print("Change Target "..UnitsData[unit["_stats"]["id"].Value]["name"])

						-- [ Condition Holder ] --
						if Action["Wave"] then
							repeat task.wait(); MacroData["Waiting"] = {["Type"] = "Wave", ["Value"] = Action["Wave"]}
							until Workspace:WaitForChild("_wave_num").Value >= tonumber(Action["Wave"])
						end
						if Action["Wavetime"] then
							repeat task.wait();
							until Workspace:WaitForChild("_wave_time").Value <= tonumber(Action["Wavetime"])
						end

						local Result = false
						task.spawn(function() Result = Functions:TargetPriority(unit) end)
						repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:TargetPriority(unit) end) end
						until Result
					end
				end
				task.wait(0.1)
			end
			MacroData["Status"] = "Finished"
			MacroData["Type"] = ""
			MacroData["Unit"] = ""
			MacroData["Waiting"] = {}
		end
	end)
end); Threads["Macro"]:Start()
Threads["Buffer"] = Utility:Thread("Auto Buffer", function()
	task.spawn(function()
		if InLobby() then return end -- Stop Thread in Lobby
		if Settings["Unit Config"].Auto["Buff"] then
			for i, _ in pairs(AAData["Game Setting"]["Buffers"]) do
				if table.find(Settings["Unit Config"].Auto["Buff"], i) then
					BufferContainer[i] = Functions:AutoBuff(i)
					BufferContainer[i]:Start()
				end
			end
		end
	end)
end); Threads["Buffer"]:Start()

Utility:Thread("Performance", function()
	task.spawn(function()
		if InLobby() then return end -- Stop Thread in Lobby
		repeat task.wait() until Workspace:FindFirstChild("_wave_num")
		repeat task.wait() until Workspace:FindFirstChild("_map")

		if Settings["Misc"].Map["Delete Map"] then
			Functions:DeleteMap(Workspace["_terrain"].terrain, true);
			Functions:DeleteMap(Workspace["_map"])
		end
		if Settings["Misc"].Map["Delete Hill"] then
			Functions:DeleteMap(Workspace["_terrain"].hill, true);
		end

		local WaveNumber = Workspace:FindFirstChild("_wave_num")
		WaveNumber:GetPropertyChangedSignal("Value"):Connect(function()
			if Settings["Misc"].Map["Delete Map"] then
				Functions:DeleteMap(Workspace["_terrain"].terrain, true);
				Functions:DeleteMap(Workspace["_map"])
			end
			if Settings["Misc"].Map["Delete Hill"] then
				Functions:DeleteMap(Workspace["_terrain"].hill, true);
			end
		end)
	end)
	task.spawn(function()
		while task.wait() do
			if Settings["Misc"].Device["Low CPU Mode"] then
				if isrbxactive() ~= true then
					setfpscap(30)
					RunService:Set3dRenderingEnabled(false)
				else
					setfpscap(1000)
					RunService:Set3dRenderingEnabled(true)
				end
			end
		end
	end)
end):Start()
Utility:Thread("Farming", function()
	task.spawn(function()
		if not InLobby() then return end -- Stop Thread in Game
	end)
	task.spawn(function()
		if InLobby() then return end -- Stop Thread in Lobby
		repeat task.wait() until Workspace:FindFirstChild("_DATA")
		repeat task.wait() until Workspace:FindFirstChild("_DATA"):FindFirstChild("GameFinished")
		local GameFinished = Workspace:FindFirstChild("_DATA"):FindFirstChild("GameFinished")
		GameFinished:GetPropertyChangedSignal("Value"):Connect(function()
			print("Game Finished: ", GameFinished.Value == true)
			if GameFinished.Value == true then
				repeat task.wait() until Players.LocalPlayer.PlayerGui.ResultsUI.Enabled == true
				if Settings["Misc"].Discord["Enabled"] then Functions:Webhook() end

				if Threads["Buffer"]:Status() == "running" then Threads["Buffer"]:Stop() end
				if Threads["Macro"]:Status() == "running" then Threads["Macro"]:Stop() end
				MacroData["Status"] = "Game Finished"
				MacroData["Type"] = ""
				MacroData["Unit"] = ""
				MacroData["Waiting"] = {}

				print("Waiting For Replay, Next or Leave")
				task.wait(2.5)

				local Category = Settings["Farm Config"]["Category"];
				local Level = Settings["World Config"]["Level"];
				if table.find({"Portals", "Secret Portals"}, Category) then
					if Settings["Farm Config"].Auto["Replay Portal"] then
						local Ignored = {
							["Maps"] = Settings["World Config"].Ignored["Map"] or {};
							["Damage Modifiers"] = Settings["World Config"].Ignored["Damage Modifier"] or {};
							["Tiers"] = Settings["World Config"].Ignored["Tier"] or {};
							["Challenges"] = Settings["World Config"].Ignored["Challenge"] or {};
						}
						local Portals = Functions:GetPortals(Level, Ignored)

						if Portals ~= {} then
							table.sort(Portals)
							local Result = false
							task.spawn(function() Result = Functions:AutoReplay("Portals", {["uuid"] = Portals[1]["uuid"]}) end)
							repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:AutoReplay("Portals", {["uuid"] = Portals[1]["uuid"]}) end) end
							until Result
							print("Replaying Portal...")
						end
					elseif Settings["Farm Config"].Auto["Leave"] then
						TeleportService:Teleport(Lobby_ID, Players.LocalPlayer)
						Functions:Teleport()
						print("Returning to lobby...")
					end
				else
					if Settings["Farm Config"].Auto["Replay"] then
						local Result = false
						task.spawn(function() Result = Functions:AutoReplay("Story Worlds") end)
						repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:AutoReplay("Story Worlds") end) end
						until Result
						print("Replaying...")
					elseif Settings["Farm Config"].Auto["Next Story"] then
						local Result = false
						task.spawn(function() Result = Functions:AutoNext("Story Worlds") end)
						repeat task.wait(0.1); if not Result then task.spawn(function() Result = Functions:AutoNext("Story Worlds") end) end
						until Result
						print("Next Story...")
					elseif Settings["Farm Config"].Auto["Leave"] then
						TeleportService:Teleport(Lobby_ID, Players.LocalPlayer)
						Functions:Teleport()
						print("Returning to lobby...")
					end
				end
			end
		end)
	end)
end):Start()

if not InLobby() and Settings["Misc"].Map["Place Anywhere"] then Functions:PlaceAnywhere(); Functions:RemoveUnitsHitbox() end
if Settings["Misc"].UI["Hide Alert Message"] then Functions:AlertMessage(not Settings["Misc"].UI["Hide Alert Message"]) end

SaveSettings()

--------------------------
----- [ POST-SETUP ] -----
--------------------------
getgenv().SHUTDOWN = function()
	Utility:StopAllThreads();
	script:Destroy();
end
warn("Astral Anti-AFK Loaded!!!")
warn("Astral Hider Name Loaded!!!")
warn("Astral AA v1 Loaded!!!")
warn("All Loaded !!!")

if InLobby() then
	repeat task.wait(0.5) until Workspace:WaitForChild(Players.LocalPlayer.Name)
	Functions:CheckInternet()
elseif not InLobby() then
	repeat task.wait(0.5) until Workspace:WaitForChild("_terrain")
	Functions:CheckInternet()
end