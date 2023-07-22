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

Settings = {}
function SaveSettings()
	local HttpService = game:GetService("HttpService")
	if not isfolder(Folder) then makefolder(Folder) end
	
	writefile(Folder .. "/" .. File, HttpService.JSONEncode(Settings))
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

-- Start of Get Level Data of Map [Added by HOLYSHz]
function GetLevelData()
	local List = {}
	for Index, Value in pairs(game.Workspace._MAP_CONFIG:WaitForChild("GetLevelData"):InvokeServer()) do List[Index] = Value end
	
	return List
end

if game.PlaceId ~= 8304191830 then GetLevelData() end
-- End of Get Level Data of Map
------------------------

----- [ SERVICES ] -----
local HttpService		= game:GetService("HttpService")
local Workspace			= game:GetService("Workspace")
local Players			= game:GetService("Players")
local RunService		= game:GetService("RunService")
local UserInputService	= game:GetService("UserInputService")

----- [ INITIALIZE ] -----
local Player			= Players.LocalPlayer
local Mouse				= Player:GetMouse()