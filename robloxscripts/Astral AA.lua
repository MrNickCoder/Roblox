----- [ UPDATE FIX ] -----
local Version = "v1.0.0b01"

----- [ LOADING SECTION ] -----
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

-------------------------------
----- [ SETTINGS ] -----
local Folder = "Astral_V1_Anime_Adventures" --
local File = game:GetService("Players").LocalPlayer.Name .. "_AnimeAdventures.json"

Settings = {} --
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

if game.PlaceId ~= 8304191830 then GetLevelData() end --]]
-----------------------------------------------------------------

----- [ SERVICES ] -----
local HttpService		= game:GetService("HttpService")
local Workspace			= game:GetService("Workspace")
local Players			= game:GetService("Players")
local RunService		= game:GetService("RunService")
local UserInputService	= game:GetService("UserInputService")

----- [ INITIALIZE ] -----
local Player			= Players.LocalPlayer
local Mouse				= Player:GetMouse()

----- [ ITEM DROP RESULTS ] -----
local ItemLoader = require(game.ReplicatedStorage.src.Loader)
local ItemInventoryService = DropLoader.load_client_service(script, "ItemInventoryServiceClient")
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

----- [ USER INTERFACE ] -----
if game.CoreGui:FindFirstChild("HoloLibUI") then game.CoreGui["HoloLibUI"]:Destroy() end

local Directory = "Anime_Adventures/"..game.Players.LocalPlayer.Name
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/main/robloxui/HoloLib.lua"))()
local Executor = tostring(identifyexecutor())
local Window = UILibrary("[Astral V1] Anime Adventures"..Version.." - "..Executor)

local HomePage = Window:AddPage("Home", "🏠")
local Developers = HomePage:AddSection("Anime Adventures")
local ChallengeHelp = HomePage:AddSection("⚙️ Challenge Config ⚙️")

local FarmPage = Window:AddPage("Auto Farm", "🤖")

local UnitPage = Window:AddPage("Unit Config", "🧙")

local PortalPage = Window:AddPage("Portal Config", "🌀")

local MiscPage = Window:AddPage("Misc [BETA]", "🛠️")

local DiscordPage = Window:AddPage("Discord", "🌐")