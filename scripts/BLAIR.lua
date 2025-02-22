repeat task.wait() until game:IsLoaded()

-- [[ SERVICES ]] --
local HttpService = game:GetService("HttpService");
local Player = game:GetService("Players").LocalPlayer;
local Lighting = game:GetService("Lighting");
local RStorage = game:GetService("ReplicatedStorage");
local UserIS = game:GetService("UserInputService");
local RService = game:GetService("RunService");

-- [[ CONFIG ]] --
local Config = {}
local saveConfig = function() end
local readConfig = function() end

if not RService:IsStudio() then
	if game.PlaceId == 6137321701 then return end
	if HttpService:JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 2239430935 then return end

	repeat task.wait() until game.Workspace:FindFirstChild(Player.Name);
	repeat task.wait() until game.Workspace:FindFirstChild(Player.Name):FindFirstChild("HumanoidRootPart");
	repeat task.wait() until game.Workspace:FindFirstChild("Map");
	repeat task.wait() until game.Workspace:FindFirstChild("Map"):FindFirstChild("Doors");
	repeat task.wait() until game.Workspace:FindFirstChild("Map"):FindFirstChild("Items");
	repeat task.wait() until Player.PlayerGui:FindFirstChild("Journal");
	repeat task.wait() until RStorage:FindFirstChild("ActiveChallenges");

	if Player.PlayerGui.Journal.JournalFrame:FindFirstChild("Settings") then Player.PlayerGui.Journal.JournalFrame:FindFirstChild("Settings"):Destroy() end;
	if Player.PlayerGui:FindFirstChild("Statusifier") then Player.PlayerGui:FindFirstChild("Statusifier"):Destroy() end;
	
	local Folder = "BLAIR"
	saveConfig = function()
		if not isfolder(Folder) then makefolder(Folder); end
		writefile(Folder.."/Settings.json", HttpService:JSONEncode(Config))
	end
	readConfig = function()
		local success, e = pcall(function()
			if not isfolder(Folder) then makefolder(Folder); end
			return HttpService:JSONDecode(readfile(Folder.."/Settings.json"))
		end)
		if success then return e else saveConfig(); return readConfig(); end
	end
	Config = readConfig();
end

