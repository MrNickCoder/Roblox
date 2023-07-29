--------------------------
----- [ UPDATE FIX ] -----
--------------------------
local Version = "v1.0.0b01"

-------------------------------
----- [ LOADING SECTION ] -----
-------------------------------
repeat task.wait() until game:IsLoaded()
if game.PlaceId == 8304191830 then
	repeat task.wait() until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name)
	repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("collection"):FindFirstChild("grid"):FindFirstChild("List"):FindFirstChild("Outer"):FindFirstChild("UnitFrames")
	repeat task.wait() until game.ReplicatedStorage.packages:FindFirstChild("assets")
	repeat task.wait() until game.ReplicatedStorage.packages:FindFirstChild("StarterGui")
else
	repeat task.wait() until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name)
	game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
	repeat task.wait() until game:GetService("Workspace")["_waves_started"].Value == true
end

------------------------
----- [ SETTINGS ] -----
------------------------
local Folder = "Astral_V1_Anime_Adventures" --
local File = game:GetService("Players").LocalPlayer.Name .. "_AnimeAdventures.json"

Settings = {}
function SaveSettings()
	local HttpService = game:GetService("HttpService")
	if not isfolder(Folder) then makefolder(Folder) end

	writefile(Folder .. "/" .. File, HttpService:JSONEncode(Settings))
	Settings = LoadSettings()
	warn("Settings Saved!")
end
function LoadSettings()
	local Success, Error = pcall(function()
		local HttpService = game:GetService("HttpService")
		if not isfolder(Folder) then makefolder(Folder) end

		return HttpService:JSONDecode(readfile(Folder .. "/" .. File))
	end)

	if Success then return Error
	else
		SaveSettings()
		return LoadSettings
	end
end
Settings = LoadSettings()

----- [ Start of Get Level Data of Map [Added by HOLYSHz] ] -----
function GetLevelData()
	local List = {}
	for Index, Value in pairs(game.Workspace._MAP_CONFIG:WaitForChild("GetLevelData"):InvokeServer()) do List[Index] = Value end

	return List
end

if game.PlaceId ~= 8304191830 then GetLevelData() end
-----------------------------------------------------------------

------------------------
----- [ SERVICES ] -----
------------------------
local HttpService			= game:GetService("HttpService")
local Workspace				= game:GetService("Workspace")
local Players				= game:GetService("Players")
local RunService			= game:GetService("RunService")
local UserInputService		= game:GetService("UserInputService")

--------------------------
----- [ INITIALIZE ] -----
--------------------------
local Player				= Players.LocalPlayer
local Mouse					= Player:GetMouse()

-----------------------
----- [ UTILITY ] -----
-----------------------
function Visible(List, Visible)
	for i, v in pairs(List) do
		v.Visible = Visible
	end
end
function Comma_Value(Text)
	local Value = Text;
	while true do
		local Str, Num = string.gsub(Value, "^(-?%d+)(%d%d%d)", "%1,%2");
		Value = Str
		if Num ~= 0 then else break end
	end
	return Value
end

---------------------------------
----- [ ITEM DROP RESULTS ] -----
---------------------------------
local ItemLoader = require(game.ReplicatedStorage.src.Loader)
local ItemInventoryService = ItemLoader.load_client_service(script, "ItemInventoryServiceClient")
function Get_Inventory_Items_Unique_Items() return ItemInventoryService["session"]['inventory']['inventory_profile_data']['unique_items'] end
function Get_Inventory_Items() return ItemInventoryService["session"]["inventory"]['inventory_profile_data']['normal_items'] end
function Get_Units_Owner() return ItemInventoryService["session"]["collection"]["collection_profile_data"]['owned_units'] end
local Count_Portal_List = 0
local Table_All_Items_Old_data = {}
local Table_All_Items_New_data = {}
for _, Items in pairs(game:GetService("ReplicatedStorage").src.Data.Items:GetDescendants()) do
	if Items:IsA("ModuleScript") then
		for Index, Item in pairs(require(Items)) do
			Table_All_Items_Old_data[Index] = {}
			Table_All_Items_Old_data[Index]['Name'] = Item['name']
			Table_All_Items_Old_data[Index]['Count'] = 0
			Table_All_Items_New_data[Index] = {}
			Table_All_Items_New_data[Index]['Name'] = Item['name']
			Table_All_Items_New_data[Index]['Count'] = 0
		end
	end
