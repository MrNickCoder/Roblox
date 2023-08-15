--------------------------
----- [ UPDATE FIX ] -----
--------------------------
local Version = "v1.0.0b01"

-------------------------------
----- [ LOADING SECTION ] -----
-------------------------------
repeat task.wait() until game:IsLoaded()
if game.PlaceId == 8304191830 then
	repeat task.wait() until game:GetService("Workspace"):FindFirstChild(game.Players.LocalPlayer.Name)
	repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("collection"):FindFirstChild("grid"):FindFirstChild("List"):FindFirstChild("Outer"):FindFirstChild("UnitFrames")
	repeat task.wait() until game:GetService("ReplicatedStorage").packages:FindFirstChild("assets")
	repeat task.wait() until game:GetService("ReplicatedStorage").packages:FindFirstChild("StarterGui")
else
	repeat task.wait() until game:GetService("Workspace"):FindFirstChild(game:GetService("Players").LocalPlayer.Name)
	game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
	repeat task.wait() until game:GetService("Workspace")["_waves_started"].Value == true
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

--------------------------
----- [ INITIALIZE ] -----
--------------------------
local Player				= Players.LocalPlayer
local Mouse					= Player:GetMouse()

local UILibrary				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloLib.lua"))()
local AAData				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/data/AnimeAdventures.lua"))()
local Utility				= loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/modules/UtilityModule.lua"))()
local Executor				= tostring(identifyexecutor())

local BufferContainer		= {}
local Getter				= {}
local UISetup				= {}
local Functions				= {}

local Loader				= require(ReplicatedStorage.src.Loader)
local UnitsData				= require(ReplicatedStorage.src.Data.Units)
local ItemsFolder			= ReplicatedStorage.src.Data.Items
local ItemInventoryService	= Loader.load_client_service(script, "ItemInventoryServiceClient")

local Count_Portal_List			= 0
local Table_All_Items_Old_data	= {}
local Table_All_Items_New_data	= {}
local CurrentMap				= ""

-------------------------
----- [ PRE-SETUP ] -----
-------------------------
do
	----- [ Common ] -----
	function InLobby() return (game.PlaceId == 8304191830) end

	----- [ Map Getter ] -----
	function Getter:GetLevelData()
		local List = {}
		for Index, Value in pairs(Workspace._MAP_CONFIG:WaitForChild("GetLevelData"):InvokeServer()) do List[Index] = Value end
		return List
	end
	function Getter:GetCurrentLevelId() if Workspace._MAP_CONFIG then return Getter:GetLevelData()["id"] end end
	function Getter:GetCurrentLevelName() if Workspace._MAP_CONFIG then return Getter:GetLevelData()["name"] end end
	function Getter:GetCurrentLevelTier() if Workspace._MAP_CONFIG then end end
	function Getter:GetCurrentMap()
		for Map, Identifiers in pairs(AAData["Map Identifier"]) do
			if Getter:GetLevelData()["map"] then
				if table.find(Identifiers, Getter:GetLevelData()["map"]) then
					return Map
				end
			end
		end
	end
	--------------------------

	----- [ Item Getter ] -----
	function Getter:Get_Inventory_Items_Unique_Items() return ItemInventoryService["session"]["inventory"]["inventory_profile_data"]["unique_items"] end
	function Getter:Get_Inventory_Items() return ItemInventoryService["session"]["inventory"]["inventory_profile_data"]["normal_items"] end
	function Getter:Get_Units_Owner() return ItemInventoryService["session"]["collection"]["collection_profile_data"]["owned_units"] end
	---------------------------
end
if not InLobby() then Getter:GetLevelData() end
if not InLobby() then CurrentMap = Getter:GetCurrentMap(); print(CurrentMap) end

---------------------------------
----- [ SETTINGS / CONFIG ] -----
---------------------------------
local Directory = "Astral_V1_Anime_Adventures/"..Players.LocalPlayer.Name -- Config Directory
local File = "Settings.json"

