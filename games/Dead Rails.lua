if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 7018190066 then return; end

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

if game.PlaceId == 116495829188952 then StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "No Loading in Lobby!"; }); return; end

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Dead Rails Script!"; });
local Success, Result = pcall(function()
	print("Loading Dead Rails Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("HumanoidRootPart");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Baseplates");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("RandomBuildings");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("RuntimeEnemies");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("NightEnemies");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("RuntimeItems");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Towns");
	task.wait(5)
	
	local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()

	------------------
	-- [[ CONFIG ]] --
	------------------
	local Config = {
		["Fullbright"] = false;
		["FullbrightAmbient"] = "255";
		
		["NoClip"] = false;
		
		["ESPItems"] = false;
		["ESPItemsList"] = {};
		["ESPEnemies"] = false;
		
		["Status"] = false;
		["StatusScale"] = "1";
	}
	local Directory = "Paradoxium/Dead Rails"
	local File_Name = "Settings.json"
	Config = Utility:LoadConfig(Config, Directory, File_Name);
	
	if PlayerGui:FindFirstChild("Dead Rails") then PlayerGui:FindFirstChild("Dead Rails"):Destroy() end;
	if PlayerGui:FindFirstChild("Statusifier") then PlayerGui:FindFirstChild("Statusifier"):Destroy() end;
	
	---------------------
	-- [[ UTILITIES ]] --
	---------------------
	local UserInterface;
	if PlayerGui:FindFirstChild("Dead Rails") then
		UserInterface = PlayerGui:FindFirstChild("Dead Rails");
	else
		UserInterface = Utility:Instance("ScreenGui", {
			Name = "Dead Rails";
			Parent = PlayerGui;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			Utility:Instance("Frame", {
				Name = "UI";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 0.5;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(0.25, 0, 0.75, 0);
				ClipsDescendants = true;
				Utility:Instance("Frame", {
					Name = "Title";
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = UDim2.new(1, 0, 0.075, 0);
					Utility:Instance("TextLabel", {
						AnchorPoint = Vector2.new(0, 0.5);
						BackgroundTransparency = 1;
						Position = UDim2.new(0, 0, 0.5, 0);
						Size = UDim2.new(1, 0, 0.8, 0);
						Font = Enum.Font.FredokaOne;
						Text = "Dead Rails";
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
					});
				});
				Utility:Instance("ScrollingFrame", {
					Name = "Settings";
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 1, 0);
					Size = UDim2.new(1, 0, 0.925, 0);
					AutomaticCanvasSize = Enum.AutomaticSize.Y;
					CanvasSize = UDim2.new(0, 0, 0, 0);
					ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0);
					ScrollBarThickness = 3;
					ScrollingDirection = Enum.ScrollingDirection.Y;
					Utility:Instance("UIListLayout", {
						Padding = UDim.new(0.01, 0);
						HorizontalAlignment = Enum.HorizontalAlignment.Center;
					});
					Utility:Instance("UIPadding", {
						PaddingBottom = UDim.new(0, 5);
						PaddingTop = UDim.new(0, 10);
					});
				});
				Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
				Utility:Instance("UIStroke", { Thickness = 2.5; });
			});
		});
	end
	if UserIS.MouseBehavior == Enum.MouseBehavior.LockCenter then UserInterface.Enabled = false; else UserInterface.Enabled = true; end
	local UIButton;
	if PlayerGui:FindFirstChild("MoneyGui"):FindFirstChild("Money"):FindFirstChild("UIButton") then
		UIButton = PlayerGui["MoneyGui"]["Money"]:FindFirstChild("UIButton");
	else
		UIButton = Utility:Instance("TextButton", {
			Name = "UIButton";
			Parent = PlayerGui:FindFirstChild("MoneyGui"):FindFirstChild("Money");
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 1, 0);
			Text = "";
		});
	end
	local Statusifier;
	if PlayerGui:FindFirstChild("Statusifier") then
		Statusifier = PlayerGui:FindFirstChild("Statusifier");
	else
		Statusifier = Utility:Instance("ScreenGui", {
			Name = "Statusifier";
			Parent = PlayerGui;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			Utility:Instance("Frame", {
				Name = "TopStatus";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundTransparency = 1;
				Position = UDim2.new(0.5, 0, 0.025, 0);
				Size = UDim2.new(1, 0, 0.05, 0);
				Utility:Instance("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal;
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				});
				Utility:Instance("UIScale", { Scale = 1; });
			});
		});
	end
	
	local Interface = {}
	do
		function Interface:CreateToggle(Name, Options, Callback)
			local Enabled = Options and Options.Default or false;
			if Options and Config[Options.Config] then Enabled = Config[Options.Config] end
			local Keybind = Options and Options.Keybind or nil;
			local On = Callback and Callback.On or function() end;
			local Off = Callback and Callback.Off or function() end;
			
			local Data = {Enabled = Enabled};
			Data.UI = Utility:Instance("Frame", {
				Name = Name;
				Parent = UserInterface["UI"]["Settings"];
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 0.5;
				Size = UDim2.new(0.92, 0, 0, 30);
				Utility:Instance("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0, 0.5);
					BackgroundTransparency = 1;
					Position = UDim2.new(0.05, 0, 0.5, 0);
					Size = UDim2.new(0.7, 0, 0.6, 0);
					Font = Enum.Font.Ubuntu;
					Text = Name;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				Utility:Instance("Frame", {
					Name = "Input";
					AnchorPoint = Vector2.new(1, 0.5);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.5;
					Position = UDim2.new(0.95, 0, 0.5, 0);
					Size = UDim2.new(0.2, 0, 0.6, 0);
					Utility:Instance("TextButton", {
						Name = "Button";
						BackgroundColor3 = Color3.fromRGB(255, 0, 0);
						Position = UDim2.new(0, 2, 0, 2);
						Size = UDim2.new(0.5, -4, 1, -4);
						Text = "";
						Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
					});
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
				});
				Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
			});
			
			function Data:Set(Value)
				Data.Enabled = Value;
				local Info = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
				if Data.Enabled then
					pcall(function()
						On();
						TweenService:Create(Data.UI["Input"]["Button"], Info, {
							Position = UDim2.new(0.5, 2, 0, 2);
							BackgroundColor3 = Color3.fromRGB(0, 255, 0);
						}):Play();
					end)
				else
					pcall(function()
						Off();
						TweenService:Create(Data.UI["Input"]["Button"], Info, {
							Position = UDim2.new(0, 2, 0, 2);
							BackgroundColor3 = Color3.fromRGB(255, 0, 0);
						}):Play();
					end)
				end
				if Options.Config then
					Config[Options.Config] = Data.Enabled;
					Utility:SaveConfig(Config, Directory, File_Name);
				end
			end
			
			Data:Set(Data.Enabled);
			Data.UI["Input"]["Button"].MouseButton1Down:Connect(function() Data:Set(not Data.Enabled); end)
			if Keybind ~= nil then
				UserIS.InputBegan:Connect(function(input, gameProcessed)
					if gameProcessed then return; end
					if input.KeyCode == Keybind then Data.Set(not Data.Enabled);end
				end)
			end
			
			return Data;
		end
		function Interface:CreateTextBox(Name, Options, Callback)
			local Value = Options and Options.Default or "";
			if Options and Config[Options.Config] then Value = Config[Options.Config] end
			local Callback = Callback or function() end;
			
			local Data = {Value = Value};
			Data.UI = Utility:Instance("Frame", {
				Name = Name;
				Parent = UserInterface["UI"]["Settings"];
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 0.5;
				Size = UDim2.new(0.92, 0, 0, 30);
				Utility:Instance("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0, 0.5);
					BackgroundTransparency = 1;
					Position = UDim2.new(0.05, 0, 0.5, 0);
					Size = UDim2.new(0.7, 0, 0.6, 0);
					Font = Enum.Font.Ubuntu;
					Text = Name;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				Utility:Instance("Frame", {
					Name = "Input";
					AnchorPoint = Vector2.new(1, 0.5);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.5;
					Position = UDim2.new(0.95, 0, 0.5, 0);
					Size = UDim2.new(0.2, 0, 0.6, 0);
					Utility:Instance("TextBox", {
						Name = "Box";
						BackgroundTransparency = 1;
						Position = UDim2.new(0, 2, 0, 2);
						Size = UDim2.new(1, -4, 1, -4);
						Font = Enum.Font.FredokaOne;
						Text = Data.Value;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
					});
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
				});
				Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
			});
			
			function Data:Set(Value)
				Data.Value = Value;
				Data.UI["Input"]["Box"].Text = Value
				Callback();
				if Options.Config then
					Config[Options.Config] = Data.Value;
					Utility:SaveConfig(Config, Directory, File_Name);
				end
			end
			
			Data.UI["Input"]["Box"].FocusLost:Connect(function() Data:Set(Data.UI["Input"]["Box"].Text); end)
			
			return Data;
		end
		function Interface:CreateSlider(Name, Options, Callback)
			local Min = Options and Options.Min or 0;
			local Max = Options and Options.Max or 1;
			local Decimals = Options and Options.Decimals or 1;
			local Value = Options and Options.Default or Min;
			if Options and Config[Options.Config] then Value = Config[Options.Config] end
			local Callback = Callback or function(Value) end;
			
			local Data = { Value = Value; Decimals = Decimals; Min = Min; Max = Max; };
			Data.UI = Utility:Instance("Frame", {
				Name = Name;
				Parent = UserInterface["UI"]["Settings"];
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 0.5;
				Size = UDim2.new(0.92, 0, 0, 50);
				Utility:Instance("Frame", {
					Name = "TextBox";
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0, 30);
					Utility:Instance("TextLabel", {
						Name = "Title";
						AnchorPoint = Vector2.new(0, 0.5);
						BackgroundTransparency = 1;
						Position = UDim2.new(0.05, 0, 0.5, 0);
						Size = UDim2.new(0.7, 0, 0.6, 0);
						Font = Enum.Font.Ubuntu;
						Text = Name;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						TextXAlignment = Enum.TextXAlignment.Left;
					});
					Utility:Instance("Frame", {
						Name = "Input";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundColor3 = Color3.fromRGB(0, 0, 0);
						BackgroundTransparency = 0.5;
						Position = UDim2.new(0.95, 0, 0.5, 0);
						Size = UDim2.new(0.2, 0, 0.6, 0);
						Utility:Instance("TextBox", {
							Name = "Box";
							BackgroundTransparency = 1;
							Position = UDim2.new(0, 2, 0, 2);
							Size = UDim2.new(1, -4, 1, -4);
							Font = Enum.Font.FredokaOne;
							Text = tostring(Data.Value);
							TextColor3 = Color3.fromRGB(255, 255, 255);
							TextScaled = true;
							Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
						});
						Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
					});
				});
				Utility:Instance("Frame", {
					Name = "Input";
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.5;
					Position = UDim2.new(0.5, 0, 1, -10);
					Size = UDim2.new(0.9, 0, 0, 3);
					Utility:Instance("TextButton", {
						Name = "Button";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						Position = UDim2.new((Data.Value - (Data.Min)) / (Data.Max - (Data.Min)), 0, 0.5, 0);
						Size = UDim2.new(0, 10, 0, 10);
						Text = "";
						Utility:Instance("UICorner", { CornerRadius = UDim.new(1, 0); });
					});
				});
				Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
			});
			
			function Data:Set(Value)
				Data.Value = Value;
				Data.UI["TextBox"]["Input"]["Box"].Text = tostring(Value);
				Callback(Value);
				if Options.Config then
					Config[Options.Config] = Data.Value;
					Utility:SaveConfig(Config, Directory, File_Name);
				end
			end
			
			local held = false;
			Data.UI["Input"]["Button"].MouseButton1Down:Connect(function()
				held = true;
				task.spawn(function()
					while held do
						task.wait();
						Data.UI["Input"]["Button"].Position = UDim2.new(math.clamp((Mouse.X - Data.UI["Input"].AbsolutePosition.X) / Data.UI["Input"].AbsoluteSize.X, 0, 1), 0, 0.5, 0);
						Data:Set(math.floor((Data.Min + (Data.Max - Data.Min) * Data.UI["Input"]["Button"].Position.X.Scale) * Data.Decimals) / Data.Decimals);
					end
				end)
			end)
			Data.UI["Input"]["Button"].MouseButton1Up:Connect(function() held = false; end)
			Data.UI.MouseLeave:Connect(function() held = false; end)
			Data.UI["TextBox"]["Input"]["Box"].FocusLost:Connect(function()
				Data.UI["TextBox"]["Input"]["Box"].Text = string.match(Data.UI["TextBox"]["Input"]["Box"].Text, "[-]?%d*[%.]?%d*");
				local Value = math.clamp(tonumber(Data.UI["TextBox"]["Input"]["Box"].Text) or Data.Min, Data.Min, Data.Max);
				Data:Set(Value);
				Data.UI["Input"]["Button"].Position = UDim2.new((Data.Value - (Data.Min)) / (Data.Max - (Data.Min)), 0, 0.5, 0);
			end)
			
			return Data;
		end
		function Interface:CreateDropdown(Name, Options, Callback)
			local Items = Options and Options.Items;
			local Value = Options and Options.Default or {};
			local Multi = Options and Options.Multi or false;
			if Options and Config[Options.Config] then Value = Config[Options.Config] end
			local Callback = Callback or function() end;
			
			local Data = {Value = Value; Items = Items; Multi = Multi; };
			Data.UI = Utility:Instance("Frame", {
				Name = Name;
				Parent = UserInterface["UI"]["Settings"];
				AutomaticSize = Enum.AutomaticSize.Y;
				BackgroundTransparency = 1;
				Size = UDim2.new(0.92, 0, 0, 0);
				Utility:Instance("Frame", {
					Name = "Input";
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.5;
					Size = UDim2.new(1, 0, 0, 30);
					Utility:Instance("TextLabel", {
						Name = "Title";
						AnchorPoint = Vector2.new(0, 0.5);
						BackgroundTransparency = 1;
						Position = UDim2.new(0.05, 0, 0.5, 0);
						Size = UDim2.new(0.7, 0, 0.6, 0);
						Font = Enum.Font.Ubuntu;
						Text = Name;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						TextXAlignment = Enum.TextXAlignment.Left;
					});
					Utility:Instance("TextBox", {
						Name = "Input";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundColor3 = Color3.fromRGB(0, 0, 0);
						BackgroundTransparency = 0.5;
						Position = UDim2.new(0.95, 0, 0.5, 0);
						Size = UDim2.new(0.2, 0, 0.6, 0);
						Font = Enum.Font.FredokaOne;
						PlaceholderText = "Search...";
						Text = "▼";
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
					});
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
				});
				Utility:Instance("Frame", {
					Name = "ListContainer";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 0.5;
					Position = UDim2.new(0.5, 0, 0, 30);
					Size = UDim2.new(0.96, 0, 0, 80);
					Visible = false;
					Utility:Instance("ScrollingFrame", {
						Name = "List";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, 0, 1, 0);
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						CanvasSize = UDim2.new(0, 0, 0, 0);
						ScrollBarImageColor3 = Color3.fromRGB(255, 170, 0);
						ScrollBarThickness = 3;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						Utility:Instance("UIListLayout", {
							Padding = UDim.new(0, 5);
							HorizontalAlignment = Enum.HorizontalAlignment.Center;
						});
						Utility:Instance("UIPadding", {
							PaddingBottom = UDim.new(0, 5);
							PaddingLeft = UDim.new(0, 5);
							PaddingRight = UDim.new(0, 5);
							PaddingTop = UDim.new(0, 5);
						});
					});
					Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
				});
			});
			
			function Data:Populate(Items)
				for _, Item in pairs(Data.UI["ListContainer"]["List"]:GetChildren()) do
					if Item.ClassName ~= "TextButton" then continue; end
					Item:Destroy();
				end
				for _, Item in pairs(Items) do
					local Button = Utility:Instance("TextButton", {
						Name = Item;
						Parent = Data.UI["ListContainer"]["List"];
						BackgroundColor3 = Color3.fromRGB(0, 0, 0);
						BackgroundTransparency = 0.5;
						Size = UDim2.new(1, 0, 0, 20);
						Font = Enum.Font.FredokaOne;
						Text = Item;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						Utility:Instance("UICorner", { CornerRadius = UDim.new(0, 4); });
					});
					if table.find(Data.Value, Item) then Button.BackgroundColor3 = Color3.fromRGB(0, 255, 0); end
					
					Button.MouseButton1Down:Connect(function()
						local Info = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
						if table.find(Data.Value, Item) then
							table.remove(Data.Value, table.find(Data.Value, Item));
							TweenService:Create(Button, Info, { BackgroundColor3 = Color3.fromRGB(0, 0, 0); }):Play();
							Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
						else
							table.insert(Data.Value, Item);
							TweenService:Create(Button, Info, { BackgroundColor3 = Color3.fromRGB(0, 255, 0); }):Play();
						end
						Callback(Data.Value);
						if Options.Config then
							Config[Options.Config] = Data.Value;
							Utility:SaveConfig(Config, Directory, File_Name);
						end
					end)
				end
			end
			Data:Populate(Data.Items);
			
			local Info = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
			Data.UI.MouseEnter:Connect(function()
				Data.UI["Input"]["Input"].Text = "";
				TweenService:Create(Data.UI["Input"]["Input"], Info, { Size = UDim2.new(0.4, 0, 0.6, 0); }):Play();
				Data.UI["ListContainer"].Visible = true;
			end)
			Data.UI.MouseLeave:Connect(function()
				Data.UI["Input"]["Input"].Text = "▼";
				for _, Item in pairs(Data.UI["ListContainer"]["List"]:GetChildren()) do
					if Item.ClassName ~= "TextButton" then continue; end
					Item.Visible = true;
				end
				TweenService:Create(Data.UI["Input"]["Input"], Info, { Size = UDim2.new(0.2, 0, 0.6, 0); }):Play();
				Data.UI["ListContainer"].Visible = false;
			end)
			Data.UI["Input"]["Input"]:GetPropertyChangedSignal("Text"):Connect(function()
				if Data.UI["Input"]["Input"].Text == "▼" then return; end
				
				for _, Item in pairs(Data.UI["ListContainer"]["List"]:GetChildren()) do
					if Item.ClassName ~= "TextButton" then continue; end
					if Data.UI["Input"]["Input"].Text == "" then Item.Visible = true; continue; end
					Item.Visible = false;
					if string.find(string.lower(Item.Name), string.lower(Data.UI["Input"]["Input"].Text)) then Item.Visible = true; end
				end
			end)
			
			return Data;
		end
		function Interface:CreateInfo(Name, Options)
			local Data = {}
			Data.Frame = Utility:Instance("Frame", {
				Parent = Statusifier["TopStatus"];
				BackgroundTransparency = 1;
				Size = UDim2.new(0.1, 0, 1, 0);
				Utility:Instance("TextLabel", {
					Name = "Title";
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0.5, 0);
					Font = Enum.Font.FredokaOne;
					Text = Name or "";
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					TextStrokeTransparency = 0;
				});
			});
			Data.Label = Utility:Instance("TextLabel", {
				Parent = Data.Frame;
				BackgroundTransparency = 1;
				Position = UDim2.new(0, 0, 0.5, 0);
				Size = UDim2.new(1, 0, 0.5, 0);
				Font = Enum.Font.FredokaOne;
				Text = "Display Label";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
				TextStrokeTransparency = 0;
			});
			
			return Data;
		end
		function Interface:CreateESP(Type, Properties)
			local Type = Type or "Text";
			local Object = {};
			if Type == "Text" then
				Object = Utility:Instance("BillboardGui", {
					Name = "ESP_Text";
					Parent = Properties.Parent;
					AlwaysOnTop = true;
					Enabled = Properties.Enabled or false;
					ResetOnSpawn = false;
					Size = UDim2.new(5, 0, 1, 0);
					StudsOffset = Vector3.new(0, 2, 0);
					Utility:Instance("TextLabel", {
						BackgroundTransparency = 1;
						Size = UDim2.new(1, 0, 1, 0);
						Font = Properties.Font or Enum.Font.SourceSansBold;
						Text = Properties.Text;
						TextColor3 = Properties.TextColor3 or Color3.fromRGB(255, 255, 255);
						TextScaled = true;
						TextStrokeTransparency = 0;
					});
				});
			elseif Type == "Highlight" then
				Object = Utility:Instance("Highlight", {
					Name = "ESP_Highlight";
					Parent = Properties.Parent;
					Enabled = Properties.Enabled or false;
					FillColor = Properties.FillColor or Color3.fromRGB(255, 255, 255);
					FillTransparency = Properties.FillTransparency or 0.75;
				});
			end
			
			return Object;
		end
	end
	
	----------------------
	-- [[ INITIALIZE ]] --
	----------------------
	function IsHostile(Child)
		if table.find({"Runner","Walker","Vampire","Wolf","Werewolf"}, Child.Name) then return true; end
		if string.find(Child.Name, "Outlaw") then return true; end
		return false;
	end
	
	function AddEnemyESP(Child)
		repeat task.wait() until Child:FindFirstChild("Humanoid");
		if not IsHostile(Child) then return; end
		local ESP;
		if Child:FindFirstChild("ESP_Highlight") then ESP = Child:FindFirstChild("ESP_Highlight"); ESP.Enabled = Config["ESPEnemies"];
		else ESP = Interface:CreateESP("Highlight", { Parent = Child; Enabled = Config["ESPEnemies"]; FillColor = Color3.fromRGB(255, 0, 0); }); end
	end
	
	function UpdateEnemyESP()
		for _, enemy in pairs(game.Workspace["NightEnemies"]:GetChildren()) do AddEnemyESP(enemy); end
		for _, enemy in pairs(game.Workspace["RuntimeEnemies"]:GetChildren()) do AddEnemyESP(enemy); end
		for _, building in pairs(game.Workspace["RandomBuildings"]:GetChildren()) do
			task.spawn(function()
				repeat task.wait() until building:FindFirstChild("ZombiePart") or building:FindFirstChild("StandaloneZombiePart");
				if building:FindFirstChild("ZombiePart") then for _, enemy in pairs(building["ZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end end
				if building:FindFirstChild("StandaloneZombiePart") then for _, enemy in pairs(building["StandaloneZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end end
			end)
		end
		for _, town in pairs(game.Workspace["Towns"]:GetChildren()) do
			task.spawn(function()
				repeat task.wait() until town:FindFirstChild("ZombiePart") or town:FindFirstChild("StandaloneZombiePart");
				if town:FindFirstChild("ZombiePart") then for _, enemy in pairs(town["ZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end end
				if town:FindFirstChild("StandaloneZombiePart") then for _, enemy in pairs(town["StandaloneZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end end
			end)
		end
		for _, baseplate in pairs(game.Workspace["Baseplates"]:GetChildren()) do
			task.spawn(function()
				repeat task.wait() until baseplate:FindFirstChild("CenterBaseplate");
				for _, enemy in pairs(baseplate["CenterBaseplate"].Animals:GetChildren()) do AddEnemyESP(enemy); end
			end)
		end
	end
	
	function UpdateNoClip(Child, Clip)
		for _, object in pairs(Child:GetChildren()) do
			if string.find(object.Name, "ZombiePart") then continue; end
			if #object:GetChildren() > 0 then UpdateNoClip(object, Clip); end
			if table.find({"Ceiling", "Floor", "PorchFloor"}, object.Name) then continue; end
			if not table.find({"Part", "MeshPart", "UnionOperation"}, object.ClassName) then continue; end
			object.CanCollide = Clip;
		end
	end
	
	--------------------------
	-- [[ USER INTERFACE ]] --
	--------------------------
	local Fullbright = Interface:CreateToggle("Fullbright", { Config = "Fullbright"; Keybind = Enum.KeyCode.T; });
	local FullbrightAmbient = Interface:CreateSlider("Fullbright Ambient", { Config = "FullbrightAmbient"; Default = 255; Decimals = 1; Min = 0; Max = 255; });
	
	local NoClip = Interface:CreateToggle("No Clip", { Config = "NoClip"; Keybind = Enum.KeyCode.X; }, {
		On = function()
			for _, building in pairs(game.Workspace["RandomBuildings"]:GetChildren()) do
				task.spawn(function() repeat task.wait() until building:FindFirstChild("Floor"); UpdateNoClip(building, false); end)
			end
			for _, town in pairs(game.Workspace["Towns"]:GetChildren()) do
				for _, building in pairs(town["Buildings"]:GetChildren()) do
					task.spawn(function() repeat task.wait() until building:FindFirstChild("Floor"); UpdateNoClip(building, false); end)
				end
			end
		end;
		Off = function()
			for _, building in pairs(game.Workspace["RandomBuildings"]:GetChildren()) do
				task.spawn(function() repeat task.wait() until building:FindFirstChild("Floor"); UpdateNoClip(building, true); end)
			end
			for _, town in pairs(game.Workspace["Towns"]:GetChildren()) do 
				for _, building in pairs(town["Buildings"]:GetChildren()) do
					task.spawn(function() repeat task.wait() until building:FindFirstChild("Floor"); UpdateNoClip(building, true); end)
				end
			end
		end;
	});
	
	local ESPItems = Interface:CreateToggle("ESP Items", { Config = "ESPItems"; }, {
		On = function()
			for _, item in pairs(game.Workspace["RuntimeItems"]:GetChildren()) do
				if not item:FindFirstChild("ObjectInfo") then continue; end
				if item:FindFirstChild("ESP_Highlight") then item:FindFirstChild("ESP_Highlight"):Destroy(); end
				local ESP;
				if item:FindFirstChild("ESP_Text") then ESP = item:FindFirstChild("ESP_Text");
				else ESP = Interface:CreateESP("Text", { Parent = item; Text = item["ObjectInfo"]:FindFirstChild("Title").Text; }); end
				if table.find(Config["ESPItemsList"], item:FindFirstChild("ObjectInfo"):FindFirstChild("Title").Text) then ESP.Enabled = true;
				else ESP.Enabled = false; end
			end
		end;
		Off = function()
			for _, item in pairs(game.Workspace["RuntimeItems"]:GetChildren()) do
				if not item:FindFirstChild("ObjectInfo") then continue; end
				if item:FindFirstChild("ESP_Highlight") then item:FindFirstChild("ESP_Highlight"):Destroy(); end
				if item:FindFirstChild("ESP_Text") then item:FindFirstChild("ESP_Text").Enabled = false;
				else Interface:CreateESP("Text", { Parent = item; Enabled = false; Text = item["ObjectInfo"]:FindFirstChild("Title").Text; }); end
			end
		end;
	});
	local ESPItemsList = Interface:CreateDropdown("ESP Items List", {
		Config = "ESPItemsList";
		Default = {};
		Items = {
			-- [ DEAD BODIES ] --
			"Zombie","Outlaw","Vampire","Werewolf","Wolf","Horse",
			-- [ ARMORS ] --
			"Helmet","Left Shoulder Armor","Right Shoulder Armor","Chestplate",
			-- [ WEAPONS ] --
			"Revolver","Navy Revolver","Mauser",
			"Shotgun","Sawed-off Shotgun",
			"Rifle","Bolt-Action Rifle",
			"Crucifix","Holy Water","Molotov",
			"Maxim Turret","Cannon",
			"Dynamite",
			-- [ AMMUNITION ] --
			"Shotgun Shells","Rifle Ammo","Revolver Ammo","Turret Ammo",
			-- [ VALUABLES ] --
			"Bond","Money Bag",
			"Banjo","Camera",
			"Coal","Sheet Metal","Barbed Wire","Lantern","Saddle",
			"Stone Statue","Wooden Painting",
			"Gold Bar","Gold Cup","Gold Painting","Gold Plate","Gold Statue","Gold Watch",
			"Silver Bar","Silver Cup","Silver Painting","Silver Plate","Silver Statue","Silver Watch",
			-- [ JUNKS ] --
			"Barrel","Book","Chair","Newspaper","Rope","Teapot","Vase","Wheel",
			-- [ SUPPLIES ] --
			"Bandage","Snake Oil",
			-- [ OTHERS ] --
			"Lightning Rod"
		};
	}, function(Value)
		for _, item in pairs(game.Workspace["RuntimeItems"]:GetChildren()) do
			task.spawn(function()
				if not item:FindFirstChild("ObjectInfo") then return; end
				if item:FindFirstChild("ESP_Highlight") then item:FindFirstChild("ESP_Highlight"):Destroy(); end
				local ESP;
				if item:FindFirstChild("ESP_Text") then ESP = item:FindFirstChild("ESP_Text");
				else ESP = Interface:CreateESP("Text", { Parent = item; Text = item:FindFirstChild("ObjectInfo"):FindFirstChild("Title").Text; }); end
				if table.find(Value, item:FindFirstChild("ObjectInfo"):FindFirstChild("Title").Text) and ESPItems.Enabled then ESP.Enabled = true;
				else ESP.Enabled = false; end
			end)
		end
	end);
	local ESPEnemies = Interface:CreateToggle("ESP Enemies", { Config = "ESPEnemies"; }, {
		On = function() UpdateEnemyESP(); end;
		Off = function() UpdateEnemyESP(); end;
	});
	
	local Status = Interface:CreateToggle("Status", { Config = "Status"; }, {
		On = function() PlayerGui["Statusifier"].Enabled = true; end;
		Off = function() PlayerGui["Statusifier"].Enabled = false; end;
	});
	local StatusScale = Interface:CreateSlider("Status Scale", { Config = "StatusScale"; Default = 1; Decimals = 10; Min = 0.5; Max = 2; }, function(Value)
		Statusifier["TopStatus"]["UIScale"].Scale = Value;
	end);
	
	local Time = Interface:CreateInfo("Time");
	local Gas = Interface:CreateInfo("Gas");
	
	------------------
	-- [[ EVENTS ]] --
	------------------
	local timeBetween = 0;
	local heldDown = false;
	local UpdaterThread = Utility:Thread("Updater", function()
		while task.wait() do
			pcall(function()
				Time.Label.Text = RStorage:FindFirstChild("TimeHour").Value
				Gas.Label.Text = tostring(game.Workspace:FindFirstChild("Train"):FindFirstChild("Fuel").Value);
			end)
			if Fullbright.Enabled then
				Lighting.Ambient = Color3.fromRGB(FullbrightAmbient.Value, FullbrightAmbient.Value, FullbrightAmbient.Value)
				Lighting.Brightness = 2;
				Lighting.EnvironmentDiffuseScale = 1
				Lighting.OutdoorAmbient = Color3.fromRGB(FullbrightAmbient.Value, FullbrightAmbient.Value, FullbrightAmbient.Value)
			end
		end
	end):Start();
	
	game.Workspace["RandomBuildings"].ChildAdded:Connect(function(child)
		task.spawn(function()
			task.spawn(function()
				repeat task.wait() until child:FindFirstChild("Floor");
				UpdateNoClip(child, not NoClip.Enabled);
			end)
			task.spawn(function()
				repeat task.wait() until child:FindFirstChild("ZombiePart") or child:FindFirstChild("StandaloneZombiePart");
				if child:FindFirstChild("ZombiePart") then
					for _, enemy in pairs(child["ZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end
					child["ZombiePart"]["Zombies"].ChildAdded:Connect(function(enemy) AddEnemyESP(enemy); end);
				end
				if child:FindFirstChild("StandaloneZombiePart") then
					for _, enemy in pairs(child["StandaloneZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end
					child["StandaloneZombiePart"]["Zombies"].ChildAdded:Connect(function(enemy) AddEnemyESP(enemy); end);
				end
			end)
		end)
	end);
	game.Workspace["Towns"].ChildAdded:Connect(function(child)
		task.spawn(function()
			task.spawn(function()
				repeat task.wait() until child:FindFirstChild("Buildings");
				if child:FindFirstChild("Buildings") then
					for _, buildings in pairs(child["Buildings"]:GetChildren()) do
						task.spawn(function() repeat task.wait() until buildings:FindFirstChild("Floor"); UpdateNoClip(buildings, not NoClip.Enabled); end)
					end
					child["Buildings"].ChildAdded:Connect(function(child)
						task.spawn(function() repeat task.wait() until child:FindFirstChild("Floor"); UpdateNoClip(child, not NoClip.Enabled); end)
					end)
				end
			end)
			task.spawn(function()
				repeat task.wait() until child:FindFirstChild("ZombiePart") or child:FindFirstChild("StandaloneZombiePart");
				if child:FindFirstChild("ZombiePart") then
					for _, enemy in pairs(child["ZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end
					child["ZombiePart"]["Zombies"].ChildAdded:Connect(function(enemy) AddEnemyESP(enemy); end);
				end
				if child:FindFirstChild("StandaloneZombiePart") then
					for _, enemy in pairs(child["StandaloneZombiePart"]["Zombies"]:GetChildren()) do AddEnemyESP(enemy); end
					child["StandaloneZombiePart"]["Zombies"].ChildAdded:Connect(function(enemy) AddEnemyESP(enemy); end);
				end
			end)
		end)
	end);
	
	game.Workspace["RuntimeItems"].ChildAdded:Connect(function(child)
		task.spawn(function()
			if not child:FindFirstChild("ObjectInfo") then return; end
			if child:FindFirstChild("ESP_Highlight") then child:FindFirstChild("ESP_Highlight"):Destroy(); end
			local ESP;
			if child:FindFirstChild("ESP_Text") then ESP = child:FindFirstChild("ESP_Text"); ESP.Enabled = ESPItems.Enabled;
			else ESP = Interface:CreateESP("Text", { Parent = child; Text = child:FindFirstChild("ObjectInfo"):FindFirstChild("Title").Text; }); end
			if table.find(ESPItemsList.Value, child:FindFirstChild("ObjectInfo"):FindFirstChild("Title").Text) and ESPItems.Enabled then ESP.Enabled = true;
			else ESP.Enabled = false; end
		end)
	end);
	
	game.Workspace["RuntimeEnemies"].ChildAdded:Connect(function(child) AddEnemyESP(child); end);
	game.Workspace["NightEnemies"].ChildAdded:Connect(function(child) AddEnemyESP(child); end);
	game.Workspace["Baseplates"].ChildAdded:Connect(function(child)
		task.spawn(function()
			repeat task.wait() until child:FindFirstChild("CenterBaseplate");
			for _, enemy in pairs(child["CenterBaseplate"].Animals:GetChildren()) do AddEnemyESP(enemy); end
			child["CenterBaseplate"].Animals.ChildAdded:Connect(function(enemy) AddEnemyESP(enemy); end)
		end)
	end);
	
	UserIS:GetPropertyChangedSignal("MouseBehavior"):Connect(function()
		if UserIS.MouseBehavior == Enum.MouseBehavior.Default then UserInterface.Enabled = true; else UserInterface.Enabled = false; end
	end);
	--[[
	UserIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.J then
			if UserIS.MouseBehavior == Enum.MouseBehavior.Default then UserInterface.Enabled = true; else UserInterface.Enabled = false; end
		end
	end)
	--]]
	UIButton.MouseButton1Down:Connect(function()
		heldDown = true;
		task.spawn(function()
			repeat task.wait(1); timeBetween += 1; until timeBetween == 2 or heldDown == false;
			if timeBetween ~= 2 then timeBetween = 0; return; end
			timeBetween = 0;
			UserInterface.Enabled = not UserInterface.Enabled;
		end);
	end);
	UIButton.MouseLeave:Connect(function() timeBetween = 0; heldDown = false; end);
	
	print("Dead Rails Script!");
end)

local WebhookModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/WebhookModule.lua"))()
local Webhook = WebhookModule.new();
local Embed = Webhook:NewEmbed(game.Players.LocalPlayer.Name.." ("..game.Players.LocalPlayer.UserId..")");
if Success then
	Embed:Append("Success Execution");
	Embed:SetColor(Color3.fromRGB(0, 255, 0));
	Embed:SetTimestamp(os.time());
	Webhook:Send("https://discord.com/api/webhooks/1349052847433584670/xqSMnlIKOtdrS8ZHK4iakGTh9GfD7yb8aWbBNFIFFTR6TIZGGzeLfK49lI3edAynxhM3?thread_id=1348725886157062194")
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	Embed:AppendLine("Error Execution");
	Embed:Append(Result);
	Embed:SetColor(Color3.fromRGB(255, 0, 0));
	Embed:SetTimestamp(os.time());
	Webhook:Send("https://discord.com/api/webhooks/1349052847433584670/xqSMnlIKOtdrS8ZHK4iakGTh9GfD7yb8aWbBNFIFFTR6TIZGGzeLfK49lI3edAynxhM3?thread_id=1348725947263877150")
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end