end
local Data_Units_All_Games = require(game:GetService("ReplicatedStorage").src.Data.Units)
for Index, Unit in pairs(Data_Units_All_Games) do
	if Unit.rarity then
		Table_All_Items_Old_data[Index] = {}
		Table_All_Items_Old_data[Index]['Name'] = Unit['name']
		Table_All_Items_Old_data[Index]['Count'] = 0
		Table_All_Items_Old_data[Index]['Count Shiny'] = 0
		Table_All_Items_New_data[Index] = {}
		Table_All_Items_New_data[Index]['Name'] = Unit['name']
		Table_All_Items_New_data[Index]['Count'] = 0
		Table_All_Items_New_data[Index]['Count Shiny'] = 0
	end
end
for Index, Item in pairs(Get_Inventory_Items()) do Table_All_Items_Old_data[Index]['Count'] = Item end
for Index, Item in pairs(Get_Inventory_Items_Unique_Items()) do
	if string.find(Item['item_id'],"portal") or string.find(Item['item_id'],"disc") then
		Count_Portal_list = Count_Portal_List + 1
		Table_All_Items_Old_data[Item['item_id']]['Count'] = Table_All_Items_Old_data[Item['item_id']]['Count'] + 1
	end
end
for Index, Unit in pairs(Get_Units_Owner()) do
	Table_All_Items_Old_data[Unit["unit_id"]]['Count'] = Table_All_Items_Old_data[Unit["unit_id"]]['Count'] + 1
	if Unit.shiny then
		Table_All_Items_Old_data[Unit["unit_id"]]['Count'] = Table_All_Items_Old_data[Unit["unit_id"]]['Count'] - 1
		Table_All_Items_Old_data[Unit["unit_id"]]['Count Shiny'] = Table_All_Items_Old_data[Unit["unit_id"]]['Count Shiny'] + 1
	end
end
----- [ Map & ID Map ] -----
local function GetCurrentLevelId() if game.Workspace._MAP_CONFIG then return game:GetService("Workspace")._MAP_CONFIG.GetLevelData:InvokeServer()["id"] end end
local function GetCurrentLevelName() if game.Workspace._MAP_CONFIG then return game:GetService("Workspace")._MAP_CONFIG.GetLevelData:InvokeServer()["name"] end end
----------------------------

