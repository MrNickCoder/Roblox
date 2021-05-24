--[[
	Created by: NickCoder
	Inspired by: Hololive
	Version: 1.0.0
--]]

----- [ SERVICES ] -----
local Players			= game:GetService("Players");
local RunService		= game:GetService("RunService");
local TweenService		= game:GetService("TweenService");
local UserInputService	= game:GetService("UserInputService");
local CoreGui			= game:GetService("CoreGui");

----- [ INITIALIZE ] -----
local Player = Players.LocalPlayer;
local PlayerGui = Player:FindFirstChild("PlayerGui");
local Mouse = Player:GetMouse();
local TweenInformation = TweenInfo.new

local Utility = {
	Settings = {
		Minimize = Enum.KeyCode.M;
		Pin = Enum.KeyCode.P;
	};
	Themes = {
		Main = {
			PrimaryColor		= Color3.fromRGB(170, 170, 255);
			SecondaryColor		= Color3.fromRGB(0, 85, 255);
			TertiaryColor		= Color3.fromRGB(255, 255, 255);

			TextColor			= Color3.fromRGB(0, 0, 0);
			TextStrokeColor		= Color3.fromRGB();
			TextStyle			= Enum.Font.Cartoon;
		};
		Pages = {
			ButtonColor			= Color3.fromRGB(0, 0, 255);
			PageColor			= Color3.fromRGB(170, 255, 255);
			
			TextColor			= Color3.fromRGB(255, 255, 255);
			TextStrokeColor		= Color3.fromRGB();
			TextStyle			= Enum.Font.Cartoon;
		};
		Section = {
			Background			= Color3.fromRGB(0, 170, 255);
			
			PrimaryColor		= Color3.fromRGB(255, 255,255);
			SecondaryColor		= Color3.fromRGB(170, 255, 255);
			TertiaryColor		= Color3.fromRGB(0, 0, 255);
			
			TextColor			= Color3.fromRGB(0, 0, 0);
			TextStrokeColor		= Color3.fromRGB();
			TextStyle			= Enum.Font.Cartoon;
		};
	};
	Minimized = false;
	Pinned = false;
}

do
	function Utility:Create(Name, Properties, Childrens)
		local Object = Instance.new(Name);
		
		for Index, Value in pairs(Properties or {}) do
			Object[Index] = Value;
		end
		
		for Index, Module in pairs(Childrens or {}) do
			Module.Parent = Object;
		end
		
		return Object;
	end
	
	function Utility:Tween(Object, Properties, Duration, ...)
		TweenService:Create(Object, TweenInformation(Duration, ...), Properties):Play();
	end
	
	function Utility:Wait()
		RunService.RenderStepped:Wait()
		return true
	end
	
	function Utility:Find(Table, Value) 
		for Index, Val in pairs(Table) do
			if Val == Value then
				return Index
			end
		end
	end

	function Utility:Sort(Pattern, Values)
		local New = {}
		Pattern = Pattern:lower()

		if Pattern == "" then
			return Values
		end

		for Index, Value in pairs(Values) do
			if tostring(Value):lower():find(Pattern) then
				table.insert(New, Value)
			end
		end

		return New
	end
	
	function Utility:ReplaceValues(OldTable, NewTable)
		local OldTable = OldTable or {};
		
		for Index, Values in next, NewTable do
			if typeof(Values) == "table" then
				Utility:ReplaceValues(OldTable[Index], Values);
			else
				OldTable[Index] = Values;
			end
		end
		
		return OldTable;
	end
	
	function Utility:CounterName(Table)
		local Name = tostring(#Table + 1);
		if string.len(Name) == 1 then Name = "00"..Name end
		if string.len(Name) == 2 then Name = "0"..Name end
		
		return Name
	end
	
	function Utility:InitializeKeybind()
		self.Keybinds = {}
		self.Ended = {}
		
		local Debounce;
		
		UserInputService.InputBegan:connect(function(Input)
			if self.Keybinds[Input.KeyCode] then
				for Index, Bind in pairs(self.Keybinds[Input.KeyCode]) do
					if Debounce then return end
					Debounce = true;
					
					Bind()
					
					wait(.2)
					Debounce = false;
				end
			end
		end)

		UserInputService.InputEnded:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				for Index, Callback in pairs(self.Ended) do
					Callback()
				end
			end
		end)
	end
	
	function Utility:BindToKey(Key, Callback)
		self.Keybinds[Key] = self.Keybinds[Key] or {}

		table.insert(self.Keybinds[Key], Callback)

		return {
			UnBind = function()
				for Index, Bind in pairs(self.Keybinds[Key]) do
					if Bind == Callback then
						table.remove(self.Keybinds[Key], Index)
					end
				end
			end
		}
	end
	
	function Utility:KeyPressed()
		local Key = UserInputService.InputBegan:Wait()

		while Key.UserInputType ~= Enum.UserInputType.Keyboard do
			Key = UserInputService.InputBegan:Wait()
		end

		wait()

		return Key
	end
	
	function Utility:GenerateCode()
		local Seed = math.randomseed(math.random());
		local Letters = "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
		
		local Code = "";
		
		for Count = 1, 6 do
			local Character = math.random(1, string.len(Letters));
			Code = Code + string.sub(Letters, Character, Character);
		end
		
		return Code
	end
	
	function Utility:DraggingEnabled(Frame, Parent)
		Parent = Parent or Frame;
		
		local Dragging = false;
		local DragInput, MousePos, FramePos;
		
		Frame.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Utility.Pinned then
				Dragging = true;
				MousePos = Input.Position;
				FramePos = Parent.Position;

				Input.Changed:connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false;
					end
				end)
			end
		end)
		
		Frame.InputChanged:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement and not Utility.Pinned then
				DragInput = Input;
			end
		end)

		UserInputService.InputChanged:connect(function(Input)
			if Input == DragInput and Dragging and not Utility.Pinned then
				local Delta = Input.Position - MousePos
				Parent.Position  = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y);
			end
		end)
	end
	
	function Utility:DraggingEnded(Callback)
		table.insert(self.Ended, Callback);
	end
end

----- [ CLASSES ] -----
local Library = {};
local Page = {};
local Section = {};

