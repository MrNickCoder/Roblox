if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 7018190066 then return; end

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
local TweenService = game:GetService("TweenService");

local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;

if game.PlaceId == 116495829188952 then StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "No Loading in Lobby!"; }); return; end

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Dead Rails Script!"; });
local Success, Result = pcall(function()
	print("Loading Dead Rails Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("HumanoidRootPart");
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
		
		["ESP"] = false;
		["ESPItems"] = {};
		["ESPEnemies"] = {};
		
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
			local Value = Options and Options.Default or Options.Min
			if Options and Config[Options.Config] then Value = Config[Options.Config] end
			local Callback = Callback or function() end;
		end
		function Interface:CreateDropdown(Name, Options, Callback)
			
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
			});
			
			return Data;
		end
		function Interface:CreateESP(Text, Properties)
			local Data = {};
			
			return Data;
		end
	end
	
	----------------------
	-- [[ INITIALIZE ]] --
	----------------------
	
	
	--------------------------
	-- [[ USER INTERFACE ]] --
	--------------------------
	local Fullbright = Interface:CreateToggle("Fullbright", { Config = "Fullbright"; Keybind = Enum.KeyCode.T; }, {
		On = function() end;
		Off = function() end;
	});
	
	local NoClip = Interface:CreateToggle("No Clip", { Config = "NoClip"; Keybind = Enum.KeyCode.X; }, {
		On = function() end;
		Off = function() end;
	});
	
	local ESP = Interface:CreateToggle("ESP", { Config = "ESP"; }, {
		On = function() end;
		Off = function() end;
	});
	
	local Status = Interface:CreateToggle("Status", { Config = "Status"; }, {
		On = function() PlayerGui["Statusifier"].Enabled = true; end;
		Off = function() PlayerGui["Statusifier"].Enabled = false; end;
	});
	
	local Time = Interface:CreateInfo("Time")
	local Gas = Interface:CreateInfo("Gas")
	
	------------------
	-- [[ EVENTS ]] --
	------------------
	local timeBetween = 0;
	local heldDown = false;
	local UpdaterThread = Utility:Thread("Updater", function()
		while task.wait() do
			if Fullbright.Enabled then
				Lighting.Ambient = Color3.fromRGB(255, 255, 255)
				Lighting.Brightness = 2;
				Lighting.EnvironmentDiffuseScale = 1
				Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			end
		end
	end):Start();
	
	UserIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.RightControl then
			if UserIS.MouseBehavior == Enum.MouseBehavior.LockCenter then UserInterface.Enabled = true; else UserInterface.Enabled = false; end
		end
	end)
	UIButton.MouseButton1Down:Connect(function()
		heldDown = true;
		task.spawn(function()
			repeat task.wait(1); timeBetween += 1; until timeBetween == 2 or heldDown == false;
			if timeBetween ~= 2 then timeBetween = 0; return; end
			timeBetween = 0;
			UserInterface.Enabled = not UserInterface.Enabled;
		end)
	end)
	UIButton.MouseLeave:Connect(function() timeBetween = 0; heldDown = 0; end)
	
	print("Dead Rails Script!");
end)

local WebhookModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/WebhookModule.lua"))()
local Webhook = WebhookModule.new();
local Embed = Webhook:NewEmbed(game.Players.LocalPlayer.Name.." ("..game.Players.LocalPlayer.UserId..")");
if Success then
	Embed:Append("Success Execution");
	Embed:SetColor(Color3.fromRGB(0, 255, 0));
	Embed:SetTimestamp(os.time());
	--Webhook:Send("https://discord.com/api/webhooks/1343691173667143751/XVEDb4JMMawvoQ9lXryspHxzuNDJ61b9UaaODQgbIf9Zqkbxgg52XS_1-PfQ7HlV5KlU")
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	Embed:AppendLine("Error Execution");
	Embed:Append(Result);
	Embed:SetColor(Color3.fromRGB(255, 0, 0));
	Embed:SetTimestamp(os.time());
	--Webhook:Send("https://discord.com/api/webhooks/1343691173667143751/XVEDb4JMMawvoQ9lXryspHxzuNDJ61b9UaaODQgbIf9Zqkbxgg52XS_1-PfQ7HlV5KlU")
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end