----- [ Webhook ] -----
getgenv().item = "-"
Player.PlayerGui:FindFirstChild("HatchInfo"):FindFirstChild("holder"):FindFirstChild("info1"):FindFirstChild("UnitName").Text = getgenv().item
function ResultWebhook()
	if Settings.ResultWebhook then
		local URL = Settings.WebhookURL; print("Webhook?")
		if URL == "" then warn("Webhook URL is empty!"); return end

		local Time = os.date('!*t', OSTime);
		local Thumbnails_Avatar = HttpService:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. game:GetService("Players").LocalPlayer.UserId .. "&size=150x150&format=Png&isCircular=true", true))
		local Executor = tostring(identifyexecutor())
		UserLevel = Player.PlayerGui:FindFirstChild("spawn_units"):FindFirstChild("Lives"):FindFirstChild("Main"):FindFirstChild("Desc"):FindFirstChild("Level").Text
		TotalGems = Player.PlayerGui:FindFirstChild("spawn_units"):FindFirstChild("Lives"):FindFirstChild("Frame"):FindFirstChild("Resource"):FindFirstChild("Gem"):FindFirstChild("Level").Text

		ResultHolder = Player.PlayerGui:FindFirstChild("ResultsUI"):FindFirstChild("Holder")
		if game.PlaceId ~= 8304191830 then
			LevelName = game:GetService("Workspace"):FindFirstChild("_MAP_CONFIG"):FindFirstChild("GetLevelData"):InvokeServer()["name"]
			Result = ResultHolder.Title.Text
		else LevelName, Result = "nil","nil" end
		if Result == "VICTORY" then Result = "VICTORY" end
		if Result == "DEFEAT" then Result = "DEFEAT" end

		_Map = game:GetService("Workspace")["_BASES"].player.base["fake_unit"]:WaitForChild("HumanoidRootPart")
		GetLevelData = game.workspace._MAP_CONFIG:WaitForChild("GetLevelData"):InvokeServer()
		World = GetLevelData.id or GetLevelData.world or GetLevelData.name
		MapName = game:GetService("Workspace")._MAP_CONFIG.GetLevelData:InvokeServer()["name"]
		CWaves = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.Middle.WavesCompleted.Text
		CTime = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.Middle.Timer.Text
		BattlePass = Player.PlayerGui:FindFirstChild("BattlePass"):FindFirstChild("Main"):FindFirstChild("Level"):FindFirstChild("V").Text
		BattlePass2 = game:GetService("Players").LocalPlayer.PlayerGui.BattlePass.Main.Level.Title.Text
		BattlePassAllLV = game:GetService("Players").LocalPlayer.PlayerGui.BattlePass.Main.Main.Rewards.Frame.Pages.Home.Amount.Text
		BattlePassLV = game:GetService("Players").LocalPlayer.PlayerGui.BattlePass.Main.Level.V.Text
		Waves = CWaves:split(": ")

		if Waves ~= nil and Waves[2] == "999" then Waves[2] = "Use [Auto Leave at Wave] or [Test Webhook]" end
		TTime = CTime:split(": ")
		if Waves ~= nil and TTime[2] == "22:55" then TTime[2] = "Use [Auto Leave at Wave] or [Test Webhook]" end
		Gold = ResultHolder:FindFirstChild("LevelRewards"):FindFirstChild("ScrollingFrame"):FindFirstChild("GoldReward"):FindFirstChild("Main"):FindFirstChild("Amount").Text
		if Gold == "+99999" then Gold = "+0" end	 
		Gems = ResultHolder:FindFirstChild("LevelRewards"):FindFirstChild("ScrollingFrame"):FindFirstChild("GemReward"):FindFirstChild("Main"):FindFirstChild("Amount").Text
		if Gems == "+99999" then Gems = "+0" end	 
		ExpReward = ResultHolder:FindFirstChild("LevelRewards"):FindFirstChild("ScrollingFrame"):FindFirstChild("XPReward"):FindFirstChild("Main"):FindFirstChild("Amount").Text
		Exp = ExpReward:split(" ")
		if Exp[1] == "+99999" then Exp[1] = "+0" end
		Trophy = ResultHolder:FindFirstChild("LevelRewards"):FindFirstChild("ScrollingFrame"):FindFirstChild("TrophyReward"):FindFirstChild("Main"):FindFirstChild("Amount").Text
		if Trophy == "+99999" then Trophy = "+0" end

		TotalTime =  ResultHolder:FindFirstChild("Middle"):FindFirstChild("Timer").Text
		TotalWaves = ResultHolder:FindFirstChild("Middle"):FindFirstChild("WavesCompleted").Text

		local TextDropLabel = ""
		local CountAmount = 1
		for Index, Item in pairs(Get_Inventory_Items()) do Table_All_Items_New_data[Index]['Count'] = Item end
		for Index, Item in pairs(Get_Inventory_Items_Unique_Items()) do
			if string.find(Item['item_id'],"portal") or string.find(Item['item_id'],"disc") then
				Table_All_Items_New_data[Item['item_id']]['Count'] = Table_All_Items_New_data[Item['item_id']]['Count'] + 1
			end
		end
		for Index, Unit in pairs(Get_Units_Owner()) do
			Table_All_Items_New_data[Unit["unit_id"]]['Count'] = Table_All_Items_New_data[Unit["unit_id"]]['Count'] + 1
			if Unit.shiny then
				Table_All_Items_New_data[Unit["unit_id"]]['Count'] = Table_All_Items_New_data[Unit["unit_id"]]['Count'] - 1
				Table_All_Items_New_data[Unit["unit_id"]]['Count Shiny'] = Table_All_Items_New_data[Unit["unit_id"]]['Count Shiny'] + 1
			end
		end
		for Index, Item in pairs(Table_All_Items_New_data) do
			if Item['Count'] > 0 and (Item['Count'] - Table_All_Items_Old_data[Index]['Count']) > 0 then
				if Item['Count Shiny'] and Item['Count'] then
					if Item['Count'] > 0 or Item['Count Shiny'] > 0 then
						if Item['Count'] > 0 and (Item['Count'] - Table_All_Items_Old_data[Index]['Count']) > 0 then
							TextDropLabel = TextDropLabel .. tostring(CountAmount) .. ". " .. tostring(Item['Name']) .. " : x" .. tostring(Item['Count'] - Table_All_Items_Old_data[Index]['Count'])
							if Item['Count Shiny'] > 0 and (Item['Count Shiny'] - Table_All_Items_Old_data[Index]['Count Shiny']) > 0 then
								TextDropLabel = TextDropLabel .. " | " .. tostring(Item['Name']) .. " (Shiny) : x" .. tostring(Item['Count Shiny'] - Table_All_Items_Old_data[Index]['Count Shiny']) .. "\n"
								CountAmount = CountAmount + 1
							else
								TextDropLabel = TextDropLabel .. "\n"
								CountAmount = CountAmount + 1
							end
						end
					end
				end
			elseif Item['Count Shiny'] and Item['Count Shiny'] > 0 and (Item['Count Shiny'] - Table_All_Items_Old_data[Index]['Count Shiny']) > 0 then
				TextDropLabel = TextDropLabel .. tostring(CountAmount) .. ". " .. tostring(Item['Name']) .. " (Shiny) : x" .. tostring(Item['Count Shiny'] - Table_All_Items_Old_data[Index]['Count Shiny']) .. "\n"
				CountAmount = CountAmount + 1
			end
		end
		for Index, Item in pairs(Table_All_Items_New_data) do
			if Item['Count'] > 0 and (Item['Count'] - Table_All_Items_Old_data[Index]['Count']) > 0 then
				if Item['Count Shiny'] and Item['Count'] then
				elseif string.find(Index,"portal") or string.find(Index,"disc") then
					Count_Portal_list = Count_Portal_list + 1
					if string.gsub(Index, "%D", "") == "" then TextDropLabel = TextDropLabel .. tostring(CountAmount) .. ". " .. tostring(Item['Name']) .. " : x" .. tostring(Item['Count'] - Table_All_Items_Old_data[Index]['Count']) .. "\n"
					else TextDropLabel = TextDropLabel .. tostring(CountAmount) .. ". " .. tostring(Item['Name']) .. " Tier " .. tostring(string.gsub(Index, "%D", "")) .. " : x" .. tostring(Item['Count'] - Table_All_Items_Old_data[Index]['Count']) .. "\n" end
				end
				CountAmount = CountAmount + 1
			else
				TextDropLabel = TextDropLabel .. tostring(CountAmount) .. ". " .. tostring(Item['Name']) .. " : x" .. tostring(Item['Count'] - Table_All_Items_Old_data[Index]['Count']) .. "\n"
				CountAmount = CountAmount + 1
			end
		end
		if TextDropLabel == "" then TextDropLabel = "No Items Drops" end

		local Data = {
			["content"] = "",
			["username"] = "Astral V1 Anime Adventures",
			["avatar_url"] = "https://tr.rbxcdn.com/5c9e29b3953ec061286e76f08f1718b3/150/150/Image/Png",
			["embeds"] = {
				{
					["author"] = {
						["name"] = "Anime Adventures |  Results ✔️",
						["icon_url"] = "https://cdn.discordapp.com/emojis/997123585476927558.webp?size=96&quality=lossless"
					},
					["thumbnail"] = {
						['url'] = Thumbnails_Avatar.data[1].imageUrl,
					},
					["description"] = " Player Name : 🐱 ||**"..game:GetService("Players").LocalPlayer.Name.."**|| 🐱\nExecutors : 🎮 "..Executor.." 🎮 ",
					["color"] = 110335,
					["timestamp"] = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec),
					['footer'] = {
						['text'] = "// Made by NickCoder", 
						['icon_url'] = "https://yt3.ggpht.com/mApbVVD8mT92f50OJuTObnBbc3j7nDCXMJFBk2SCDpSPcaoH9DB9rxVpJhsB5SxAQo1UN2GzyA=s48-c-k-c0x00ffffff-no-rj"
					},
					["fields"] = {
						{
							["name"] ="Current Level ✨ & Gems 💎 & Gold 💰 & Portals 🌀",
							["value"] = "```ini\n"..tostring(game.Players.LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text).." ✨\n"..
								"Current Gold : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.gold_amount.Value)).." 💰\n"..
								"Current Gems : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.gem_amount.Value)).." 💎\n"..
								"Current Trophies : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.trophies.Value)).." 🏆\n"..
								"Current Pearl : "..tostring(Comma_Value(game.Players.LocalPlayer._stats._resourceSummerPearls.Value)).." 🦪\n"..
								"Current Portal : ".. tostring(Count_Portal_list).." 🌀```",
						},
						{
							["name"] ="Results :",
							["value"] = " ```ini\nWorld : "..MapName.." 🌏\n"..
								"Map : "..World.." 🗺️\n"..
								"Results : "..Result.." ⚔️\n"..
								"Wave End : "..tostring(Waves[2]).." 🌊\n"..
								"Time : " ..tostring(TTime[2]).." ⌛\n"..
								"All Kill Count : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.kills.Value)).." ⚔️\n"..
								"DMG Deal : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.damage_dealt.Value)).." 🩸```",
							["inline"] = true
						},
						{
							["name"] ="Rewards :",
							["value"] = "```ini\n" ..Comma_Value(Gold).." Gold 💰\n"..
								Comma_Value(Gems).." Gems 💎\n"..
								Comma_Value(Exp[1]).." XP 🧪\n"..
								Trophy.." Trophy 🏆```",
						},
						{
							["name"] ="Items Drop :",
							["value"] = "```ini\n"..TextDropLabel.."```",
							["inline"] = false 
						}
					}
				}
			}
		}

		local WBody = game:GetService("HttpService"):JSONEncode(Data)
		local WHeaders = {["content-type"] = "application/json"}
		local WRequest = http_request or request or HttpPost or syn.request or http.request
		local WHook = {Url = URL, Body = WBody, Method = "POST", Headers = WHeaders}
		warn("Sending webhook notification...")
		WRequest(WHook)
	end