do
	Library.__index = Library;
	Page.__index = Page;
	Section.__index = Section;
	
	----- [ NEW CLASS ] -----
	function Library.new(Title, Settings, Themes)
		if Settings then Utility.Settings = Utility:ReplaceValues(Utility.Settings, Settings) end
		if Themes then Utility.Themes = Utility:ReplaceValues(Utility.Themes, Themes); print(Utility.Themes) end
		
		local Container = Utility:Create("ScreenGui", {
			Name = Title;
			Parent = PlayerGui;
		},{
			Utility:Create("Frame", {
				Name = "Main";
				BackgroundColor3 = Utility.Themes.Main.PrimaryColor;
				Position = UDim2.new(0.5, -300, 0.5, -200);
				Size = UDim2.new(0, 600, 0, 400);
				ZIndex = 1000;
				ClipsDescendants = true;
			},{
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("Frame", {
					Name = "Topbar";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
					Position = UDim2.new(0.5, 0, 0, 0);
					Size = UDim2.new(1, 0, 0, 30);
					ZIndex = 1015;
				},{
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					});
					Utility:Create("Frame", {
						Name = "ExtraBackground";
						AnchorPoint = Vector2.new(0.5, 1);
						BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 1, 0);
						Size = UDim2.new(1, 0, 0, 15);
						ZIndex = 1015;
					});
					Utility:Create("ImageButton", {
						Name = "Holo";
						AnchorPoint = Vector2.new(0, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0, 0, 0.5, 0);
						Size = UDim2.new(0, 30, 0, 30);
						ZIndex = 1020;
						Image = "rbxassetid://6696950714";
					});
					Utility:Create("ImageButton", {
						Name = "Close";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(1, -5, 0.5, 0);
						Size = UDim2.new(0, 25, 0, 25);
						ZIndex = 1020;
						Image = "rbxassetid://54479706";
						ImageColor3 = Color3.fromRGB(255, 0, 0);
					});
					Utility:Create("ImageButton", {
						Name = "Minimize";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(1, -35, 0.5, 0);
						Size = UDim2.new(0, 25, 0, 25);
						ZIndex = 1020;
						Image = "rbxassetid://538059577";
						ImageColor3 = Color3.fromRGB(85, 255, 0);
					});
					Utility:Create("ImageButton", {
						Name = "Pin";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(1, -65, 0.5, 0);
						Size = UDim2.new(0, 25, 0, 25);
						ZIndex = 1020;
						Image = "rbxassetid://5122741784";
						ImageColor3 = Color3.fromRGB(255, 170, 0);
					});
					Utility:Create("TextLabel", {
						Name = "Title";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(0.85, 0, 0.8, 0);
						ZIndex = 1020;
						Font = Utility.Themes.Main.TextStyle;
						Text = Title;
						TextColor3 = Utility.Themes.Main.TextColor;
						TextScaled = true;
						TextXAlignment = Enum.TextXAlignment.Left;
					})
				});
				Utility:Create("Frame", {
					Name = "Sidebar";
					AnchorPoint = Vector2.new(0, 1);
					BackgroundColor3 = Utility.Themes.Main.TertiaryColor;
					Position = UDim2.new(0, 0, 1, 0);
					Size = UDim2.new(0, 20, 1, -20);
					ZIndex = 1010;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					});
					Utility:Create("ScrollingFrame", {
						Name = "Buttons";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(1, -10, 0.5, -10);
						Size = UDim2.new(0, 130, 0, 320);
						ZIndex = 1015;
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						BottomImage = "";
						CanvasSize = UDim2.new(0, 0, 0, 0);
						MidImage = "";
						ScrollBarThickness = 0;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						TopImage = "";
					}, {
						Utility:Create("UIListLayout", {
							Padding = UDim.new(0, 5);
							SortOrder = Enum.SortOrder.Name;
						});
					});
					Utility:Create("TextButton", {
						Name = "Settings";
						AnchorPoint = Vector2.new(1, 1);
						BackgroundColor3 = Utility.Themes.Pages.ButtonColor;
						BackgroundTransparency = 1;
						Position = UDim2.new(1, -10, 1, -10);
						Size = UDim2.new(0, 130, 0, 25);
						ZIndex = 1015;
						ClipsDescendants = true;
						Text = "";
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(1, 0);
						});
						Utility:Create("TextLabel", {
							Name = "Title";
							AnchorPoint = Vector2.new(0.5, 0.5);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Size = UDim2.new(0.8, 0, 0.8, 0);
							ZIndex = 1020;
							Font = Utility.Themes.Pages.TextStyle;
							Text = "Holo Settings";
							TextColor3 = Utility.Themes.Pages.TextColor;
							TextScaled = true;
						})
					})
				});
				Utility:Create("ScrollingFrame", {
					Name = "Pages";
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 10, 0.5, 15);
					Size = UDim2.new(0, 560, 0, 350);
					ZIndex = 1005;
					AutomaticCanvasSize = Enum.AutomaticSize.Y;
					BottomImage = "";
					CanvasSize = UDim2.new(0, 0, 0, 0);
					MidImage = "";
					ScrollBarThickness = 0;
					ScrollingDirection = Enum.ScrollingDirection.Y;
					ScrollingEnabled = false;
					TopImage = "";
				}, {
					Utility:Create("UIListLayout", {
						SortOrder = Enum.SortOrder.Name;
					});
					Utility:Create("Frame", {
						Name = "000";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Utility.Themes.Pages.PageColor;
						Size = UDim2.new(0, 560, 0, 350);
						ZIndex = 1006;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 20);
						});
						Utility:Create("ScrollingFrame", {
							Name = "Sections";
							AnchorPoint = Vector2.new(0.5, 0.5);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Size = UDim2.new(0, 540, 0, 330);
							ZIndex = 1007;
							AutomaticCanvasSize = Enum.AutomaticSize.Y;
							BottomImage = "";
							CanvasSize = UDim2.new(0, 0, 0, 0);
							MidImage = "";
							ScrollBarThickness = 0;
							ScrollingDirection = Enum.ScrollingDirection.Y;
							TopImage = "";
						}, {
							Utility:Create("UIListLayout", {
								Padding = UDim.new(0, 10);
								HorizontalAlignment = Enum.HorizontalAlignment.Center;
							})
						})
					});
					Utility:Create("Frame", {
						Name = "100";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Utility.Themes.Pages.PageColor;
						Size = UDim2.new(0, 560, 0, 350);
						ZIndex = 1006;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 20);
						});
						Utility:Create("ScrollingFrame", {
							Name = "Sections";
							AnchorPoint = Vector2.new(0.5, 0.5);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Size = UDim2.new(0, 540, 0, 330);
							ZIndex = 1007;
							AutomaticCanvasSize = Enum.AutomaticSize.Y;
							BottomImage = "";
							CanvasSize = UDim2.new(0, 0, 0, 0);
							MidImage = "";
							ScrollBarThickness = 0;
							ScrollingDirection = Enum.ScrollingDirection.Y;
							TopImage = "";
						}, {
							Utility:Create("UIListLayout", {
								Padding = UDim.new(0, 10);
								HorizontalAlignment = Enum.HorizontalAlignment.Center;
							})
						})
					})
				})
			})
		})
		
		Utility:InitializeKeybind();
		Utility:DraggingEnabled(Container.Main.Topbar, Container.Main);
		
		local Sidebar = Container.Main.Sidebar;
		Sidebar.MouseEnter:connect(function()
			Utility:Tween(Sidebar, {Size = UDim2.new(0, 150, 1, -20)}, .5);
			Utility:Tween(Sidebar.Settings, {BackgroundTransparency = 0}, .5);
		end)
		Sidebar.MouseLeave:connect(function()
			Utility:Tween(Sidebar, {Size = UDim2.new(0, 20, 1, -20)}, .5);
			Utility:Tween(Sidebar.Settings, {BackgroundTransparency = 1}, .5);
		end)
		
		Library:UpdateLibrary(Container, Utility.Minimized);
		local Debounce;
		
		Sidebar.Settings.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true;
				
				local ContainerLocation = ((#Container.Main.Pages:GetChildren() - 2) * 350);
				Utility:Tween(Container.Main.Pages, {CanvasPosition = Vector2.new(0, ContainerLocation)}, .5);
				
				wait(.2)
				Debounce = false
			end
		end)

		local Topbar = Container.Main.Topbar;
		Topbar.Holo.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true;

				Utility:Tween(Container.Main.Pages, {CanvasPosition = Vector2.new(0, 0)}, .5);

				wait(.2)
				Debounce = false
			end
		end)
		Topbar.Close.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true;
				
				
				
				wait(.2)
				Debounce = false
			end
		end)
		
		local Minimize = function()
			if Debounce then return end
			Debounce = true;

			Utility.Minimized = not Utility.Minimized;

			Library:UpdateLibrary(Container, Utility.Minimized);

			wait(.2)
			Debounce = false
		end
		local Pin = function()
			if Debounce then return end
			Debounce = true;

			Utility.Pinned = not Utility.Pinned;

			local Value = Utility.Pinned and "Enabled" or "Disabled";
			local Pin = {
				Enabled = {
					Rotation = -45;
					ImageColor3 = Color3.fromRGB(255, 0, 0);
				};
				Disabled = {
					Rotation = 0;
					ImageColor3 = Color3.fromRGB(255, 170, 0)
				}
			}
			Utility:Tween(Topbar.Pin, Pin[Value], 0.2);

			wait(.2)
			Debounce = false
		end
		
		Topbar.Minimize.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Minimize();
			end
		end)
		Topbar.Pin.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Pin();
			end
		end)
		Utility:BindToKey(Utility.Settings.Minimize, Minimize);
		Utility:BindToKey(Utility.Settings.Pin, Pin);
		
		return setmetatable({
			Container = Container;
			Sidebar = Sidebar;
			PagesButtons = Container.Main.Sidebar.Buttons;
			PagesContainers = Container.Main.Pages;
			Pages = {};
		}, Library)
	end
	
	function Page.new(Library, Title)
		local Button = Utility:Create("TextButton", {
			Name = Utility:CounterName(Library.Pages);
			Parent = Library.PagesButtons;
			AnchorPoint = Vector2.new(1, 1);
			BackgroundColor3 = Utility.Themes.Pages.ButtonColor;
			BackgroundTransparency = 1;
			Position = UDim2.new(1, -10, 1, -10);
			Size = UDim2.new(0, 130, 0, 25);
			ZIndex = 1015;
			ClipsDescendants = true;
			Text = "";
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(1, 0);
			});
			Utility:Create("TextLabel", {
				Name = "Title";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(0.8, 0, 0.8, 0);
				ZIndex = 1020;
				Font = Utility.Themes.Pages.TextStyle;
				Text = Title;
				TextColor3 = Utility.Themes.Pages.TextColor;
				TextScaled = true;
			})
		})
		
		local Container = Utility:Create("Frame", {
			Name = Utility:CounterName(Library.Pages);
			Parent = Library.PagesContainers;
			AnchorPoint = Vector2.new(0.5, 0.5);
			BackgroundColor3 = Utility.Themes.Pages.PageColor;
			Size = UDim2.new(0, 560, 0, 350);
			ZIndex = 1006;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("ScrollingFrame", {
				Name = "Sections";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(0, 540, 0, 330);
				ZIndex = 1007;
				AutomaticCanvasSize = Enum.AutomaticSize.Y;
				BottomImage = "";
				CanvasSize = UDim2.new(0, 0, 0, 0);
				MidImage = "";
				ScrollBarThickness = 0;
				ScrollingDirection = Enum.ScrollingDirection.Y;
				TopImage = "";
			}, {
				Utility:Create("UIListLayout", {
					Padding = UDim.new(0, 10);
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
				})
			})
		})
		
		Library.Sidebar.MouseEnter:connect(function()
			Utility:Tween(Button, {BackgroundTransparency = 0}, .5);
		end)
		Library.Sidebar.MouseLeave:connect(function()
			Utility:Tween(Button, {BackgroundTransparency = 1}, .5);
		end)
		
		return setmetatable({
			Library = Library;
			Container = Container;
			Button = Button;
			Sections = {};
		}, Page)
	end
	
	function Section.new(Page, Title)
		local Container = Utility:Create("Frame", {
			Name = Utility:CounterName(Page.Sections);
			Parent = Page.Container.Sections;
			BackgroundColor3 = Utility.Themes.Section.Background;
			Size = UDim2.new(1, 0, 0, 30);
			ZIndex = 1007;
			ClipsDescendants = true;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 10);
			});
			Utility:Create("TextLabel", {
				Name = "Title";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 0, 5);
				Size = UDim2.new(0.9, 0, 0, 20);
				ZIndex = 1007;
				Font = Utility.Themes.Section.TextStyle;
				Text = Title;
				TextColor3 = Utility.Themes.Section.TextColor;
				TextScaled = true;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			Utility:Create("Frame", {
				Name = "List";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundTransparency = 1;
				Position = UDim2.new(0.5, 0, 0, 30);
				Size = UDim2.new(1, -20, 0, 0);
				ZIndex = 1007;
				ClipsDescendants = true;
			}, {
				Utility:Create("UIListLayout", {
					Padding = UDim.new(0, 10);
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.Name;
				})
			})
		})
		
		return setmetatable({
			Page = Page;
			Container = Container;
			ColorPickers = {};
			Timers = {};
			Modules = {};
			Binds = {};
			Lists = {};
		}, Section)
	end
	
	function Library:AddPage(...)
		local Page = Page.new(self, ...);
		local Button = Page.Button;
		
		table.insert(self.Pages, Page)
		
		Button.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				self:SelectPage(Page)
			end
		end)
		
		return Page
	end
	
	function Page:AddSection(...)
		local Section = Section.new(self, ...)
		
		table.insert(self.Sections, Section)

		return Section
	end
	
	----- [ FUNCTIONS ] -----
	
	----- [ MODULES ] -----
	function Library:Notification(Title, Message, Type, Callback)
		if self.ActiveNotification then
			self.ActiveNotification = self.ActiveNotification();
		end
		
		local Notification = Utility:Create("Frame", {
			Name = "Notification";
			Parent = self.Container;
			AnchorPoint = Vector2.new(0.5, 0.5);
			BackgroundColor3 = Utility.Themes.Main.PrimaryColor;
			Position = UDim2.new(0.5, 0, 0.5, 0);
			Size = UDim2.new(0, 300, 0, 200);
			ZIndex = 1050;
			ClipsDescendants = true;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Topbar";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
				Position = UDim2.new(0.5, 0, 0, 0);
				Size = UDim2.new(1, 0, 0, 30);
				ZIndex = 1055;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(1, 0);
				});
				Utility:Create("Frame", {
					Name = "ExtraBackground";
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 1, 0);
					Size = UDim2.new(1, 0, 0, 15);
					ZIndex = 1055;
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0.5, 0);
					Size = UDim2.new(0.85, 0, 0.8, 0);
					ZIndex = 1060;
					Font = Utility.Themes.Main.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Main.TextColor;
					TextScaled = true;
					TextWrapped = true;
				})
			});
			Utility:Create("Frame", {
				Name = "Body";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundColor3 = Utility.Themes.Main.TertiaryColor;
				Position = UDim2.new(0.5, 0, 0, 40);
				Size = UDim2.new(1, -20, 1, -90);
				ZIndex = 1050;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 15);
				});
				Utility:Create("TextLabel", {
					Name = "Message";
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0.5, 0);
					Size = UDim2.new(1, -20, 1, -20);
					ZIndex = 1050;
					ClipsDescendants = true;
					Font = Utility.Themes.Main.TextStyle;
					Text = Message;
					TextScaled = true;
					TextWrapped = true;
				})
			});
			Utility:Create("Frame", {
				Name = "Buttons";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 0, 160);
				Size = UDim2.new(1, -20, 1, -170);
				ZIndex = 1050;
			}, {
				Utility:Create("UIGridLayout", {
					CellPadding = UDim2.new(0, 5, 0, 5);
					CellSize = UDim2.new(0, 135, 1, 0);
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.Name;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				})
			})
		})
		
		Utility:DraggingEnabled(Notification);
		
		Title = Title or "Notification";
		Message = Message or "";
		Type = Type or "Ok";
		
		local Types = {
			["Ok"] = {
				CellSize = UDim2.new(1, 0, 1, 0);
				Items = {"Ok"};
			};
			["YesNo"] = {
				CellSize = UDim2.new(0, 135, 1, 0);
				Items = {"Yes", "No"};
			};
			["AcceptDecline"] = {
				CellSize = UDim2.new(0, 135, 1, 0);
				Items = {"Accept", "Decline"};
			};
		}
		
		local Result = nil;
		local Active = true;
		local Close = function()
			if not Active then return end
			Active = false;
			
			Utility:Tween(Notification, {Size = UDim2.new(0, 350, 0, 250)}, 0.5);
			Utility:Tween(Notification.Body.Message, {TextTransparency = 1}, 0.5);
			wait(0.25)
			Utility:Tween(Notification, {Size = UDim2.new(0, 0, 0, 0)}, 0.25);
			
			wait(0.25)
			Notification:Destroy();
		end;
		
		Notification.Size = UDim2.new(0, 0, 0, 0);
		Notification.Position = UDim2.new(0.5, 0, 0.5, 0);
		Notification.Body.Message.TextTransparency = 1;

		Utility:Tween(Notification, {Size = UDim2.new(0, 350, 0, 250)}, 0.5);
		Utility:Tween(Notification.Body.Message, {TextTransparency = 0}, 0.5);
		
		Notification.Buttons.UIGridLayout.CellSize = Types[Type].CellSize;
		for Index, Items in pairs(Types[Type].Items) do
			local Button = Utility:Create("TextButton", {
				Name = Index.."_"..Items;
				Parent = Notification.Buttons;
				BackgroundColor3 = Utility.Themes.Pages.PageColor;
				BackgroundTransparency = 1;
				ZIndex = 1050;
				Font = Utility.Themes.Main.TextStyle;
				Text = Items;
				TextColor3 = Utility.Themes.Main.TextColor;
				TextSize = 20;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 10);
				})
			})
			
			Utility:Tween(Button, {BackgroundTransparency = 0}, 0.5);
			
			local Debounce;
			
			Button.InputBegan:connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if Debounce then return end
					Debounce = true;
					
					if not Active then return end
					if Callback then
						Callback(Items)
					end
					Result = Items

					Close()
					Utility:Tween(Button, {BackgroundTransparency = 1}, 0.5);
					
					wait(1)
					Debounce = false;
				end
			end)
			
		end
		
		wait(.25)
		Utility:Tween(Notification, {Size = UDim2.new(0, 300, 0, 200)}, 0.25);
		
		self.ActiveNotifcation = Close;
		
		repeat Utility:Wait() until Result ~= nil
		
		return Result
	end
	
	function Section:AddLabel(Title, Cleared)
		local Label = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			BackgroundTransparency = Cleared and 1 or 0;
			Size = UDim2.new(1, 0, 0, 30);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("TextLabel", {
				Name = "Label";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.Background;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				Font = Utility.Themes.Section.TextStyle;
				Text = Title;
				TextColor3 = Utility.Themes.Section.PrimaryColor;
				TextSize = Cleared and 25 or 20;
				TextWrapped = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
			})
		})
		
		table.insert(self.Modules, Label);
		self:Resize();
		
		return Label
	end
	
	function Section:AddButton(Title, Callback)
		local Button = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 30);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("TextButton", {
				Name = "Button";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				Font = Utility.Themes.Section.TextStyle;
				Text = Title;
				TextColor3 = Utility.Themes.Section.TextColor;
				TextSize = 20;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
			})
		})
		
		table.insert(self.Modules, Button);
		self:Resize();
		
		local Debounce;
		
		Button.Button.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true;
				
				Button.Button.TextSize = 0;
				Utility:Tween(Button.Button, {TextSize = 22}, 0.2)
				
				wait(0.2)
				Utility:Tween(Button.Button, {TextSize = 20}, 0.2)
				
				if Callback then
					Callback(function(...)
						self:UpdateButton(Button, ...);
					end)
				end
				
				wait(0.1)
				Debounce = false;
			end
		end)
		
		return Button
	end
	
	function Section:AddToggle(Title, Default, Callback)
		local Toggle = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 30);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Size = UDim2.new(0.8, 0, 1, 0);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				});
				Utility:Create("Frame", {
					Name = "Toggle";
					AnchorPoint = Vector2.new(1, 0);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(1, -2, 0, 2);
					Size = UDim2.new(0, 80, 1, -4);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 20);
					});
					Utility:Create("TextButton", {
						Name = "Button";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
						Position = UDim2.new(0.5, -20, 0.5, 0);
						Size = UDim2.new(0, 36, 1, -4);
						ZIndex = 1008;
						Text = "";
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 20);
						});
					})
				})
			})
		})
		
		table.insert(self.Modules, Toggle);
		self:Resize();
		
		local Active = Default;
		self:UpdateToggle(Toggle, nil, Active);
		local Debounce, Click;
		
		Click = function()
			if Debounce then return end
			Debounce = true;

			Active = not Active;
			self:UpdateToggle(Toggle, nil, Active);

			if Callback then
				Callback(Active, function(...)
					self:UpdateToggle(Toggle, ...);
				end)
			end

			wait(0.1)
			Debounce = false;
		end
		
		Toggle.Background.Toggle.Button.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Click()
			end
		end)
		Toggle.Background.Toggle.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Click()
			end
		end)
		
		return Toggle
	end
	
	function Section:AddTextbox(Title, Default, Callback)
		local Textbox = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 30);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0, 0.5);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 10, 0.5, 0);
					Size = UDim2.new(0.5, -10, 1, 0);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				Utility:Create("Frame", {
					Name = "Box";
					AnchorPoint = Vector2.new(1, 0.5);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(1, -2, 0.5, 0);
					Size = UDim2.new(0.5, -10, 1, -4);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 20);
					});
					Utility:Create("TextBox", {
						Name = "Input";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(0.9, 0, 1, -4);
						ZIndex = 1008;
						Font = Utility.Themes.Section.TextStyle;
						Text = Default or "";
						TextColor3 = Utility.Themes.Section.TextColor;
						TextSize = 16;
						TextWrapped = true;
						TextXAlignment = Enum.TextXAlignment.Right;
					})
				})
			})
		})

		table.insert(self.Modules, Textbox);
		self:Resize();
		
		local InputBox = Textbox.Background.Box.Input;
		local Debounce;
		
		Textbox.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true;
				
				InputBox:CaptureFocus();
				
				wait(.1)
				Debounce = false;
			end
		end)
		
		InputBox.Focused:connect(function()
			if Textbox.Background.Box.Size ~= UDim2.new(0.5, -10, 1, -4) then
				return
			end
			
			Utility:Tween(Textbox.Background.Box, {
				Size = UDim2.new(1, -4, 1, -4);
			}, 0.2);
			
			InputBox.Text = InputBox.Text;
			InputBox.TextXAlignment = Enum.TextXAlignment.Center;
		end)
		
		InputBox:GetPropertyChangedSignal("Text"):connect(function()
			if Callback then
				Callback(InputBox.Text, nil, function(...)
					self:UpdateTextbox(Textbox, ...);
				end)
			end
		end)
		
		InputBox.FocusLost:connect(function()
			InputBox.TextXAlignment = Enum.TextXAlignment.Right;
			Utility:Tween(Textbox.Background.Box, {
				Size = UDim2.new(0.5, -10, 1, -4)
			}, 0.2);
			
			if Callback then
				Callback(InputBox.Text, nil, function(...)
					self:UpdateTextbox(Textbox, ...);
				end)
			end
		end)
		
		return Textbox
	end
	
	function Section:AddKeybind(Title, Default, Callback, ChangedCallback)
		local Keybind = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 40);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 10, 0, 0);
					Size = UDim2.new(0.75, 0, 1, 0);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				Utility:Create("TextButton", {
					Name = "Keybind";
					AnchorPoint = Vector2.new(1, 0.5);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(1, -2, 0.5, 0);
					Size = UDim2.new(0, 80, 1, -4);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Default and Default.Name or "None";
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 20);
					});
				})
			})
		})
		
		table.insert(self.Modules, Keybind);
		self:Resize();
		
		self.Binds[Keybind] = {Callback = function()
			if Callback then
				Callback(function(...)
					self:UpdateKeybind(Keybind, ...);
				end)
			end
		end}
		
		if Default and Callback then
			self:UpdateKeybind(Keybind, nil, Default);
		end
		
		local Debounce;
		
		Keybind.Background.Keybind.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true;
				
				Utility:Tween(Keybind.Background.Keybind, {
					Size = UDim2.new(0, 80, 0.5, -4);
				}, 0.2);
				wait(0.1);
				Utility:Tween(Keybind.Background.Keybind, {
					Size = UDim2.new(0, 80, 1, -4);
				}, 0.1);
				
				if self.Binds[Keybind].Connection then
					self:UpdateKeybind(Keybind);
				end
				
				if Keybind.Background.Keybind.Text == "None" then
					Keybind.Background.Keybind.Text = "...";
					
					local Key = Utility:KeyPressed();
					
					self:UpdateKeybind(Keybind, nil, Key.KeyCode);
					
					if ChangedCallback then
						ChangedCallback(Key, function(...)
							self:UpdateKeybind(Keybind, ...);
						end)
					end
				end
				
				wait(.2)
				Debounce = false;
			end
		end)
		
		return Keybind
	end
	
	function Section:AddSlider(Title, Default, Min, Max, Callback)
		local Slider = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 60);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 18);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Size = UDim2.new(1, 0, 0, 30);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				});
				Utility:Create("TextBox", {
					Name = "Input";
					AnchorPoint = Vector2.new(1, 1);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(1, -4, 1, -4);
					Size = UDim2.new(0, 75, 0, 26);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Default or Min;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 16;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				});
				Utility:Create("Frame", {
					Name = "Slider";
					AnchorPoint = Vector2.new(0, 0.5);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(0, 15, 1, -17);
					Size = UDim2.new( 0, 300, 0, 6);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					});
					Utility:Create("Frame", {
						Name = "Design";
						BackgroundColor3 = Utility.Themes.Section.TertiaryColor;
						Size = UDim2.new(0.5, 0, 1, 0);
						ZIndex = 1008;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(1, 0);
						})
					});
					Utility:Create("TextButton", {
						Name = "Button";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Utility.Themes.Section.TertiaryColor;
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(0, 20, 0, 20);
						ZIndex = 1009;
						Text = "";
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(1, 0);
						})
					})
				})
			})
		})
		
		table.insert(self.Modules, Slider);
		self:Resize();
		
		local Allowed = {
			[""] = true;
			["-"] = true;
		}
		
		local Value = Default or Min
		local Dragging;
		
		local Callback = function(Value)
			if Callback then
				Callback(Value, function(...)
					self:UpdateSlider(Slider, ...);
				end)
			end
		end
		
		self:UpdateSlider(Slider, nil, Value, Min, Max);
		
		Utility:DraggingEnded(function()
			Dragging = false;
		end)
		
		Slider.MouseEnter:connect(function()
			Utility:Tween(Slider.Background.Slider.Button, {BackgroundTransparency = 0}, 0.1);
		end)
		
		Slider.MouseLeave:connect(function()
			Utility:Tween(Slider.Background.Slider.Button, {BackgroundTransparency = 1}, 0.2);
		end)
		
		Slider.Background.Slider.Button.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true;
				
				while Dragging do
					Value = self:UpdateSlider(Slider, nil, nil, Min, Max, Value);
					Callback(Value);

					Utility:Wait();
				end
				
			end
		end)
		
		Slider.Background.Input.FocusLost:connect(function()
			if not tonumber(Slider.Background.Input.Text) then
				Value = self:UpdateSlider(Slider, nil, Default or Min, Min, Max)
				Callback(Value)
			end
		end)
		
		Slider.Background.Input:GetPropertyChangedSignal("Text"):connect(function()
			local Text = Slider.Background.Input.Text
			
			if not Allowed[Text] and not tonumber(Text) then
				Slider.Background.Input.Text = Text:sub(1, #Text - 1)
			elseif not Allowed[Text] then	
				if tonumber(Text) > Max then Text = tostring(Max) end
				if tonumber(Text) < Min then Text = tostring(Min) end
				Value = self:UpdateSlider(Slider, nil, tonumber(Text) or Value, Min, Max)
				Callback(Value)
			end
		end)
		
		return Slider
	end
	
	function Section:AddDropdown(Title, List, Callback)
		local Dropdown = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 45);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 18);
				});
				Utility:Create("ImageButton", {
					Name = "Down";
					AnchorPoint = Vector2.new(1, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(1, -7, 0, 7);
					Size = UDim2.new(0, 24, 0, 24);
					ZIndex = 1008;
					Image = "rbxassetid://538059577";
					ImageColor3 = Utility.Themes.Section.Background;
				});
				Utility:Create("Frame", {
					Name = "Input";
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(0, 4, 0, 4);
					Size = UDim2.new(0.9, 0, 0, 30);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 18);
					});
					Utility:Create("TextBox", {
						Name = "Input";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, -20, 1, -6);
						ZIndex = 1008;
						Font = Utility.Themes.Section.TextStyle;
						Text = Title;
						TextColor3 = Utility.Themes.Section.TextColor;
						TextSize = 20;
						TextXAlignment = Enum.TextXAlignment.Left;
					})
				});
				Utility:Create("Frame", {
					Name = "List";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(0.5, 0, 0, 42);
					Size = UDim2.new(1, -14, 0, 0);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 18);
					});
					Utility:Create("ScrollingFrame", {
						Name = "List";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, -20, 1, -20);
						ZIndex = 1008;
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						BottomImage = "";
						CanvasSize = UDim2.new(0, 0, 0, 0);
						MidImage = "";
						ScrollBarThickness = 0;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						TopImage = "";
					}, {
						Utility:Create("UIListLayout", {
							Padding = UDim.new(0, 5);
							HorizontalAlignment = Enum.HorizontalAlignment.Center;
						});
					})
				})
			})
		})
		
		table.insert(self.Modules, Dropdown);
		self:Resize();
		
		local Focused, Debounce;
		
		List = List or {};
		
		Dropdown.Background.Down.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true
				
				if Dropdown.Background.Down.Rotation == 0 then
					self:UpdateDropdown(Dropdown, nil, List, Callback)
				else
					self:UpdateDropdown(Dropdown, nil, nil, Callback)
				end
				
				wait(.1)
				Debounce = false
			end
		end)
		
		Dropdown.Background.Input.Input.Focused:connect(function()
			if Dropdown.Background.Down.Rotation == 0 then
				self:UpdateDropdown(Dropdown, nil, List, Callback)
			end

			Focused = true
		end)
		
		Dropdown.Background.Input.Input.FocusLost:connect(function()
			Focused = false;
		end)
		
		Dropdown.Background.Input.Input:GetPropertyChangedSignal("Text"):connect(function()
			if Focused then
				local List = Utility:Sort(Dropdown.Background.Input.Input.Text, List);
				List = #List ~= 0 and List ;

				self:UpdateDropdown(Dropdown, nil, List, Callback);
			end
		end)
		
		Dropdown:GetPropertyChangedSignal("Size"):connect(function()
			self:Resize()
		end)
		
		return Dropdown
	end
	
	function Section:AddTimer(Title, Default, Interval, Callback)
		local Timer = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 70);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, 0);
					Size = UDim2.new(1, -50, 0, 30);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				});
				Utility:Create("Frame", {
					Name = "Interval";
					AnchorPoint = Vector2.new(0, 1);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(0, 25, 1, -5);
					Size = UDim2.new(0.3, 0, 0, 34);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					});
					Utility:Create("TextLabel", {
						Name = "Interval";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, -10, 1, -10);
						ZIndex = 1008;
						Font = Utility.Themes.Section.TextStyle;
						Text = "00:00:00";
						TextColor3 = Utility.Themes.Section.TextColor;
						TextSize = 25;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 5);
						})
					})
				});
				Utility:Create("TextButton", {
					Name = "Button";
					AnchorPoint = Vector2.new(1, 1);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(1, -25, 1, -7);
					Size = UDim2.new(0.4, 0, 0, 30);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = "Start";
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				})
			})
		})
		
		local Editor = Utility:Create("Frame", {
			Name = Title.."_Editor";
			Parent = self.Page.Library.Container;
			AnchorPoint = Vector2.new(0.5, 0.5);
			BackgroundColor3 = Utility.Themes.Main.PrimaryColor;
			Position = UDim2.new(0.5, 0, 0.5, 0);
			Size = UDim2.new(0, 250, 0, 150);
			Visible = false;
			ZIndex = 1050;
			ClipsDescendants = true;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Topbar";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
				Position = UDim2.new(0.5, 0, 0, 0);
				Size = UDim2.new(1, 0, 0, 30);
				ZIndex = 1055;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(1, 0);
				});
				Utility:Create("Frame", {
					Name = "ExtraBackground";
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 1, 0);
					Size = UDim2.new(1, 0, 0, 15);
					ZIndex = 1055;
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0.5, 0);
					Size = UDim2.new(0.85, 0, 0.8, 0);
					ZIndex = 1060;
					Font = Utility.Themes.Main.TextStyle;
					Text = Title.." Editor";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextScaled = true;
					TextWrapped = true;
				})
			});
			Utility:Create("Frame", {
				Name = "Buttons";
				AnchorPoint = Vector2.new(0.5, 1);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 1, -10);
				Size = UDim2.new(1, -20, 0, 30);
				ZIndex = 1050;
			}, {
				Utility:Create("UIGridLayout", {
					CellPadding = UDim2.new(0, 5, 0, 5);
					CellSize = UDim2.new(0, 110, 1, 0);
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.Name;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				});
				Utility:Create("TextButton", {
					Name = "1_Submit";
					BackgroundColor3 = Utility.Themes.Section.Background;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "Submit";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 20;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				});
				Utility:Create("TextButton", {
					Name = "2_Cancel";
					BackgroundColor3 = Utility.Themes.Section.Background;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "Cancel";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 20;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				})
			});
			Utility:Create("Frame", {
				Name = "Inputs";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
				Position = UDim2.new(0.5, 0, 0, 40);
				Size = UDim2.new(1, -20, 0, 60);
				ZIndex = 1050;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("UIGridLayout", {
					CellPadding = UDim2.new(0, 15, 0, 0);
					CellSize = UDim2.new(0, 60, 0, 45);
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.Name;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				});
				Utility:Create("TextBox", {
					Name = "HH";
					BackgroundColor3 = Utility.Themes.Main.TertiaryColor;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "00";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 25;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					})
				});
				Utility:Create("TextBox", {
					Name = "MM";
					BackgroundColor3 = Utility.Themes.Main.TertiaryColor;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "00";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 25;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					})
				});
				Utility:Create("TextBox", {
					Name = "SS";
					BackgroundColor3 = Utility.Themes.Main.TertiaryColor;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "00";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 25;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					})
				})
			})
		})
		
		Utility:DraggingEnabled(Editor);
		table.insert(self.Modules, Timer);
		self:Resize();
		
		local Allowed = {
			[""] = true;
		}
		local Active = Default or false;
		local Time = Interval or {HH = 0; MM = 0; SS = 0;};
		local Animate_Debounce, Activate_Debounce, Toggle, Animate, Activate;
		local HHMMSS = {
			HH = 0;
			MM = 0;
			SS = 0;
		}
		
		self.Timers[Timer] = {
			Editor = Editor;
			Callback = function(Prop, Value)
				HHMMSS[Prop] = Value;
			end
		}
		
		local Callback = function(Value)
			if Callback then
				Callback(Value, function(...)
					self:UpdateTimer(Timer, ...);
				end)
			end
		end
		
		if Interval then
			self:UpdateTimer(Timer, nil, Interval);
			
			for Index, Prop in pairs({"HH", "MM", "SS"}) do
				HHMMSS[Prop] = Interval[Prop];
			end
		end
		
		for Index, TextBox in pairs(Editor.Inputs:GetChildren()) do
			if TextBox:IsA("TextBox") then
				local Focused, Hovered;
				local Clamps = {
					HH = 23;
					MM = 59;
					SS = 59;
				}
				
				TextBox.MouseEnter:connect(function()
					Hovered = true;
				end)
				
				TextBox.MouseLeave:connect(function()
					Hovered = false;
				end)
				
				TextBox.Focused:connect(function()
					Focused = true;
				end)
				
				TextBox.FocusLost:connect(function()
					Focused = false;

					if not tonumber(TextBox.Text) then
						TextBox.Text = HHMMSS[TextBox.Name];
					end
				end)
				
				TextBox:GetPropertyChangedSignal("Text"):connect(function()
					local Text = TextBox.Text;
					
					if not Allowed[Text] and not tonumber(Text) then
						TextBox.Text = Text:sub(1, #Text - 1);
					elseif Focused and not Allowed[Text] then
						HHMMSS[TextBox.Name] = math.clamp(tonumber(TextBox.Text), 0, Clamps[TextBox.Name]);

						self:UpdateTimer(Timer, nil, HHMMSS);
					end
				end)
				
				TextBox.InputChanged:connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseWheel and Hovered then
						HHMMSS[TextBox.Name] = math.clamp(tonumber(TextBox.Text) + Input.Position.Z, 0, Clamps[TextBox.Name]);

						self:UpdateTimer(Timer, nil, HHMMSS);
					end
				end)
			end
		end
		
		local LastTime = Interval;
		Animate = function(Visible, Overwrite)
			if Overwrite then
				if not Toggle then return end

				if Animate_Debounce then
					while Animate_Debounce do
						Utility:Wait();
					end
				end
			elseif not Overwrite then
				if Animate_Debounce then return end
			end
			
			Toggle = Visible;
			Animate_Debounce = true;
			
			if Visible then
				if self.Page.Library.ActiveTimer and self.Page.Library.ActiveTimer ~= Animate then
					self.Page.Library.ActiveTimer(nil, true)
				end
				
				self.Page.Library.ActiveTimer = Animate
				LastTime = {
					HH = HHMMSS["HH"];
					MM = HHMMSS["MM"];
					SS = HHMMSS["SS"];
				};
				
				Editor.Visible = true;
				Editor.Size = UDim2.new(0, 0, 0, 0);
				
				Utility:Tween(Editor, {Size = UDim2.new(0, 300, 0, 200)}, 0.4);
				wait(0.2)
				Utility:Tween(Editor, {Size = UDim2.new(0, 250, 0, 150)}, 0.2);
			else
				Utility:Tween(Editor, {Size = UDim2.new(0, 300, 0, 200)}, 0.4);
				wait(0.2)
				Utility:Tween(Editor, {Size = UDim2.new(0, 0, 0, 0)}, 0.2);
				wait(0.2)
				Editor.Visible = false
			end
			
			wait(.1)
			Animate_Debounce = false;
		end
		
		Activate = function(Status)
			if Activate_Debounce then return end
			if HHMMSS["HH"] == 0 and HHMMSS["MM"] == 0 and HHMMSS["SS"] == 0 then return end
			
			Activate_Debounce = true;
			
			Active = Status;
			
			if Toggle then
				print("Minimize Editor")
				self:UpdateTimer(Timer, nil, LastTime);
				Animate(false);
			end
			
			self:UpdateTimer(Timer, nil, HHMMSS);
			
			if Active then
				Timer.Background.Button.Text = "Stop";
				
				local Left = {
					HH = HHMMSS["HH"];
					MM = HHMMSS["MM"];
					SS = HHMMSS["SS"];
				};
				
				coroutine.resume(coroutine.create(function()
					while Active do
						if Left["SS"] <= 0 then
							if Left["MM"] <= 0 then
								if Left["HH"] <= 0 then
									Left = {
										HH = HHMMSS["HH"];
										MM = HHMMSS["MM"];
										SS = HHMMSS["SS"];
									};
									Callback(HHMMSS);
								else
									Left["HH"] = Left["HH"] - 1;
									Left["MM"] = 59;
								end
							else
								Left["MM"] = Left["MM"] - 1;
								Left["SS"] = 59;
							end
						else
							Left["SS"] = Left["SS"] - 1;
						end
						
						
						
						local Hours, Minutes, Seconds = Left["HH"], Left["MM"], Left["SS"];

						if string.len(Hours) == 1 then Hours = "0"..Hours end
						if string.len(Minutes) == 1 then Minutes = "0"..Minutes end
						if string.len(Seconds) == 1 then Seconds = "0"..Seconds end

						Timer.Background.Interval.Interval.Text = Hours..":"..Minutes..":"..Seconds;
						
						wait(1);
					end
				end))
			else
				Timer.Background.Button.Text = "Start";
				
				self:UpdateTimer(Timer, nil, HHMMSS);
			end
			
			wait(.1)
			Activate_Debounce = false;
		end
		
		if Default then
			Activate(Default);
		end
		
		Timer.Background.Button.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Activate(not Active);
			end
		end)
		
		Editor.Buttons["1_Submit"].InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Active then
				Animate(false);
			end
		end)
		
		Editor.Buttons["2_Cancel"].InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Active then
				self:UpdateTimer(Timer, nil, LastTime);
				Animate(false);
			end
		end)
		
		Timer.Background.Interval.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Active then
				Animate(not Toggle);
			end
		end)
		
		return Timer
	end
	
	function Section:AddModelViewer(Title, Default, Callback)
		
	end
	
	function Section:AddColorPicker(Title, Default, Callback)
		local ColorPicker = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 40);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 10, 0, 0);
					Size = UDim2.new(0.75, 0, 1, 0);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				Utility:Create("TextButton", {
					Name = "Color";
					AnchorPoint = Vector2.new(1, 0.5);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(1, -2, 0.5, 0);
					Size = UDim2.new(0, 80, 1, -4);
					ZIndex = 1008;
					Text = "";
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 20);
					});
					Utility:Create("Frame", {
						Name = "Color";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, -10, 1, -10);
						ZIndex = 1008;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 20);
						})
					})
				})
			})
		})
		
		local Editor = Utility:Create("Frame", {
			Name = Title.."_Editor";
			Parent = self.Page.Library.Container;
			AnchorPoint = Vector2.new(0.5, 0.5);
			BackgroundColor3 = Utility.Themes.Main.PrimaryColor;
			Position = UDim2.new(0.5, 0, 0.5, 0);
			Size = UDim2.new(0, 250, 0, 250);
			Visible = false;
			ZIndex = 1050;
			ClipsDescendants = true;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Topbar";
				AnchorPoint = Vector2.new(0.5, 0);
				BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
				Position = UDim2.new(0.5, 0, 0, 0);
				Size = UDim2.new(1, 0, 0, 30);
				ZIndex = 1055;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(1, 0);
				});
				Utility:Create("Frame", {
					Name = "ExtraBackground";
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundColor3 = Utility.Themes.Main.SecondaryColor;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 1, 0);
					Size = UDim2.new(1, 0, 0, 15);
					ZIndex = 1055;
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0.5, 0);
					Size = UDim2.new(0.85, 0, 0.8, 0);
					ZIndex = 1060;
					Font = Utility.Themes.Main.TextStyle;
					Text = Title.." Editor";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextScaled = true;
					TextWrapped = true;
				})
			});
			Utility:Create("Frame", {
				Name = "Buttons";
				AnchorPoint = Vector2.new(0.5, 1);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 1, -10);
				Size = UDim2.new(1, -20, 0, 20);
				ZIndex = 1050;
			}, {
				Utility:Create("UIGridLayout", {
					CellPadding = UDim2.new(0, 5, 0, 5);
					CellSize = UDim2.new(0, 110, 1, 0);
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.Name;
					VerticalAlignment = Enum.VerticalAlignment.Center;
				});
				Utility:Create("TextButton", {
					Name = "1_Submit";
					BackgroundColor3 = Utility.Themes.Section.Background;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "Submit";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 20;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				});
				Utility:Create("TextButton", {
					Name = "2_Cancel";
					BackgroundColor3 = Utility.Themes.Section.Background;
					ZIndex = 1050;
					Font = Utility.Themes.Main.TextStyle;
					Text = "Cancel";
					TextColor3 = Utility.Themes.Main.TextColor;
					TextSize = 20;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				})
			});
			Utility:Create("Frame", {
				Name = "Container";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Main.TertiaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -20, 1, -80);
				ZIndex = 1050;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 10);
				});
				Utility:Create("ImageButton", {
					Name = "Canvas";
					AnchorPoint = Vector2.new(0.5, 0);
					AutoButtonColor = false;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, 10);
					Size = UDim2.new(1, -20, 0, 100);
					ZIndex = 1050;
					Image = "rbxassetid://5108535320";
					ImageColor3 = Color3.fromRGB(255, 0, 0);
					ScaleType = Enum.ScaleType.Slice;
					SliceCenter = Rect.new(2, 2, 298, 298);
				}, {
					Utility:Create("ImageLabel", {
						Name = "White_Overlay";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, 0, 1, 0);
						ZIndex = 1050;
						Image = "rbxassetid://5107152351";
					});
					Utility:Create("ImageLabel", {
						Name = "Black_Overlay";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(1, 0, 1, 0);
						ZIndex = 1050;
						Image = "rbxassetid://5107152095";
					});
					Utility:Create("ImageLabel", {
						Name = "Cursor";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(0, 10, 0, 10);
						ZIndex = 1050;
						Image = "rbxassetid://5100115962";
					})
				});
				Utility:Create("ImageButton", {
					Name = "Color";
					AnchorPoint = Vector2.new(0.5, 0);
					AutoButtonColor = false;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, 115);
					Selectable = false;
					Size = UDim2.new(1, -30, 0, 16);
					ZIndex = 1050;
					Image = "rbxassetid://5028857472";
					ScaleType = Enum.ScaleType.Slice;
					SliceCenter = Rect.new(2, 2, 298, 298);
				}, {
					Utility:Create("Frame", {
						Name = "Select";
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = Utility.Themes.Main.TextColor;
						BorderSizePixel = 0;
						Position = UDim2.new(0.5, 0, 0.5, 0);
						Size = UDim2.new(0, 4, 1, 2);
						ZIndex = 1050;
					}),
					Utility:Create("UIGradient", { -- [ RAINBOW CANVAS ] --
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0));
							ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0));
							ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0));
							ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255));
							ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255));
							ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 0, 255));
							ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0));
						})
					})
				});
				Utility:Create("Frame", {
					Name = "Inputs";
					AnchorPoint = Vector2.new(0.5, 1);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 1, -10);
					Size = UDim2.new(1, -20, 0, 20);
					ZIndex = 1050;
				}, {
					Utility:Create("UIListLayout", {
						Padding = UDim.new(0, 6);
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalAlignment = Enum.HorizontalAlignment.Center;
						SortOrder = Enum.SortOrder.LayoutOrder;
						VerticalAlignment = Enum.VerticalAlignment.Center;
					});
					Utility:Create("Frame", {
						Name = "R";
						BackgroundColor3 = Utility.Themes.Section.Background;
						LayoutOrder = 1;
						Size = UDim2.new(0.305, 0, 1, 0);
						ZIndex = 1050;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 5);
						});
						Utility:Create("TextLabel", {
							Name = "Text";
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0, 0, 0, 0);
							Size = UDim2.new(0.4, 0, 1, 0);
							ZIndex = 1050;
							Font = Utility.Themes.Main.TextStyle;
							Text = "R:";
							TextColor3 = Utility.Themes.Main.TextColor;
							TextSize = 15;
						});
						Utility:Create("TextBox", {
							Name = "Textbox";
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0.3, 0, 0, 0);
							Size = UDim2.new(0.6, 0, 1, 0);
							ZIndex = 1050;
							Font = Utility.Themes.Main.TextStyle;
							Text = "255";
							TextColor3 = Utility.Themes.Main.TextColor;
							TextSize = 15;
						})
					});
					Utility:Create("Frame", {
						Name = "G";
						BackgroundColor3 = Utility.Themes.Section.Background;
						LayoutOrder = 2;
						Size = UDim2.new(0.305, 0, 1, 0);
						ZIndex = 1050;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 5);
						});
						Utility:Create("TextLabel", {
							Name = "Text";
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0, 0, 0, 0);
							Size = UDim2.new(0.4, 0, 1, 0);
							ZIndex = 1050;
							Font = Utility.Themes.Main.TextStyle;
							Text = "G:";
							TextColor3 = Utility.Themes.Main.TextColor;
							TextSize = 15;
						});
						Utility:Create("TextBox", {
							Name = "Textbox";
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0.3, 0, 0, 0);
							Size = UDim2.new(0.6, 0, 1, 0);
							ZIndex = 1050;
							Font = Utility.Themes.Main.TextStyle;
							Text = "255";
							TextColor3 = Utility.Themes.Main.TextColor;
							TextSize = 15;
						})
					});
					Utility:Create("Frame", {
						Name = "B";
						BackgroundColor3 = Utility.Themes.Section.Background;
						LayoutOrder = 3;
						Size = UDim2.new(0.305, 0, 1, 0);
						ZIndex = 1050;
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0, 5);
						});
						Utility:Create("TextLabel", {
							Name = "Text";
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0, 0, 0, 0);
							Size = UDim2.new(0.4, 0, 1, 0);
							ZIndex = 1050;
							Font = Utility.Themes.Main.TextStyle;
							Text = "B:";
							TextColor3 = Utility.Themes.Main.TextColor;
							TextSize = 15;
						});
						Utility:Create("TextBox", {
							Name = "Textbox";
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Position = UDim2.new(0.3, 0, 0, 0);
							Size = UDim2.new(0.6, 0, 1, 0);
							ZIndex = 1050;
							Font = Utility.Themes.Main.TextStyle;
							Text = "255";
							TextColor3 = Utility.Themes.Main.TextColor;
							TextSize = 15;
						})
					})
				})
			})
		})

		Utility:DraggingEnabled(Editor);
		table.insert(self.Modules, ColorPicker);
		self:Resize();
		
		local Allowed = {
			[""] = true;
		}
		
		local Canvas = Editor.Container.Canvas;
		local Color = Editor.Container.Color;
		
		local CanvasSize, CanvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition;
		local ColorSize, ColorPosition = Color.AbsoluteSize, Color.AbsolutePosition;
		
		local DraggingColor, DraggingCanvas;
		
		local Colors3 = Default or Color3.fromRGB(255, 255, 255);
		local Hue, Sat, Brightness = 0, 0, 1;
		local RGB = {
			R = 255;
			G = 255;
			B = 255;
		};
		
		self.ColorPickers[ColorPicker] = {
			Editor = Editor;
			Callback = function(Prop, Value)
				RGB[Prop] = Value;
				Hue, Sat, Brightness = Color3.toHSV(Color3.fromRGB(RGB.R, RGB.G, RGB.B));
			end
		}
		
		local Callback = function(Value)
			if Callback then
				Callback(Value, function(...)
					self:UpdateColorPicker(ColorPicker, ...);
				end)
			end
		end
		
		Utility:DraggingEnded(function()
			DraggingColor, DraggingCanvas = false, false;
		end)
		
		if Default then
			self:UpdateColorPicker(ColorPicker, nil, Default);

			Hue, Sat, Brightness = Color3.toHSV(Default);
			Default = Color3.fromHSV(Hue, Sat, Brightness);

			for Index, Prop in pairs({"R", "G", "B"}) do
				RGB[Prop] = Default[Prop] * 255;
			end
		else
			self:UpdateColorPicker(ColorPicker, nil, Colors3);
		end
		
		for Index, Container in pairs(Editor.Container.Inputs:GetChildren()) do
			if Container:IsA("Frame") then
				local TextBox = Container.Textbox;
				local Focused, Hovered;
				
				TextBox.MouseEnter:connect(function()
					Hovered = true;
				end)

				TextBox.MouseLeave:connect(function()
					Hovered = false;
				end)
				
				TextBox.Focused:Connect(function()
					Focused = true;
				end)

				TextBox.FocusLost:Connect(function()
					Focused = false;

					if not tonumber(TextBox.Text) then
						TextBox.Text = math.floor(RGB[Container.Name]);
					end
				end)

				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					local Text = TextBox.Text;

					if not Allowed[Text] and not tonumber(Text) then
						TextBox.Text = Text:sub(1, #Text - 1);
					elseif Focused and not Allowed[Text] then
						RGB[Container.Name] = math.clamp(tonumber(TextBox.Text), 0, 255);

						local Colors3 = Color3.fromRGB(RGB.R, RGB.G, RGB.B);
						Hue, Sat, Brightness = Color3.toHSV(Colors3);

						self:UpdateColorPicker(ColorPicker, nil, Colors3);
						Callback(Colors3);
					end
				end)
				
				TextBox.InputChanged:connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseWheel and Hovered then
						RGB[Container.Name] = math.clamp(tonumber(TextBox.Text) + Input.Position.Z, 0, 255);
						
						local Colors3 = Color3.fromRGB(RGB.R, RGB.G, RGB.B);
						Hue, Sat, Brightness = Color3.toHSV(Colors3);
						
						self:UpdateColorPicker(ColorPicker, nil, Colors3);
						Callback(Colors3);
					end
				end)
			end
		end
		
		Canvas.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				DraggingCanvas = true;
				
				CanvasSize, CanvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition;
				
				while DraggingCanvas do	
					Sat = math.clamp((Mouse.X - CanvasPosition.X) / CanvasSize.X, 0, 1);
					Brightness = 1 - math.clamp((Mouse.Y - CanvasPosition.Y) / CanvasSize.Y, 0, 1);
					
					Colors3 = Color3.fromHSV(Hue, Sat, Brightness);
					
					for Index, Prop in pairs({"R", "G", "B"}) do
						RGB[Prop] = Colors3[Prop] * 255;
					end

					self:UpdateColorPicker(ColorPicker, nil, {Hue, Sat, Brightness});
					Utility:Tween(Canvas.Cursor, {Position = UDim2.new(Sat, 0, 1 - Brightness, 0)}, 0.1);

					Callback(Colors3);
					Utility:Wait();
				end
			end
		end)
		
		Canvas.InputEnded:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				DraggingCanvas = false;
			end
		end)
		
		Color.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				DraggingColor = true;
				
				ColorSize, ColorPosition = Color.AbsoluteSize, Color.AbsolutePosition;
				
				while DraggingColor do
					Hue = 1 - math.clamp(1 - ((Mouse.X - ColorPosition.X) / ColorSize.X), 0, 1);
					Colors3 = Color3.fromHSV(Hue, Sat, Brightness);

					for Index, Prop in pairs({"R", "G", "B"}) do
						RGB[Prop] = Colors3[Prop] * 255;
					end

					local X = Hue;
					self:UpdateColorPicker(ColorPicker, nil, {Hue, Sat, Brightness});
					Utility:Tween(Editor.Container.Color.Select, {Position = UDim2.new(X, 0, 0.5, 0)}, 0.1);

					Callback(Colors3);
					Utility:Wait();
				end
			end
		end)
		
		Color.InputEnded:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				DraggingColor = false;
			end
		end)
		
		local Toggle, Debounce, Animate;
		local LastColor = Color3.fromHSV(Hue, Sat, Brightness);
		
		Animate = function(Visible, Overwrite)
			if Overwrite then
				if not Toggle then return end

				if Debounce then
					while Debounce do
						Utility:Wait()
					end
				end
			else
				if Debounce then return end
			end

			Toggle = Visible;
			Debounce = true;

			if Visible then
				if self.Page.Library.ActivePicker and self.Page.Library.ActivePicker ~= Animate then
					self.Page.Library.ActivePicker(nil, true);
				end

				self.Page.Library.ActivePicker = Animate;
				LastColor = Color3.fromHSV(Hue, Sat, Brightness);
				
				Editor.Visible = true;
				Editor.Size = UDim2.new(0, 0, 0, 0);
				
				Utility:Tween(Editor, {Size = UDim2.new(0, 300, 0, 300)}, 0.4);
				wait(0.2)
				Utility:Tween(Editor, {Size = UDim2.new(0, 250, 0, 250)}, 0.2);
				
				CanvasSize, CanvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition;
				ColorSize, ColorPosition = Color.AbsoluteSize, Color.AbsolutePosition;
			else
				Utility:Tween(Editor, {Size = UDim2.new(0, 300, 0, 300)}, 0.4);
				wait(0.2)
				Utility:Tween(Editor, {Size = UDim2.new(0, 0, 0, 0)}, 0.4);
				wait(0.2)
				Editor.Visible = false;
			end
			
			wait(.1)
			Debounce = false;
		end
		
		ColorPicker.Background.Color.InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Animate(not Toggle)
			end
		end)
		
		Editor.Buttons["1_Submit"].InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Animate(false);
			end
		end)

		Editor.Buttons["2_Cancel"].InputBegan:connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				self:UpdateColorPicker(ColorPicker, nil, LastColor);
				Animate(false);
			end
		end)
		
		return ColorPicker
	end
	
	function Section:AddRadio(Title, Default, List, Callback)
		local Radio = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 35);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, 0);
					Size = UDim2.new(1, -50, 0, 30);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				});
				Utility:Create("Frame", {
					Name = "List";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(0.5, 0, 0, 30);
					Size = UDim2.new(1, -10, 0, 10);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 15);
					});
					Utility:Create("UIGridLayout", {
						CellPadding = UDim2.new(0, 10, 0, 10);
						CellSize = UDim2.new(0, 155, 0, 30);
						FillDirectionMaxCells = 3;
						HorizontalAlignment = Enum.HorizontalAlignment.Center;
						SortOrder = Enum.SortOrder.LayoutOrder;
						VerticalAlignment = Enum.VerticalAlignment.Center;
					});
				})
			})
		})
		
		table.insert(self.Modules, Radio);
		self:Resize();
		
		local Selected = Default or "";
		local Debounce;
		
		local Callback = function(Value)
			if Callback then
				Callback(Value, function(...)
					self:UpdateRadio(Radio, ...);
				end)
			end
		end
		
		if List and List ~= {} then
			local Lines = math.floor(#List / 3);
			if (#List / 3) % 1 > 0 then Lines = Lines + 1; end
			
			local Size = Lines * 40;
			
			Radio.Size = UDim2.new(1, 0, 0, 50 + Size);
			Radio.Background.List.Size = UDim2.new(1, -10, 0, 10 + Size);
			
			for Index, Item in pairs(List) do
				local Object = Utility:Create("Frame", {
					Name = Item;
					Parent = Radio.Background.List;
					BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					});
					Utility:Create("TextLabel", {
						Name = "Title";
						AnchorPoint = Vector2.new(0, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(0, 10, 0.5, 0);
						Size = UDim2.new(1, -40, 1, 0);
						ZIndex = 1008;
						Font = Utility.Themes.Section.TextStyle;
						Text = Item;
						TextColor3 = Utility.Themes.Section.TextColor;
						TextSize = 20;
						TextXAlignment = Enum.TextXAlignment.Left;
					});
					Utility:Create("TextButton", {
						Name = "Radio";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundColor3 = Utility.Themes.Section.TextColor;
						Position = UDim2.new(1, -5, 0.5, 0);
						Size = UDim2.new(0, 20, 0, 20);
						ZIndex = 1008;
						Text = "";
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(1, 0);
						});
						Utility:Create("Frame", {
							Name = "Fill";
							AnchorPoint = Vector2.new(0.5, 0.5);
							BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Size = UDim2.new(1, -8, 1, -8);
							Visible = false;
							ZIndex = 1008;
						}, {
							Utility:Create("UICorner", {
								CornerRadius = UDim.new(1, 0);
							})
						})
					})
				})
				
				if Default then
					if Item == Default then
						Selected = Item;
						self:UpdateRadio(Radio, nil, Item);
					end
				else
					if not Selected then
						Selected = Item;
						self:UpdateRadio(Radio, nil, Item);
					end					
				end
				
				Object.Radio.InputBegan:connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Debounce then return end
						Debounce = true;
						
						Selected = Item;
						self:UpdateRadio(Radio, nil, Item);
						Callback(Item);
						
						wait(.1)
						Debounce = false;
					end
				end)
				
			end
			
			self:Resize();
		end
		
		return Radio
	end
	
	function Section:AddCheckbox(Title, Default, List, Callback)
		local Checkbox = Utility:Create("Frame", {
			Name = Utility:CounterName(self.Modules);
			Parent = self.Container.List;
			BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
			Size = UDim2.new(1, 0, 0, 35);
			ZIndex = 1008;
		}, {
			Utility:Create("UICorner", {
				CornerRadius = UDim.new(0, 20);
			});
			Utility:Create("Frame", {
				Name = "Background";
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, -6, 1, -6);
				ZIndex = 1008;
				ClipsDescendants = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 20);
				});
				Utility:Create("TextLabel", {
					Name = "Title";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0.5, 0, 0, 0);
					Size = UDim2.new(1, -50, 0, 30);
					ZIndex = 1008;
					Font = Utility.Themes.Section.TextStyle;
					Text = Title;
					TextColor3 = Utility.Themes.Section.TextColor;
					TextSize = 20;
				});
				Utility:Create("Frame", {
					Name = "List";
					AnchorPoint = Vector2.new(0.5, 0);
					BackgroundColor3 = Utility.Themes.Section.Background;
					Position = UDim2.new(0.5, 0, 0, 30);
					Size = UDim2.new(1, -10, 0, 10);
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 15);
					});
					Utility:Create("UIGridLayout", {
						CellPadding = UDim2.new(0, 10, 0, 10);
						CellSize = UDim2.new(0, 155, 0, 30);
						FillDirectionMaxCells = 3;
						HorizontalAlignment = Enum.HorizontalAlignment.Center;
						SortOrder = Enum.SortOrder.LayoutOrder;
						VerticalAlignment = Enum.VerticalAlignment.Center;
					});
				})
			})
		})

		table.insert(self.Modules, Checkbox);
		self:Resize();
		
		local Selected = Default or {};
		local Debounce;

		local Callback = function(Value)
			if Callback then
				Callback(Value, function(...)
					self:UpdateCheckbox(Checkbox, ...);
				end)
			end
		end
		
		if List and List ~= {} then
			local Lines = math.floor(#List / 3);
			if (#List / 3) % 1 > 0 then Lines = Lines + 1; end

			local Size = Lines * 40;

			Checkbox.Size = UDim2.new(1, 0, 0, 50 + Size);
			Checkbox.Background.List.Size = UDim2.new(1, -10, 0, 10 + Size);
			
			for Index, Item in pairs(List) do
				local Object = Utility:Create("Frame", {
					Name = Item;
					Parent = Checkbox.Background.List;
					BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
					ZIndex = 1008;
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 10);
					});
					Utility:Create("TextLabel", {
						Name = "Title";
						AnchorPoint = Vector2.new(1, 0.5);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Position = UDim2.new(1, -10, 0.5, 0);
						Size = UDim2.new(1, -40, 1, 0);
						ZIndex = 1008;
						Font = Utility.Themes.Section.TextStyle;
						Text = Item;
						TextColor3 = Utility.Themes.Section.TextColor;
						TextSize = 20;
						TextXAlignment = Enum.TextXAlignment.Left;
					});
					Utility:Create("TextButton", {
						Name = "Checkbox";
						AnchorPoint = Vector2.new(0, 0.5);
						BackgroundColor3 = Utility.Themes.Section.TextColor;
						Position = UDim2.new(0, 5, 0.5, 0);
						Size = UDim2.new(0, 20, 0, 20);
						ZIndex = 1008;
						Text = "";
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0.2, 0);
						});
						Utility:Create("Frame", {
							Name = "Fill";
							AnchorPoint = Vector2.new(0.5, 0.5);
							BackgroundColor3 = Utility.Themes.Section.PrimaryColor;
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Size = UDim2.new(1, -8, 1, -8);
							Visible = false;
							ZIndex = 1008;
						}, {
							Utility:Create("UICorner", {
								CornerRadius = UDim.new(0.2, 0);
							})
						})
					})
				})
				
				if Default then
					self:UpdateCheckbox(Checkbox, nil, Selected);
				end
				
				Object.Checkbox.InputBegan:connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Debounce then return end
						Debounce = true;
						
						local NewSelected = {};
						local Located;
						for Index, Items in pairs(Selected) do
							if Items == Item then
								Located = true
							else
								table.insert(NewSelected, #NewSelected, Items);
							end
						end
						if not Located then
							table.insert(NewSelected, #NewSelected, Item);
						end
						Selected = NewSelected;
						
						wait(.1)
						
						self:UpdateCheckbox(Checkbox, nil, NewSelected);
						Callback(NewSelected);
						
						wait(.2)
						Debounce = false;
					end
				end)
			end
			
			self:Resize();
		end
		
		return Checkbox
	end
	
	----- [ CLASS FUNCTIONS ] -----
	function Library:SelectPage(Page)
		local Button = Page.Button;
		local Container = Page.Container;
		
		local ContainerLocation = (tonumber(Container.Name) * 350);
		Utility:Tween(Page.Library.PagesContainers, {CanvasPosition = Vector2.new(0, ContainerLocation)}, .5);
	end
	
	function Section:Resize(Smooth)
		
		local Padding = 10;
		local SectionSize = self.Container.Title.AbsoluteSize.Y + Padding;
		local ListSize = 0;
		
		for Index, Module in pairs(self.Modules) do
			SectionSize = SectionSize + Module.AbsoluteSize.Y + Padding;
			ListSize = ListSize + Module.AbsoluteSize.Y + Padding;
		end
		
		if Smooth then
			Utility:Tween(self.Container, {Size = UDim2.new(1, 0, 0, SectionSize)}, 0.05);
			Utility:Tween(self.Container.List, {Size = UDim2.new(1, -20, 0, ListSize)}, 0.05);
		else
			self.Container.Size = UDim2.new(1, 0, 0, SectionSize);
			self.Container.List.Size = UDim2.new(1, -20, 0, ListSize);
		end
		
	end
	
	function Section:GetModule(Info)
		if table.find(self.Modules, Info) then
			return Info
		end

		for Index, Module in pairs(self.Modules) do
			if (Module:FindFirstChild("Title") or Module:FindFirstChild("TextBox", true)).Text == Info then
				return Module
			end
		end

		error("No module found under "..tostring(Info))
	end
	
	----- [ UPDATES ] -----
	function Library:UpdateLibrary(Container, Value)
		local Value = Value and "Enabled" or "Disabled";
		local Minimize = {
			Enabled = {
				Main = UDim2.new(0, 600, 0, 30);
				Icon = -180;
			};
			Disabled = {
				Main = UDim2.new(0, 600, 0, 400);
				Icon = 0;
			};
		}
		Utility:Tween(Container.Main, {
			Size = Minimize[Value].Main;
		}, 0.2);
		Utility:Tween(Container.Main.Topbar.Minimize, {
			Rotation = Minimize[Value].Icon;
		}, 0.2);
	end
	
	function Section:UpdateButton(Button, Title)
		Button = self:GetModule(Button);

		Button.Button.Text = Title;
	end
	
	function Section:UpdateToggle(Toggle, Title, Value)
		Toggle = self:GetModule(Toggle);
		
		local Changes = {
			Disabled = {
				Position = UDim2.new(0.5, 20, 0.5, 0);
				Color = Utility.Themes.Section.TertiaryColor;
			};
			Enabled = {
				Position = UDim2.new(0.5, -20, 0.5, 0);
				Color = Utility.Themes.Section.Background
			};
		}
		
		Value = Value and "Disabled" or "Enabled";
		
		if Title then
			Toggle.Background.Title.Text = Title;
		end
		
		Utility:Tween(Toggle.Background.Toggle.Button, {
			Size = UDim2.new(0, 36, 1, -8);
			Position = Changes[Value].Position
		}, 0.2);
		Utility:Tween(Toggle.Background.Toggle, {
			BackgroundColor3 = Changes[Value].Color
		}, 0.2);
		
		wait(0.1)
		Utility:Tween(Toggle.Background.Toggle.Button, {
			Size = UDim2.new(0, 36, 1, -4);
			Position = Changes[Value].Position
		}, 0.1);
	end
	
	function Section:UpdateTextbox(Textbox, Title, Value)
		Textbox = self:GetModule(Textbox);
		
		if Title then
			Textbox.Background.Title.Text = Title;
		end
		
		if Value then
			Textbox.Background.Box.Input.Text = Value;
		end
	end
	
	function Section:UpdateKeybind(Keybind, Title, Key)
		Keybind = self:GetModule(Keybind);
		
		local Bind = self.Binds[Keybind];
		
		if Title then
			Keybind.Background.Title.Text = Title;
		end
		
		if Bind.Connection then
			Bind.Connection = Bind.Connection:UnBind();
		end
		
		if Key then
			if typeof(Key) == "string" then Key = Enum.KeyCode[Key] end
			
			self.Binds[Keybind].Connection = Utility:BindToKey(Key, Bind.Callback);
			Keybind.Background.Keybind.Text = Key.Name;
		else
			Keybind.Background.Keybind.Text = "None";
		end
	end
	
	function Section:UpdateSlider(Slider, Title, Value, Min, Max, LValue)
		Slider = self:GetModule(Slider);
		
		if Title then
			Slider.Background.Title.Text = Title;
		end
		
		local Percent = (Mouse.X - Slider.Background.Slider.AbsolutePosition.X) / Slider.Background.Slider.AbsoluteSize.X;
		
		if Value then -- [ SUPPORT NEGATIVE RANGES ] --
			Percent = (Value - Min) / (Max - Min);
		end
		
		Percent = math.clamp(Percent, 0, 1);
		Value = Value or math.floor(Min + (Max - Min) * Percent);
		
		Slider.Background.Input.Text = Value
		Utility:Tween(Slider.Background.Slider.Design, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.1);
		Utility:Tween(Slider.Background.Slider.Button, {Position = UDim2.new(Percent, 0, .5, 0)}, 0.1);
		
		if Value ~= LValue and Slider.Background.Slider.Button.BackgroundTransparency == 0 then
			Utility:Tween(Slider.Background.Slider.Button, {
				Size = UDim2.new(0, 10, 0, 10);
			}, 0.2);
			
			wait(.1);
			Utility:Tween(Slider.Background.Slider.Button, {
				Size = UDim2.new(0, 20, 0, 20);
			}, 0.);
		end
		
		return Value
	end
	
	function Section:UpdateDropdown(Dropdown, Title, List, Callback)
		Dropdown = self:GetModule(Dropdown);
		
		if Title then
			Dropdown.Background.Input.Input.Text = Title;
		end
		
		local Entries = 0;
		
		for Index, Button in pairs(Dropdown.Background.List.List:GetChildren()) do
			if Button:IsA("TextButton") then
				Button:Destroy()
			end
		end
		
		for Index, Value in pairs(List or {}) do
			local Button = Utility:Create("TextButton", {
				Name = Value;
				Parent = Dropdown.Background.List.List;
				BackgroundColor3 = Utility.Themes.Section.SecondaryColor;
				Size = UDim2.new(1, 0, 0, 25);
				ZIndex = 1008;
				Font = Utility.Themes.Section.TextStyle;
				Text = Value;
				TextColor3 = Utility.Themes.Section.TextColor;
				TextSize = 18;
				TextWrapped = true;
			}, {
				Utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 15);
				})
			})
			
			local Debounce;
			
			Button.InputBegan:connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if Debounce then return end
					Debounce = true;
					
					if Callback then
						Callback(Value, function(...)
							self:UpdateDropdown(Dropdown, ...)
						end)	
					end

					self:UpdateDropdown(Dropdown, Value, nil, Callback)
					
					wait(.1)
					Debounce = false;
				end
			end)
			
			Entries = Entries + 1;
		end
		
		local DropdownSize = (Entries == 0 and 45) or (math.clamp(Entries, 0, 4) * 30) + 70;
		local ListSize = (Entries == 0 and 0) or (math.clamp(Entries, 0, 4) * 30) + 15;
		
		Utility:Tween(Dropdown.Background.List, {
			Size = UDim2.new(1, -14, 0, ListSize);
		}, 0.3);
		Utility:Tween(Dropdown, {
			Size = UDim2.new(1, 0, 0, DropdownSize);
		}, 0.3);
		Utility:Tween(Dropdown.Background.Down, {Rotation = List and 180 or 0}, 0.3);
		
	end
	
	function Section:UpdateTimer(Timer, Title, Interval)
		Timer = self:GetModule(Timer);
		
		local Timers = self.Timers[Timer];
		local Editor = Timers.Editor;
		local Callback = Timers.Callback;
		local Clamps = {
			HH = 23;
			MM = 59;
			SS = 59;
		}
		
		if Title then
			Timer.Background.Title.Text = Title;
			Editor.Topbar.Title.Text = Title.." Editor"
		end
		
		local Time = Interval;
		local Hours, Minutes, Seconds = math.clamp(Time["HH"], 0, Clamps["HH"]), math.clamp(Time["MM"], 0, Clamps["MM"]), math.clamp(Time["SS"], 0, Clamps["SS"]);
		
		if string.len(Hours) == 1 then Hours = "0"..Hours end
		if string.len(Minutes) == 1 then Minutes = "0"..Minutes end
		if string.len(Seconds) == 1 then Seconds = "0"..Seconds end
		
		Timer.Background.Interval.Interval.Text = Hours..":"..Minutes..":"..Seconds;
		
		for Index, TextBox in pairs(Editor.Inputs:GetChildren()) do
			if TextBox:IsA("TextBox") then
				local Value = math.clamp(Time[TextBox.Name], 0, Clamps[TextBox.Name]);
				
				if string.len(Value) == 1 then Value = "0"..Value end
				
				TextBox.Text = Value;
			end
		end
		
	end
	
	function Section:UpdateModelViewer(ModelViewer, Title)
		ModelViewer = self:GetModule(ModelViewer);
	end
	
	function Section:UpdateColorPicker(ColorPicker, Title, Color)
		ColorPicker = self:GetModule(ColorPicker);
		
		local Picker = self.ColorPickers[ColorPicker];
		local Editor = Picker.Editor;
		local Callback = Picker.Callback;
		
		if Title then
			ColorPicker.Background.Title.Text = Title
			Editor.Topbar.Title.Text = Title
		end

		local Colors3;
		local Hue, Sat, Brightness;
		
		if type(Color) == "table" then
			Hue, Sat, Brightness = unpack(Color);
			Colors3 = Color3.fromHSV(Hue, Sat, Brightness);
		else
			Colors3 = Color;
			Hue, Sat, Brightness = Color3.toHSV(Colors3);
		end
		
		Utility:Tween(ColorPicker.Background.Color.Color, {BackgroundColor3 = Colors3}, 0.5);
		Utility:Tween(Editor.Container.Color.Select, {Position = UDim2.new(Hue, 0, 0.5, 0)}, 0.1);

		Utility:Tween(Editor.Container.Canvas, {ImageColor3 = Color3.fromHSV(Hue, 1, 1)}, 0.5);
		Utility:Tween(Editor.Container.Canvas.Cursor, {Position = UDim2.new(Sat, 0, 1 - Brightness)}, 0.5);

		for Index, Container in pairs(Editor.Container.Inputs:GetChildren()) do
			if Container:IsA("Frame") then
				local Value = math.clamp(Colors3[Container.Name], 0, 1) * 255;

				Container.Textbox.Text = math.floor(Value);
			end
		end
	end
	
	function Section:UpdateRadio(Radio, Title, Item)
		Radio = self:GetModule(Radio);
		
		if Title then
			Radio.Background.Title.Text = Title;
		end
		
		for Index, Items in pairs(Radio.Background.List:GetChildren()) do
			if Items:IsA("Frame") then
				if Items.Name == Item then
					Items.Radio.Fill.Visible = true;
				else
					Items.Radio.Fill.Visible = false;
				end
			end
		end
	end
	
	function Section:UpdateCheckbox(Checkbox, Title, Items)
		Checkbox = self:GetModule(Checkbox);
		
		if Title then
			Checkbox.Background.Title.Text = Title;
		end
		
		for Index, Object in pairs(Checkbox.Background.List:GetChildren()) do
			if Object:IsA("Frame") then
				Object.Checkbox.Fill.Visible = false;
			end
		end
		
		for Index, Object in pairs(Checkbox.Background.List:GetChildren()) do
			if Object:IsA("Frame") then
				for Index, Item in pairs(Items) do
					if Object.Name == Item then
						Object.Checkbox.Fill.Visible = true;
					end
				end
			end
		end
	end
end

return Library
