--[[
  ___  ___  ________  ___       ________  ___       ___  ________     
 |\  \|\  \|\   __  \|\  \     |\   __  \|\  \     |\  \|\   __  \    
 \ \  \\\  \ \  \|\  \ \  \    \ \  \|\  \ \  \    \ \  \ \  \|\ /_   
  \ \   __  \ \  \\\  \ \  \    \ \  \\\  \ \  \    \ \  \ \   __  \  
   \ \  \ \  \ \  \\\  \ \  \____\ \  \\\  \ \  \____\ \  \ \  \|\  \ 
    \ \__\ \__\ \_______\ \_______\ \_______\ \_______\ \__\ \_______\
     \|__|\|__|\|_______|\|_______|\|_______|\|_______|\|__|\|_______|

   	Created by: NickCoder
   	Inspired by: Hololive
   	Derived from: Venyx & Finity
   	Version: 1.0.0                                                  
--]]

------------------------
----- [ SERVICES ] -----
------------------------
local Players			= game:GetService("Players");
local RunService		= game:GetService("RunService");
local TweenService		= game:GetService("TweenService");
local UserInputService	= game:GetService("UserInputService");
local CoreGui			= game:GetService("CoreGui");

--------------------------
----- [ INITIALIZE ] -----
--------------------------
local Player			= Players.LocalPlayer;
local PlayerGui			= Player:FindFirstChild("PlayerGui");
local Mouse				= Player:GetMouse();
local TweenInformation	= TweenInfo.new

local Utility = {
	Themes = {
		Background		= Color3.fromRGB(24, 24, 24);
		Glow			= Color3.fromRGB(0, 0, 0);
		Accent			= Color3.fromRGB(10, 10, 10); 
		LightContrast	= Color3.fromRGB(20, 20, 20); 
		DarkContrast	= Color3.fromRGB(14, 14, 14);
		TextColor		= Color3.fromRGB(255, 255, 255);
	};
	Objects = {};
}

do
	function Utility:Create(Name, Properties, Childrens)
		local Object = Instance.new(Name);

		for Index, Value in pairs(Properties or {}) do
			Object[Index] = Value;
			
			if typeof(Value) == "Color3" then -- save for theme changer later
				local Theme = Utility:Find(Utility.Themes, Value)

				if Theme then
					Utility.Objects[Utility.Themes] = Utility.Objects[Utility.Themes] or {}
					Utility.Objects[Utility.Themes][Index] = Utility.Objects[Utility.Themes][Index] or setmetatable({}, {_mode = "k"})

					table.insert(Utility.Objects[Utility.Themes][Index], Object)
				end
			end
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
	
	function Utility:Pop(Object, Shrink)
		local Clone = Object:Clone()
		
		Clone.AnchorPoint = Vector2.new(0.5, 0.5)
		Clone.Size = Clone.Size - UDim2.new(0, Shrink, 0, Shrink)
		Clone.Position = UDim2.new(0.5, 0, 0.5, 0)

		Clone.Parent = Object
		Clone:ClearAllChildren()
		
		if Utility:HasProperty(Object, "ImageTransparency") then Object.ImageTransparency = 1
		else Object.BackgroundTransparency = 1 end
		Utility:Tween(Clone, {Size = Object.Size}, 0.2)

		spawn(function()
			wait(0.2)

			if Utility:HasProperty(Object, "ImageTransparency") then Object.ImageTransparency = 0
			else Object.BackgroundTransparency = 0 end
			Clone:Destroy()
		end)

		return Clone
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

		local Debounce = false;

		UserInputService.InputBegan:Connect(function(Input, Chatting)
			if Chatting then return end
			if self.Keybinds[Input.KeyCode] then
				for _, Bind in pairs(self.Keybinds[Input.KeyCode]) do
					if Debounce then return end
					Debounce = true;

					Bind()

					wait(.2)
					Debounce = false;
				end
			end
		end)

		UserInputService.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then
				for _, Callback in pairs(self.Ended) do
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
	
	function Utility:HasProperty(Object, Property)
		local Success = pcall(function()
			return Object[Property]
		end)
		return Success and not Object:FindFirstChild(Property)
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
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then
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
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input;
			end
		end)

		UserInputService.InputChanged:connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				Parent.Position  = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y);
			end
		end)
	end

	function Utility:DraggingEnded(Callback)
		table.insert(self.Ended, Callback);
	end
end

-----------------------
----- [ CLASSES ] -----
-----------------------
local Library = {LastNotification = nil}
local Page = {}
local Section = {}