-- [[ UTILITIES ]] --
do
	function Create(Name, Data)
		local Object = Instance.new(Name, Data.Parent);
		for Index, Value in next, Data do
			if Index ~= "Parent" then
				if typeof(Value) == "Instance" then Value.Parent = Object;
				else Object[Index] = Value; end
			end
		end
		return Object;
	end
	function CreateSettings(Name, Options, Callback)
		local Enabled = Options and Options.Default or false;
		if Options and Config[Options.Config] then Enabled = Config[Options.Config] end
		local Keybind = Options and Options.Keybind or nil;
		local On = Callback and Callback.On or function() end;
		local Off = Callback and Callback.Off or function() end;
		
		local Settings;
		if Player.PlayerGui.Journal.JournalFrame:FindFirstChild("Settings") then
			Settings = Player.PlayerGui.Journal.JournalFrame:FindFirstChild("Settings");
		else
			Settings = Create("Frame", {
				Name = "Settings";
				Parent = Player.PlayerGui.Journal.JournalFrame;
				AnchorPoint = Vector2.new(0, 0.5);
				BackgroundTransparency = 1;
				Size = UDim2.new(1, 0, 0.04, 0);
				Create("UIListLayout", {
					Padding = UDim.new(0, 10);
					FillDirection = Enum.FillDirection.Horizontal;
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				});
			});
		end

		local Data = {Enabled = Enabled}
		Data.Button = Create("TextButton", {
			Name = Name;
			Parent = Settings;
			BackgroundColor3 = Color3.fromRGB(0,0);
			BackgroundTransparency = 0.25;
			Size = UDim2.new(0.10, 0, 1, 0);
			Text = "";
			Create("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundTransparency = 1;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(0.9, 0, 0.7, 0);
				Font = Enum.Font.FredokaOne;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
			});
			Create("Frame", {
				BackgroundColor3 = Data.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);
				Position = UDim2.new(0, 0, 1, 0);
				Size = UDim2.new(1, 0, 0, 2);
			});
		});
		Data.Toggle = Data.Button["Frame"];
		Data.AddTextbox = function(Properties, Options)
			Properties.Text = Options and Config[Options.Config] or Properties.Text or "";
			local Type = Options and Options.Type or "Text";
			local Control = Create("TextBox", {
				Parent = Data.Button;
				AnchorPoint = Vector2.new(0.5, 1);
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 0.25;
				Position = UDim2.new(0.5, 0, 0, -2);
				Size = UDim2.new(0.8, 0, 0.8, 0);
				Font = Enum.Font.SourceSansBold;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
				Create("UICorner", { CornerRadius = UDim.new(0, 5); });
			});
			for Index, Value in pairs(Properties or {}) do
				Control[Index] = Value;
				if Index == "Text" and Options.Config then
					Config[Options.Config] = Value;
					saveConfig();
				end
			end;
			
			if Type == "Number" then Control:GetPropertyChangedSignal("Text"):Connect(function() Control.Text = Control.Text:gsub('%D+', ''); end) end
			
			Control.FocusLost:Connect(function()
				if Options.Config then
					Config[Options.Config] = Control.Text;
					saveConfig();
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
				saveConfig();
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
		if Player.PlayerGui:FindFirstChild("Statusifier") then
			SideInfo = Player.PlayerGui:FindFirstChild("Statusifier");
		else
			SideInfo = Create("ScreenGui", {
				Name = "Statusifier";
				Parent = Player.PlayerGui;
				Create("Frame", {
					Name = "Container";
					AnchorPoint = Vector2.new(0, 1);
					BackgroundTransparency = 1;
					Position = UDim2.new(0, 0, 1, 0);
					Size = UDim2.new(0.1, 0, 0.45, 0);
					Create("UIListLayout", { Padding = UDim.new(0, 5); });
				});
			});
		end

		local Data = {}
		Data.Frame = Create("Frame", {
			Name = Name;
			Parent = SideInfo["Container"];
			AutomaticSize = Enum.AutomaticSize.Y;
			BackgroundColor3 = Color3.fromRGB(0, 0, 0);
			BackgroundTransparency = 0.5;
			Size = UDim2.new(1, 0, 0, 0);
			Create("TextLabel", {
				BackgroundTransparency = 1;
				Size = UDim2.new(1, 0, 0, 15);
				Font = Enum.Font.SourceSansBold;
				Text = "[ "..Name.." ]";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
			});
			Create("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y;
				BackgroundTransparency = 1;
				Position = UDim2.new(0, 0, 0, 15);
				Size = UDim2.new(1, 0, 0, 0);
				Create("UIListLayout", { Padding = UDim.new(0, 0); });
			});
		});
		Data.List = Data.Frame["Frame"];
		Data.AddInfo = function(Text)
			return Create("TextLabel", {
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
		Data.UI = Create("BillboardGui", {
			Name = "ESP";
			Parent = Properties.Parent;
			AlwaysOnTop = true;
			Enabled = Properties.Enabled;
			Size = UDim2.new(5, 0, 2, 0);
			StudsOffset = Vector3.new(0, 2, 0);
			Create("TextLabel", {
				BackgroundTransparency = 1;
				Size = UDim2.new(1, 0, 0.5, 0);
				Font = Enum.Font.FredokaOne;
				Text = Text;
				TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
				TextScaled = true;
			});
		});
		Data.Distance = Create("TextLabel", {
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
				Data.Distance.Text = (math.floor((Data.UI.Parent.Position - Player.Character.PrimaryPart.Position).Magnitude * 100) / 100) .."m";
			end
		end)

		return Data
	end
end

-- [[ VARIABLES ]] --
local Light = Create("SpotLight", {
	Parent = Player.Character:FindFirstChild("HumanoidRootPart");
	Brightness = 10;
	Range = 60;
	Face = Enum.NormalId.Front;
	Angle = 120;
	Shadows = false;
});
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

-- [[ USER INTERFACE ]] --
local CustomLights = CreateSettings("Custom Lights", { Config = "CustomLight"; Keybind = Enum.KeyCode.R; }, {
	On = function() Light.Enabled = true end;
	Off = function() Light.Enabled = false end;
});
local CustomLightsRange = CustomLights.AddTextbox({ Position = UDim2.new(0.25, 0, 0, -2); Size = UDim2.new(0.4, 0, 0.8, 0); Text = "60"; }, { Config = "CustomLightRange"; Type = "Number" });
local CustomLightBrightness = CustomLights.AddTextbox({ Position = UDim2.new(0.75, 0, 0, -2); Size = UDim2.new(0.4, 0, 0.8, 0); Text = "10"; }, { Config = "CustomLightBrightness"; Type = "Number" });

local CustomSprint = CreateSettings("Custom Sprint", { Config = "CustomSprint"; Default = true; });
local CustomSprintSpeed = CustomSprint.AddTextbox({ Text = "13"; }, { Config = "CustomSprintSpeed"; Type = "Number" });

local Fullbright = CreateSettings("Fullbright", { Config = "Fullbright"; Keybind = Enum.KeyCode.T; }, {
	On = function()
		Lighting.Ambient = Color3.fromRGB(138, 138, 138);
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128);
		Lighting.Brightness = 2;
	end;
	Off = function()
		Lighting.Ambient = Color3.fromRGB(11, 11, 11);
		Lighting.OutdoorAmbient = Color3.fromRGB(16, 16, 16);
		Lighting.Brightness = 0;
	end;
});
local NoClipDoor = CreateSettings("No Clip Door", { Config = "NoClipDoor"; Keybind = Enum.KeyCode.X; }, {
	On = function() for _, v in pairs(Doors) do v.CanCollide = false end end;
	Off = function() for _, v in pairs(Doors) do v.CanCollide = true end end;
});

local VoodooESP = nil;
if game.Workspace:FindFirstChild("VoodooDoll") then VoodooESP = CreateESP("[Voodoo]", { Parent = game.Workspace:WaitForChild("VoodooDoll"); Color = Color3.fromRGB(0, 255, 0) }); end
local GhostESP = nil;
local ESP = CreateSettings("ESP", { Config = "ESP"; }, {
	On = function()
		if VoodooESP then VoodooESP.UI.Enabled = true; end
		if GhostESP then GhostESP.UI.Enabled = true; end
	end;
	Off = function()
		if VoodooESP then VoodooESP.UI.Enabled = false; end
		if GhostESP then GhostESP.UI.Enabled = false; end
	end;
});
game.Workspace.ChildAdded:Connect(function(instance)
	if instance.Name ~= "Ghost" then return; end
	GhostESP = CreateESP("[Ghost]", { Parent = instance:WaitForChild("Head"); Color = Color3.fromRGB(255, 0, 0); Enabled = ESP.Enabled; });
end)

local SideStatus = CreateSettings("Side Status", { Config = "SideStatus"; Default = true; }, {
	On = function() Player.PlayerGui["Statusifier"].Enabled = true end;
	Off = function() Player.PlayerGui["Statusifier"].Enabled = false end;
});

-- [[ CURSED OBJECT ]] --
local Objects = CreateInfo("Cursed Object");
if game.Workspace:FindFirstChild("SummoningCircle") then Objects.AddInfo("Summoning Circle"); end
if game.Workspace:FindFirstChild("Ouija Board") then Objects.AddInfo("Ouija Board"); end
if game.Workspace["Map"]["Items"]:FindFirstChild("Tarot Cards") then Objects.AddInfo("Tarot Cards"); end

-- [[[ ROOM ]]] --
local Room = CreateInfo("Possible Room");
local RoomName = Room.AddInfo("Room Name");
local RoomTemp = Room.AddInfo("Room Temp");
task.spawn(function()
	while task.wait() do
		local LowestTempRoom = nil;
		for _, v in pairs(game.Workspace.Map["Zones"]:GetChildren()) do
			if v.ClassName ~= "Part" and v.ClassName ~= "UnionOperation" then continue; end
			if v:FindFirstChild("Exclude") then continue; end
			if LowestTempRoom == nil then LowestTempRoom = v; continue; end
			if v["_____Temperature"]["_____LocalBaseTemp"].Value < LowestTempRoom["_____Temperature"]["_____LocalBaseTemp"].Value then LowestTempRoom = v; end
		end
		if LowestTempRoom then
			RoomName.Text = LowestTempRoom.Name;
			RoomTemp.Text = (math.floor(LowestTempRoom["_____Temperature"].Value * 1000) / 1000)
		end
	end
end)

-- [[[ GHOST ]]] --
local Ghost = CreateInfo("Ghost Status");
local GhostActivity = Ghost.AddInfo("Activity");
local GhostLocation = Ghost.AddInfo("Location");
local GhostSpeed = Ghost.AddInfo("WalkSpeed");
local GhostDuration = Ghost.AddInfo("Duration");
task.spawn(function()
	while task.wait() do
		GhostActivity.Text = "Activity: ".. RStorage["Activity"].Value;
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
end)

-- [[[ EVIDENCE ]]] --
if 

-- [[[ PLAYER ]]] --
task.spawn(function()
	while task.wait() do
		Light.Brightness = tonumber(CustomLightBrightness.Text) or 0;
		Light.Range = tonumber(CustomLightsRange.Text) or 0;

		if CustomSprint.Enabled and Sprinting then
			Player.Character:FindFirstChild("Humanoid").WalkSpeed = tonumber(CustomSprintSpeed.Text);
		end
	end
end)

UserIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then Sprinting = true; end
	if Sprinting then
		if input.KeyCode == Enum.KeyCode.LeftBracket then local speed = tonumber(CustomSprintSpeed.Text); CustomSprintSpeed.Text = tostring(speed + 1); end
		if input.KeyCode == Enum.KeyCode.RightBracket then local speed = tonumber(CustomSprintSpeed.Text); CustomSprintSpeed.Text = tostring(speed - 1); end
	end
end)
UserIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then Sprinting = false; end
end)
if Player.PlayerGui:FindFirstChild("MobileUI") then
	Player.PlayerGui["MobileUI"].SprintButton.MouseButton1Down:Connect(function() Sprinting = true; end)
	Player.PlayerGui["MobileUI"].SprintButton.MouseButton1Up:Connect(function() Sprinting = false; end)
end

print("BLAIR Script!");