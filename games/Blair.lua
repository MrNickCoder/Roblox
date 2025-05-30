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
	repeat task.wait(.1) until game.Workspace[LocalPlayer.Name]:FindFirstChild("HumanoidRootPart");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Map");
	repeat task.wait(.1) until game.Workspace["Map"]:FindFirstChild("Van");
	repeat task.wait(.1) until game.Workspace["Map"]:FindFirstChild("Doors");
	repeat task.wait(.1) until game.Workspace["Map"]:FindFirstChild("Items");
	repeat task.wait(.1) until game.Workspace["Map"]:FindFirstChild("Zones");
	repeat task.wait(.1) until PlayerGui:FindFirstChild("Journal");
	repeat task.wait(.1) until RStorage:FindFirstChild("ActiveChallenges");
	repeat task.wait(.1) until RStorage:FindFirstChild("Remotes");
	repeat task.wait(.1) until RStorage:FindFirstChild("EnvironmentLoaded");
	repeat task.wait(.1) until RStorage["EnvironmentLoaded"].Value;
	repeat task.wait(.1) until RStorage:FindFirstChild("LoadingFinished");
	repeat task.wait(.1) until RStorage["LoadingFinished"].Value;
	task.wait(5);

	local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()
	local BlairData = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/data/Blair.lua"))()
	
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
		["ESPList"] = {};
		
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
				BorderSizePixel = 0;
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
					BorderSizePixel = 0;
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
					BorderSizePixel = 0;
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
				
				return Control;
			end;

			function Data:AddDropdrown(Properties, Options)
				local Selected = Options and Config[Options.Config] or {};
				local List = Options and Options.List or {};
				local Control = { Selected = Selected; };
				Control.Button = Utility:Instance("TextButton", {
					Parent = Data.Button;
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.25;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, -2);
					Size = UDim2.new(0.8, 0, 0.8, 0);
					Font = Enum.Font.SourceSansBold;
					Text = "Open List";
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 5); });
				});
				for Index, Value in pairs(Properties or {}) do
					if Control.Button[Index] then Control.Button[Index] = Value; end
				end;
				Control.Scroll = Utility:Instance("Frame", {
					Parent = Data.Button;
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.25;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, 0);
					Size = UDim2.new(1.1, 0, 10, 0);
					Visible = false;
					ZIndex = 2;
					ClipsDescendants = true;
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 10); });
					Utility:Instance("ScrollingFrame", {
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Color3.fromRGB(0, 0, 0);
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, 0, 0.96, 0);
						ZIndex = 2;
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						CanvasSize = UDim2.new(0, 0, 0, 0);
						ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255);
						ScrollBarThickness = 5;
						Utility:Instance("UIListLayout", { Padding = UDim.new(0, 3); HorizontalAlignment = Enum.HorizontalAlignment.Center; });
						Utility:Instance("UIPadding", { PaddingLeft = UDim.new(0.06, 0); PaddingRight = UDim.new(0.06, 0); });
					})
				});
				for _, Item in pairs(List) do
					local Button = Utility:Instance("TextButton", {
						Name = Item;
						Parent = Control.Scroll["ScrollingFrame"];
						BackgroundColor3 = Color3.fromRGB(40, 40, 40);
						Size = UDim2.new(1, 0, 0.1, 0);
						Text = "";
						ZIndex = 2;
						Utility:Instance("UICorner", { CornerRadius = UDim.new(1, 0); });
						Utility:Instance("TextLabel", {
							AnchorPoint = Vector2.new(0.5, 0.5);
							BackgroundTransparency = 1;
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Size = UDim2.new(0.9, 0, 0.9, 0);
							ZIndex = 2;
							Font = Enum.Font.SourceSansBold;
							Text = Item;
							TextColor3 = Color3.fromRGB(255, 255, 255);
							TextScaled = true;
						});
					});
					if table.find(Control.Selected, Item) then Button.BackgroundColor3 = Color3.fromRGB(0, 211, 0);
					else Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40); end

					Button.MouseButton1Down:Connect(function()
						if table.find(Control.Selected, Item) then
							table.remove(Control.Selected, table.find(Control.Selected, Item));
							Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
						else
							table.insert(Control.Selected, Item);
							Button.BackgroundColor3 = Color3.fromRGB(0, 211, 0);
						end
						if Options.Config then
							Config[Options.Config] = Control.Selected;
							Utility:SaveConfig(Config, Directory, File_Name);
						end
						if Options.Callback then Options.Callback(Control.Selected); end
					end)
				end

				Control.Button.MouseButton1Down:Connect(function()
					Control.Scroll.Visible = not Control.Scroll.Visible
					if Control.Scroll.Visible then Control.Button.Text = "Close List";
					else Control.Button.Text = "Open List"; end
				end)

				return Control;
			end

			function Data:AddButton(Properties, Options)
				local Display = Options and Options.Display or "";
				local Control = { Debounce = false; };
				Control.Button = Utility:Instance("TextButton", {
					Parent = Data.Button;
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.25;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, -2);
					Size = UDim2.new(0.8, 0, 0.8, 0);
					Font = Enum.Font.SourceSansBold;
					Text = Display;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 5); });
				});
				for Index, Value in pairs(Properties or {}) do
					if Control.Button[Index] then Control.Button[Index] = Value; end
				end;

				Control.Button.MouseButton1Down:Connect(function()
					if Control.Debounce then return; end
					if Options.Callback then Options.Callback(); end

					Control.Debounce = true;
					task.spawn(function()
						task.wait(1);
						Control.Debounce = false;
					end)
				end)

				return Control;
			end
			
			function Data:Set(Value)
				Data.Enabled = Value;
				if Options.Config then
					Config[Options.Config] = Data.Enabled;
					Utility:SaveConfig(Config, Directory, File_Name);
				end
				if Data.Enabled then pcall(function() On(); Data.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0); end)
				else pcall(function() Off(); Data.Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0); end) end
			end
			Data:Set(Data.Enabled);
			
			Data.Button.MouseButton1Down:Connect(function() Data:Set(not Data.Enabled); end)
			if UserIS.KeyboardEnabled and UserIS.MouseEnabled and not UserIS.TouchEnabled then
				if Keybind ~= nil then
					Data.Button["TextLabel"].Text = Name .." [".. Keybind.Name .."]";
					UserIS.InputBegan:Connect(function(input, gameProcessed)
						if gameProcessed then return; end
						if input.KeyCode == Keybind then Data:Set(not Data.Enabled); end
					end)
				end
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
		function CreateESP(Type, Properties)
			local Type = Type or "Text";
			local Data = {};
			if Type == "Text" then
				if Properties.ParentText and Properties.ParentText:FindFirstChild("ESP_Text") then
					Data.ESP = Properties.ParentText["ESP_Text"];
					Data.ESP.Size = Properties.Size or UDim2.new(5, 0, 2, 0);
					Data.ESP.StudsOffset = Properties.StudsOffset or Vector3.new(0, 2, 0);
					Data.ESP.Enabled = Properties.Enabled or false;
					Data.ESP["Title"].Text = Properties.Text;
					Data.ESP["Title"].TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
					if Properties.Distance and Data.ESP:FindFirstChild("Distance") then
						Data.Distance = Data.ESP["Distance"];
						Data.Distance.TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
					end
				elseif Properties.Parent and Properties.Parent:FindFirstChild("ESP_Text") then
					Data.ESP = Properties.Parent["ESP_Text"];
					Data.ESP.Size = Properties.Size or UDim2.new(5, 0, 2, 0);
					Data.ESP.StudsOffset = Properties.StudsOffset or Vector3.new(0, 2, 0);
					Data.ESP.Enabled = Properties.Enabled or false;
					Data.ESP["Title"].Text = Properties.Text;
					Data.ESP["Title"].TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
					if Properties.Distance and Data.ESP:FindFirstChild("Distance") then
						Data.Distance = Data.ESP["Distance"];
						Data.Distance.TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
					end
				else
					Data.ESP = Utility:Instance("BillboardGui", {
						Name = "ESP_Text";
						Parent = Properties.ParentText or Properties.Parent;
						ResetOnSpawn = Properties.ResetOnSpawn or false;
						AlwaysOnTop = true;
						Enabled = Properties.Enabled or false;
						Size = Properties.Size or UDim2.new(5, 0, 2, 0);
						StudsOffset = Properties.StudsOffset or Vector3.new(0, 2, 0);
						Utility:Instance("TextLabel", {
							Name = "Title";
							BackgroundTransparency = 1;
							Size = UDim2.new(1, 0, 0.5, 0);
							Font = Enum.Font.FredokaOne;
							Text = Properties.Text;
							TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
							TextScaled = true;
						});
					});
					if Properties.Distance then
						Data.Distance = Utility:Instance("TextLabel", {
							Name = "Distance";
							Parent = Data.ESP;
							BackgroundTransparency = 1;
							Position = UDim2.new(0, 0, 0.5, 0);
							Size = UDim2.new(1, 0, 0.5, 0);
							Font = Enum.Font.FredokaOne;
							Text = "0m";
							TextColor3 = Properties.Color or Color3.fromRGB(255, 255, 255);
							TextScaled = true;
						});
					end
				end
				if Properties.Distance then
					task.spawn(function()
						while task.wait() do
							if Data.Destroyed then break; end
							if not Properties.Distance then break; end
							pcall(function() Data.Distance.Text = (math.floor((Properties.Distance.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude * 100) / 100) .."m"; end)
						end
					end)
				end
				return setmetatable({
					ESP = Data.ESP;
					Distance = Data.Distance;
					Enable = function() pcall(function() Data.ESP.Enabled = true; end); end;
					Disable = function() pcall(function() Data.ESP.Enabled = false; end); end;
					Destroy = function() pcall(function() Data.Destroyed = true; Data.ESP:Destroy(); end); end;
				}, {});
			elseif Type == "Highlight" then
				if Properties.ParentHighlight and Properties.ParentHighlight:FindFirstChild("ESP_Highlight") then Properties.ParentHighlight["ESP_Highlight"]:Destroy(); end
				if Properties.Parent and Properties.Parent:FindFirstChild("ESP_Highlight") then Properties.Parent["ESP_Highlight"]:Destroy(); end
				Data.ESP = Utility:Instance("Highlight", {
					Name = "ESP_Highlight";
					Parent = Properties.ParentHighlight or Properties.Parent;
					Enabled = Properties.Enabled or false;
					FillColor = Properties.Color or Color3.fromRGB(255, 255, 255);
					FillTransparency = Properties.FillTransparency or 0.75;
				});
				return setmetatable({
					ESP = Data.ESP;
					Enable = function() pcall(function() Data.ESP.Enabled = true; end); end;
					Disable = function() pcall(function() Data.ESP.Enabled = false; end); end;
					Destroy = function() pcall(function() Data.ESP:Destroy(); end); end;
				}, {});
			elseif Type == "Text & Highlight" then
				Data.TextESP = CreateESP("Text", Properties);
				Data.HighlightESP = CreateESP("Highlight", Properties);
				return setmetatable({
					TextESP = Data.TextESP;
					HighlightESP = Data.HighlightESP;
					Enable = function() pcall(function() Data.TextESP:Enable(); Data.HighlightESP:Enable(); end); end;
					Disable = function() pcall(function() Data.TextESP:Disable(); Data.HighlightESP:Disable(); end); end;
					Destroy = function() pcall(function() Data.TextESP:Destroy(); Data.HighlightESP:Destroy(); end); end;
				}, {});
			elseif Type == "Backpack" then
				if Properties.Parent and Properties.Parent:FindFirstChild("ESP_Backpack") then
					Data.ESP = Properties.Parent["ESP_Backpack"];
					Data.ESP.MaxDistance = Properties.MaxDistance or 15;
					Data.ESP.Size = Properties.Size or UDim2.new(2, 0, 2, 0);
					Data.ESP.StudsOffset = Properties.StudsOffset or Vector3.new(2, 1, 1);
					Data.ESP.Enabled = Properties.Enabled or false;
				else
					Data.ESP = Utility:Instance("BillboardGui", {
						Name = "ESP_Backpack";
						Parent = Properties.Parent;
						ResetOnSpawn = Properties.ResetOnSpawn or false;
						AlwaysOnTop = true;
						MaxDistance = Properties.MaxDistance or 15;
						Size = Properties.Size or UDim2.new(2, 0, 2, 0);
						StudsOffset = Properties.StudsOffset or Vector3.new(2, 1, 1);
						Enabled = Properties.Enabled or false;
						Utility:Instance("Frame", {
							BackgroundTransparency = 1;
							Size = UDim2.new(1, 0, 1, 0);
							Utility:Instance("UIListLayout", { HorizontalAlignment = Enum.HorizontalAlignment.Center; });
						});
					});
				end
				Data.Slots = {};
				for Slot = 1, 5 do
					if Data.ESP["Frame"]:FindFirstChild("Slot_"..tostring(Slot)) then
						Data.Slots[Slot] = Data.ESP["Frame"]:FindFirstChild("Slot_"..tostring(Slot));
					else
						Data.Slots[Slot] = Utility:Instance("TextLabel", {
							Name = "Slot_"..tostring(Slot);
							Parent = Data.ESP["Frame"];
							BackgroundTransparency = 1;
							Size = UDim2.new(1, 0, 0.2, 0);
							Font = Enum.Font.SourceSansBold;
							Text = "";
							TextColor3 = Color3.fromRGB(255, 255, 255);
							TextScaled = true;
							TextStrokeTransparency = 0;
						});
					end
				end
				return setmetatable({
					ESP = Data.ESP;
					Slots = Data.Slots;
					Enable = function() pcall(function() Data.ESP.Enabled = true; end); end;
					Disable = function() pcall(function() Data.ESP.Enabled = false; end); end;
					Destroy = function() pcall(function() Data.Destroyed = true; Data.ESP:Destroy(); end); end;
				}, {});
			end
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
	local function PopulateDoors(Model)
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
	local DoorCount = 0;
	local ManifestCount = 0;
	local blinkConnection;

	local BooBooESP = {};
	local GeneratorESP = {};
	local GhostESP = {};
	local PlayerESP = {};
	local CursedObjectESP = nil;
	local ItemsESP = {};

	task.spawn(function()
		repeat task.wait() until game.Workspace:FindFirstChild("BooBooDoll")
		BooBooESP["Text"] = CreateESP("Text", { Text = "[BooBoo]"; Distance = game.Workspace["BooBooDoll"]; Parent = game.Workspace["BooBooDoll"]; Color = Color3.fromRGB(0, 255, 255); });
		BooBooESP["Highlight"] = CreateESP("Highlight", { Parent = game.Workspace["BooBooDoll"]; Color = Color3.fromRGB(0, 255, 255); });

		repeat task.wait() until #game.Workspace["Map"]["Generators"]:GetChildren() > 0
		if (game.Workspace["Map"]["Generators"]:GetChildren()[1]):WaitForChild("Highlight", 1) then (game.Workspace["Map"]["Generators"]:GetChildren()[1])["Highlight"]:Destroy(); end
		local Generator = game.Workspace["Map"]["Generators"]:GetChildren()[1];
		GeneratorESP["Text"] = CreateESP("Text", { Text = "[Generator]"; Distance = Generator; Parent = Generator; Color = Color3.fromRGB(255, 16, 240); });
		GeneratorESP["Highlight"] = CreateESP("Highlight", { Parent = Generator; Color = Color3.fromRGB(255, 16, 240); });
	end)
	if game.Workspace:FindFirstChild("Ghost") then
		if game.Workspace["Ghost"]:WaitForChild("Highlight", 1) then game.Workspace["Ghost"]["Highlight"]:Destroy(); end
		local Ghost = game.Workspace["Ghost"];
		GhostESP["Text"] = CreateESP("Text", { Text = "[Ghost]"; Distance = Ghost.PrimaryPart; ParentText = Ghost:WaitForChild("Head"); Color = Color3.fromRGB(255, 0, 0); });
		GhostESP["Text"] = CreateESP("Highlight", { Parent = Ghost; Color = Color3.fromRGB(255, 0, 0); });
	end
	for _, player in pairs(Players:GetChildren()) do
		if player == LocalPlayer then continue; end
		repeat task.wait() until player.Character;
		PlayerESP[player.Name] = {};
		PlayerESP[player.Name]["Player"] = player;
		PlayerESP[player.Name]["ESP"] = CreateESP("Text & Highlight", { Text = player.DisplayName; ParentText = player.Character:FindFirstChild("Head"); ParentHighlight = player.Character; Color = Color3.fromRGB(255, 255, 255); FillTransparency = 1; });
		PlayerESP[player.Name]["Backpack"] = CreateESP("Backpack", { Parent = player.Character; });
	end
	function ValidateItemESP(item)
		if item.Name == "Tarot Cards" then return false; end
		if item.Name == "Music Box" then return false; end
		if not table.find(Utility:GetTableKeys(BlairData["Items"]), item.Name) then return false; end
		if item.Name == "Incense Burner" then
			if item:WaitForChild("Used").Value then return false; end
			if item:WaitForChild("GhostIncensed").Value then return false; end
		end
		if item.Name == "Photo Camera" then
			if item:WaitForChild("PhotoCameraMemory") then
				if item["PhotoCameraMemory"]:WaitForChild("Memory").Value == 100 then return false; end
				if item["PhotoCameraMemory"]:WaitForChild("MemoryCapacity").Text == "100/100 MB" then return false; end
			end
		end
		return true;
	end
	task.spawn(function()
		task.wait(5);
		for _, item in pairs(game.Workspace["Map"]["Items"]:GetChildren()) do
			if not ValidateItemESP(item) then continue; end
			if not table.find(Config["ESPList"], item.Name) then continue; end
			local Item = { ["Item"] = item; };
			Item["ESP"] = CreateESP("Highlight", { Parent = item; Color = Color3.fromRGB(0, 255, 0); });
			table.insert(ItemsESP, Item)
		end
	end)

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
	
	local List =  Utility:CombineTable({"Ghost","BooBoo Doll","Generator","Players","Cursed Object","Backpack"}, Utility:GetTableKeys(BlairData["Items"]));
	local ESP = CreateSettings("ESP", { Config = "ESP"; });
	local ESPList = ESP:AddDropdrown({}, {
		Config = "ESPList";
		List = List;
		Callback = function()
			for _, iESP in pairs(ItemsESP) do iESP["ESP"]:Destroy(); end ItemsESP = {};
			for _, item in pairs(game.Workspace["Map"]["Items"]:GetChildren()) do
				if not ValidateItemESP(item) then continue; end
				if not table.find(Config["ESPList"], item.Name) then continue; end
				local Item = { ["Item"] = item; };
				Item["ESP"] = CreateESP("Highlight", { Parent = item; Color = Color3.fromRGB(0, 255, 0); });
				table.insert(ItemsESP, Item)
			end
		end;
	});
	
	local Freecam = CreateSettings("Freecam", { Config = "Freecam"; });

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
			local function AddCursedESP(Display, Parent)
				CursedObjectESP = CreateESP("Text", { Text = Display; Parent = Parent; Color = Color3.fromRGB(215, 252, 0); });
				if Config["ESP"] and table.find(Config["ESPList"], "Cursed Object") then CursedObjectESP:Enable(); else CursedObjectESP:Disable(); end
			end
			if game.Workspace:WaitForChild("SummoningCircle", 2) then Objects.AddInfo("Summoning Circle"); AddCursedESP("[Summoning Circle]", game.Workspace["SummoningCircle"]); end
			if game.Workspace:WaitForChild("Spirit Board", 2) then Objects.AddInfo("Spirit Board"); AddCursedESP("[Spirit Board]", game.Workspace["Spirit Board"]); end
			if game.Workspace["Map"]["Items"]:WaitForChild("Tarot Cards", 2) then Objects.AddInfo("Tarot Cards"); AddCursedESP("[Tarot Cards]", game.Workspace["Map"]["Items"]["Tarot Cards"]); end
			for _, Player in pairs(Players:GetChildren()) do
				if Player.Backpack:FindFirstChild("Tarot Cards") then Objects.AddInfo("Tarot Cards"); AddCursedESP("[Tarot Cards]", Player.Backpack["Tarot Cards"]); break; end
				if Player.Character and Player.Character:FindFirstChild("Tarot Cards") then Objects.AddInfo("Tarot Cards"); AddCursedESP("[Tarot Cards]", Player.Character["Tarot Cards"]); break; end
			end
			if game.Workspace["Map"]["Items"]:WaitForChild("Music Box", 2) then Objects.AddInfo("Music Box"); AddCursedESP("[Music Box]", game.Workspace["Map"]["Items"]["Music Box"]); end
			for _, Player in pairs(Players:GetChildren()) do
				if Player.Backpack:FindFirstChild("Music Box") then Objects.AddInfo("Music Box"); AddCursedESP("[Music Box]", Player.Backpack["Music Box"]); break; end
				if Player.Character and Player.Character:FindFirstChild("Music Box") then Objects.AddInfo("Music Box"); AddCursedESP("[Music Box]", Player.Character["Music Box"]); break; end
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
	local RoomDoor = Room.AddInfo("Door Interact"); RoomDoor.Visible = false;
	local RoomManifest = Room.AddInfo("Manifest"); RoomManifest.Visible = false;
	local RoomThread = Utility:Thread("Room", function()
		while task.wait() do
			local LowestTempRoom = nil;
			for _, v in pairs(game.Workspace["Map"]["Zones"]:GetChildren()) do
				if v.ClassName ~= "Part" and v.ClassName ~= "UnionOperation" then continue; end
				if v:FindFirstChild("Exclude") then continue; end
				if not v:FindFirstChild("_____Temperature") then continue; end
				if not v["_____Temperature"]:FindFirstChild("_____LocalBaseTemp") then continue; end
				if LowestTempRoom == nil then LowestTempRoom = v; continue; end
				if v["_____Temperature"]["_____LocalBaseTemp"].Value > LowestTempRoom["_____Temperature"]["_____LocalBaseTemp"].Value then continue; end
				LowestTempRoom = v;
			end
			if LowestTempRoom and LowestTempRoom["_____Temperature"] then
				RoomName.Text = LowestTempRoom.Name;
				RoomTemp.Text = (math.floor(LowestTempRoom["_____Temperature"].Value * 1000) / 1000)
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
			if DoorCount > 0 then RoomDoor.Visible = true; RoomDoor.Text = "Door Interact: "..tostring(DoorCount); end
			if ManifestCount > 0 then RoomManifest.Visible = true; RoomManifest.Text = "Manifest: "..tostring(ManifestCount); end
		end
	end):Start()

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
				if game.Workspace["Ghost"]:FindFirstChild("Hunting") then
					if game.Workspace["Ghost"]["Hunting"].Value then for _, v in pairs({GhostLocation, GhostSpeed, GhostBlink, GhostDuration}) do v.Visible = true; end
					else for _, v in pairs({GhostLocation}) do v.Visible = true; end end
				end
				pcall(function()
					if game.Workspace:WaitForChild("Ghost") then
						GhostLocation.Text = game.Workspace:WaitForChild("Ghost", 5):WaitForChild("Zone", 5).Value.Name or "";
						GhostSpeed.Text = "Walk Speed: ".. (math.floor(game.Workspace:WaitForChild("Ghost", 5).Humanoid.WalkSpeed * 1000) / 1000);
						GhostDuration.Text = "Duration: ".. RStorage["HuntDuration"].Value;
					end
				end)
			else for _, v in pairs({GhostLocation, GhostSpeed, GhostBlink, GhostDuration}) do v.Visible = false; end end
			if not GhostBanshee.Visible or not GhostFaejkur.Visible then
				for _, Player in pairs(Players:GetChildren()) do
					if Player.Character then FindParabolic(Player.Character); end
				end
				FindParabolic(game.Workspace["Map"]["Items"]);
			end
		end
	end):Start()
	if game.Workspace:FindFirstChild("Ghost") then
		local saveStamp = tick();
		pcall(function()
			blinkConnection = game.Workspace["Ghost"]:WaitForChild("Head"):GetPropertyChangedSignal("Transparency"):Connect(function()
				GhostBlink.Text = "Blink: ".. (math.floor((tick() - saveStamp) * 1000) / 1000) .."s"
				saveStamp = tick();
			end);
		end);
	end
	game.Workspace.ChildAdded:Connect(function(instance)
		if instance.Name ~= "Ghost" then return; end
		if game.Workspace["Ghost"]:WaitForChild("Highlight", 1) then game.Workspace["Ghost"]["Highlight"]:Destroy(); end
		GhostESP["Text"] = CreateESP("Text", { Text = "[Ghost]"; Distance = instance.PrimaryPart; Parent = instance:WaitForChild("Head", 1); Color = Color3.fromRGB(255, 0, 0); });
		GhostESP["Highlight"] = CreateESP("Highlight", { Parent = instance; Color = Color3.fromRGB(255, 0, 0); });
		local saveStamp = tick();
		pcall(function()
			blinkConnection = instance:WaitForChild("Head", 1):GetPropertyChangedSignal("Transparency"):Connect(function()
				GhostBlink.Text = "Blink: ".. (math.floor((tick() - saveStamp) * 1000) / 1000) .."s"
				saveStamp = tick();
			end);
		end);
		if game.Workspace["Ghost"]:WaitForChild("Hunting") then
			if not game.Workspace["Ghost"]["Hunting"].Value then ManifestCount = ManifestCount + 1; end
		end
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
			for _, evi in pairs({"EMF Level 5","Ultraviolet","Freezing Temp.","Ghost Orbs","Ghost Writing","Spirit Box","SLS Anomaly"}) do
				Evidences[evi] = Evidence.AddInfo(evi);
				Evidences[evi].Visible = false;
			end
			
			local function FindSpiritBox(Object)
				for _, sb in pairs(Object:GetChildren()) do
					if sb.Name ~= "Spirit Box" then continue; end
					for _, talk in pairs(sb:FindFirstChild("GhostTalk"):GetChildren()) do
						if not talk.Playing then continue; end
						if talk.Name == "GhostTalk5" then GhostYama.Visible = true; end
						Evidences["Spirit Box"].Visible = true;
					end
				end
			end
			local function FindEMFReader(Object)
				for _, emf in pairs(Object:GetChildren()) do
					if emf.Name ~= "EMF Reader" then continue; end
					if not emf:FindFirstChild("5") then continue; end
					if emf["5"].Material ~= Enum.Material.Neon then continue; end
					Evidences["EMF Level 5"].Visible = true;
				end
			end
			if RStorage["Remotes"]:FindFirstChild("TextChatServicer") then
				RStorage["Remotes"]["TextChatServicer"].OnClientEvent:Connect(function() Evidences["Spirit Box"].Visible = true; end)
			end
			
			local EvidenceThread = Utility:Thread("Evidence", function()
				while task.wait() do
					if not Evidences["EMF Level 5"].Visible then
						if not game.Workspace:FindFirstChild("Ghost") then
							for _, Player in pairs(Players:GetChildren()) do
								if Player.Character then FindEMFReader(Player.Character); end
							end
							FindEMFReader(game.Workspace["Map"]["Items"]);
						end
					end
					if not Evidences["Ultraviolet"].Visible and #game.Workspace["Map"]["Prints"]:GetChildren() > 0 then
						for _, prints in pairs(game.Workspace["Map"]["Prints"]:GetChildren()) do
							if table.find({"Script, LocalScript"}, prints.ClassName) then continue; end
							Evidences["Ultraviolet"].Visible = true;
						end
					end
					if not Evidences["Freezing Temp."].Visible then
						if LowestTemp["_____Temperature"].Value < 0.1 and LowestTemp["_____Temperature"]["_____LocalBaseTemp"].Value <= 0 then Evidences["Freezing Temp."].Visible = true; end
					end
					if not Evidences["Ghost Orbs"].Visible and #game.Workspace["Map"]["Orbs"]:GetChildren() > 0 then
						for _, orbs in pairs(game.Workspace["Map"]["Orbs"]:GetChildren()) do
							if table.find({"Script, LocalScript"}, orbs.ClassName) then continue; end
							Evidences["Ghost Orbs"].Visible = true;
						end
					end
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
					if not Evidences["SLS Anomaly"].Visible then
						if not game.Workspace:FindFirstChild("Ghost") then
							for _, instance in pairs(game.Workspace:GetChildren()) do
								if instance.ClassName ~= "Model" then continue; end
								if Players:FindFirstChild(instance.Name) then continue; end
								if instance.Name == "Ghost" then continue; end
								if not string.find(instance.Name, "SLS_") then continue; end
								Evidences["SLS Anomaly"].Visible = true;
							end
						end
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

	local ESPThread = Utility:Thread("ESP", function()
		while task.wait() do
			if Config["ESP"] and table.find(Config["ESPList"], "BooBoo Doll") then
				if BooBooESP["Text"] then BooBooESP["Text"]:Enable(); end
				if BooBooESP["Highlight"] then BooBooESP["Highlight"]:Enable(); end
			else
				if BooBooESP["Text"] then BooBooESP["Text"]:Disable(); end
				if BooBooESP["Highlight"] then BooBooESP["Highlight"]:Disable(); end
			end
			if Config["ESP"] and table.find(Config["ESPList"], "Generator") then
				if GeneratorESP["Text"] then GeneratorESP["Text"]:Enable(); end
				if GeneratorESP["Highlight"] then GeneratorESP["Highlight"]:Enable(); end
			else
				if GeneratorESP["Text"] then GeneratorESP["Text"]:Disable(); end
				if GeneratorESP["Highlight"] then GeneratorESP["Highlight"]:Disable(); end
			end
			if Config["ESP"] and table.find(Config["ESPList"], "Ghost") then
				if GhostESP["Text"] then GhostESP["Text"]:Enable(); end
				if GhostESP["Highlight"] then GhostESP["Highlight"]:Enable(); end
			else
				if GhostESP["Text"] then GhostESP["Text"]:Disable(); end
				if GhostESP["Highlight"] then GhostESP["Highlight"]:Disable(); end
			end
			if CursedObjectESP then if Config["ESP"] and table.find(Config["ESPList"], "Cursed Object") then CursedObjectESP:Enable(); else CursedObjectESP:Disable(); end end
			for _, pESP in pairs(PlayerESP) do
				if pESP["Player"] == nil then continue; end
				if Config["ESP"] and table.find(Config["ESPList"], "Players") then pESP["ESP"]:Enable(); else pESP["ESP"]:Disable(); end
				if Config["ESP"] and table.find(Config["ESPList"], "Backpack") then
					pESP["Backpack"]:Enable();
					for Slot = 1, 5 do
						if not pESP["Player"]:FindFirstChild("Slot"..tostring(Slot)) then pESP["Backpack"]["Slots"][Slot].Text = ""; continue; end
						if pESP["Player"]["Slot"..tostring(Slot)].Value == nil then pESP["Backpack"]["Slots"][Slot].Text = ""; continue; end
						pESP["Backpack"]["Slots"][Slot].Text = (pESP["Player"]["Slot"..tostring(Slot)].Value).Name;
					end
				else pESP["Backpack"]:Disable(); end
			end
			for _, iESP in pairs(ItemsESP) do
				if not Config["ESP"] then iESP["ESP"]:Disable(); continue; end
				if iESP["Item"].Parent ~= game.Workspace["Map"]["Items"] then iESP["ESP"]:Disable(); continue; end
				iESP["ESP"]:Enable();
			end
		end
	end):Start()

	game.Workspace.ChildAdded:Connect(function(instance)
		if Players:FindFirstChild(instance.Name) and PlayerESP[instance.Name] then
			
		end
	end)

	game.Workspace["Map"].DescendantAdded:Connect(function(instance)
		if instance.ClassName ~= "Sound" then return; end
		if instance.Name == "GhostCrying" then CryingCount = CryingCount + 1; end
		if string.find(instance.Name, "DoorCreak") then DoorCount = DoorCount + 1; end
	end)

	game.Workspace["Map"]["Items"].ChildAdded:Connect(function(item)
		if not ValidateItemESP(item) then return; end
		if not table.find(Config["ESPList"], item.Name) then return; end
		for _, iESP in pairs(ItemsESP) do
			if iESP["Item"] and iESP["Item"] == item then
				if not ValidateItemESP(iESP["Item"]) then
					iESP["ESP"]:Destroy();
					table.remove(ItemsESP, table.find(iESP));
				end
				return;
			end
		end
		local Item = { ["Item"] = item; };
		Item["ESP"] = CreateESP("Highlight", { Parent = item; Color = Color3.fromRGB(0, 255, 0); });
		table.insert(ItemsESP, Item)
	end)

	Players.PlayerAdded:Connect(function(player)
		if PlayerESP[player.Name] then return; end
		repeat task.wait() until player.Character;
		PlayerESP[player.Name] = {};
		PlayerESP[player.Name]["Player"] = player;
		PlayerESP[player.Name]["ESP"] = CreateESP("Text & Highlight", { Text = player.DisplayName; ParentText = player.Character:FindFirstChild("Head"); ParentHighlight = player.Character; Color = Color3.fromRGB(255, 255, 255); FillTransparency = 1; });
		PlayerESP[player.Name]["Backpack"] = CreateESP("Backpack", { Parent = player.Character; });
	end)
	Players.PlayerRemoving:Connect(function(player)
		PlayerESP[player.Name] = nil;
	end)

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

	print("Loaded Blair Script!");
end)

local WebhookModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/WebhookModule.lua"))();
local Webhook = WebhookModule.new();
local Embed = Webhook:NewEmbed(game.Players.LocalPlayer.Name.." ("..game.Players.LocalPlayer.UserId..")");
if Success then
	Embed:Append("Success Execution");
	Embed:SetColor(Color3.fromRGB(0, 255, 0));
	Embed:SetTimestamp(os.time());
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	Embed:AppendLine("Error Execution");
	Embed:Append(Result);
	Embed:SetColor(Color3.fromRGB(255, 0, 0));
	Embed:SetTimestamp(os.time());
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end