end
function BabyWebhook()

end
function SnipeWebhook()

end
function SpecialSummonSniperWebhook()

end
function StandardSummonSniperWebhook()

end
function ShopSniperWebhook()

end
-----------------------

------------------------------
----- [ USER INTERFACE ] -----
------------------------------
if game.CoreGui:FindFirstChild("HoloLibUI") then game.CoreGui["HoloLibUI"]:Destroy() end

local Directory = "Anime_Adventures/"..game.Players.LocalPlayer.Name
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloLib.lua"))()
local AAData = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/animeadventures/AAData.lua"))()
local Executor = tostring(identifyexecutor())
local Window = UILibrary.new("[Astral V1] Anime Adventures "..Version.." - "..Executor)
Window.ToggleKey = Enum.KeyCode.P

local PHome = Window:AddPage("Home", "🏠")
local SDevelopers = PHome:AddSection("Anime Adventures")
local SHelp = PHome:AddSection("❓ Help ❓")

local PFarm = Window:AddPage("Auto Farm", "🤖")
local SFarmConfig = PFarm:AddSection("⚙️ Auto Farm Configuration ⚙️")
local SWorldConfig = PFarm:AddSection("🌏 World Config 🌏")

local PUnit = Window:AddPage("Unit Config", "🧙")
local SUnitConfig = PUnit:AddSection("⚙️ Unit Configuration ⚙️")

