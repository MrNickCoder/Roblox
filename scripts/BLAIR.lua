repeat task.wait() until game:IsLoaded()

-- [[ SERVICES ]] --
local HttpService = game:GetService("HttpService");
local Player = game:GetService("Players").LocalPlayer;
local Lighting = game:GetService("Lighting");
local RStorage = game:GetService("ReplicatedStorage");
local UserIS = game:GetService("UserInputService");

if game.PlaceId == 6137321701 then return end
if HttpService:JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 2239430935 then return end

repeat task.wait() until game.Workspace:FindFirstChild(Player.Name)
repeat task.wait() until game.Workspace:FindFirstChild(Player.Name):FindFirstChild("HumanoidRootPart")
repeat task.wait() until game.Workspace:FindFirstChild("Map")
task.wait(5)

-- [[ UTILITIES ]] --
do
	function Create(Name, Properties, Childrens)
		local Object = Instance.new(Name);
		for Index, Value in pairs(Properties or {}) do Object[Index] = Value; end
		for Index, Module in pairs(Childrens or {}) do Module.Parent = Object; end
		return Object;
	end
	function CreateSettings(Name, Enabled)
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
			}, {
				Create("UIListLayout", {
					Padding = UDim.new(0, 10);
					FillDirection = Enum.FillDirection.Horizontal;
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				});
			});
		end
		
		local Data = {}
		Data.Button = Create("TextButton", {
			Name = Name;
			Parent = Settings;
			BackgroundColor3 = Color3.fromRGB(0,0);
			BackgroundTransparency = 0.25;
			Size = UDim2.new(0.10, 0, 1, 0);
			Text = "";
		}, {
			Create("BoolValue", {
				Name = "Enable";
				Value = Enabled or false;
			});
			Create("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundTransparency = 1;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(0.7, 0, 0.7, 0);
				Font = Enum.Font.FredokaOne;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
			});
			Create("Frame", {
				BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);
				Position = UDim2.new(0, 0, 1, 0);
				Size = UDim2.new(1, 0, 0, 2);
			});
		});
		Data.Enabled = Data.Button["Enable"];
		Data.Toggle = Data.Button["Frame"];
		
		task.spawn(function()
			while task.wait() do
				if Data.Enabled.Value then Data.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0);
				else Data.Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0); end
			end
		end)
		
		Data.Button.MouseButton1Down:Connect(function() Data.Enabled.Value = not Data.Enabled.Value; end)
		
		return Data;
	end
	function CreateInfo(Name)
		local SideInfo;
		if Player.PlayerGui:FindFirstChild("Statusifier") then
			SideInfo = Player.PlayerGui:FindFirstChild("Statusifier");
		else
			SideInfo = Create("ScreenGui", {
				Name = "Statusifier";
				Parent = Player.PlayerGui;
			}, {
				Create("Frame", {
					Name = "Container";
					AnchorPoint = Vector2.new(0, 1);
					BackgroundTransparency = 1;
					Position = UDim2.new(0, 0, 1, 0);
					Size = UDim2.new(0, 150, 0.45, 0);
				}, {
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
		}, {
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
			}, {
				Create("UIListLayout");
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
end

-- [[ INTERFACE ]] --
local CustomLightsRange = Create("TextBox", {
	AnchorPoint = Vector2.new(0.5, 1);
	BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	BackgroundTransparency = 0.25;
	Position = UDim2.new(0.25, 0, 0, -2);
	Size = UDim2.new(0.4, 0, 0.8, 0);
	Font = Enum.Font.SourceSansBold;
	Text = "60";
	TextColor3 = Color3.fromRGB(255, 255, 255);
	TextScaled = true;
}, { Create("UICorner"); });
local CustomLightBrightness = Create("TextBox", {
	AnchorPoint = Vector2.new(0.5, 1);
	BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	BackgroundTransparency = 0.25;
	Position = UDim2.new(0.75, 0, 0, -2);
	Size = UDim2.new(0.4, 0, 0.8, 0);
	Font = Enum.Font.SourceSansBold;
	Text = "10";
	TextColor3 = Color3.fromRGB(255, 255, 255);
	TextScaled = true;
}, { Create("UICorner"); });
local CustomSprintSpeed = Create("TextBox", {
	AnchorPoint = Vector2.new(0.5, 1);
	BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	BackgroundTransparency = 0.25;
	Position = UDim2.new(0.5, 0, 0, -2);
	Size = UDim2.new(0.8, 0, 0.8, 0);
	Font = Enum.Font.SourceSansBold;
	Text = "13";
	TextColor3 = Color3.fromRGB(255, 255, 255);
	TextScaled = true;
}, { Create("UICorner"); });

-- [[ VARIABLES ]] --
local Fullbright = CreateSettings("Fullbright");
local CustomLights = CreateSettings("Custom Lights");
CustomLightsRange.Parent = CustomLights.Button;
CustomLightBrightness.Parent = CustomLights.Button;
local CustomSprint = CreateSettings("Custom Sprint", true);
CustomSprintSpeed.Parent = CustomSprint.Button;
local NoClipDoor = CreateSettings("No Clip Door");
--local ESP = CreateSettings("ESP");
local SideStatus = CreateSettings("Side Status", true);

local Ghost = CreateInfo("Ghost Status");
local GhostLocation = Ghost.AddInfo("Location");
local GhostSpeed = Ghost.AddInfo("WalkSpeed");
local GhostDuration = Ghost.AddInfo("Duration");

local Objects = CreateInfo("Cursed Object");
if workspace:FindFirstChild("SummoningCircle") then Objects.AddInfo("Summoning Circle"); end
if workspace:FindFirstChild("Ouija Board") then Objects.AddInfo("Ouija Board"); end
if workspace["Map"]["Items"]:FindFirstChild("Tarot Cards") then Objects.AddInfo("Tarot Cards"); end

local Room = CreateInfo("Possible Room");
local RoomName = Room.AddInfo("Room Name");
local RoomTemp = Room.AddInfo("Room Temp");

local Light = Create("SpotLight", {
	Parent = Player.Character:FindFirstChild("HumanoidRootPart");
	Brightness = tonumber(CustomLightBrightness.Text);
	Range = tonumber(CustomLightsRange.Text);
	Face = Enum.NormalId.Front;
	Angle = 120;
	Shadows = false;
});

local Sprinting = false
local AllCollidable = {}

-- [[ EVENT ]] --
function PopulateCollidable(Model)
	for _, v in pairs(Model:GetChildren()) do
		if not table.find({"Part", "MeshPart", "Model"}, v.ClassName) then continue; end
		if #v:GetChildren() > 0 then PopulateCollidable(v); end
		if (v.ClassName == "Part" or v.ClassName == "MeshPart") and v.CanCollide then table.insert(AllCollidable, v); end
		
	end
end
PopulateCollidable(workspace["Map"]["Doors"]);

task.spawn(function()
	while task.wait() do
		local LowestTempRoom = nil;
		for _, v in pairs(workspace.Map["Zones"]:GetChildren()) do
			if v.ClassName ~= "Part" and v.ClassName ~= "UnionOperation" then continue; end
			if v:FindFirstChild("Exclude") then continue; end
			if LowestTempRoom == nil then LowestTempRoom = v; continue; end
			if v["_____Temperature"]["_____LocalBaseTemp"].Value < LowestTempRoom["_____Temperature"]["_____LocalBaseTemp"].Value then LowestTempRoom = v; end
		end
		if LowestTempRoom then
			RoomName.Text = LowestTempRoom.Name;
			RoomTemp.Text = LowestTempRoom["_____Temperature"].Value
		end
	end
end)
task.spawn(function()
	while task.wait() do
		Player.PlayerGui["Statusifier"].Enabled = SideStatus.Enabled.Value;
		Light.Brightness = tonumber(CustomLightBrightness.Text) or 0;
		Light.Range = tonumber(CustomLightsRange.Text) or 0;
		Light.Enabled = CustomLights.Enabled.Value;
		
		if Fullbright.Enabled.Value then
			Lighting.Ambient = Color3.fromRGB(138, 138, 138);
			Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128);
			Lighting.Brightness = 2;
		else
			Lighting.Ambient = Color3.fromRGB(11, 11, 11);
			Lighting.OutdoorAmbient = Color3.fromRGB(16, 16, 16);
			Lighting.Brightness = 0;
		end
		
		if CustomSprint.Enabled.Value and Sprinting then
			Player.Character:FindFirstChild("Humanoid").WalkSpeed = tonumber(CustomSprintSpeed.Text);
		end
	end
end)
task.spawn(function()
	while task.wait() do
		if workspace:FindFirstChild("Ghost") then
			for _, v in pairs({GhostLocation, GhostSpeed, GhostDuration}) do v.Visible = true; end

			task.spawn(function()
				if workspace:WaitForChild("Ghost") then
					GhostLocation.Text = workspace:WaitForChild("Ghost"):WaitForChild("Zone").Value.Name;
					GhostSpeed.Text = "Walk Speed: ".. workspace:WaitForChild("Ghost").Humanoid.WalkSpeed;
					GhostDuration.Text = "Duration: ".. RStorage["HuntDuration"].Value + 1;
				end
			end)
		else
			for _, v in pairs({GhostLocation, GhostSpeed, GhostDuration}) do v.Visible = false; end
		end
	end
end)
for _, v in pairs({CustomLightsRange, CustomLightBrightness, CustomSprintSpeed}) do
	v:GetPropertyChangedSignal("Text"):Connect(function() v.Text = v.Text:gsub('%D+', ''); end)
end
NoClipDoor.Enabled:GetPropertyChangedSignal("Value"):Connect(function()
	for _, v in pairs(AllCollidable) do v.CanCollide = not NoClipDoor.Enabled.Value; end
end)
UserIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.R then CustomLights.Enabled.Value = not CustomLights.Enabled.Value; end
	if input.KeyCode == Enum.KeyCode.X then NoClipDoor.Enabled.Value = not NoClipDoor.Enabled.Value; end
	if input.KeyCode == Enum.KeyCode.LeftShift then Sprinting = true; end
	if Sprinting then
		if input.KeyCode == Enum.KeyCode.LeftBracket then local speed = tonumber(CustomSprintSpeed.Text); CustomSprintSpeed.Text = tostring(speed + 1); end
		if input.KeyCode == Enum.KeyCode.RightBracket then local speed = tonumber(CustomSprintSpeed.Text); CustomSprintSpeed.Text = tostring(speed - 1); end
	end
end)
UserIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then Sprinting = false; end
end)

print("BLAIR Script!");