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

-----------------------
----- [ UTILITY ] -----
-----------------------
local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/modules/UtilityModule.lua"))()
function InLobby() return (game.PlaceId == 8304191830) end

------------------------
----- [ SETTINGS ] -----
------------------------
local Folder = "Astral_V1_Anime_Adventures" --
local File = game:GetService("Players").LocalPlayer.Name .. "_AnimeAdventures.json"

Settings = {}
function SaveSettings() Settings = Utility:SaveConfig(Settings, Folder, File); warn("Settings Saved!") end
function LoadSettings() return Utility:SaveConfig(Settings, Folder, File) end
Settings = LoadSettings()

----- [ Start of Get Level Data of Map [Added by HOLYSHz] ] -----
function GetLevelData()
	local List = {}
	for Index, Value in pairs(game.Workspace._MAP_CONFIG:WaitForChild("GetLevelData"):InvokeServer()) do List[Index] = Value end

	return List
end

if not InLobby() then GetLevelData() end
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
								"Current Gold : "..tostring(Utility:Comma_Value(game.Players.LocalPlayer._stats.gold_amount.Value)).." 💰\n"..
								"Current Gems : "..tostring(Utility:Comma_Value(game.Players.LocalPlayer._stats.gem_amount.Value)).." 💎\n"..
								"Current Trophies : "..tostring(Utility:Comma_Value(game.Players.LocalPlayer._stats.trophies.Value)).." 🏆\n"..
								"Current Pearl : "..tostring(Utility:Comma_Value(game.Players.LocalPlayer._stats._resourceSummerPearls.Value)).." 🦪\n"..
								"Current Portal : ".. tostring(Count_Portal_list).." 🌀```",
						},
						{
							["name"] ="Results :",
							["value"] = " ```ini\nWorld : "..MapName.." 🌏\n"..
								"Map : "..World.." 🗺️\n"..
								"Results : "..Result.." ⚔️\n"..
								"Wave End : "..tostring(Waves[2]).." 🌊\n"..
								"Time : " ..tostring(TTime[2]).." ⌛\n"..
								"All Kill Count : "..tostring(Utility:Comma_Value(game.Players.LocalPlayer._stats.kills.Value)).." ⚔️\n"..
								"DMG Deal : "..tostring(Utility:Comma_Value(game.Players.LocalPlayer._stats.damage_dealt.Value)).." 🩸```",
							["inline"] = true
						},
						{
							["name"] ="Rewards :",
							["value"] = "```ini\n" ..Comma_Value(Gold).." Gold 💰\n"..
								Utility:Comma_Value(Gems).." Gems 💎\n"..
								Utility:Comma_Value(Exp[1]).." XP 🧪\n"..
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
local AAData = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/data/AnimeAdventures.lua"))()
local Executor = tostring(identifyexecutor())
local Window = UILibrary.new("[Astral V1] Anime Adventures "..Version.." - "..Executor, {
	Size = UDim2.new(0, 700, 0, 400),
	ToggleKey = Enum.KeyCode.P,
	Enabled = false,
})

local UISetup = {}
do
	----- [ Home Page ] -----
	local PHome;
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

		Window:SelectPage(PHome, true)
	end
	-----------------------

	----- [ Auto Farm Config ] -----
	local PFarm;
	local SFarmSplits = PFarm:AddSplit()
	local FarmCategory;
	local AutoStart, AutoReplay, AutoPortalReplay, AutoNextStory, AutoLeave;
	function UISetup:AutoFarm()
		PFarm = Window:AddPage("Auto Farm", "🤖")
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
	local PUnit;
	local LoadUnitConfig, TeamSelect;
	local UnitSettings = {};
	function UISetup:UnitConfig()
		PUnit = Window:AddPage("Unit Config", "🧙")
		if Settings and not Settings["Unit Config"] then Settings["Unit Config"] = {} end
		if Settings and not Settings["Unit Config"].Auto then Settings["Unit Config"].Auto = {} end
		local STeamConfig = PUnit:AddSection("🧙 Team Configuration 🧙")
		if InLobby() then STeamConfig:Enabled(false) end
		local SUnitConfig = PUnit:AddSection("⚙️ Unit Configuration ⚙️")
		local SUnitSplits = PUnit:AddSplit()

		TeamSelect = STeamConfig:AddDropdown("🧙 Select Team: ", function(value)

		end, {Options = {"Team 1","Team 2","Team 3","Team 4","Team 5"}})

		LoadUnitConfig = SUnitConfig:AddDropdown("🧙 Load Unit Config: ", function(value)

		end, {Options = {"Default"}, Value = "Default"})
		SUnitConfig:AddButton("💾 Save Unit Config", function(value)

		end)
		SUnitConfig:AddButton("🔥 Delete Unit Config", function(value)

		end)
		SUnitConfig:AddLabel()
		if not InLobby() then SUnitConfig:AddToggle("🚩 Modify Units Positions", function(value) getgenv().ModifyPosition(value) end, {Active = false}) end
		SUnitConfig:AddToggle("👨‍🌾 Auto Place Unit", function(value) Settings["Unit Config"].Auto["Place"] = value; SaveSettings() end, {Active = Settings["Unit Config"].Auto["Place"] or false})
		SUnitConfig:AddToggle("⭐️ Auto Upgrade Units", function(value) Settings["Unit Config"].Auto["Upgrade"] = value; SaveSettings() end, {Active = Settings["Unit Config"].Auto["Upgrade"] or false})
		SUnitConfig:AddToggle("🔥 Auto Abilities", function(value) Settings["Unit Config"].Auto["Abilities"] = value; SaveSettings() end, {Active = Settings["Unit Config"].Auto["Abilities"] or false})
		SUnitConfig:AddDropdown("🧙 Auto Buff 100%", function(value) Settings["Unit Config"].Auto["Buff"] = value; SaveSettings() end, {MultiValue = true, Options = {"Orwin/Erwin", "Wenda/Wendy", "Leafy/Leafa"}, Value = Settings["Unit Config"].Auto["Buff"] or {}})

		
		for UnitSlot = 1, 6 do
			UnitSettings[UnitSlot] = {}
			local USettings = UnitSettings[UnitSlot]
			if UnitSlot % 2 ~= 0 then USettings["Section"] = PUnit:AddSection("🧙⚙️ Unit "..UnitSlot..": ", {Split = SUnitSplits, Side = "Left"})
			else USettings["Section"] = PUnit:AddSection("🧙⚙️ Unit "..UnitSlot..": ", {Split = SUnitSplits, Side = "Right"}) end

			USettings["Enable"] = USettings["Section"]:AddToggle("⚙️ Use Unit Settings", function(value) end, {Active = false})

			if not InLobby() then
				USettings["Section"]:AddToggle("📍 Show Position", function(value) end)
				USettings["Single"] = USettings["Section"]:AddButton("🚩 Set Position [Single]", function() end)
				USettings["Group"] = USettings["Section"]:AddButton("🚩 Set Position [Group]", function() end)
				USettings["Spread"] = USettings["Section"]:AddButton("🚩 Get Positions [Spread]", function() end)
			end

			USettings["Target"] = USettings["Section"]:AddDropdown("🎯 Target Priority: ", function(value) end, {Options = AAData["Unit Setting"]["Target Priority"], Value = "First"})
			USettings["Place"] = USettings["Section"]:AddTextbox("Place from wave: ", function(value) end, {Placeholder = "Wave", Text = "1", Pattern = "[%d-]+"})
			USettings["Upgrade"] = USettings["Section"]:AddTextbox("Upgrade from wave: ", function(value) end, {Placeholder = "Wave", Text = "1", Pattern = "[%d-]+"})
			USettings["Sell"] = USettings["Section"]:AddTextbox("Auto Sell at wave: ", function(value) end, {Placeholder = "Wave", Text = "99", Pattern = "[%d-]+"})
			USettings["Total"] = USettings["Section"]:AddSlider("Total Units: ", function(value) end, {Value = "6", Min = "0", Max = "6"})
			USettings["Upgrade Cap"] = USettings["Section"]:AddSlider("Upgrade Cap: ", function(value) end, {Value = "0", Min = "0", Max = "15"})
		end

		-------------------------------------------

		if not InLobby() then
			getgenv().ModifyPosition = function(value)
				for UnitSlot = 1, 6 do
					local USettings = UnitSettings[UnitSlot]
					USettings["Single"].Button.Visible = value
					USettings["Group"].Button.Visible = value
					USettings["Spread"].Button.Visible = value
				end
			end

			getgenv().ModifyPosition(false)
		end
	end
	---------------------------

	----- [ Macro Config ] -----
	local PMacro;
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
	local PShopNItems;
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
	local PMisc;
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
		SOtherConfig:AddButton("Redeem All Codes", function()
			for _, code in pairs(AAData["Codes"]) do
				pcall(function() game:GetService("ReplicatedStorage").endpoints["client_to_server"]["redeem_code"]:InvokeServer(code)() end)
			end
			Window:Notify("Info", "Done Collecting Codes")
		end)
		SOtherConfig:AddButton("Return To Lobby", function() end)
		
		--- [ Reset ] ---
		
	end
	-------------------------
end

----- [ Setup ] -----
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
Window:Enabled(true)
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

if InLobby() then
	repeat task.wait(0.5) until Workspace:WaitForChild(game.Players.LocalPlayer.Name)
	CheckInternet()
elseif not InLobby() then
	repeat task.wait(0.5) until Workspace:WaitForChild("_terrain")
	CheckInternet()
end