local PShop = Window:AddPage("Shop", "💰")

local PMisc = Window:AddPage("Misc [BETA]", "🛠️")

local PDiscord = Window:AddPage("Discord", "🌐")

----- [ Auto Farm Config ] -----
local FarmCategory;
local AutoReplay, AutoPortalReplay, AutoNextStory;
local function AutoFarmConfigUI()
	if Settings and not Settings.FarmConfig then Settings.FarmConfig = {} end
	if Settings and not Settings.WorldConfig then Settings.WorldConfig = {} end
	
	SFarmConfig:AddLabel({Text = "🔱 Farm Category"})
	FarmCategory = SFarmConfig:AddDropdown("Pick Category", function(value)
		if Settings.FarmConfig.FarmCategory == value then return end
		Settings.FarmConfig.FarmCategory = value
		Settings.WorldConfig.WorldType = AAData["World Type"]["Type"][value]["Worlds"][1]
		SaveSettings()
		warn("Changed Farming Type to "..value)
		
		getgenv().UpdateOptions(value)
		getgenv().UpdateWorldType(value)
	end, {
		Options = AAData["World Type"]["Types"],
		Value = Settings.FarmConfig.FarmCategory or AAData["World Type"]["Types"][1]
	})
	
	SFarmConfig:AddLabel()
	SFarmConfig:AddToggle("🌾 Auto Start", function(value) Settings.FarmConfig.AutoStart = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoStart or false})
	SFarmConfig:AddToggle("👨‍🌾 Auto Place Unit", function(value) Settings.FarmConfig.AutoPlace = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoPlace or false})
	SFarmConfig:AddToggle("⭐️ Auto Upgrade Units", function(value) Settings.FarmConfig.AutoUpgrade = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoUpgrade or false})
	SFarmConfig:AddToggle("🔥 Auto Abilities", function(value) Settings.FarmConfig.AutoAbilities = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoAbilities or false})
	SFarmConfig:AddCheckbox("🧙 Auto Buff 100%", function(value) Settings.FarmConfig.AutoBuff = value; SaveSettings() end, {Options = {"Orwin/Erwin", "Wenda/Wendy", "Leafy/Leafa"}, Selected = Settings.FarmConfig.AutoBuff or {}})
	
	SFarmConfig:AddLabel()
	AutoReplay = SFarmConfig:AddToggle("🏃 Auto Replay", function(value) Settings.FarmConfig.AutoReplay = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoReplay or false})
	AutoPortalReplay = SFarmConfig:AddToggle("🏃 Auto Pick Portal [Replay]", function(value) Settings.FarmConfig.AutoReplayPortal = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoReplayPortal or false})
	AutoNextStory = SFarmConfig:AddToggle("🏃 Auto Next Story", function(value) Settings.FarmConfig.AutoNextStory = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoNextStory or false})
	
	SFarmConfig:AddLabel()
	SFarmConfig:AddToggle("🏃 Auto Leave", function(value) Settings.FarmConfig.AutoLeave = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoLeave or false})
	SFarmConfig:AddToggle("⭐️ Sell Units At Wave", function(value) Settings.FarmConfig.WaveSell = value; SaveSettings() end, {Active = Settings.FarmConfig.WaveSell or false})
	SFarmConfig:AddToggle("⭐️ Leave At Wave", function(value) Settings.FarmConfig.WaveLeave = value; SaveSettings() end, {Active = Settings.FarmConfig.WaveLeave or false})
	SFarmConfig:AddToggle("🏃 Auto Defeat", function(value) Settings.FarmConfig.AutoDefeat = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoDefeat or false})
	
	getgenv().UpdateOptions = function(value)
		AutoReplay.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Replay"]
		AutoPortalReplay.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Portal Replay"]
		AutoNextStory.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Next Story"]
		
		FarmCategory.Section:Resize(true)
	end
	
	getgenv().UpdateOptions(FarmCategory.Data.Value)
