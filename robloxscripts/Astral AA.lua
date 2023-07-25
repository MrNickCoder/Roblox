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
function Comma_Value(Text)
	local Value = Text;
	while true do
		local Str, Num = string.gsub(Value, "^(-?%d+)(%d%d%d)", "%1,%2");
		Value = Str
		if Num ~= 0 then else break end
	end
	return Value
end
----------------------------

----- [ Webhook ] -----
getgenv().item = "-"
Player.PlayerGui:FindFirstChild("HatchInfo"):FindFirstChild("holder"):FindFirstChild("info1"):FindFirstChild("UnitName").Text = getgenv().item
function Webhook()
	if Settings.WebhookEnabled then
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
		BattlePassValue = Player.PlayerGui:FindFirstChild("BattlePass"):FindFirstChild("Main"):FindFirstChild("Level"):FindFirstChild("V").Text
		BattlePass = game:GetService("Players").LocalPlayer.PlayerGui.BattlePass.Main.Level.Title.Text
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
							["value"] = "```ini\n"..tostring(game.Players.LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text)..  " ✨\nCurrent Gold : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.gold_amount.Value)).. " 💰\nCurrent Gems : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.gem_amount.Value)).. " 💎\nCurrent Trophies : "..tostring(Comma_Value(game.Players.LocalPlayer._stats.trophies.Value)).. " 🏆\nCurrent Portal : ".. tostring(Count_Portal_list) .." 🌀```",
						},
						{
							["name"] ="Results :",
							["value"] = " ```ini\nWorld : "..MapName.. " 🌏\nMap : "..World.. " 🗺️\nResults : "..Result.. " ⚔️\nWave End : " ..tostring(Waves[2]).." 🌊\nTime : " ..tostring(TTime[2]).." ⌛\nAll Kill Count : " ..tostring(Comma_Value(game.Players.LocalPlayer._stats.kills.Value)).. " ⚔️\nDMG Deal : " ..tostring(Comma_Value(game.Players.LocalPlayer._stats.damage_dealt.Value)).."⚔️```",
							["inline"] = true
						},
						{
							["name"] ="Rewards :",
							["value"] = "```ini\n" ..Comma_Value(Gold).." Gold 💰\n"..Comma_Value(Gems).." Gems 💎\n"..Comma_Value(Exp[1]).." XP 🧪\n"..Trophy.." Trophy 🏆```",
						},
						{
							["name"] ="Items Drop :",
							["value"] = "```ini\n" .. TextDropLabel .. "```",
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

local PMisc = Window:AddPage("Misc [BETA]", "🛠️")

local PDiscord = Window:AddPage("Discord", "🌐")

----- [ Auto Farm Config ] -----
local function AutoFarmConfigUI()
	if Settings and not Settings.FarmConfig then Settings.FarmConfig = {} end
	if Settings and not Settings.WorldConfig then Settings.WorldConfig = {} end
	
	SFarmConfig:AddLabel({Text = "🔱 Farm Category"})
	local FarmCategory = SFarmConfig:AddDropdown("Pick Category", function(value)
		Settings.FarmConfig.FarmCategory = value
		SaveSettings()
		
		getgenv().UpdateOptions(value)
		getgenv().UpdateWorldType(value)
	end, {Options = AAData["World Type"]["Types"], Value = Settings.FarmConfig.FarmCategory or AAData["World Type"]["Types"][1]})
	
	SFarmConfig:AddLabel()
	SFarmConfig:AddToggle("🌾 Auto Start", function(value) Settings.FarmConfig.AutoStart = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoStart or false})
	SFarmConfig:AddToggle("👨‍🌾 Auto Place Unit", function(value) Settings.FarmConfig.AutoPlace = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoPlace or false})
	SFarmConfig:AddToggle("⭐️ Auto Upgrade Units", function(value) Settings.FarmConfig.AutoUpgrade = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoUpgrade or false})
	SFarmConfig:AddToggle("🔥 Auto Abilities", function(value) Settings.FarmConfig.AutoAbilities = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoAbilities or false})
	SFarmConfig:AddCheckbox("🧙 Auto Buff 100%", function(value) Settings.FarmConfig.AutoBuff = value; SaveSettings() end, {Options = {"Orwin/Erwin", "Wenda/Wendy", "Leafy/Leafa"}, Selected = Settings.FarmConfig.AutoBuff or {}})
	
	SFarmConfig:AddLabel()
	local AutoReplay = SFarmConfig:AddToggle("🏃 Auto Replay", function(value) Settings.FarmConfig.AutoReplay = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoReplay or false})
	local AutoPortalReplay = SFarmConfig:AddToggle("🏃 Auto Pick Portal [Replay]", function(value) Settings.FarmConfig.AutoReplayPortal = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoReplayPortal or false})
	local AutoNextStory = SFarmConfig:AddToggle("🏃 Auto Next Story", function(value) Settings.FarmConfig.AutoNextStory = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoNextStory or false})
	local AutoNextLevel = SFarmConfig:AddToggle("🏃 Auto Next Level", function(value) Settings.FarmConfig.AutoNextLevel = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoNextLevel or false})
	
	SFarmConfig:AddLabel()
	SFarmConfig:AddToggle("🏃 Auto Leave", function(value) Settings.FarmConfig.AutoLeave = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoLeave or false})
	SFarmConfig:AddToggle("⭐️ Sell Units At Wave", function(value) Settings.FarmConfig.WaveSell = value; SaveSettings() end, {Active = Settings.FarmConfig.WaveSell or false})
	SFarmConfig:AddToggle("⭐️ Leave At Wave", function(value) Settings.FarmConfig.WaveLeave = value; SaveSettings() end, {Active = Settings.FarmConfig.WaveLeave or false})
	SFarmConfig:AddToggle("🏃 Auto Defeat", function(value) Settings.FarmConfig.AutoDefeat = value; SaveSettings() end, {Active = Settings.FarmConfig.AutoDefeat or false})
	
	SWorldConfig:AddLabel({Text = "🌏 Select World"})
	local WorldType = SWorldConfig:AddDropdown("Pick World", function(value)
		Settings.WorldConfig.WorldType = value
		SaveSettings()
		
		getgenv().UpdateWorldLevel(value)
	end)
	SWorldConfig:AddLabel()
	SWorldConfig:AddLabel({Text = "🎚️ Select Level"})
	local WorldLevel = SWorldConfig:AddDropdown("Pick Level", function(value)
		Settings.WorldConfig.WorldLevel = value
		SaveSettings()
	end)
	SWorldConfig:AddLabel()
	
	getgenv().UpdateOptions = function(value)
		AutoReplay.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Replay"]
		AutoPortalReplay.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Portal Replay"]
		AutoNextStory.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Next Story"]
		AutoNextLevel.Toggle.Visible = AAData["World Type"]["Type"][value]["UI"]["Auto Next Level"]
		
		FarmCategory.Section:Resize(true)
		--[[
		if value == "Story Worlds" then
			AutoReplay.Toggle.Visible = true
			AutoPortalReplay.Toggle.Visible = false
			AutoNextStory.Toggle.Visible = true
			AutoNextLevel.Toggle.Visible = false
		elseif value == "Legend Stages" or value == "Raid Worlds" then
			AutoReplay.Toggle.Visible = true
			AutoPortalReplay.Toggle.Visible = false
			AutoNextStory.Toggle.Visible = false
			AutoNextLevel.Toggle.Visible = false
		elseif value == "Portals" or value == "Secret Portals" then
			AutoReplay.Toggle.Visible = false
			AutoPortalReplay.Toggle.Visible = true
			AutoNextStory.Toggle.Visible = false
			AutoNextLevel.Toggle.Visible = false
		elseif value == "Dungeon" then
			AutoReplay.Toggle.Visible = false
			AutoPortalReplay.Toggle.Visible = false
			AutoNextStory.Toggle.Visible = false
			AutoNextLevel.Toggle.Visible = false
		elseif value == "Infinity Castle" then
			AutoReplay.Toggle.Visible = false
			AutoPortalReplay.Toggle.Visible = false
			AutoNextStory.Toggle.Visible = false
			AutoNextLevel.Toggle.Visible = true
		end
		--]]
	end
	getgenv().UpdateWorldType = function(value)
		WorldType:Reset()
		if not AAData["World Type"]["Type"][value]["Worlds"] then
			WorldType.Dropdown.Visible = false
			WorldLevel.Dropdown.Visible = false
		else
			WorldType.Dropdown.Visible = true
			WorldLevel.Dropdown.Visible = true

			WorldType.Data.Options = AAData["World Type"]["Type"][value]["Worlds"]
		end
		
		WorldType.Section:Resize(true)
		--[[
		if value == "Story Worlds" then
			WorldType.Data.Options = {"Planet Namak", "Shiganshinu District", "Snowy Town","Hidden Sand Village", "Marine's Ford",
				"Ghoul City", "Hollow World", "Ant Kingdom", "Magic Town", "Cursed Academy","Clover Kingdom","Cape Canaveral", "Alien Spaceship","Fabled Kingdom",
				"Hero City","Puppet Island","Virtual Dungeon","Windhym"}
		elseif value == "Legend Stages" then
			WorldType.Data.Options = {"Clover Kingdom (Elf Invasion)", "Hollow Invasion","Cape Canaveral (Legend)", "Fabled Kingdom (Legend)", "Hero City (Midnight)", "Virtual Dungeon (Bosses)"}
		elseif value == "Raid Worlds" then
			WorldType.Data.Options = {"Storm Hideout","West City", "Infinity Train", "Shiganshinu District - Raid","Hiddel Sand Village - Raid", "Freezo's Invasion", "Entertainment District", 
				"Hero City (Hero Slayer)", "Marine's Ford (Buddha)"}
		elseif value == "Portals" then
			WorldType.Data.Options = {"Alien Portals","Zeldris Portals","Demon Portals","Dressrosa Portals","Madoka Portals","The Eclipse"}
		elseif value == "Dungeon" then
			WorldType.Data.Options = {"Cursed Womb","Crused Parade","Anniversary Island"}
		elseif value == "Secret Portals" then
			WorldType.Data.Options = {"Dressrosa Secret Portals","Madoka Secret Portals","The Eclipse Secret"} 
		end
		--]]
	end
	getgenv().UpdateWorldLevel = function(value)
		WorldLevel:Reset()
		if not AAData["World Type"]["Type"][FarmCategory.Data.Value]["Worlds"] and AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"] then
			WorldLevel.Dropdown.Visible = false
		else
			WorldLevel.Dropdown.Visible = true
			
			WorldLevel.Data.Options = AAData["World Type"]["Type"][FarmCategory.Data.Value]["World"][value]["Levels"]
		end
		
		WorldLevel.Section:Resize(true)
		--[[
		if FarmCategory.Data.Value == "Story Worlds" then
			if value == "Planet Namak" then
				WorldLevel.Data.Options = {"namek_infinite", "namek_level_1", "namek_level_2", "namek_level_3", "namek_level_4", "namek_level_5", "namek_level_6"}
			elseif value == "Shiganshinu District" then
				WorldLevel.Data.Options = {"aot_infinite", "aot_level_1", "aot_level_2", "aot_level_3", "aot_level_4","aot_level_5", "aot_level_6"}
			elseif value == "Snowy Town" then
				WorldLevel.Data.Options = {"demonslayer_infinite", "demonslayer_level_1", "demonslayer_level_2", "demonslayer_level_3", "demonslayer_level_4", "demonslayer_level_5","demonslayer_level_6"}
			elseif value == "Hidden Sand Village" then
				WorldLevel.Data.Options =  {"naruto_infinite", "naruto_level_1", "naruto_level_2", "naruto_level_3","naruto_level_4", "naruto_level_5", "naruto_level_6"}
			elseif value == "Marine's Ford" then
				WorldLevel.Data.Options = {"marineford_infinite","marineford_level_1","marineford_level_2","marineford_level_3","marineford_level_4","marineford_level_5","marineford_level_6"}
			elseif value == "Ghoul City" then
				WorldLevel.Data.Options = {"tokyoghoul_infinite","tokyoghoul_level_1","tokyoghoul_level_2","tokyoghoul_level_3","tokyoghoul_level_4","tokyoghoul_level_5","tokyoghoul_level_6"}
			elseif value == "Hollow World" then
				WorldLevel.Data.Options = {"hueco_infinite","hueco_level_1","hueco_level_2","hueco_level_3","hueco_level_4","hueco_level_5","hueco_level_6"}
			elseif value == "Ant Kingdom" then
				WorldLevel.Data.Options = {"hxhant_infinite","hxhant_level_1","hxhant_level_2","hxhant_level_3","hxhant_level_4","hxhant_level_5","hxhant_level_6"}
			elseif value == "Magic Town" then
				WorldLevel.Data.Options =  {"magnolia_infinite","magnolia_level_1","magnolia_level_2","magnolia_level_3","magnolia_level_4","magnolia_level_5","magnolia_level_6"}
			elseif value == "Cursed Academy" then
				WorldLevel.Data.Options = {"jjk_infinite","jjk_level_1","jjk_level_2","jjk_level_3", "jjk_level_4","jjk_level_5","jjk_level_6"}
			elseif value == "Clover Kingdom" then
				WorldLevel.Data.Options = {"clover_infinite","clover_level_1","clover_level_2","clover_level_3","clover_level_4","clover_level_5","clover_level_6"}
			elseif value == "Cape Canaveral" then
				WorldLevel.Data.Options = {"jojo_infinite","jojo_level_1","jojo_level_2","jojo_level_3","jojo_level_4","jojo_level_5","jojo_level_6",}
			elseif value == "Alien Spaceship" then
				WorldLevel.Data.Options = {"opm_infinite","opm_level_1","opm_level_2","opm_level_3","opm_level_4","opm_level_5","opm_level_6",}
			elseif value == "Fabled Kingdom" then
				WorldLevel.Data.Options = {"7ds_infinite","7ds_level_1","7ds_level_2","7ds_level_3","7ds_level_4","7ds_level_5","7ds_level_6",}
			elseif value == "Hero City" then
				WorldLevel.Data.Options = {"mha_infinite","mha_level_1","mha_level_2","mha_level_3","mha_level_4","mha_level_5","mha_level_6",}
			elseif value == "Puppet Island" then
				WorldLevel.Data.Options = {"dressrosa_infinite","dressrosa_level_1","dressrosa_level_2","dressrosa_level_3","dressrosa_level_4","dressrosa_level_5","dressrosa_level_6",}
			elseif value == "Virtual Dungeon" then
				WorldLevel.Data.Options = {"sao_infinite","sao_level_1","sao_level_2","sao_level_3","sao_level_4","sao_level_5","sao_level_6",}
			elseif value == "Windhym" then
				WorldLevel.Data.Options = {"berserk_infinite","berserk_level_1","berserk_level_2","berserk_level_3","berserk_level_4","berserk_level_5","berserk_level_6",}	
			end
		end
		--]]
	end
	
	getgenv().UpdateOptions(FarmCategory.Data.Value)
	getgenv().UpdateWorldType(FarmCategory.Data.Value)
	getgenv().UpdateWorldLevel(WorldType.Data.Value)
end
-------------------------

----- [ World Config ] -----
local function WorldConfigUI()

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
else
	HomeUI()
	AutoFarmConfigUI()
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