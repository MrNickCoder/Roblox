if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local HttpService = game:GetService("HttpService");

local LocalPlayer = Players.LocalPlayer;

local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/Games.lua"))();

local PlaceID = game.PlaceId;
local UniverseID = HttpService:JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. PlaceID .."/universe")).universeId;

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Welcome "..LocalPlayer.DisplayName.."!"; });
if Games["UniverseIDs"][UniverseID] then
	loadstring(game:HttpGet(Games["UniverseIDs"][UniverseID]))();
elseif Games["PlaceIDs"][PlaceID] then
	loadstring(game:HttpGet(Games["PlaceIDs"][PlaceID]))();
end