end
-------------------------

----- [ World Config ] -----
local WorldType, WorldLevel, WorldDifficulty;
local function WorldConfigUI()
	local WorldTypeLabel = SWorldConfig:AddLabel({Text = "🌏 Select World"})
	WorldType = SWorldConfig:AddDropdown("", function(value)
		if Settings.WorldConfig.WorldType == value then return end
		Settings.WorldConfig.WorldType = value
		Settings.WorldConfig.WorldLevel = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"][1]
		SaveSettings()
		warn("Changed World Type to "..value)

		getgenv().UpdateWorldLevel(value)
	end, {})
	
	local WCSpace_1 = SWorldConfig:AddLabel()
	
	local WorldLevelLabel = SWorldConfig:AddLabel({Text = "🎚️ Select Level"})
	WorldLevel = SWorldConfig:AddDropdown("", function(value)
		if Settings.WorldConfig.WorldLevel == value then return end
		Settings.WorldConfig.WorldLevel = value
		if string.find(Settings.WorldConfig.WorldLevel, "_infinite") or table.find({"Legend Stages", "Raid Worlds"}, Settings.FarmConfig.FarmCategory) then
			Settings.WorldConfig.WorldDifficulty = "Hard"
		elseif table.find({"Portals", "Dungeon", "Secret Portals"}, Settings.FarmConfig.FarmCategory) then
			Settings.WorldConfig.WorldDifficulty = "Default"
		else
			Settings.WorldConfig.WorldDifficulty = "Normal"
		end
		SaveSettings()
		warn("Changed World Level to "..value)
		
		getgenv().UpdateWorldDifficulty(value)
	end, {})
	
	local WCSpace_2 = SWorldConfig:AddLabel()
	
	local WorldDifficultyLabel = SWorldConfig:AddLabel({Text = "🔫 Select Difficulty"})
	WorldDifficulty = SWorldConfig:AddDropdown("", function(value)
		if Settings.WorldConfig.WorldDifficulty == value then return end
		Settings.WorldConfig.WorldDifficulty = value
		SaveSettings()
		warn("Changed World Difficulty to "..value)
	end, {})
	
	getgenv().UpdateWorldType = function(value)
		WorldType.Reset()
		if not AAData["World Type"]["Type"][value]["Worlds"] then
			local List = {
				WorldTypeLabel.Label, WorldType.Dropdown,
				WCSpace_1.Label,
				WorldLevelLabel.Label, WorldLevel.Dropdown,
				WCSpace_2.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Label
			}
			Visible(List, false)
		else
			local List = {
				WorldTypeLabel.Label, WorldType.Dropdown,
				WCSpace_1.Label,
				WorldLevelLabel.Label, WorldLevel.Dropdown,
				WCSpace_2.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Label
			}
			Visible(List, true)
			
			WorldType.Data.Options = AAData["World Type"]["Type"][value]["Worlds"]
			if Settings.WorldConfig.WorldType and
				not table.find(AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"], Settings.WorldConfig.WorldType) then
				Settings.WorldConfig.WorldType = AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"][1]
			end
			WorldType.Data.Value = Settings.WorldConfig.WorldType
			WorldType.Section:UpdateDropdown(WorldType, WorldType.Data.Value, {})
			
			getgenv().UpdateWorldLevel(WorldType.Data.Value)
		end

		WorldType.Section:Resize(true)
	end
	getgenv().UpdateWorldLevel = function(value)
		WorldLevel.Reset()
		if not AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"] and
			AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"] then
			local List = {
				WCSpace_1.Label,
				WorldLevelLabel.Label, WorldLevel.Dropdown,
				WCSpace_2.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Label
			}
			Visible(List, false)
		else
			local List = {
				WCSpace_1.Label,
				WorldLevelLabel.Label, WorldLevel.Dropdown,
				WCSpace_2.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Label
			}
			Visible(List, true)

			WorldLevel.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"]
			if Settings.WorldConfig.WorldLevel and
				not table.find(AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"], Settings.WorldConfig.WorldLevel) then
				Settings.WorldConfig.WorldLevel = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"][1]
			end
			WorldLevel.Data.Value = Settings.WorldConfig.WorldLevel
			WorldLevel.Section:UpdateDropdown(WorldLevel, WorldLevel.Data.Value, {})
			
			getgenv().UpdateWorldDifficulty(WorldLevel.Data.Value)
		end

		WorldLevel.Section:Resize(true)
	end
	getgenv().UpdateWorldDifficulty = function(value)
		WorldDifficulty.Reset()
		if not AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"] and
			AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"] then
			local List = {
				WCSpace_2.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Label
			}
			Visible(List, false)
		else
			local List = {
				WCSpace_2.Label,
				WorldDifficultyLabel.Label, WorldDifficulty.Label
			}
			Visible(List, true)
			
			if string.find(Settings.WorldConfig.WorldLevel, "_infinite") or table.find({"Legend Stages", "Raid Worlds"}, Settings.FarmConfig.FarmCategory) then
				WorldDifficulty.Data.Options = {"Hard"}
				Settings.WorldConfig.WorldDifficulty = "Hard"
			elseif table.find({"Portals", "Dungeon", "Secret Portals"}, Settings.FarmConfig.FarmCategory) then
				WorldDifficulty.Data.Options = {"Default"}
				Settings.WorldConfig.WorldDifficulty = "Default"
			else
				WorldDifficulty.Data.Options = {"Normal", "Hard"}
				Settings.WorldConfig.WorldDifficulty = "Normal"
			end
			WorldDifficulty.Data.Value = Settings.WorldConfig.WorldDifficulty
			WorldDifficulty.Section:UpdateDropdown(WorldDifficulty, WorldDifficulty.Data.Value, {})
		end
		
		WorldDifficulty.Section:Resize(true)
	end
	
	getgenv().UpdateWorldType(FarmCategory.Data.Value)
	getgenv().UpdateWorldLevel(WorldType.Data.Value)
	getgenv().UpdateWorldDifficulty(WorldLevel.Data.Value)
end
----------------------------

----- [ Home Page ] -----
local function HomeUI()
	SDevelopers:AddLabel({Text = "📝 Scripted by: Arpon AG#6612 & Forever4D#0001 & HOLYSHz#3819"})
	SDevelopers:AddLabel({Text = "📝 Also thanks to Trapstar#7845, bytenode#9646 for the help!"})
	SDevelopers:AddLabel({Text = "📝 Improved by: NickCoder"})
	SDevelopers:AddLabel({Text = "📝 UI By: NickCoder"})
	SDevelopers:AddLabel({Text = "🔧 To toggle the UI press \" P \""})
	
	SHelp:AddLabel({Text = "double_cost = 'High Cost'"})
	SHelp:AddLabel({Text = "short_range = 'Short Range'"})
	SHelp:AddLabel({Text = "fast_enemies = 'Fast Enemies'"})
	SHelp:AddLabel({Text = "regen_enemies = 'Regen Enemies'"})
	SHelp:AddLabel({Text = "tank_enemies = 'Tank Enemies'"})
	SHelp:AddLabel({Text = "shield_enemies = 'Shield Enemies'"})
	SHelp:AddLabel({Text = "triple_cost = 'Triple Cost'"})
	SHelp:AddLabel({Text = "hyper_regen_enemies = 'Hyper-Regen Enemies'"})
	SHelp:AddLabel({Text = "hyper_shield_enemies = 'Steel-Plated Enemies'"})
	SHelp:AddLabel({Text = "godspeed_enemies = 'Godspeed Enemies'"})
	SHelp:AddLabel({Text = "flying_enemies = 'Flying Enemies'"})
	SHelp:AddLabel({Text = "mini_range = 'Mini-Range'"})
	
	Window:SelectPage(PHome, true)
end
-----------------------

----- [ Setup ] -----
if game.PlaceId == 8304191830 then
	HomeUI()
	AutoFarmConfigUI()
	WorldConfigUI()
	warn("Loaded Lobby UI")
else
	HomeUI()
	AutoFarmConfigUI()
	WorldConfigUI()
	warn("Loaded Game UI")
end
---------------------

-------------------------
----- [ FUNCTIONS ] -----
-------------------------


----- [ Auto Leave ] -----
local PlaceID = 8304191830
local AllIDs = {}
local FoundAnything = ""
local ActualHour = os.date("!*t").hour
local Deleted = false
local Last
local ServerFile = pcall(function() AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json")) end)
if not ServerFile then
	table.insert(AllIDs, ActualHour)
	writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
	local Site;
	if FoundAnything == "" then Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
	else Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. FoundAnything)) end

	local ID = ""
	if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then FoundAnything = Site.nextPageCursor end

	local Num = 0;
	local ExtraNum = 0
	for Index, Server in pairs(Site.data) do
		ExtraNum += 1
		local Possible = true
		ID = tostring(Server.id)
		if tonumber(Server.maxPlayers) > tonumber(Server.playing) then
			if ExtraNum ~= 1 and tonumber(Server.playing) < Last or ExtraNum == 1 then Last = tonumber(Server.playing)
			elseif ExtraNum ~= 1 then continue end

			for _,Existing in pairs(AllIDs) do
				if Num ~= 0 then
					if ID == tostring(Existing) then Possible = false end
				else
					if tonumber(ActualHour) ~= tonumber(Existing) then
						local delFile = pcall(function()
							delfile("NotSameServers.json")
							AllIDs = {}
							table.insert(AllIDs, ActualHour)
						end)
					end
				end
				Num = Num + 1
			end
			if Possible == true then
				table.insert(AllIDs, ID)
				wait()
				pcall(function()
					writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
					wait()
					game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
				end)
				wait(4)
			end
		end
	end
end
function Teleport()
	while wait() do
		pcall(function()
			TPReturner()
			if FoundAnything ~= "" then
				TPReturner()
			end
		end)
	end
end
--------------------------

----- [ Start of Check Connection ] -----
function CheckInternet()
	warn("Auto Reconnect Loaded")
	while task.wait(5) do
		game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(a)
			if a.Name == 'ErrorPrompt' then
				task.wait(10)
				warn("Trying to Reconnect")
				TPReturner()
			end
		end)
	end
end
-----------------------------------------

warn("Astral Anti-AFK Loaded!!!")
warn("Astral Hider Name Loaded!!!")
warn("Astral AA v1 Loaded!!!")
warn("All Loaded !!!")

if game.PlaceId == 8304191830 then
	repeat task.wait(0.5) until Workspace:WaitForChild(game.Players.LocalPlayer.Name)
	CheckInternet()
elseif game.PlaceId ~= 8304191830 then
	repeat task.wait(0.5) until Workspace:WaitForChild("_terrain")
	CheckInternet()
end