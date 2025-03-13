if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 2239430935 then return; end

--------------------
-- [[ SERVICES ]] --
--------------------
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local Lighting = game:GetService("Lighting");
local RStorage = game:GetService("ReplicatedStorage");
local UserIS = game:GetService("UserInputService");
local RService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");

local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
local Mouse = LocalPlayer:GetMouse();

if game.PlaceId == 6137321701 then StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "No Loading in Lobby!"; }); return; end

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Blair Script!"; });
local Success, Result = pcall(function()
	print("Loading Blair Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("HumanoidRootPart");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Map");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Map"):FindFirstChild("Van");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Map"):FindFirstChild("Doors");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Map"):FindFirstChild("Items");
	repeat task.wait(.1) until PlayerGui:FindFirstChild("Journal");
	repeat task.wait(.1) until RStorage:FindFirstChild("ActiveChallenges");
	task.wait(5);

	local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()
	
	------------------
	-- [[ CONFIG ]] --
	------------------
	local Config = {
		["CustomLight"] = false;
		["CustomLightRange"] = "60";
		["CustomLightBrightness"] = "10";
		
		["CustomSprint"] = false;
		["CustomSprintSpeed"] = "13";
		
		["Fullbright"] = false;
		["FullbrightAmbient"] = "255";
		
		["NoClipDoor"] = false;
		
		["ESP"] = false;
		
		["Freecam"] = false;
		
		["SideStatus"] = false;
		["SideStatusScale"] = "1";
	}
	local Directory = "Paradoxium/Blair"
	local File_Name = "Settings.json"
	Config = Utility:LoadConfig(Config, Directory, File_Name);

	if PlayerGui.Journal.Background:FindFirstChild("Settings") then PlayerGui.Journal.Background:FindFirstChild("Settings"):Destroy() end;
	if PlayerGui:FindFirstChild("Statusifier") then PlayerGui:FindFirstChild("Statusifier"):Destroy() end;

	---------------------
	-- [[ UTILITIES ]] --
	---------------------
	do
		function CreateSettings(Name, Options, Callback)
			local Enabled = Options and Options.Default or false;
			if Options and Config[Options.Config] then Enabled = Config[Options.Config] end
			local Keybind = Options and Options.Keybind or nil;
			local On = Callback and Callback.On or function() end;
			local Off = Callback and Callback.Off or function() end;
			
			local Settings;
			if PlayerGui.Journal.Background:FindFirstChild("Settings") then
				Settings = PlayerGui.Journal.Background:FindFirstChild("Settings");
			else
				Settings = Utility:Instance("Frame", {
					Name = "Settings";
					Parent = PlayerGui.Journal.Background;
					AnchorPoint = Vector2.new(0, 1);
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0.04, 0);
					Utility:Instance("UIListLayout", {
						Padding = UDim.new(0, 10);
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalAlignment = Enum.HorizontalAlignment.Center;
						VerticalAlignment = Enum.VerticalAlignment.Center;
					});
				});
			end

			local Data = {Enabled = Enabled}
			Data.Button = Utility:Instance("TextButton", {
				Name = Name;
				Parent = Settings;
				BackgroundColor3 = Color3.fromRGB(0,0);
				BackgroundTransparency = 0.25;
				Size = UDim2.new(0.10, 0, 1, 0);
				Text = "";
				Utility:Instance("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundTransparency = 1;
					Position = UDim2.new(0.5, 0, 0.5, 0);
					Size = UDim2.new(0.9, 0, 0.7, 0);
					Font = Enum.Font.FredokaOne;
					Text = Name;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
				});
				Utility:Instance("Frame", {
					BackgroundColor3 = Data.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);
					Position = UDim2.new(0, 0, 1, 0);
					Size = UDim2.new(1, 0, 0, 2);
				});
			});
			Data.Toggle = Data.Button["Frame"];
			
			function Data:AddTextbox(Properties, Options)
				Properties.Text = Options and Config[Options.Config] or Properties.Text or "";
				local Display = Options and Options.Display or "";
				local Type = Options and Options.Type or "Text";
				local Negative = Options and Options.Negative or false;
				local Control = Utility:Instance("TextBox", {
					Parent = Data.Button;
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.25;
					Position = UDim2.new(0.5, 0, 0, -2);
					Size = UDim2.new(0.8, 0, 0.8, 0);
					Font = Enum.Font.SourceSansBold;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 5); });
					Utility:Instance("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5, 0, -0.1, 0);
						Size = UDim2.new(0.9, 0, 0.6, 0);
						Font = Enum.Font.FredokaOne;
						Text = Display;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						TextStrokeTransparency = 0;
						TextXAlignment = Enum.TextXAlignment.Left;
					});
				});
				for Index, Value in pairs(Properties or {}) do
					Control[Index] = Value;
					if Index == "Text" and Options.Config then
						Config[Options.Config] = Value;
						Utility:SaveConfig(Config, Directory, File_Name);
					end
				end;
				
				if Type == "Integer" then Control:GetPropertyChangedSignal("Text"):Connect(function() Control.Text = string.match(Control.Text, (Negative and "[-]?" or "").."%d*"); end) end
				if Type == "Number" then Control:GetPropertyChangedSignal("Text"):Connect(function() Control.Text = string.match(Control.Text, (Negative and "[-]?" or "").."%d*[%.]?%d*"); end) end
				
				Control.FocusLost:Connect(function()
					if Options.Config then
						Config[Options.Config] = Control.Text;
						Utility:SaveConfig(Config, Directory, File_Name);
					end
				end)
				
				return Control
			end;
			
			Data.Set = function(Value)
				Data.Enabled = Value;
				if Data.Enabled then pcall(function() On(); Data.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0); end)
				else pcall(function() Off(); Data.Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0); end) end
				if Options.Config then
					Config[Options.Config] = Data.Enabled;
					Utility:SaveConfig(Config, Directory, File_Name);
				end
			end

			Data.Set(Data.Enabled);
			Data.Button.MouseButton1Down:Connect(function() Data.Set(not Data.Enabled); end)
			if Keybind ~= nil then
				Data.Button["TextLabel"].Text = Name .." [".. Keybind.Name .."]";
				UserIS.InputBegan:Connect(function(input, gameProcessed)
					if gameProcessed then return; end
					if input.KeyCode == Keybind then Data.Set(not Data.Enabled);end
				end)
			end

			return Data;
		end
		function CreateInfo(Name, Options)
			local SideInfo;
			if PlayerGui:FindFirstChild("Statusifier") then
				SideInfo = PlayerGui:FindFirstChild("Statusifier");
			else
				SideInfo = Utility:Instance("ScreenGui", {
					Name = "Statusifier";
					Parent = PlayerGui;
					ResetOnSpawn = false;
					Enabled = Config["SideStatus"];
					Utility:Instance("Frame", {
						Name = "Container";
						BackgroundTransparency = 1;
						Position = UDim2.new(0, 0, 0.55, 0);
						Size = UDim2.new(0, 150, 0, 0);
						Utility:Instance("UIListLayout", { Padding = UDim.new(0, 5); });
						Utility:Instance("UIScale", { Scale = 1; });
					});
				});
			end

			local Data = {}
			Data.Frame = Utility:Instance("Frame", {
				Name = Name;
				Parent = SideInfo["Container"];
				AutomaticSize = Enum.AutomaticSize.Y;
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 0.5;
				Size = UDim2.new(1, 0, 0, 0);
				Utility:Instance("TextLabel", {
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0, 15);
					Font = Enum.Font.SourceSansBold;
					Text = "[ "..Name.." ]";
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
				});
				Utility:Instance("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundTransparency = 1;
					Position = UDim2.new(0, 0, 0, 15);
					Size = UDim2.new(1, 0, 0, 0);
					Utility:Instance("UIListLayout", { Padding = UDim.new(0, 0); });
				});
			});
			Data.List = Data.Frame["Frame"];
			Data.AddInfo = function(Text)
				return Utility:Instance("TextLabel", {
					Parent = Data.List;
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0, 15);
					Font = Enum.Font.SourceSans;
					Text = Text;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
				});
			end;

			return Data;
		end
		function CreateESP(Text, Properties)
			local Data = {}
			if (Properties.ParentHighlight and Properties.ParentHighlight:FindFirstChild("ESP_Highlight")) then
				Data.Highlight = Properties.ParentHighlight:FindFirstChild("ESP_Highlight");
				Data.Highlight.Enabled = Properties.Enabled;
			elseif(Properties.Parent and Properties.Parent:FindFirstChild("ESP_Highlight")) then
				Data.Highlight = Properties.Parent:FindFirstChild("ESP_Highlight");
				Data.Highlight.Enabled = Properties.Enabled;
			else
				Data.Highlight = Utility:Instance("Highlight", {
					Name = "ESP_Highlight";
					Parent = Properties.ParentHighlight or Properties.Parent;
					Enabled = Properties.Enabled;
					FillColor = Properties.Color or Color3.fromRGB(255, 255, 255);
					FillTransparency = 0.75;
				});
			end
			if (Properties.ParentUI and Properties.ParentUI:FindFirstChild("ESP")) then
				Data.UI = Properties.ParentUI:FindFirstChild("ESP");
				Data.UI.Enabled = Properties.Enabled;
				Data.Distance = Data.UI["Distance"];
			elseif (Properties.Parent and Properties.Parent:FindFirstChild("ESP")) then
				Data.UI = Properties.Parent:FindFirstChild("ESP");
				Data.UI.Enabled = Properties.Enabled;
				Data.Distance = Data.UI["Distance"];
			else
				Data.UI = Utility:Instance("BillboardGui", {
					Name = "ESP";
					Parent = Properties.ParentUI or Properties.Parent;
					AlwaysOnTop = true;
					Enabled = Properties.Enabled;
					Size = UDim2.new(5, 0, 2, 0);
					StudsOffset = Vector3.new(0, 2, 0);
					Utility:Instance("TextLabel", {
						BackgroundTransparency = 1;
						Size = UDim2.new(1, 0, 0.5, 0);
						Font = Enum.Font.FredokaOne;
						Text = Text;
						TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
						TextScaled = true;
					});
				});
				Data.Distance = Utility:Instance("TextLabel", {
					Name = "Distance";
					Parent = Data.UI;
					BackgroundTransparency = 1;
					Position = UDim2.new(0, 0, 0.5, 0);
					Size = UDim2.new(1, 0, 0.5, 0);
					Font = Enum.Font.FredokaOne;
					Text = "0m";
					TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
					TextScaled = true;
				});
			end
			
			task.spawn(function()
				while task.wait() do
					if not Data.UI.Parent then break; end
					pcall(function() Data.Distance.Text = (math.floor((Data.UI.Parent.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude * 100) / 100) .."m"; end)
				end
			end)
			
			function Data:Enable() pcall(function() Data.Highlight.Enabled = true; Data.UI.Enabled = true; end); end
			function Data:Disable() pcall(function() Data.Highlight.Enabled = false; Data.UI.Enabled = false; end); end

			return Data
		end
	end

	----------------------
	-- [[ INITIALIZE ]] --
	----------------------
	local FreecamModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/FreecamModule.lua"))()
	FreecamModule.IgnoreGUI = {"Radio", "Journal", "MobileUI", "Statusifier"}
	local Light;
	if LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("SpotLight") then
		Light = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("SpotLight")
	else
		Light = Utility:Instance("SpotLight", {
			Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
			Brightness = 10;
			Range = 60;
			Face = Enum.NormalId.Front;
			Angle = 120;
			Shadows = false;
		});
	end
	local Sprinting = false
	local Doors = {}
	function PopulateDoors(Model)
		for _, v in pairs(Model:GetChildren()) do
			if not table.find({"Part", "MeshPart", "Model"}, v.ClassName) then continue; end
			if #v:GetChildren() > 0 then PopulateDoors(v); end
			if (v.ClassName == "Part" or v.ClassName == "MeshPart") and v.CanCollide then table.insert(Doors, v); end
		end
	end
	PopulateDoors(game.Workspace["Map"]["Doors"]);
	local SavedLighting = {}
	for _, value in pairs({"Ambient", "OutdoorAmbient", "Brightness"}) do SavedLighting[value] = Lighting[value]; end
	local AtmosphereDensity = Lighting["Atmosphere"].Density
	local LowestTemp = nil;
	local CryingCount = 0;

	--------------------------
	-- [[ USER INTERFACE ]] --
	--------------------------
	local CustomLights = CreateSettings("Custom Lights", { Config = "CustomLight"; Keybind = Enum.KeyCode.R; }, {
		On = function() Light.Enabled = true end;
		Off = function() Light.Enabled = false end;
	});
	local CustomLightsRange = CustomLights:AddTextbox({
		Position = UDim2.new(0.25, 0, 0, -2);
		Size = UDim2.new(0.4, 0, 0.8, 0);
		Text = "60";
	}, { Config = "CustomLightRange"; Display = "Range"; Type = "Integer"; });
	local CustomLightBrightness = CustomLights:AddTextbox({
		Position = UDim2.new(0.75, 0, 0, -2);
		Size = UDim2.new(0.4, 0, 0.8, 0);
		Text = "10";
	}, { Config = "CustomLightBrightness"; Display = "Brightness"; Type = "Integer"; });

	local CustomSprint = CreateSettings("Custom Sprint", { Config = "CustomSprint"; });
	local CustomSprintSpeed = CustomSprint:AddTextbox({ Text = "13"; }, { Config = "CustomSprintSpeed"; Display = "Speed"; Type = "Number"; });

	local FullbrightAmbient;
	local Fullbright = CreateSettings("Fullbright", { Config = "Fullbright"; Keybind = Enum.KeyCode.T; }, {
		On = function()
			if FullbrightAmbient and FullbrightAmbient.Text ~= "" then Lighting.Ambient = Color3.fromRGB(tonumber(FullbrightAmbient.Text), tonumber(FullbrightAmbient.Text), tonumber(FullbrightAmbient.Text));
			elseif Config["FullbrightAmbient"] then Lighting.Ambient = Color3.fromRGB(tonumber(Config["FullbrightAmbient"]), tonumber(Config["FullbrightAmbient"]), tonumber(Config["FullbrightAmbient"]));
			else Lighting.Ambient = Color3.fromRGB(138, 138, 138); end
			Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128);
			Lighting.Brightness = 2;
			Lighting["Atmosphere"].Density = 0
		end;
		Off = function()
			for index, value in pairs(SavedLighting) do Lighting[index] = value; end;
			Lighting["Atmosphere"].Density = AtmosphereDensity
		end;
	});
	FullbrightAmbient = Fullbright:AddTextbox({ Text = "138"; }, { Config = "FullbrightAmbient"; Display = "Ambient"; Type = "Integer"; });

	local NoClipDoor = CreateSettings("No Clip Door", { Config = "NoClipDoor"; Keybind = Enum.KeyCode.X; }, {
		On = function()
			for _, v in pairs(Doors) do v.CanCollide = false end
			game.Workspace["Map"]["Van"]["Van"]["Door"]["Lines"]["Part"].CanCollide = false;
			game.Workspace["Map"]["Van"]["Van"]["Door"]["Main"].CanCollide = false;
		end;
		Off = function()
			for _, v in pairs(Doors) do v.CanCollide = true end
			game.Workspace["Map"]["Van"]["Van"]["Door"]["Lines"]["Part"].CanCollide = true;
			game.Workspace["Map"]["Van"]["Van"]["Door"]["Main"].CanCollide = true;
		end;
	});

	local BooBooESP = nil;
	if game.Workspace:FindFirstChild("BooBooDoll") then BooBooESP = CreateESP("[BooBoo]", { Parent = game.Workspace:WaitForChild("BooBooDoll"); Color = Color3.fromRGB(0, 255, 0); }); end
	local GeneratorESP = CreateESP("[Generator]", { Parent = game.Workspace["Map"]["Generators"]:GetChildren()[1]; Color = Color3.fromRGB(255, 16, 240); });
	local GhostESP = nil;
	if game.Workspace:FindFirstChild("Ghost") then
		pcall(function() GhostESP = CreateESP("[Ghost]", { ParentUI = instance:FindFirstChild("Head"); ParentHighlight = instance; Color = Color3.fromRGB(255, 0, 0); }); end)
	end
	
	local ESP = CreateSettings("ESP", { Config = "ESP"; }, {
		On = function()
			if BooBooESP then BooBooESP:Enable(); end
			if GeneratorESP then GeneratorESP:Enable(); end
			if GhostESP then GhostESP:Enable(); end
		end;
		Off = function()
			if BooBooESP then BooBooESP:Disable(); end
			if GeneratorESP then GeneratorESP:Disable(); end
			if GhostESP then GhostESP:Disable(); end
		end;
	});
	game.Workspace.ChildAdded:Connect(function(instance)
		if instance.Name ~= "Ghost" then return; end
		GhostESP = CreateESP("[Ghost]", { ParentUI = instance:WaitForChild("Head"); ParentHighlight = instance; Color = Color3.fromRGB(255, 0, 0); Enabled = ESP.Enabled; });
	end)
	
	local Freecam = CreateSettings("Freecam", { Config = "Freecam"; }, {
		On = function() end;
		Off = function() end;
	});

	local SideStatus = CreateSettings("Side Status", { Config = "SideStatus"; }, {
		On = function() PlayerGui["Statusifier"].Enabled = true; end;
		Off = function() PlayerGui["Statusifier"].Enabled = false; end;
	});
	local SideStatusScale = SideStatus:AddTextbox({ Text = "1"; }, { Config = "SideStatusScale"; Display = "Scale"; Type = "Number"; });

	---------------------------
	-- [[[ CURSED OBJECT ]]] --
	---------------------------
	local Objects = CreateInfo("Cursed Object");
	task.spawn(function()
		pcall(function()
			if game.Workspace:WaitForChild("SummoningCircle", 5) then Objects.AddInfo("Summoning Circle"); end
			if game.Workspace:WaitForChild("Spirit Board", 5) then Objects.AddInfo("Spirit Board"); end
			if game.Workspace["Map"]["Items"]:WaitForChild("Tarot Cards", 5) then Objects.AddInfo("Tarot Cards"); end
			for _, Player in pairs(Players:GetChildren()) do
				if Player.Backpack:FindFirstChild("Tarot Cards") then Objects.AddInfo("Tarot Cards"); break; end
				if Player.Character and Player.Character:FindFirstChild("Tarot Cards") then Objects.AddInfo("Tarot Cards"); break; end
			end
			if game.Workspace["Map"]["Items"]:WaitForChild("Music Box", 5) then Objects.AddInfo("Music Box"); end
			for _, Player in pairs(Players:GetChildren()) do
				if Player.Backpack:FindFirstChild("Music Box") then Objects.AddInfo("Music Box"); break; end
				if Player.Character and Player.Character:FindFirstChild("Music Box") then Objects.AddInfo("Music Box"); break; end
			end
		end)
	end)

	------------------
	-- [[[ ROOM ]]] --
	------------------
	local Room = CreateInfo("Possible Room");
	local RoomName = Room.AddInfo("Room Name");
	local RoomTemp = Room.AddInfo("Room Temp");
	local RoomWater = Room.AddInfo("Water Running");
	local RoomSalt = Room.AddInfo("Salt Stepped"); RoomSalt.Visible = false;
	local RoomCrying = Room.AddInfo("Ghost Crying"); RoomCrying.Visible = false;
	local RoomThread = Utility:Thread("Room", function()
		while task.wait() do
			local LowestTempRoom = nil;
			for _, v in pairs(game.Workspace["Map"]["Zones"]:GetChildren()) do
				if v.ClassName ~= "Part" and v.ClassName ~= "UnionOperation" then continue; end
				if v:FindFirstChild("Exclude") then continue; end
				if LowestTempRoom == nil then LowestTempRoom = v; continue; end
				if not v:FindFirstChild("_____Temperature") then continue; end
				if v:FindFirstChild("_____Temperature")["_____LocalBaseTemp"].Value > LowestTempRoom:FindFirstChild("_____Temperature")["_____LocalBaseTemp"].Value then continue; end
				LowestTempRoom = v;
			end
			if LowestTempRoom and LowestTempRoom:FindFirstChild("_____Temperature") then
				RoomName.Text = LowestTempRoom.Name;
				RoomTemp.Text = (math.floor(LowestTempRoom:FindFirstChild("_____Temperature").Value * 1000) / 1000)
				LowestTemp = LowestTempRoom
			end
			local FoundWater = false;
			for _, waters in pairs(game.Workspace["Map"]["Water"]:GetChildren()) do
				if #waters:GetChildren() > 0 and waters:FindFirstChild("WaterRunning") then FoundWater = true; break; end
			end
			if FoundWater then RoomWater.Visible = true; else RoomWater.Visible = false; end
			if not RoomSalt.Visible then
				for _, salt in pairs(game.Workspace["Map"]["Misc"]:GetChildren()) do
					if salt.Name == "SaltStepped" then RoomSalt.Visible = true; end
				end
			end
			if CryingCount > 0 then RoomCrying.Visible = true; RoomCrying.Text = "Ghost Crying: "..tostring(CryingCount); end
		end
	end):Start()

	game.Workspace["Map"].DescendantAdded:Connect(function(instance)
		if instance.ClassName ~= "Sound" then return; end
		if instance.Name == "GhostCrying" then CryingCount = CryingCount + 1; end
	end)

	-------------------
	-- [[[ GHOST ]]] --
	-------------------
	local Ghost = CreateInfo("Ghost Status");
	local GhostActivity = Ghost.AddInfo("Activity");
	local GhostLocation = Ghost.AddInfo("Location");
	local GhostSpeed = Ghost.AddInfo("WalkSpeed");
	local GhostBlink = Ghost.AddInfo("Blink");
	local GhostDuration = Ghost.AddInfo("Duration");
	local GhostDisruption = Ghost.AddInfo("Disrupting");
	local GhostBanshee = Ghost.AddInfo("Banshee Scream"); GhostBanshee.Visible = false;
	local GhostFaejkur = Ghost.AddInfo("Faejkur Laugh"); GhostFaejkur.Visible = false;
	local GhostYama = Ghost.AddInfo("Yama Roar"); GhostYama.Visible = false;
	function FindParabolic(Object)
		for _, parabolic in pairs(Object:GetChildren()) do
			if parabolic.Name ~= "Parabolic Microphone" then continue; end
			if parabolic:FindFirstChild("Handle") then
				if parabolic.Handle:FindFirstChild("BansheeScream") and parabolic.Handle:FindFirstChild("BansheeScream").Playing then GhostBanshee.Visible = true; end
				if parabolic.Handle:FindFirstChild("FaeLaugh") and parabolic.Handle:FindFirstChild("FaeLaugh").Playing then GhostFaejkur.Visible = true; end
			end
		end
	end
	local GhostThread = Utility:Thread("Ghost", function()
		while task.wait() do
			GhostActivity.Text = "Activity: ".. RStorage["Activity"].Value;
			if RStorage["Disruption"].Value then GhostDisruption.Visible = true; else GhostDisruption.Visible = false; end
			if game.Workspace:FindFirstChild("Ghost") then
				for _, v in pairs({GhostLocation, GhostSpeed, GhostDuration, GhostBlink}) do v.Visible = true; end

				pcall(function()
					if game.Workspace:WaitForChild("Ghost") then
						GhostLocation.Text = game.Workspace:WaitForChild("Ghost", 5):WaitForChild("Zone", 5).Value.Name or "";
						GhostSpeed.Text = "Walk Speed: ".. (math.floor(game.Workspace:WaitForChild("Ghost", 5).Humanoid.WalkSpeed * 1000) / 1000);
						GhostDuration.Text = "Duration: ".. RStorage["HuntDuration"].Value;
					end
				end)
			else
				for _, v in pairs({GhostLocation, GhostSpeed, GhostDuration, GhostBlink}) do v.Visible = false; end
			end
			if not GhostBanshee.Visible or not GhostFaejkur.Visible then
				for _, Player in pairs(Players:GetChildren()) do
					if Player.Character then FindParabolic(Player.Character); end
				end
				FindParabolic(game.Workspace["Map"]["Items"]);
			end
		end
	end):Start()

	local blinkConnection;
	game.Workspace.ChildAdded:Connect(function(instance)
		if instance.Name ~= "Ghost" then return; end
		local saveStamp = tick();
		pcall(function()
			blinkConnection = instance:WaitForChild("Head"):GetPropertyChangedSignal("Transparency"):Connect(function()
				GhostBlink.Text = "Blink: ".. (math.floor((tick() - saveStamp) * 1000) / 1000) .."s"
				saveStamp = tick();
			end);
		end);
	end);
	game.Workspace.ChildRemoved:Connect(function(instance)
		if instance.Name ~= "Ghost" then return; end
		pcall(function() blinkConnection:Disconnect(); end);
	end);

	----------------------
	-- [[[ EVIDENCE ]]] --
	----------------------
	if RStorage:FindFirstChild("ActiveChallenges") then
		if not (RStorage["ActiveChallenges"]:FindFirstChild("evidencelessOne") and RStorage["ActiveChallenges"]:FindFirstChild("evidencelessTwo")) then
			local Evidence = CreateInfo("Evidences");
			local Evidences = {}
			for _, evi in pairs({"EMF Level 5","Ultraviolet","Freezing Temp.","Ghost Orbs","Ghost Writing","Spirit Box","SLS Camera"}) do
				Evidences[evi] = Evidence.AddInfo(evi);
				Evidences[evi].Visible = false;
			end
			
			function FindSpiritBox(Object)
				for _, sb in pairs(Object:GetChildren()) do
					if sb.Name ~= "Spirit Box" then continue; end
					for _, talk in pairs(sb:FindFirstChild("GhostTalk"):GetChildren()) do
						if talk.Playing then Evidences["Spirit Box"].Visible = true; end
					end
				end
			end
			
			local EvidenceThread = Utility:Thread("Evidence", function()
				while task.wait() do
					if not Evidences["EMF Level 5"].Visible then
						
					end
					if not Evidences["Ultraviolet"].Visible and #game.Workspace["Map"]["Prints"]:GetChildren() > 0 then Evidences["Ultraviolet"].Visible = true; end
					if not Evidences["Freezing Temp."].Visible then
						if LowestTemp["_____Temperature"].Value < 0.1 then Evidences["Freezing Temp."].Visible = true; end
					end
					if not Evidences["Ghost Orbs"].Visible and #game.Workspace["Map"]["Orbs"]:GetChildren() > 0 then Evidences["Ghost Orbs"].Visible = true; end
					if not Evidences["Ghost Writing"].Visible then
						for _, item in pairs(game.Workspace["Map"]["Items"]:GetChildren()) do
							if item.Name ~= "Ghost Writing Book" then continue; end
							if item:FindFirstChild("Written").Value then Evidences["Ghost Writing"].Visible = true; break; end
						end
					end
					if not Evidences["Spirit Box"].Visible then
						for _, Player in pairs(Players:GetChildren()) do
							if Player.Character then FindSpiritBox(Player.Character); end
						end
						FindSpiritBox(game.Workspace["Map"]["Items"]);
					end
				end
			end):Start()
		end
	end

	--------------------
	-- [[[ PLAYER ]]] --
	--------------------
	if RStorage:FindFirstChild("ActiveChallenges") then
		if not RStorage["ActiveChallenges"]:FindFirstChild("noSanity") then
			local PlayerStats = CreateInfo("Player Status");
			local PlayerSanity = PlayerStats.AddInfo("Sanity");
			local PlayerThread = Utility:Thread("Player", function()
				while task.wait() do
					PlayerSanity.Text = "Sanity: ".. (math.floor(LocalPlayer.Sanity.Value * 100) / 100);
				end
			end):Start()
		end
	end

	------------------
	-- [[ EVENTS ]] --
	------------------
	local timeBetween = { ["UI"] = 0; ["Freecam"] = 0; }
	local heldDown = { ["UI"] = false; ["Freecam"] = false; }
	local UpdaterThread = Utility:Thread("Updater", function()
		while task.wait() do
			Light.Brightness = tonumber(CustomLightBrightness.Text) or 0;
			Light.Range = tonumber(CustomLightsRange.Text) or 0;

			if CustomSprint.Enabled and Sprinting then LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = tonumber(CustomSprintSpeed.Text) or 13; end
			if PlayerGui:FindFirstChild("Statusifier") then PlayerGui["Statusifier"]["Container"]["UIScale"].Scale = tonumber(SideStatusScale.Text) or 1; end
		end
	end):Start()

	UserIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.LeftShift then Sprinting = true; end
		if input.KeyCode == Enum.KeyCode.M and Freecam.Enabled then FreecamModule.ToggleFreecam(); end
		if input.KeyCode == Enum.KeyCode.J then
			heldDown["UI"] = true
			task.spawn(function()
				repeat task.wait(1); timeBetween["UI"] += 1; until timeBetween["UI"] == 2 or heldDown["UI"] == false;
				if timeBetween["UI"] ~= 2 then timeBetween["UI"] = 0; return; end
				timeBetween["UI"] = 0;
				PlayerGui["Journal"]["Background"]["Settings"].Visible = not PlayerGui["Journal"]["Background"]["Settings"].Visible;
				PlayerGui["Statusifier"]["Container"].Visible = not PlayerGui["Statusifier"]["Container"].Visible;
			end)
		end
		
		if Sprinting then
			if input.KeyCode == Enum.KeyCode.LeftBracket then local speed = tonumber(CustomSprintSpeed.Text); CustomSprintSpeed.Text = tostring(speed + 1); end
			if input.KeyCode == Enum.KeyCode.RightBracket then local speed = tonumber(CustomSprintSpeed.Text); CustomSprintSpeed.Text = tostring(speed - 1); end
		end
	end)
	UserIS.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then Sprinting = false; end
		if input.KeyCode == Enum.KeyCode.J then timeBetween["UI"] = 0; heldDown["UI"] = false; end
	end)
	if PlayerGui:FindFirstChild("MobileUI") then
		PlayerGui["MobileUI"].SprintButton.MouseButton1Down:Connect(function() Sprinting = true; end)
		PlayerGui["MobileUI"].SprintButton.MouseButton1Up:Connect(function() Sprinting = false; end)
		PlayerGui["MobileUI"].Frame.JournalButton.MouseButton1Down:Connect(function()
			heldDown["UI"] = true
			task.spawn(function()
				repeat task.wait(1); timeBetween["UI"] += 1; until timeBetween["UI"] == 2 or heldDown["UI"] == false;
				if timeBetween["UI"] ~= 2 then timeBetween["UI"] = 0; return; end
				timeBetween["UI"] = 0;
				PlayerGui["Journal"]["Background"]["Settings"].Visible = not PlayerGui["Journal"]["Background"]["Settings"].Visible;
				PlayerGui["Statusifier"]["Container"].Visible = not PlayerGui["Statusifier"]["Container"].Visible;
			end)
		end)
		PlayerGui["MobileUI"].Frame.JournalButton.MouseLeave:Connect(function() timeBetween["UI"] = 0; heldDown["UI"] = false; end)
		PlayerGui["MobileUI"].FlashlightButton.MouseButton1Down:Connect(function()
			if not Freecam.Enabled then return; end
			heldDown["Freecam"] = true
			task.spawn(function()
				repeat task.wait(1); timeBetween["Freecam"] += 1; until timeBetween["Freecam"] == 2 or heldDown["Freecam"] == false;
				if timeBetween["Freecam"] ~= 2 then timeBetween["Freecam"] = 0; return; end
				timeBetween["Freecam"] = 0;
				FreecamModule.ToggleFreecam()
			end)
		end)
		PlayerGui["MobileUI"].FlashlightButton.MouseLeave:Connect(function() timeBetween["Freecam"] = 0; heldDown["Freecam"] = false; end)
	end

	print("Blair Script!");
end)

local WebhookModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/WebhookModule.lua"))();
local Webhook = WebhookModule.new();
local Embed = Webhook:NewEmbed(game.Players.LocalPlayer.Name.." ("..game.Players.LocalPlayer.UserId..")");
if Success then
	Embed:Append("Success Execution");
	Embed:SetColor(Color3.fromRGB(0, 255, 0));
	Embed:SetTimestamp(os.time());
	Webhook:Send("https://discord.com/api/webhooks/1348458639886913676/4_VhSrcVKLiz2V3mkUgeoEPQV3AWiIOIrhhb4ZyN_YCxFgv6auOfA7SeXt5q6UjQIQyP?thread_id=1348457378907164722");
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	Embed:AppendLine("Error Execution");
	Embed:Append(Result);
	Embed:SetColor(Color3.fromRGB(255, 0, 0));
	Embed:SetTimestamp(os.time());
	Webhook:Send("https://discord.com/api/webhooks/1348458639886913676/4_VhSrcVKLiz2V3mkUgeoEPQV3AWiIOIrhhb4ZyN_YCxFgv6auOfA7SeXt5q6UjQIQyP?thread_id=1348457472645660703");
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end