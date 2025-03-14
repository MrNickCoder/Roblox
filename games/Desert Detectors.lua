if not game:IsLoaded() then game.Loaded:Wait() end
if game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/".. game.PlaceId .."/universe")).universeId ~= 7177812860 then return; end

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

StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Loading Desert Detectors Script!"; });
local Success, Result = pcall(function()
    print("Loading Desert Detectors Script!");
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name);
	repeat task.wait(.1) until game.Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("HumanoidRootPart");
	repeat task.wait(.1) until game.Workspace:FindFirstChild("Loot");
    repeat task.wait(.1) until PlayerGui:FindFirstChild("Menu_UI");
    repeat task.wait(.1) until PlayerGui["Menu_UI"]:FindFirstChild("Frame");
    repeat task.wait(.1) until PlayerGui["Menu_UI"]["Frame"]:FindFirstChild("Interior");
    repeat task.wait(.1) until PlayerGui["Menu_UI"]["Frame"]["Interior"]:FindFirstChild("ScrollingFrame");
    repeat task.wait(.1) until PlayerGui["Menu_UI"]["Frame"]["Interior"]["ScrollingFrame"]:FindFirstChild("Frame");
    repeat task.wait(.1) until RStorage:FindFirstChild("Objects");
	task.wait(5);

    local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/UtilityModule.lua"))()
	
	------------------
	-- [[ CONFIG ]] --
	------------------
    local Config = {
        ["ESP"] = false;
        ["ESPList"] = {};
    }
    local Directory = "Paradoxium/Desert Detectors"
	local File_Name = "Settings.json"
	Config = Utility:LoadConfig(Config, Directory, File_Name);

	if PlayerGui:FindFirstChild("Desert Detector") then PlayerGui:FindFirstChild("Desert Detector"):Destroy() end;

    ---------------------
	-- [[ UTILITIES ]] --
	---------------------
    local UserInterface;
	if PlayerGui:FindFirstChild("Desert Detector") then
		UserInterface = PlayerGui:FindFirstChild("Desert Detector");
	else
		UserInterface = Utility:Instance("ScreenGui", {
			Name = "Desert Detector";
			Parent = PlayerGui;
            Enabled = false;
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
						Text = "Desert Detectors";
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

    local Interface = {}
    do
        function Interface:CreateToggle(Name, Options, Callback)
			local Enabled = Options and (Config[Options.Config] or Options.Default or false);
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
        function Interface:CreateDropdown(Name, Options, Callback)
			local Items = Options and Options.Items;
			local Value = Options and (Config[Options.Config] or Options.Default or {});
			local Multi = Options and Options.Multi or false;
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
			if UserIS.KeyboardEnabled and UserIS.MouseEnabled then
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
			end
			if UserIS.TouchEnabled and not UserIS.KeyboardEnabled and not UserIS.MouseEnabled then
				Data.UI["Input"]["Input"].Text = "";
				Data.UI["Input"]["Input"].Size = UDim2.new(0.4, 0, 0.6, 0);
				Data.UI["ListContainer"].Visible = true;
			end

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
        function Interface:CreateESP(Properties)
			return Utility:Instance("Highlight", {
                Name = "ESP";
                Parent = Properties.Parent;
                Enabled = Properties.Enabled or false;
                FillColor = Properties.FillColor or Color3.fromRGB(255, 255, 255);
                FillTransparency = Properties.FillTransparency or 0.75;
            });
		end
    end

    ----------------------
	-- [[ INITIALIZE ]] --
	----------------------
    local Items = {};
    for _, item in pairs(RStorage["Objects"]:GetChildren()) do table.insert(Items, item.Name); end

    local UpdateESP = function()
		for _, Loot in pairs(game.Workspace["Loot"]:GetChildren()) do 
			local ESP;
			if Loot:FindFirstChild("ESP") then ESP = Loot["ESP"]
			else ESP = Interface:CreateESP({ Parent = Loot; FillColor = Color3.fromRGB(0, 220, 0); }); end

			if not Config["ESP"] then ESP.Enabled = false; continue; end
			if table.find(Config["ESPList"], Loot.Name) then ESP.Enabled = true; continue; end
			ESP.Enabled = false;
		end
    end

    --------------------------
	-- [[ USER INTERFACE ]] --
	--------------------------
    local ESP = Interface:CreateToggle("ESP", { Config = "ESP"; }, { On = UpdateESP; Off = UpdateESP; });
    local ESPList = Interface:CreateDropdown("ESP List", {
		Config = "ESPList";
		Default = {};
		Items = Items;
	}, UpdateESP);

    ------------------
	-- [[ EVENTS ]] --
	------------------
    local timeBetween = 0;
	local heldDown = false;
    game.Workspace["Loot"].ChildAdded:Connect(UpdateESP);
	game.Workspace["Loot"].ChildRemoved:Connect(UpdateESP);

    UserIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return; end
        if input.KeyCode == Enum.KeyCode.J then UserInterface.Enabled = not UserInterface.Enabled; end
    end)

    print("Desert Detectors Script!");
end)

local WebhookModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNickCoder/Roblox/refs/heads/main/modules/WebhookModule.lua"))();
local Webhook = WebhookModule.new();
local Embed = Webhook:NewEmbed(game.Players.LocalPlayer.Name.." ("..game.Players.LocalPlayer.UserId..")");
if Success then
	Embed:Append("Success Execution");
	Embed:SetColor(Color3.fromRGB(0, 255, 0));
	Embed:SetTimestamp(os.time());
	--Webhook:Send("https://discord.com/api/webhooks/1348458639886913676/4_VhSrcVKLiz2V3mkUgeoEPQV3AWiIOIrhhb4ZyN_YCxFgv6auOfA7SeXt5q6UjQIQyP?thread_id=1348457378907164722");
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Successfully Loaded Script!"; });
else
	Embed:AppendLine("Error Execution");
	Embed:Append(Result);
	Embed:SetColor(Color3.fromRGB(255, 0, 0));
	Embed:SetTimestamp(os.time());
	--Webhook:Send("https://discord.com/api/webhooks/1348458639886913676/4_VhSrcVKLiz2V3mkUgeoEPQV3AWiIOIrhhb4ZyN_YCxFgv6auOfA7SeXt5q6UjQIQyP?thread_id=1348457472645660703");
	StarterGui:SetCore("SendNotification", { Title = "Paradoxium"; Text = "Error Loading Script!"; });
	error(Result);
end