Settings = {}
function SaveSettings() Settings = Utility:SaveConfig(Settings, Directory, File); warn("Settings Saved!") end
function LoadSettings() return Utility:LoadConfig(Settings, Directory, File) end
function SaveUnitPosition(UnitSlot, Positions:{any}, Reset:boolean)
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
do
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
		if Unit.rarity then
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
	for Index, Item in pairs(Getter:Get_Inventory_Items()) do Table_All_Items_Old_data[Index]["Count"] = Item end
	for _, Item in pairs(Getter:Get_Inventory_Items_Unique_Items()) do
		if string.find(Item["item_id"], "portal") or string.find(Item["item_id"], "disc") then
			Count_Portal_list = Count_Portal_List + 1
			Table_All_Items_Old_data[Item["item_id"]]["Count"] = Table_All_Items_Old_data[Item["item_id"]]["Count"] + 1
		end
	end
	for _, Unit in pairs(Getter:Get_Units_Owner()) do
		Table_All_Items_Old_data[Unit["unit_id"]]["Count"] = Table_All_Items_Old_data[Unit["unit_id"]]["Count"] + 1
		if Unit.shiny then
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
	Window:Enabled(false)

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
		getgenv().UpdateWorldLevel = function(value:string)
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
		getgenv().UpdateWorldDifficulty = function(value:string)
			WorldDifficulty.Functions:Hide()
			local List = {
				WorldDifficultySeparator.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Dropdown,
				
			};
			local visible = false
			if AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"] then
				if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value] then
					if AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][WorldType.Data.Value]["Levels"] then
						if (Settings["World Config"]["World Level"] and string.find(Settings["World Config"]["World Level"], "_infinite")) or
							(Settings["Farm Config"]["Farm Category"] and table.find({"Legend Stages", "Raid Worlds"}, Settings["Farm Config"]["Farm Category"])) then
							WorldDifficulty.Data.Options = {"Hard"}
							Settings["World Config"]["World Difficulty"] = "Hard"
						elseif (Settings["Farm Config"]["Farm Category"] and table.find({"Portals", "Dungeon", "Secret Portals"}, Settings["Farm Config"]["Farm Category"])) then
							WorldDifficulty.Data.Options = {"Default"}
							Settings["World Config"]["World Difficulty"] = "Default"
						else
							WorldDifficulty.Data.Options = {"Normal", "Hard"}
							Settings["World Config"]["World Difficulty"] = "Normal"
						end
						WorldDifficulty.Data.Value = Settings["World Config"]["World Difficulty"]
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
		getgenv().UpdateIgnoredMap = function(value:string)
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
		getgenv().UpdateIgnoredDamageModifier = function(value:string)
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
		getgenv().UpdateIgnoredTier = function(value:string)
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
		getgenv().UpdateIgnoredChallenge = function(value:string)
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
			--coroutine.resume(coroutine.create(function()
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
			--end))
		end

		-------------------------------------------

		getgenv().UpdateUnitConfig = function()
			if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value] then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value] = {} end
			if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units = {} end
			for UnitSlot = 1, 6 do
				--coroutine.resume(coroutine.create(function()
					if not Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)] then Settings["Unit Config"].Configs[LoadUnitConfig.Data.Value].Units["Unit "..tostring(UnitSlot)] = {} end
					if not UnitSettings[UnitSlot] then UnitSettings[UnitSlot] = {} end
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
				--end))
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
					--coroutine.resume(coroutine.create(function()
						if not UnitSettings[UnitSlot] then UnitSettings[UnitSlot] = {} end
						local USettings = UnitSettings[UnitSlot]
						Utility:Show({
							USettings["Selected Position"].Dropdown,
							USettings["Single"].Button,
							USettings["Delete"].Button,
							USettings[""].Label,
							USettings["Group"].Button,
							USettings["Spread"].Button,
							USettings["Clear"].Button,
						}, value)
					--end))
				end
			end

			getgenv().PositionChange(false)
		end

		getgenv().UpdateUnitConfig()
	end
	---------------------------

	----- [ Macro Config ] -----
	local MacroConfig, CreateMacro;
	function UISetup:Macro()
		PMacro = Window:AddPage("Macro", "🕹️")
		local SMacroSplits = PMacro:AddSplit()
		local SMacroStatus = PMacro:AddSection("🕹️ Macro Information 🕹️", {Split = SMacroSplits, Side = "Left"})
		local SMacroOptions = PMacro:AddSection("⚙️ Macro Options ⚙️", {Split = SMacroSplits, Side = "Left"})
		local SMacroUnits = PMacro:AddSection("🧙 Macro Units 🧙", {Split = SMacroSplits, Side = "Left"})
		local SMacroMaps = PMacro:AddSection("🌏 Macro Maps 🌏", {Split = SMacroSplits, Side = "Right"})
		
		SMacroStatus:AddLabel("Status: N/A")
		SMacroStatus:AddLabel("Action: N/A")
		SMacroStatus:AddLabel("Type: N/A")
		SMacroStatus:AddLabel("Unit: N/A")
		SMacroStatus:AddLabel("Currently Waiting For Money: N/A")
		
		MacroConfig = SMacroOptions:AddDropdown("🕹️ Macro: ", function(value)

		end, {})
		CreateMacro = SMacroOptions:AddTextbox("💾 Create Macro", function(value)
			table.insert(MacroConfig.Data.Options, value)
			CreateMacro.Data.Text = ""
			CreateMacro.Section:UpdateTextbox(CreateMacro, nil, {Text = CreateMacro.Data.Text})
		end, {Placeholder = "Macro Name", RequireEntered = true})
		SMacroOptions:AddToggle("⏺️ Record", function(value) end)
		SMacroOptions:AddToggle("⚡ Record Abilities", function(value) end)
		SMacroOptions:AddButton("🔥 Delete Macro", function() end)
		SMacroOptions:AddToggle("▶️ Play Macro", function(value) end)
		
		SMacroUnits:AddButton("🧙 Equip Macro Units", function() end)
		
		for _, Map in pairs(AAData["Maps"]) do
			local MacroMap = SMacroMaps:AddDropdown(Map..": ", function(value) end, {Value = "None", ExpandLimit = 5})
			MacroMap.Data.Options = Utility:Combine_Table({"None"}, MacroConfig.Data.Options)
		end
		
		-------------------------------------------
		
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
		if Settings and not Settings["Misc"].Map then Settings["Misc"].Map = {} end
		if Settings and not Settings["Misc"].Script then Settings["Misc"].Script = {} end
		if Settings and not Settings["Misc"].Players then Settings["Misc"].Players = {} end
		
		local SDiscordWebhook = PMisc:AddSection("🌐 Discord Webhook 🌐")
		local SMiscSplit = PMisc:AddSplit()
		local SDevicePerformance = PMisc:AddSection("🖥️ Device Performance 🖥️", {Split = SMiscSplit, Side = "Left"})
		local SLaggyBETA = PMisc:AddSection("LAGGY Config (BETA)", {Split = SMiscSplit, Side = "Left"})
		local SMapPerformance = PMisc:AddSection("🌏 Map Performance 🌏", {Split = SMiscSplit, Side = "Right"})
		local SScriptSettings = PMisc:AddSection("⌛ Script Settings ⌛", {Split = SMiscSplit, Side = "Right"})
		local SPlayersModification = PMisc:AddSection("🐱 Players Modification 🐱", {Split = SMiscSplit, Side = "Right"})
		local SOtherConfig = PMisc:AddSection("⚙️ Other Config ⚙️", {Split = SMiscSplit, Side = "Right"})
		local SReset = PMisc:AddSection("🤖 Reset 🤖", {Split = SMiscSplit, Side = "Right"})
		
		--- [ Discord ] ---
		SDiscordWebhook:AddTextbox("Webhook Urls", function(value) Settings["Misc"].Discord["Webhook"] = value; SaveSettings() end, {Placeholder = "URL", MultiLine = true})
		SDiscordWebhook:AddTextbox("Sniper Webhook Urls", function(value) Settings["Misc"].Discord["Sniper Webhook"] = value; SaveSettings() end, {Placeholder = "URL", MultiLine = true})
		SDiscordWebhook:AddTextbox("Baby Webhook Urls", function(value) Settings["Misc"].Discord["Baby Webhook"] = value; SaveSettings() end, {Placeholder = "URL", MultiLine = true})
		
		--- [ Device Performance ] ---
		SDevicePerformance:AddToggle("🖥️ Low CPU Mode", function(value) Settings["Misc"].Device["Low CPU Mode"] = value; SaveSettings() end, {Active = Settings["Misc"].Device["Low CPU Mode"] or false})
		SDevicePerformance:AddToggle("🔫 Boost FPS Mode", function(value) Settings["Misc"].Device["Boost FPS Mode"] = value; SaveSettings() end, {Active = Settings["Misc"].Device["Boost FPS Mode"] or false})
		
		--- [ LAGGY ] ---
		
		--- [ Map Performance ] ---
		SMapPerformance:AddToggle("🗺️ Delete Map", function(value) Settings["Misc"].Map["Delete Map"] = value; SaveSettings() end, {Active = Settings["Misc"].Map["Delete Map"] or false})
		SMapPerformance:AddToggle("👇 Place Anywhere", function(value) Settings["Misc"].Map["Place Anywhere"] = value; SaveSettings() end, {Active = Settings["Misc"].Map["Place Anywhere"] or false})
		SMapPerformance:AddButton("Activate Place Anywhere", function() end)
		SMapPerformance:AddToggle("⛰️ Delete Hill [Disable hill placing]", function(value) Settings["Misc"].Map["Delete Hill"] = value; SaveSettings() end, {Active = Settings["Misc"].Map["Delete Hill"] or false})
		SMapPerformance:AddButton("Activate Delete Hill", function() end)
		
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
					if ItemInventoryService["session"]["collection"]["collection_profile_data"]["equipped_units"][tostring(slot)] then
						local uuid = ItemInventoryService["session"]["collection"]["collection_profile_data"]["equipped_units"][tostring(slot)]
						local unit_id = ItemInventoryService["session"]["collection"]["collection_profile_data"]["owned_units"][uuid]["unit_id"]
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
	----- [ Place ] -----
	function Functions:PlaceUnit()

	end
	---------------------

	----- [ Upgrade ] -----
	function Functions:UpgradeUnit()
		repeat task.wait() until Workspace:WaitForChild("_UNITS")
		for _, unit in ipairs(Workspace["_UNITS"]:GetChildren()) do

		end
	end
	-----------------------

	----- [ Target Priority ] -----
	function Functions:TargetPriority()

	end
	-------------------------------

	----- [ Position Unit ] -----
	function Functions:PositionUnit(UnitSlot, Type:string, Specific:string)
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
        return Utility:Thread(Buffer, function()
			print(Buffer.." Auto Buff Started")
            local LocalPlayer = Players.LocalPlayer
            local Data = AAData["Game Setting"]["Buffers"][Buffer]

            local Container = {}
            local function RemoveBuffer()
				if #Container <= 0 then return end
                local Temp = {}
                for _, unit in pairs(Workspace._UNITS:GetChildren()) do
                    if table.find(Data["Name"], unit.Name) then
						if unit:FindFirstChild("_stats") and unit:FindFirstChild("_stats"):FindFirstChild("player").Value == LocalPlayer then
							if not table.find(Temp, unit) then
                        		table.insert(Temp, unit)
							end
						end
                    end
                end
                for pos, unit in pairs(Container) do -- Removing Deleted Buffer
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

    ----- [ Teleport ] -----
    function Functions:Teleport()
        while task.wait() do
            pcall(function()
                Utility:Teleporter(8304191830)
                if Utility.FoundAnything ~= "" then
                    Utility:Teleporter(8304191830)
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
                    Utility:Teleporter(8304191830)
                end
            end)
        end
    end
    --------------------------
end

---------------------
----- [ SETUP ] -----
---------------------
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
Window:Enabled(true)

coroutine.resume(coroutine.create(function()
	task.spawn(function()
		if not InLobby() and Settings["Unit Config"].Auto["Buff"] then
			for i, _ in pairs(AAData["Game Setting"]["Buffers"]) do
				if table.find(Settings["Unit Config"].Auto["Buff"], i) then
					BufferContainer[i] = Functions:AutoBuff(i)
					BufferContainer[i]:Start()
				end
			end
		end
	end)
end))
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