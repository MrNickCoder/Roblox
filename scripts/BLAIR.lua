if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 2239430935 then return; end

--------------------
-- [[ SERVICES ]] --
--------------------
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui");
local Lighting = game:GetService("Lighting");
local RStorage = game:GetService("ReplicatedStorage");
local UserIS = game:GetService("UserInputService");
local RService = game:GetService("RunService");

local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;


if game.PlaceId == 6137321701 then StarterGui:SetCore("SendNotification", { Title = "BLAIR"; Text = "No Loading in Lobby!"; }); return; end

StarterGui:SetCore("SendNotification", { Title = "BLAIR"; Text = "Loading Script!"; });
local Success, Result = pcall(function()
	print("Loading BLAIR Script!");
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
	Config = Utility:LoadConfig(Config, "BLAIR", "Settings.json");

	if PlayerGui.Journal.JournalFrame:FindFirstChild("Settings") then PlayerGui.Journal.JournalFrame:FindFirstChild("Settings"):Destroy() end;
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
			if PlayerGui.Journal.JournalFrame:FindFirstChild("Settings") then
				Settings = PlayerGui.Journal.JournalFrame:FindFirstChild("Settings");
			else
				Settings = Utility:Instance("Frame", {
					Name = "Settings";
					Parent = PlayerGui.Journal.JournalFrame;
					AnchorPoint = Vector2.new(0, 0.5);
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
						Utility:SaveConfig(Config, "BLAIR", "Settings.json");
					end
				end;
				
				if Type == "Integer" then Control:GetPropertyChangedSignal("Text"):Connect(function() Control.Text = string.match(Control.Text, (Negative and "[-]?" or "").."%d*"); end) end
				if Type == "Number" then Control:GetPropertyChangedSignal("Text"):Connect(function() Control.Text = string.match(Control.Text, (Negative and "[-]?" or "").."%d*[%.]?%d*"); end) end
				
				Control.FocusLost:Connect(function()
					if Options.Config then
						Config[Options.Config] = Control.Text;
						Utility:SaveConfig(Config, "BLAIR", "Settings.json");
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
					Utility:SaveConfig(Config, "BLAIR", "Settings.json");
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
			Data.Highlight = Utility:Instance("Highlight", {
				Name = "ESP_Highlight";
				Parent = Properties.Parent;
				Enabled = Properties.Enabled;
				FillColor = Properties.Color or Color3.fromRGB(255, 255, 255);
				FillTransparency = 0.75;
			});
			Data.UI = Utility:Instance("BillboardGui", {
				Name = "ESP";
				Parent = Properties.Parent;
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
				Parent = Data.UI;
				BackgroundTransparency = 1;
				Position = UDim2.new(0, 0, 0.5, 0);
				Size = UDim2.new(1, 0, 0.5, 0);
				Font = Enum.Font.FredokaOne;
				Text = "0m";
				TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
				TextScaled = true;
			});
			
			task.spawn(function()
				while task.wait() do
					if not Data.UI.Parent then break; end
					pcall(function() Data.Distance.Text = (math.floor((Data.UI.Parent.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude * 100) / 100) .."m"; end)
				end
			end)
			
			function Data:Enable() Data.Highlight.Enabled = true; Data.UI.Enabled = true; end
			function Data:Disable() Data.Highlight.Enabled = false; Data.UI.Enabled = false; end

			return Data
		end
	end

	----------------------
	-- [[ INITIALIZE ]] --
	----------------------
	local Freecam = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/FreecamModule.lua"))()
	Freecam.IgnoreGUI = {"Radio", "Journal", "MobileUI", "Statusifier"}
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

	local VoodooESP = nil;
	if game.Workspace:FindFirstChild("VoodooDoll") then VoodooESP = CreateESP("[Voodoo]", { Parent = game.Workspace:WaitForChild("VoodooDoll"); Color = Color3.fromRGB(0, 255, 0); }); end
	local GeneratorESP = CreateESP("[Generator]", { Parent = game.Workspace["Map"]["Generators"]:GetChildren()[1]; Color = Color3.fromRGB(255, 16, 240); });
	local GhostESP = nil;
	if game.Workspace:FindFirstChild("Ghost") then GhostESP = CreateESP("[Ghost]", { Parent = instance:WaitForChild("Head"); Color = Color3.fromRGB(255, 0, 0); }); end
	
	local ESP = CreateSettings("ESP", { Config = "ESP"; }, {
		On = function()
			if VoodooESP then VoodooESP:Enable(); end
			if GeneratorESP then GeneratorESP:Enable(); end
			if GhostESP then GhostESP:Enable(); end
		end;
		Off = function()
			if VoodooESP then VoodooESP:Disable(); end
			if GeneratorESP then GeneratorESP:Disable(); end
			if GhostESP then GhostESP:Disable(); end
		end;
	});
	game.Workspace.ChildAdded:Connect(function(instance)
		if instance.Name ~= "Ghost" then return; end
		GhostESP = CreateESP("[Ghost]", { Parent = instance:WaitForChild("Head"); Color = Color3.fromRGB(255, 0, 0); Enabled = ESP.Enabled; });
	end)

	local SideStatus = CreateSettings("Side Status", { Config = "SideStatus"; }, {
		On = function() PlayerGui["Statusifier"].Enabled = true end;
		Off = function() PlayerGui["Statusifier"].Enabled = false end;
	});
	local SideStatusScale = SideStatus:AddTextbox({ Text = "1"; }, { Config = "SideStatusScale"; Display = "Scale"; Type = "Number"; });

	---------------------------
	-- [[[ CURSED OBJECT ]]] --
	---------------------------
	local Objects = CreateInfo("Cursed Object");
	task.spawn(function()
		pcall(function()
			if game.Workspace:WaitForChild("SummoningCircle", 5) then Objects.AddInfo("Summoning Circle"); end
			if game.Workspace:WaitForChild("Ouija Board", 5) then Objects.AddInfo("Ouija Board"); end
			if game.Workspace["Map"]["Items"]:WaitForChild("Tarot Cards", 5) then Objects.AddInfo("Tarot Cards"); end
			for _, Player in pairs(Players:GetChildren()) do if Player.Character and Player.Character:WaitForChild("Tarot Cards", 5) then Objects.AddInfo("Tarot Cards"); break; end end
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
		end
	end):Start()

	-------------------
	-- [[[ GHOST ]]] --
	-------------------
	local Ghost = CreateInfo("Ghost Status");
	local GhostActivity = Ghost.AddInfo("Activity");
	local GhostLocation = Ghost.AddInfo("Location");
	local GhostSpeed = Ghost.AddInfo("WalkSpeed");
	local GhostDuration = Ghost.AddInfo("Duration");
	local GhostDisruption = Ghost.AddInfo("Disrupting");
	local GhostThread = Utility:Thread("Ghost", function()
		while task.wait() do
			GhostActivity.Text = "Activity: ".. RStorage["Activity"].Value;
			if RStorage["Disruption"].Value then GhostDisruption.Visible = true; else GhostDisruption.Visible = false; end
			if game.Workspace:FindFirstChild("Ghost") then
				for _, v in pairs({GhostLocation, GhostSpeed, GhostDuration}) do v.Visible = true; end

				pcall(function()
					if game.Workspace:WaitForChild("Ghost") then
						GhostLocation.Text = game.Workspace:WaitForChild("Ghost", 5):WaitForChild("Zone", 5).Value.Name or "";
						GhostSpeed.Text = "Walk Speed: ".. (math.floor(game.Workspace:WaitForChild("Ghost", 5).Humanoid.WalkSpeed * 1000) / 1000);
						GhostDuration.Text = "Duration: ".. RStorage["HuntDuration"].Value;
					end
				end)
			else
				for _, v in pairs({GhostLocation, GhostSpeed, GhostDuration}) do v.Visible = false; end
			end
		end
	end):Start()

	----------------------
	-- [[[ EVIDENCE ]]] --
	----------------------
	if RStorage:FindFirstChild("ActiveChallenges") then
		if not (RStorage["ActiveChallenges"]:FindFirstChild("evidencelessOne") and RStorage["ActiveChallenges"]:FindFirstChild("evidencelessTwo")) then
			local Evidence = CreateInfo("Evidences");
			local Evidences = {}
			for _, evi in pairs({"EMF Level 5","Fingerprints","Freezing Temp.","Ghost Orbs","Ghost Writing","Spirit Box"}) do
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
					if not Evidences["Fingerprints"].Visible and #game.Workspace["Map"]["Prints"]:GetChildren() > 0 then Evidences["Fingerprints"].Visible = true; end
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
	local timeBetween = 0
	local heldDown = false
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
		if input.KeyCode == Enum.KeyCode.M then Freecam.ToggleFreecam(); end
		if input.KeyCode == Enum.KeyCode.J then
			heldDown = true
			task.spawn(function()
				repeat task.wait(1); timeBetween += 1; until timeBetween == 2 or heldDown == false;
				if timeBetween ~= 2 then timeBetween = 0; return; end
				timeBetween = 0;
				PlayerGui["Journal"]["JournalFrame"]["Settings"].Visible = not PlayerGui["Journal"]["JournalFrame"]["Settings"].Visible;
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
		if input.KeyCode == Enum.KeyCode.J then timeBetween = 0; heldDown = false; end
	end)
	if PlayerGui:FindFirstChild("MobileUI") then
		PlayerGui["MobileUI"].SprintButton.MouseButton1Down:Connect(function() Sprinting = true; end)
		PlayerGui["MobileUI"].SprintButton.MouseButton1Up:Connect(function() Sprinting = false; end)
		PlayerGui["MobileUI"].Frame.JournalButton.MouseButton1Down:Connect(function()
			heldDown = true
			task.spawn(function()
				repeat task.wait(1); timeBetween += 1; until timeBetween == 2 or heldDown == false;
				if timeBetween ~= 2 then timeBetween = 0; return; end
				timeBetween = 0;
				PlayerGui["Journal"]["JournalFrame"]["Settings"].Visible = not PlayerGui["Journal"]["JournalFrame"]["Settings"].Visible;
				PlayerGui["Statusifier"]["Container"].Visible = not PlayerGui["Statusifier"]["Container"].Visible;
			end)
		end)
		PlayerGui["MobileUI"].Frame.JournalButton.MouseLeave:Connect(function() timeBetween = 0; heldDown = false; end)
	end

	print("BLAIR Script!");
end)

if Success then
	StarterGui:SetCore("SendNotification", { Title = "BLAIR"; Text = "Successfully Loaded!"; });
else
	StarterGui:SetCore("SendNotification", { Title = "BLAIR"; Text = "Error Loading!"; });
	error(Result);
end