do
	Library.__index = Library;
	Page.__index = Page;
	Section.__index = Section;
	
	-------------------------
	----- [ NEW CLASS ] -----
	-------------------------
	function Library.new(Title, Data)
		if not RunService:IsStudio() and CoreGui:FindFirstChild("HoloLibUI") then warn("Hololib:", "instance already exists in coregui!"); return end
		
		Data = Data or {Size = UDim2.new(0, 700, 0, 380), ToggleKey = nil, Enabled = true}
		Data.Size = Data.Size or UDim2.new(0, 700, 0, 380)
		Data.ToggleKey = Data.ToggleKey or nil
		Data.Enabled = Data.Enabled or true
		
		local Container = Utility:Create("ScreenGui", {
			Name = "HoloLibUI";
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			ResetOnSpawn = false,
			Enabled = Data.Enabled,
		},{
			Utility:Create("ImageLabel", {
				Name = "Main",
				Draggable = true,
				Active = true,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.5, -190),
				Size = Data.Size,
				Image = "rbxassetid://4641149554",
				ImageColor3 = Utility.Themes.Background,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(4, 4, 296, 296)
			}, {
				Utility:Create("ImageLabel", {
					Name = "Glow",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -15, 0, -15),
					Size = UDim2.new(1, 30, 1, 30),
					ZIndex = 0,
					Image = "rbxassetid://5028857084",
					ImageColor3 = Utility.Themes.Glow,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(24, 24, 276, 276)
				});
				Utility:Create("ImageLabel", {
					Name = "Pages",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Position = UDim2.new(0, 0, 0, 38),
					Size = UDim2.new(0, 126, 1, -38),
					ZIndex = 3,
					Image = "rbxassetid://5012534273",
					ImageColor3 = Utility.Themes.DarkContrast,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(4, 4, 296, 296)
				}, {
					Utility:Create("ScrollingFrame", {
						Name = "Pages_Container",
						Active = true,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0, 10),
						Size = UDim2.new(1, 0, 1, -20),
						CanvasSize = UDim2.new(0, 0, 0, 314),
						ScrollBarThickness = 0
					}, {
						Utility:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 10)
						});
					});
				});
				Utility:Create("ImageLabel", {
					Name = "TopBar",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, 38),
					ZIndex = 5,
					Image = "rbxassetid://4595286933",
					ImageColor3 = Utility.Themes.Accent,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(4, 4, 296, 296)
				}, {
					Utility:Create("TextLabel", { -- Title
						Name = "Title",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 12, 0, 19),
						Size = UDim2.new(1, -46, 0, 16),
						ZIndex = 5,
						Font = Enum.Font.GothamBold,
						Text = Title,
						TextColor3 = Utility.Themes.TextColor,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					});
					Utility:Create("ImageButton", { -- Minimize Button
						Name = "Button",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(1, -50, 0.5, -8),
						Size = UDim2.new(0, 40, 0, 16),
						ZIndex = 5,
						Image = "rbxassetid://5028857472",
						ImageColor3 = Utility.Themes.LightContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 298, 298)
					}, {
						Utility:Create("ImageLabel", {
							Name = "Frame",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 2, 0.5, -6),
							Size = UDim2.new(1, -22, 1, -4),
							ZIndex = 5,
							Image = "rbxassetid://5028857472",
							ImageColor3 = Utility.Themes.TextColor,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(2, 2, 298, 298)
						});
					});
				});
			});
		});
		
		if not RunService:IsStudio() then Container.Parent = CoreGui
		else Container.Parent = PlayerGui end
		
		if Data and Data.Size then Container.Main.Position = UDim2.new(0.5, 0, 0.5, -(Data.Size.Y.Offset / 2)) end
		
		Utility:InitializeKeybind()
		
		local MetaTable = setmetatable({
			Container = Container,
			PagesContainer = Container.Main.Pages.Pages_Container,
			Pages = {},
			Size = Data.Size,
			ToggleKey = Data.ToggleKey,
		}, Library)
		
		Container.Main.TopBar.Button.MouseButton1Click:Connect(function()
			MetaTable:Toggle()
		end)
		
		UserInputService.InputEnded:connect(function(Input, Chatting)
			if Chatting then return end
			if MetaTable.ToggleKey and MetaTable.ToggleKey ~= nil then
				if typeof(MetaTable.ToggleKey) == "string" then MetaTable.ToggleKey = Enum.KeyCode[MetaTable.ToggleKey] end
				
				if Input.KeyCode == MetaTable.ToggleKey then
					MetaTable:Toggle()
				end
			end
		end)
		
		return MetaTable
	end
	
	function Page.new(Library, Title, Icon)
		local Button = Utility:Create("TextButton", {
			Name = Title,
			Parent = Library.PagesContainer,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 26),
			ZIndex = 3,
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "",
			TextSize = 14
		}, {
			Utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 40, 0.5, 0),
				Size = UDim2.new(0, 76, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.65,
				TextXAlignment = Enum.TextXAlignment.Left
			});
			(tonumber(Icon) ~= nil and Utility:Create("ImageLabel", {
				Name = "Icon", 
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16),
				ZIndex = 3,
				Image = "rbxassetid://" .. tostring(Icon),
				ImageColor3 = Utility.Themes.TextColor,
				ImageTransparency = 0.64
			})) or Utility:Create("TextLabel", {
				Name = "Icon", 
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Icon or "",
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.65,
			});
		});

		local Container = Utility:Create("ScrollingFrame", {
			Name = Title,
			Parent = Library.Container.Main,
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 134, 0, 46),
			Size = UDim2.new(1, -142, 1, -56),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Utility.Themes.DarkContrast,
			Visible = false
		}, {
			Utility:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			});
			Utility:Create("UIPadding", {
				PaddingBottom = UDim.new(0, 10)
			})
		});
		
		Container.CanvasSize = UDim2.new(0, 0, 0, Container.AbsoluteSize.Y)

		return setmetatable({
			Library = Library,
			Container = Container,
			Button = Button,
			Sections = {}
		}, Page)
	end
	
	function Section.new(Page, Title, Split)
		local Container = Utility:Create("ImageLabel", {
			Name = Title,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 0, 28),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.LightContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 296, 296),
			ClipsDescendants = true
		}, {
			Utility:Create("Frame", {
				Name = "Container",
				Active = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				--Position = UDim2.new(0, 8, 0, 8),
				--Size = UDim2.new(1, -16, 1, -16)
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				Utility:Create("TextLabel", {
					Name = "Title",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 20),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Utility.Themes.TextColor,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTransparency = 1
				});
				Utility:Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				});
			});
			Utility:Create("UIPadding", {
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8),
			});
		});
		
		Container.Parent = Page.Container
		
		if Split and Split.Split then
			if not Split.Side then Split.Side = "Left" end
			
			if Split.Split["Container_"..Split.Side] then
				Container.Parent = Split.Split["Container_"..Split.Side]
			end
		end

		return setmetatable({
			Page = Page,
			Container = Container.Container,
			Colorpickers = {},
			Modules = {},
			Binds = {},
			Lists = {},
		}, Section) 
	end
	
	function Library:AddPage(...)
		local Page = Page.new(self, ...)
		local Button = Page.Button

		table.insert(self.Pages, Page)
		
		Button.MouseButton1Click:Connect(function()
			self:SelectPage(Page, true)
		end)

		return Page
	end

	function Page:AddSection(...)
		local Section = Section.new(self, ...)

		table.insert(self.Sections, Section)

		return Section
	end
	
	-------------------------
	----- [ FUNCTIONS ] -----
	-------------------------
	function Library:SetTheme(Theme, Color)
		Utility.Themes[Theme] = Color

		for Property, Objects in pairs(Utility.Objects[Theme]) do
			for Index, Object in pairs(Objects) do
				if not Object.Parent or (Object.Name == "Button" and Object.Parent.Name == "ColorPicker") then
					Objects[Index] = nil -- i can do this because weak tables :D
				else
					Object[Property] = Color
				end
			end
		end
	end

	function Library:Toggle()
		if self.Toggling then return end
		if self.Container.Parent then
			self.Toggling = true
		
			local Container = self.Container.Main
			local Topbar = Container.TopBar
			local Frame = Topbar.Button.Frame
			
			local Position = {
				In = UDim2.new(0, 2, 0.5, -6),
				Out = UDim2.new(0, 20, 0.5, -6)
			}

			if self.Minimized then
				if self.FocusedPage then self.FocusedPage.Container.Visible = true end
				
				Utility:Tween(Frame, {Size = UDim2.new(1, -22, 1, -9), Position = Position["In"] + UDim2.new(0, 0, 0, 2.5)}, 0.2)
				wait(0.1)
				Utility:Tween(Frame, {Size = UDim2.new(1, -22, 1, -4), Position = Position["In"]}, 0.1)
				
				Utility:Tween(Container, {Size = self.Size}, 0.2)
				wait(0.2)

				--Container.ClipsDescendants = false
				self.Minimized = false
			else
				self.Minimized = true
				--Container.ClipsDescendants = true
				
				Utility:Tween(Frame, {Size = UDim2.new(1, -22, 1, -9), Position = Position["Out"] + UDim2.new(0, 0, 0, 2.5)}, 0.2)
				wait(0.1)
				Utility:Tween(Frame, {Size = UDim2.new(1, -22, 1, -4), Position = Position["Out"]}, 0.1)

				Utility:Tween(Container, {Size = UDim2.new(0, self.Size.X.Offset, 0, Topbar.Size.Y.Offset)}, 0.2)
				wait(0.2)
				
				if self.FocusedPage then self.FocusedPage.Container.Visible = false end
			end

			self.Toggling = false
		end
	end
	
	function Library:Notify(Title, Text, Callback)
		if self.ActiveNotification then
			self.ActiveNotification = self.ActiveNotification()
		end
		
		local Notification = Utility:Create("ImageLabel", {
			Name = "Notification",
			Parent = self.Container,
			Draggable = true,
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 200, 0, 60),
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.Background,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 296, 296),
			ZIndex = 3,
			ClipsDescendants = true
		}, {
			Utility:Create("UIPadding", {
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 8),
			});
			Utility:Create("ImageLabel", {
				Name = "Flash",
				Position = UDim2.new(0, -10, 0, -8),
				Size = UDim2.new(1, 20, 1, 16),
				BackgroundTransparency = 1,
				Image = "rbxassetid://4641149554",
				ImageColor3 = Utility.Themes.TextColor,
				ZIndex = 5
			});
			Utility:Create("ImageLabel", {
				Name = "Glow",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -25, 0, -23),
				Size = UDim2.new(1, 50, 1, 46),
				ZIndex = 2,
				Image = "rbxassetid://5028857084",
				ImageColor3 = Utility.Themes.Glow,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(24, 24, 276, 276)
			});
			Utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -40, 0, 16),
				ZIndex = 4,
				Font = Enum.Font.GothamBold,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left
			});
			Utility:Create("TextLabel", {
				Name = "Text",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 1, -16),
				Size = UDim2.new(1, -40, 0, 16),
				ZIndex = 4,
				Font = Enum.Font.Gotham,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12.000,
				TextXAlignment = Enum.TextXAlignment.Left
			});
			Utility:Create("ImageButton", {
				Name = "Accept",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 0, 16),
				Image = "rbxassetid://5012538259",
				ImageColor3 = Utility.Themes.TextColor,
				ZIndex = 4
			});
			Utility:Create("ImageButton", {
				Name = "Decline",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -16, 1, -16),
				Size = UDim2.new(0, 16, 0, 16),
				Image = "rbxassetid://5012538583",
				ImageColor3 = Utility.Themes.TextColor,
				ZIndex = 4
			})
		})
		
		-- Position and Size
		Title = Title or "Notification"
		Text = Text or ""

		Notification.Title.Text = Title
		Notification.Text.Text = Text

		local Padding = 10
		local TextSize = Notification.Text.TextBounds

		Notification.Position = Library.LastNotification or UDim2.new(0, Padding, 1, -(Notification.AbsoluteSize.Y + Padding))
		Notification.Size = UDim2.new(0, 0, 0, 60)

		Utility:Tween(Notification, {Size = UDim2.new(0, TextSize.X + 70, 0, 60)}, 0.2)
		wait(0.2)

		Notification.ClipsDescendants = false
		Utility:Tween(Notification.Flash, {
			Size = UDim2.new(0, 0, 0, 60),
			Position = UDim2.new(1, 10, 0, -8)
		}, 0.2)

		-- Callbacks
		local Active = true
		local Close = function()
			if not Active then return end

			Active = false
			Notification.ClipsDescendants = true

			Library.LastNotification = Notification.Position
			Notification.Flash.Position = UDim2.new(0, -10, 0, -8)
			Utility:Tween(Notification.Flash, {Size = UDim2.new(1, 20, 1, 16)}, 0.2)

			wait(0.2)
			Utility:Tween(Notification, {
				Size = UDim2.new(0, 0, 0, 60),
				Position = Notification.Position + UDim2.new(0, TextSize.X + 70, 0, 0)
			}, 0.2)

			wait(0.2)
			Notification:Destroy()
		end

		self.ActiveNotification = Close

		Notification.Accept.MouseButton1Click:Connect(function()
			if not Active then return end
			if Callback then Callback(true) end
			Close()
		end)

		Notification.Decline.MouseButton1Click:Connect(function()
			if not Active then return end
			if Callback then Callback(false) end
			Close()
		end)
	end
	
	function Library:Enabled(Enabled)
		self.Container.Enabled = Enabled
	end
	
	---------------------------
	----- [ New MODULES ] -----
	---------------------------
	function Section:AddLabel(Text)
		local Label = Utility:Create("TextLabel", {
			Name = "TextLabel",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 14),
			ZIndex = 2,
			Font = Enum.Font.Gotham,
			Text = Text or "",
			TextColor3 = Utility.Themes.TextColor,
			TextSize = 12,
			TextTransparency = 0.10000000149012,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left
		})
		
		Label:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Label = Label,
			Text = Text,
			Functions = Functions,
			Update = Update,
		}, {})
		function Update(...) self:UpdateLabel(MetaTable, ...) end
		
		table.insert(self.Modules, MetaTable.Label)
		
		return MetaTable
	end
	
	function Section:AddButton(Title, Callback)
		local Button = Utility:Create("ImageButton", {
			Name = "Button",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			Utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012
			})
		})
		
		Button:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Button = Button,
			Title = Title,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateButton(MetaTable, ...) end

		table.insert(self.Modules, MetaTable.Button)

		local Text = Button.Title
		local Debounce = false;
		
		function Functions:Click()
			if Debounce then return end

			-- [ Animation ]
			Utility:Pop(Button, 10)

			Debounce = true
			Text.TextSize = 0
			Utility:Tween(Button.Title, {TextSize = 14}, 0.2)

			wait(0.2)
			Utility:Tween(Button.Title, {TextSize = 12}, 0.2)

			if MetaTable.Callback then
				MetaTable.Callback(function(...)
					MetaTable.Section:UpdateButton(MetaTable, ...)
				end)
			end

			Debounce = false
		end
		
		Button.MouseButton1Click:Connect(function()
			Functions:Click()
		end)

		return MetaTable
	end
	
	function Section:AddToggle(Title, Callback, Data)
		Data = Data or {Active = false}
		Data.Active = Data.Active or false
		
		local Toggle = Utility:Create("ImageButton", {
			Name = "Toggle",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		},{
			Utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, 1),
				Size = UDim2.new(0.5, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Utility:Create("ImageLabel", {
				Name = "Button",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -50, 0.5, -8),
				Size = UDim2.new(0, 40, 0, 16),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("ImageLabel", {
					Name = "Frame",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 2, 0.5, -6),
					Size = UDim2.new(1, -22, 1, -4),
					ZIndex = 2,
					Image = "rbxassetid://5028857472",
					ImageColor3 = Utility.Themes.TextColor,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				})
			})
		})
		
		Toggle:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Toggle = Toggle,
			Title = Title,
			Data = Data,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateToggle(MetaTable, ...) end

		table.insert(self.Modules, MetaTable.Toggle)

		self:UpdateToggle(MetaTable, nil, {Active = MetaTable.Data.Active})
		
		function Functions:Toggle()
			MetaTable.Data.Active = not MetaTable.Data.Active
			MetaTable.Section:UpdateToggle(MetaTable, nil, {Active = MetaTable.Data.Active})

			if MetaTable.Callback then
				MetaTable.Callback(MetaTable.Data.Active, function(...)
					MetaTable.Section:UpdateToggle(MetaTable, ...)
				end)
			end
		end
		
		Toggle.MouseButton1Click:Connect(function()
			Functions:Toggle()
		end)

		return MetaTable
	end
	
	function Section:AddTextbox(Title, Callback, Data)
		Data = Data or {Text = "", Placeholder = "", MultiLine = false, Pattern = "", RequireEntered = false}
		Data.Text = Data.Text or ""
		Data.Placeholder = Data.Placeholder or ""
		Data.MultiLine = Data.MultiLine or false
		Data.Pattern = Data.Pattern or ""
		Data.RequireEntered = Data.RequireEntered or false
		
		local Textbox = Utility:Create("ImageButton", {
			Name = "Textbox",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			Utility:Create("UIPadding", {
				PaddingBottom = UDim.new(0, 7),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 7)
			}),
			Utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 9),
				Size = UDim2.new(0.5, 0, 0, 30),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Utility:Create("ImageLabel", {
				Name = "Button",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 100, 1, 0),
				ZIndex = 3,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("ScrollingFrame", {
					Name = "TextContainer",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 5, 0, 0),
					Size = UDim2.new(1, -10, 1, 0),
					ZIndex = 4,
					ClipsDescendants = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarThickness = 0
				}, {
					Utility:Create("UIPadding", {
						PaddingBottom = UDim.new(0, 2),
					}),
					Utility:Create("TextLabel", {
						Name = "Placeholder",
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 4,
						Font = Enum.Font.GothamBold,
						Text = Data.Placeholder,
						TextColor3 = Utility.Themes.TextColor,
						TextTransparency = 0.5,
						TextSize = 11,
					}, {
						Utility:Create("TextBox", {
							Name = "Textbox", 
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							MultiLine = Data.MultiLine or false,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 4,
							Font = Enum.Font.GothamBold,
							Text = Data.Text,
							TextColor3 = Utility.Themes.TextColor,
							TextSize = 11,
							TextWrapped = true,
							ClearTextOnFocus = false
						})
					})
				})
			})
		})
		
		Textbox:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Textbox = Textbox,
			Title = Title,
			Data = Data,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateTextbox(MetaTable, ...) end

		table.insert(self.Modules, MetaTable.Textbox)

		local Button = Textbox.Button
		local Placeholder = Button.TextContainer.Placeholder
		local Input = Placeholder.Textbox
		
		if Input.Text == "" then Placeholder.Text = MetaTable.Data.Placeholder
		else Placeholder.Text = "" end
		
		function Functions:Focus()
			if Textbox.Button.Size ~= UDim2.new(0, 100, 1, 0) then return end

			Input:CaptureFocus()
		end
		
		Textbox.MouseButton1Click:Connect(function()
			Functions:Focus()
		end)

		Input:GetPropertyChangedSignal("Text"):Connect(function()
			if Input.Text == "" then Placeholder.Text = MetaTable.Data.Placeholder
			else Placeholder.Text = "" end
			
			if Input.Text ~= "" and MetaTable.Data.Pattern ~= "" then
				if string.find(Input.Text, MetaTable.Data.Pattern) then
					local I, J = string.find(Input.Text, MetaTable.Data.Pattern)
					Input.Text = Input.Text:sub(I, J)
				else Input.Text = "" end
			end
			
			MetaTable.Data.Text = Input.Text
			if Button.ImageTransparency == 0 and (Button.Size == UDim2.new(1, 0, 1, 0) or Button.Size == UDim2.new(0, 100, 1, 0)) then
				Utility:Pop(Button, 10)
			end -- i know, i dont like this either
			
			if not MetaTable.Data.RequireEntered then
				if MetaTable.Callback then
					MetaTable.Callback(Input.Text, nil, function(...)
						self:UpdateTextbox(MetaTable, ...)
					end)
				end
			end
		end)
		
		Input:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			Button.TextContainer.CanvasPosition = Vector2.new(0, Button.TextContainer.AbsoluteCanvasSize.Y)
		end)
		
		Textbox:GetPropertyChangedSignal("Size"):Connect(function()
			self:Resize()
		end)
		
		Input.Focused:Connect(function()
			if MetaTable.Data.MultiLine then Utility:Tween(Textbox, {Size = UDim2.new(1, 0, 0, 100)}, 0.2)
			else Utility:Tween(Textbox, {Size = UDim2.new(1, 0, 0, 30)}, 0.2) end
			Utility:Tween(Textbox.Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.2)
			wait()
			
			Placeholder.TextXAlignment = Enum.TextXAlignment.Left
			Input.TextXAlignment = Enum.TextXAlignment.Left
			if MetaTable.Data.MultiLine then
				Placeholder.TextYAlignment = Enum.TextYAlignment.Top
				Input.TextYAlignment = Enum.TextYAlignment.Top
			else
				Placeholder.TextYAlignment = Enum.TextYAlignment.Center
				Input.TextYAlignment = Enum.TextYAlignment.Center
			end
			wait(0.2)
			Textbox.Title.Visible = false
		end)

		Input.FocusLost:Connect(function(enterPressed)
			MetaTable.Data.Text = Input.Text
			Placeholder.TextXAlignment = Enum.TextXAlignment.Center
			Placeholder.TextYAlignment = Enum.TextYAlignment.Center
			Input.TextXAlignment = Enum.TextXAlignment.Center
			Input.TextYAlignment = Enum.TextYAlignment.Center
			
			Utility:Tween(Textbox, {Size = UDim2.new(1, 0, 0, 30)}, 0.2)
			Utility:Tween(Textbox.Button, {Size = UDim2.new(0, 100, 1, 0)}, 0.2)
			
			if MetaTable.Callback and (MetaTable.Data.RequireEntered and enterPressed) then
				MetaTable.Callback(Input.Text, true, function(...)
					self:UpdateTextbox(MetaTable, ...)
				end)
			end
			
			wait(0.2)
			Textbox.Title.Visible = true
			Button.TextContainer.CanvasPosition = Vector2.new(0, Button.TextContainer.AbsoluteCanvasSize.Y)
		end)
		
		return MetaTable
	end
	
	function Section:AddKeybind(Title, Callback, ChangedCallback, Data)
		Data = Data or {Key = nil}
		Data.Key = Data.Key or nil
		if typeof(Data.Key) == "string" then Data.Key = Enum.KeyCode[Data.Key] end
		
		local Keybind = Utility:Create("ImageButton", {
			Name = "Keybind",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			Utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, 1),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Utility:Create("ImageLabel", {
				Name = "Button",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -110, 0.5, -8),
				Size = UDim2.new(0, 100, 0, 16),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("TextLabel", {
					Name = "Text",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Font = Enum.Font.GothamBold,
					Text = Data.Key and Data.Key.Name or "None",
					TextColor3 = Utility.Themes.TextColor,
					TextSize = 11
				})
			})
		})
		
		Keybind:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Keybind = Keybind,
			Title = Title,
			Data = Data,
			Callback = Callback,
			ChangedCallback = ChangedCallback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateKeybind(MetaTable, ...) end

		table.insert(self.Modules, MetaTable.Keybind)

		local Text = Keybind.Button.Text
		local Button = Keybind.Button

		local Animate = function()
			if Button.ImageTransparency == 0 then
				Utility:Pop(Button, 10)
			end
		end

		self.Binds[Keybind] = {Callback = function()
			if MetaTable.Section.Container.Parent.Visible then
				Animate()

				if MetaTable.Callback then
					MetaTable.Callback(function(...)
						self:UpdateKeybind(MetaTable, ...)
					end)
				end
			end
		end}

		if MetaTable.Data.Key and MetaTable.Callback then self:UpdateKeybind(MetaTable, nil, {Key = MetaTable.Data.Key}) end
		
		function Functions:SetKey()
			Animate()

			if MetaTable.Section.Binds[Keybind].Connection then return MetaTable.Section:UpdateKeybind(MetaTable) end -- unbind

			if Text.Text == "None" then -- new bind
				Text.Text = "..."

				local Key = Utility:KeyPressed()
				MetaTable.Data.Key = Key.KeyCode

				MetaTable.Section:UpdateKeybind(MetaTable, nil, {Key = Key.KeyCode})
				Animate()

				if MetaTable.ChangedCallback then
					MetaTable.ChangedCallback(Key, function(...)
						MetaTable.Section:UpdateKeybind(MetaTable, ...)
					end)
				end
			end
		end
		
		Keybind.MouseButton1Click:Connect(function()
			Functions:SetKey()
		end)

		return MetaTable
	end
	
	function Section:AddSlider(Title, Callback, Data)
		Data = Data or {Value = 1, Min = 0, Max = 1}
		Data.Value = Data.Value or 1
		Data.Min = Data.Min or 0
		Data.Max = Data.Max or 1
		
		local Slider = Utility:Create("ImageButton", {
			Name = "Slider",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 50),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			Utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 6),
				Size = UDim2.new(0.5, 0, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Utility:Create("TextBox", {
				Name = "TextBox",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -30, 0, 6),
				Size = UDim2.new(0, 20, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.GothamBold,
				Text = Data.Value or Data.Min,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right
			}),
			Utility:Create("TextLabel", {
				Name = "Slider",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 28),
				Size = UDim2.new(1, -20, 0, 16),
				ZIndex = 3,
				Text = "",
			}, {
				Utility:Create("ImageLabel", {
					Name = "Bar",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 4),
					ZIndex = 3,
					Image = "rbxassetid://5028857472",
					ImageColor3 = Utility.Themes.LightContrast,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				}, {
					Utility:Create("ImageLabel", {
						Name = "Fill",
						BackgroundTransparency = 1,
						Size = UDim2.new(0.8, 0, 1, 0),
						ZIndex = 3,
						Image = "rbxassetid://5028857472",
						ImageColor3 = Utility.Themes.TextColor,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 298, 298)
					}, {
						Utility:Create("ImageLabel", {
							Name = "Circle",
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageTransparency = 1.000,
							ImageColor3 = Utility.Themes.TextColor,
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(0, 10, 0, 10),
							ZIndex = 3,
							Image = "rbxassetid://4608020054"
						})
					})
				})
			})
		})
		
		Slider:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Slider = Slider,
			Title = Title,
			Data = Data,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateSlider(MetaTable, ...) end

		table.insert(self.Modules, MetaTable.Slider)

		local Allowed = {
			[""] = true,
			["-"] = true
		}

		local Textbox = Slider.TextBox
		local Circle = Slider.Slider.Bar.Fill.Circle
		
		local Dragging, Last

		local Callback = function(Value)
			if MetaTable.Callback then
				MetaTable.Callback(Value, function(...)
					self:UpdateSlider(MetaTable, ...)
				end)
			end
		end

		self:UpdateSlider(MetaTable, nil, {Value = MetaTable.Data.Value, Min = MetaTable.Data.Min, Max = MetaTable.Data.Max})

		Utility:DraggingEnded(function() Dragging = false end)
		
		Slider.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true

				while Dragging do
					Utility:Tween(Circle, {ImageTransparency = 0}, 0.1)

					MetaTable.Data.Value = self:UpdateSlider(MetaTable, nil, {Value = nil, Min = MetaTable.Data.Min, Max = MetaTable.Data.Max, LValue = MetaTable.Data.Value})
					Callback(MetaTable.Data.Value)

					Utility:Wait()
				end

				wait(0.5)
				Utility:Tween(Circle, {ImageTransparency = 1}, 0.2)
			end
		end)

		Textbox.FocusLost:Connect(function()
			if not tonumber(Textbox.Text) then
				MetaTable.Data.Value = self:UpdateSlider(MetaTable, nil, {Value = MetaTable.Data.Value or MetaTable.Data.Min, Min = MetaTable.Data.Min, Max = MetaTable.Data.Max})
				Callback(MetaTable.Data.Value)
			end
		end)

		Textbox:GetPropertyChangedSignal("Text"):Connect(function()
			local Text = Textbox.Text

			if not Allowed[Text] and not tonumber(Text) then
				Textbox.Text = Text:sub(1, #Text - 1)
			elseif not Allowed[Text] then	
				MetaTable.Data.Value = self:UpdateSlider(MetaTable, nil, {Value = tonumber(Text) or MetaTable.Data.Value, Min = MetaTable.Data.Min, Max = MetaTable.Data.Max})
				Callback(MetaTable.Data.Value)
			end
		end)

		return MetaTable
	end

	function Section:AddDropdown(Title, Callback, Data)
		Data = Data or {Options = {}, Value = nil, MultiValue = false, ExpandLimit = 3}
		Data.Options = Data.Options or {}
		Data.Value = Data.Value or nil
		Data.MultiValue = Data.MultiValue or false
		Data.ExpandLimit = Data.ExpandLimit or 3
		
		local Dropdown = Utility:Create("Frame", {
			Name = "Dropdown",
			Parent = self.Container,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 30),
			ClipsDescendants = true
		}, {
			Utility:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			Utility:Create("ImageLabel", {
				Name = "Search",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.DarkContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("Frame", {
					Name = "Container",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 2
				}, {
					Utility:Create("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Utility:Create("UIPadding", {
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10)
					}),
					Utility:Create("TextLabel", {
						Name = "1 Title",
						AnchorPoint = Vector2.new(0, 0.5),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 0, 1, 0),
						ZIndex = 3,
						Font = Enum.Font.Gotham,
						Text = Title or "",
						TextColor3 = Utility.Themes.TextColor,
						TextSize = 12,
						TextTransparency = 0.10000000149012,
						TextXAlignment = Enum.TextXAlignment.Left,
						ClipsDescendants = true
					}),
					Utility:Create("TextBox", {
						Name = "2 TextBox",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 3,
						Font = Enum.Font.Gotham,
						Text = (not Data.MultiValue and (Data.Value or Data.Options[1])) or "",
						TextColor3 = Utility.Themes.TextColor,
						TextSize = 12,
						TextTransparency = 0.10000000149012,
						TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false
					}),
					Utility:Create("Frame", {
						Name = "3 Button",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(1, -28, 0.5, -9),
						Size = UDim2.new(0, 18, 0, 18),
						ZIndex = 3,
					}, {
						Utility:Create("ImageButton", {
							Name = "Button",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 3,
							Image = "rbxassetid://5012539403",
							ImageColor3 = Utility.Themes.TextColor,
							SliceCenter = Rect.new(2, 2, 298, 298)
						})
					})
				})
			}),
			Utility:Create("ImageLabel", {
				Name = "List",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, -34),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.Background,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("ScrollingFrame", {
					Name = "Frame",
					Active = true,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 4, 0, 4),
					Size = UDim2.new(1, -8, 1, -8),
					CanvasPosition = Vector2.new(0, 28),
					CanvasSize = UDim2.new(0, 0, 0, 120),
					ZIndex = 2,
					ScrollBarThickness = 3,
					ScrollBarImageColor3 = Utility.Themes.DarkContrast
				}, {
					Utility:Create("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					})
				})
			})
		})
		
		Dropdown:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Dropdown = Dropdown,
			Title = Title,
			Data = Data,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateDropdown(MetaTable, ...) end
		
		table.insert(self.Modules, MetaTable.Dropdown)

		local Search = Dropdown.Search
		local Focused
			
		function Functions:Hide()
			MetaTable.Section:UpdateDropdown(MetaTable, nil, {})
		end
		
		Search.Container["1 Title"].InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then
				Search.Container["2 TextBox"]:CaptureFocus();
			end
		end)
		
		Search.Container["2 TextBox"].Size = UDim2.new(1, -(Search.Container["1 Title"].AbsoluteSize.X + 18), 1, 0)
		
		Search.Container["3 Button"].Button.MouseButton1Click:Connect(function()
			if Search.Container["3 Button"].Button.Rotation == 0 then
				self:UpdateDropdown(MetaTable, nil, {Options = MetaTable.Data.Options})
			else
				self:UpdateDropdown(MetaTable, nil, {})
			end
		end)

		Search.Container["2 TextBox"].Focused:Connect(function()
			if Search.Container["3 Button"].Button.Rotation == 0 then
				self:UpdateDropdown(MetaTable, nil, {Options = MetaTable.Data.Options})
			end

			Focused = true
			Utility:Tween(Dropdown.Search.Container["2 TextBox"], {
				Size = UDim2.new(1, -18, 1, 0)
			}, 0.2)
			Search.Container["1 Title"].Visible = false
		end)

		Search.Container["2 TextBox"].FocusLost:Connect(function()
			Focused = false
			Utility:Tween(Dropdown.Search.Container["2 TextBox"], {
				Size = UDim2.new(1, -(Dropdown.Search.Container["1 Title"].AbsoluteSize.X + 18), 1, 0)
			}, 0.2)
			Search.Container["1 Title"].Visible = true
			if MetaTable.Data.MultiValue then
				Search.Container["2 TextBox"].Text = ""
			end
		end)

		Search.Container["2 TextBox"]:GetPropertyChangedSignal("Text"):Connect(function()
			if Focused then
				local Options = Utility:Sort(Search.Container["2 TextBox"].Text, MetaTable.Data.Options)
				Options = #Options ~= 0 and Options

				self:UpdateDropdown(MetaTable, nil, {Options = Options})
			end
		end)

		Dropdown:GetPropertyChangedSignal("Size"):Connect(function() self:Resize() end)
		
		return MetaTable
	end
	
	function Section:AddRadio(Title, Callback, Data)
		Data = Data or {Options = {}, Selected = nil, Column = 3}
		Data.Options = Data.Options or {}
		Data.Selected = Data.Selected or nil
		Data.Column = Data.Column or 3
		
		local Radio = Utility:Create("ImageLabel", {
			Name = "Radio",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 53),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			Utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 6),
				Size = UDim2.new(1, -20, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Utility:Create("ImageLabel", {
				Name = "Options",
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 5, 1, -5),
				Size = UDim2.new(1, -10, 1, -28),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("Frame", {
					Name = "Container",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 5, 0, 5),
					Size = UDim2.new(1, -10, 1, -10),
					ZIndex = 2,
					ClipsDescendants = true
				}, {
					Utility:Create("UIGridLayout", {
						CellPadding = UDim2.new(0, 10, 0, 10),
						CellSize = UDim2.new(0.32, -10, 0, 15),
						FillDirectionMaxCells = 3,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					})
				})
			})
		})
		
		Radio:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Radio = Radio,
			Title = Title,
			Data = Data,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateRadio(MetaTable, ...) end
		
		table.insert(self.Modules, MetaTable.Radio)
		
		self:UpdateRadio(MetaTable, MetaTable.Title, {})
		
		return MetaTable
	end
	
	function Section:AddCheckbox(Title, Callback, Data)
		Data = Data or {Options = {}, Selected = {}, Column = 3}
		Data.Options = Data.Options or {}
		Data.Selected = Data.Selected or {}
		Data.Column = Data.Column or 3
		
		local Checkbox = Utility:Create("ImageLabel", {
			Name = "Checkbox",
			Parent = self.Container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 53),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = Utility.Themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			Utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 6),
				Size = UDim2.new(1, -20, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Utility.Themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Utility:Create("ImageLabel", {
				Name = "Options",
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 5, 1, -5),
				Size = UDim2.new(1, -10, 1, -28),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("Frame", {
					Name = "Container",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 5, 0, 5),
					Size = UDim2.new(1, -10, 1, -10),
					ZIndex = 2,
					ClipsDescendants = true
				}, {
					Utility:Create("UIGridLayout", {
						CellPadding = UDim2.new(0, 10, 0, 10),
						CellSize = UDim2.new(0.32, -10, 0, 15),
						FillDirectionMaxCells = 3,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					})
				})
			})
		})
		
		Checkbox:GetPropertyChangedSignal("Visible"):Connect(function() self:Resize(true) end)
		
		local Functions = {}
		local MetaTable = setmetatable({
			Section = self,
			Checkbox = Checkbox,
			Title = Title,
			Data = Data,
			Callback = Callback,
			Functions = Functions,
			Update = Update
		}, {})
		function Update(...) self:UpdateCheckbox(MetaTable,...) end

		table.insert(self.Modules, MetaTable.Checkbox)
		
		self:UpdateCheckbox(MetaTable, MetaTable.Title, {})
		
		return MetaTable
	end
	
	-------------------------------
	----- [ CLASS FUNCTIONS ] -----
	-------------------------------
	function Library:SelectPage(Page, Toggle)
		if Toggle and self.FocusedPage == Page then return end -- already selected

		local Button = Page.Button

		if Toggle then
			-- [ Page Button ]
			Button.Title.TextTransparency = 0
			Button.Title.Font = Enum.Font.GothamBold

			if Button:FindFirstChild("Icon") then
				if Button.Icon.ClassName == "ImageLabel" then Button.Icon.ImageTransparency = 0
				else Button.Icon.TextTransparency = 0 end
			end

			-- [ Update Selected Page ]
			local FocusedPage = self.FocusedPage
			self.FocusedPage = Page

			if FocusedPage then self:SelectPage(FocusedPage) end

			-- [ Sections ]
			local ExistingSections = FocusedPage and #FocusedPage.Sections or 0
			local SectionsRequired = #Page.Sections - ExistingSections

			Page:Resize()

			for Index, Section in pairs(Page.Sections) do
				Section.Container.Parent.ImageTransparency = 0
			end

			if SectionsRequired < 0 then -- "hides" some sections
				for Index = ExistingSections, #Page.Sections + 1, -1 do
					local Section = FocusedPage.Sections[Index].Container.Parent

					Utility:Tween(Section, {ImageTransparency = 1}, 0.1)
				end
			end

			wait(0.1)
			Page.Container.Visible = true

			if FocusedPage then FocusedPage.Container.Visible = false end

			if SectionsRequired > 0 then -- "creates" more section
				for Index = ExistingSections + 1, #Page.Sections do
					local Section = Page.Sections[Index].Container.Parent

					Section.ImageTransparency = 1
					Utility:Tween(Section, {ImageTransparency = 0}, 0.05)
				end
			end

			wait(0.05)

			for Index, Section in pairs(Page.Sections) do

				Utility:Tween(Section.Container.Title, {TextTransparency = 0}, 0.1)
				Section:Resize(true)

				wait(0.05)
			end

			wait(0.05)
			Page:Resize(true)
		else
			-- [ Page Button ]
			Button.Title.Font = Enum.Font.Gotham
			Button.Title.TextTransparency = 0.65

			if Button:FindFirstChild("Icon") then
				if Button.Icon.ClassName == "ImageLabel" then Button.Icon.ImageTransparency = 0.65
				else Button.Icon.TextTransparency = 0.65 end
			end

			-- [ Sections ]
			for Index, Section in pairs(Page.Sections) do	
				Utility:Tween(Section.Container.Parent, {Size = UDim2.new(1, -10, 0, 28)}, 0.1)
				Utility:Tween(Section.Container.Title, {TextTransparency = 1}, 0.1)
			end

			wait(0.1)

			Page.LastPosition = Page.Container.CanvasPosition.Y
			Page:Resize()
		end
	end
	
	function Page:AddSplit()
		local Split = Utility:Create("Frame", {
			Name = "Split",
			Parent = self.Container,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			ZIndex = 2,
			ClipsDescendants = true
		}, {
			Utility:Create("Frame", {
				Name = "Left",
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.new(0.5, 0, 0, 0),
				ZIndex = 2,
				ClipsDescendants = true
			}, {
				Utility:Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				});
			});
			Utility:Create("Frame", {
				Name = "Right",
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.new(0.5, 0, 0, 0),
				ZIndex = 2,
				ClipsDescendants = true
			}, {
				Utility:Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				});
			});
			Utility:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Horizontal
			});
		})

		return setmetatable({
			Container_Left = Split.Left,
			Container_Right = Split.Right,
		}, {})
	end
	
	function Page:Resize(Scroll)
		local Padding = 10
		local Size = 0

		for Index, Section in pairs(self.Sections) do
			Size = Size + Section.Container.Parent.AbsoluteSize.Y + Padding
		end

		--self.Container.CanvasSize = UDim2.new(0, 0, 0, Size)
		self.Container.ScrollBarImageTransparency = Size > self.Container.AbsoluteSize.Y

		if Scroll then
			Utility:Tween(self.Container, {CanvasPosition = Vector2.new(0, self.LastPosition or 0)}, 0.2)
		end
	end
	
	function Page:Enabled(Enabled)
		self.Button.Visible = Enabled
		self.Container.Visible = Enabled
	end
	
	function Section:Resize(Smooth)
		if self.Page.Library.FocusedPage ~= self.Page then return end
		
		local Padding = 4
		local Size = (4 * Padding) + self.Container.Title.AbsoluteSize.Y -- Offset
		
		for Index, Module in pairs(self.Modules) do
			if Module.Visible then
				Size = Size + Module.AbsoluteSize.Y + Padding
			end
		end

		if Smooth then
			Utility:Tween(self.Container.Parent, {Size = UDim2.new(1, -10, 0, Size)}, 0.05)
		else
			self.Container.Parent.Size = UDim2.new(1, -10, 0, Size)
			self.Page:Resize()
		end
	end

	function Section:Enabled(Enabled)
		self.Container.Parent.Visible = Enabled
	end
	
	function Section:GetModule(Info)
		if table.find(self.Modules, Info) then return Info end

		for Index, Module in pairs(self.Modules) do
			if (Module:FindFirstChild("Title") or Module:FindFirstChild("TextBox", true)).Text == Info then
				return Module
			end
		end

		error("No module found under "..tostring(Info))
	end
	
	------------------------------
	----- [ MODULE UPDATES ] -----
	------------------------------
	function Section:UpdateLabel(MetaTable, Text)
		local Label = self:GetModule(MetaTable.Label)
		
		Label.Text = Text
	end
	
	function Section:UpdateButton(MetaTable, Title)
		local Button = self:GetModule(MetaTable.Button)

		Button.Title.Text = Title
	end
	
	function Section:UpdateToggle(MetaTable, Title, Data)
		local Toggle = self:GetModule(MetaTable.Toggle)

		local Position = {
			In = UDim2.new(0, 2, 0.5, -6),
			Out = UDim2.new(0, 20, 0.5, -6)
		}

		local Frame = Toggle.Button.Frame
		local Value = Data.Active and "Out" or "In"

		if Title then Toggle.Title.Text = Title end

		Utility:Tween(Frame, {Size = UDim2.new(1, -22, 1, -9), Position = Position[Value] + UDim2.new(0, 0, 0, 2.5)}, 0.2)

		wait(0.1)
		Utility:Tween(Frame, {Size = UDim2.new(1, -22, 1, -4), Position = Position[Value]}, 0.1)
	end
	
	function Section:UpdateTextbox(MetaTable, Title, Data)
		local Textbox = self:GetModule(MetaTable.Textbox)

		if Title then Textbox.Title.Text = Title end
		if Data and Data.Placeholder then Textbox.Button.TextContainer.Placeholder.Text = Data.Placeholder end
		if Data and Data.Text then Textbox.Button.TextContainer.Placeholder.Textbox.Text = Data.Text end
	end
	
	function Section:UpdateKeybind(MetaTable, Title, Data)
		local Keybind = self:GetModule(MetaTable.Keybind)

		local Text = Keybind.Button.Text
		local Bind = self.Binds[Keybind]

		if Title then Keybind.Title.Text = Title end

		if Bind.Connection then Bind.Connection = Bind.Connection:UnBind() end

		if Data and Data.Key then
			self.Binds[Keybind].Connection = Utility:BindToKey(Data.Key, Bind.Callback)
			Text.Text = Data.Key.Name
		else
			Text.Text = "None"
		end
	end
	
	function Section:UpdateSlider(MetaTable, Title, Data)
		local Slider = self:GetModule(MetaTable.Slider)

		if Title then Slider.Title.Text = Title end

		local Bar = Slider.Slider.Bar
		local Percent = (Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X

		if Data and Data.Value then Percent = (Data.Value - Data.Min) / (Data.Max - Data.Min) end -- support negative ranges

		Percent = math.clamp(Percent, 0, 1)
		local Value = Data.Value or math.floor(Data.Min + (Data.Max - Data.Min) * Percent)
		Value = math.clamp(Value, MetaTable.Data.Min, MetaTable.Data.Max)

		Slider.TextBox.Text = Value
		Utility:Tween(Bar.Fill, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.1)

		if Data and Data.LValue and Value ~= Data.LValue and Slider.ImageTransparency == 0 then Utility:Pop(Slider, 10) end

		return Value
	end

	function Section:UpdateDropdown(MetaTable, Title, Data)
		local Dropdown = self:GetModule(MetaTable.Dropdown)

		if Title then
			Dropdown.Search.Container["1 Title"].Text = Title
			Dropdown.Search.Container["2 TextBox"].Size = UDim2.new(1, -(Dropdown.Search.Container["1 Title"].AbsoluteSize.X + 18), 1, 0)
		end
		if Data and Data.Value then
			if typeof(Data.Value) == "table" then
				Dropdown.Search.Container["2 TextBox"].Text = ""
			else
				Dropdown.Search.Container["2 TextBox"].Text = Data.Value
			end
		end

		local Entries = 0

		Utility:Pop(Dropdown.Search, 10)

		for Index, Button in pairs(Dropdown.List.Frame:GetChildren()) do
			if Button:IsA("ImageButton") then Button:Destroy() end
		end
		
		local Debounce;
		local Animate = function(Item, Active)
			if Active then
				Utility:Tween(Item, {ImageColor3 = Utility.Themes.TextColor}, 0.2)
			else
				Utility:Tween(Item, {ImageColor3 = Utility.Themes.DarkContrast}, 0.2)
			end
		end
		
		for Index, Item in pairs(Data and Data.Options or {}) do
			local Button = Utility:Create("ImageButton", {
				Parent = Dropdown.List.Frame,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Utility.Themes.DarkContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				Utility:Create("UIPadding", {
					PaddingBottom = UDim.new(0, 2),
					PaddingLeft = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 2),
					PaddingTop = UDim.new(0, 2)
				}),
				Utility:Create("ImageLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Image = "rbxassetid://5028857472",
					ImageColor3 = Utility.Themes.DarkContrast,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				}, {
					Utility:Create("UIPadding", {
						PaddingLeft = UDim.new(0, 8),
						PaddingRight = UDim.new(0, 8),
					}),
					Utility:Create("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 3,
						Font = Enum.Font.Gotham,
						Text = Item,
						TextColor3 = Utility.Themes.TextColor,
						TextSize = 12,
						TextXAlignment = "Left",
						TextTransparency = 0.10000000149012
					})
				})
			})
			
			local Active = false;

			if MetaTable.Data.Value then
				if typeof(MetaTable.Data.Value) == "table" then
					for Index, Value in pairs(MetaTable.Data.Value) do
						if Value ~= Item then continue end
						Active = true
						break
					end
				elseif MetaTable.Data.Value == Item then
					Active = true
				end
				
				if Active then
					Button.ImageColor3 = Utility.Themes.TextColor;
				end
			end

			Button.MouseButton1Click:Connect(function()
				if Debounce then return end
				Debounce = true;
				
				if MetaTable.Data.MultiValue then
					local NewSelected = {};
					local Located = false;
					
					if MetaTable.Data.Value then
						for Index, Value in pairs(MetaTable.Data.Value) do
							if Value == Item then Located = true; continue end
							table.insert(NewSelected, Value)
						end
					end
					
					if not Located then table.insert(NewSelected, Item); Active = true else Active = false end
					Animate(Button, Active)
					
					MetaTable.Data.Value = NewSelected
					if MetaTable.Callback then
						MetaTable.Callback(NewSelected, function(...)
							self:UpdateCheckbox(MetaTable, ...)
						end)
					end
				else
					MetaTable.Data.Value = Item

					if MetaTable.Callback then
						MetaTable.Callback(Item, function(...)
							self:UpdateDropdown(Dropdown, ...)
						end)
					end

					self:UpdateDropdown(MetaTable, nil, {Value = Item})
				end
				
				wait(.1)
				Debounce = false;
			end)

			Entries = Entries + 1
		end

		local Frame = Dropdown.List.Frame

		Utility:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, (Entries == 0 and 30) or math.clamp(Entries, 0, MetaTable.Data.ExpandLimit) * 34 + 38)}, 0.3)
		Utility:Tween(Dropdown.Search.Container["3 Button"].Button, {Rotation = (Data and Data.Options) and 180 or 0}, 0.3)

		if Entries > MetaTable.Data.ExpandLimit then
			for Index, Button in pairs(Dropdown.List.Frame:GetChildren()) do
				if Button:IsA("ImageButton") then Button.Size = UDim2.new(1, -6, 0, 30) end
			end

			Frame.CanvasSize = UDim2.new(0, 0, 0, (Entries * 34) - 4)
			Frame.ScrollBarImageTransparency = 0
		else
			Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
			Frame.ScrollBarImageTransparency = 1
		end
	end
	
	function Section:UpdateRadio(MetaTable, Title, Data)
		local Radio = self:GetModule(MetaTable.Radio)
		
		if Title then Radio.Title.Text = Title; end
		
		local Lines = math.floor(#MetaTable.Data.Options / MetaTable.Data.Column);
		if (#MetaTable.Data.Options / MetaTable.Data.Column) % 1 > 0 then Lines = Lines + 1; end

		local Size = (Lines * 15) + ((Lines - 1) * 10);

		Radio.Size = UDim2.new(1, 0, 0, 38 + Size)
		Radio.Options.Container.UIGridLayout.FillDirectionMaxCells = MetaTable.Data.Column
		Radio.Options.Container.UIGridLayout.CellSize = UDim2.new((math.round(100/MetaTable.Data.Column)-1)/100, -10, 0, 15)
		
		for Index, Button in pairs(Radio.Options.Container:GetChildren()) do
			if Button:IsA("ImageButton") then Button:Destroy() end
		end
		
		local Debounce;
		local Animate = function(Item)
			for Index, Button in pairs(Radio.Options.Container:GetChildren()) do
				if Button:IsA("ImageButton") then
					if Button == Item then
						Button.Radio.Fill.Visible = true;
						Button.Radio.Fill.Size = UDim2.new(0, 0, 0, 0)
						Utility:Tween(Button.Radio.Fill, {Size = UDim2.new(0, 13, 0, 13)}, 0.2)
					else
						if Button.Radio.Fill.Visible == true then
							Button.Radio.Fill.Size = UDim2.new(0, 13, 0, 13)
							Utility:Tween(Button.Radio.Fill, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
							wait(0.2)
							Button.Radio.Fill.Visible = false;
						end
					end
				end
			end
		end
		
		for Index, Item in pairs(MetaTable.Data.Options) do
			local Option = Utility:Create("ImageButton", {
				Name = "Option",
				Parent = Radio.Options.Container,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, {
				Utility:Create("Frame", {
					Name = "Radio",
					BackgroundColor3 = Utility.Themes.TextColor,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 15, 0, 15),
					ZIndex = 2,
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0.5, 0),
					}),
					Utility:Create("Frame", {
						Name = "Fill",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Utility.Themes.DarkContrast,
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 13, 0, 13),
						ZIndex = 3,
						Visible = false
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0.5, 0),
						})
					})
				}),
				Utility:Create("TextLabel", {
					Name = "Item",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 20, 0, 0),
					Size = UDim2.new(1, -20, 1, 0),
					ZIndex = 2,
					Font = Enum.Font.Gotham,
					Text = Item,
					TextColor3 = Utility.Themes.TextColor,
					TextSize = 12,
					TextTransparency = 0.10000000149012,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})

			if MetaTable.Data.Selected ~= nil then
				if Item == MetaTable.Data.Selected then
					MetaTable.Data.Selected = Item;
					Option.Radio.Fill.Visible = true;
				end
			else
				MetaTable.Data.Selected = Item;
				Option.Radio.Fill.Visible = true;
			end

			Option.MouseButton1Click:Connect(function()
				if Debounce then return end
				Debounce = true;

				MetaTable.Data.Selected = Item
				Animate(Option)
				if MetaTable.Callback then
					MetaTable.Callback(Item, function(...)
						self:UpdateCheckbox(MetaTable, ...)
					end)
				end

				wait(.1)
				Debounce = false;
			end)

		end
	end
	
	function Section:UpdateCheckbox(MetaTable, Title, Data)
		local Checkbox = self:GetModule(MetaTable.Checkbox)

		if Title then Checkbox.Title.Text = Title end
		
		local Lines = math.floor(#MetaTable.Data.Options / MetaTable.Data.Column);
		if (#MetaTable.Data.Options / MetaTable.Data.Column) % 1 > 0 then Lines = Lines + 1; end

		local Size = (Lines * 15) + ((Lines - 1) * 10);

		Checkbox.Size = UDim2.new(1, 0, 0, 38 + Size)
		Checkbox.Options.Container.UIGridLayout.FillDirectionMaxCells = MetaTable.Data.Column
		Checkbox.Options.Container.UIGridLayout.CellSize = UDim2.new((math.round(100/MetaTable.Data.Column)-1)/100, -10, 0, 15)
		
		for Index, Button in pairs(Checkbox.Options.Container:GetChildren()) do
			if Button:IsA("ImageButton") then Button:Destroy() end
		end
		
		local Debounce;
		local Animate = function(Item, Active)
			if Active then
				Item.Checkbox.Fill.Visible = true;
				Item.Checkbox.Fill.Size = UDim2.new(0, 0, 0, 0)
				Utility:Tween(Item.Checkbox.Fill, {Size = UDim2.new(0, 13, 0, 13)}, 0.2)
			else
				Item.Checkbox.Fill.Size = UDim2.new(0, 13, 0, 13)
				Utility:Tween(Item.Checkbox.Fill, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
				wait(0.2)
				Item.Checkbox.Fill.Visible = false;
			end
		end
		
		for Index, Item in pairs(MetaTable.Data.Options) do
			local Option = Utility:Create("ImageButton", {
				Name = "Option",
				Parent = Checkbox.Options.Container,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, {
				Utility:Create("Frame", {
					Name = "Checkbox",
					BackgroundColor3 = Utility.Themes.TextColor,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 15, 0, 15),
					ZIndex = 2,
				}, {
					Utility:Create("UICorner", {
						CornerRadius = UDim.new(0.2, 0),
					}),
					Utility:Create("Frame", {
						Name = "Fill",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Utility.Themes.DarkContrast,
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 13, 0, 13),
						ZIndex = 3,
						Visible = false
					}, {
						Utility:Create("UICorner", {
							CornerRadius = UDim.new(0.2, 0),
						})
					})
				}),
				Utility:Create("TextLabel", {
					Name = "Item",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 20, 0, 0),
					Size = UDim2.new(1, -20, 1, 0),
					ZIndex = 2,
					Font = Enum.Font.Gotham,
					Text = Item,
					TextColor3 = Utility.Themes.TextColor,
					TextSize = 12,
					TextTransparency = 0.10000000149012,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
			
			local Active = false;
			
			if MetaTable.Data.Selected then
				for Index, Value in pairs(MetaTable.Data.Selected) do
					if Value ~= Item then continue end
					Active = true
					
					Option.Checkbox.Fill.Visible = true;
					break
				end
			end
			
			Option.MouseButton1Click:Connect(function()
				if Debounce then return end
				Debounce = true;

				local NewSelected = {};
				local Located = false;
				if MetaTable.Data.Selected then
					for Index, Value in pairs(MetaTable.Data.Selected) do
						if Value == Item then Located = true; continue end
						table.insert(NewSelected, Value)
					end
				end
				if not Located then table.insert(NewSelected, Item); Active = true else Active = false end
				Animate(Option, Active)
				
				MetaTable.Data.Selected = NewSelected
				if MetaTable.Callback then
					MetaTable.Callback(NewSelected, function(...)
						self:UpdateCheckbox(MetaTable, ...)
					end)
				end

				wait(.1)
				Debounce = false;
			end)
			
		end
	end
	
end

return Library