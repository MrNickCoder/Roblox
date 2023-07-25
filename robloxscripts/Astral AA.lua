-------------------------------------------------------------------------------------------------

local Library = require(game:GetService("ReplicatedStorage"):FindFirstChild("My Libraries").HoloLib)

local Window = Library.new("HoloLib Window Testing")

Settings = {}

-------------------------------------
local Page = Window:AddPage("Page")
local ButtonSection = Page:AddSection("Buttons")
local Button1 = ButtonSection:AddButton("Button", function() print("Test Button") end)
--
local ToggleSection = Page:AddSection("Toggles")
local ToggleNotActive = ToggleSection:AddToggle("Toggle Not Active", function(Value) Settings.Toggle = Value end, {Active = Settings.Toggle})
local ToggleActive = ToggleSection:AddToggle("Toggle Active", function(Value) print(Value) end, {Active = true})
--
local LabelSection = Page:AddSection("Labels")
local LabelLorem = LabelSection:AddLabel({Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet cursus sit amet dictum sit amet justo donec. Volutpat commodo sed egestas egestas fringilla phasellus. Scelerisque eleifend donec pretium vulputate sapien nec. Sapien pellentesque habitant morbi tristique senectus. Gravida arcu ac tortor dignissim convallis aenean. Est lorem ipsum dolor sit amet consectetur adipiscing. Aliquet risus feugiat in ante metus dictum. Enim nunc faucibus a pellentesque. Sit amet est placerat in egestas erat imperdiet. Senectus et netus et malesuada fames ac. Justo laoreet sit amet cursus sit amet dictum sit amet. Dui vivamus arcu felis bibendum. Rhoncus dolor purus non enim."})
local LabelTrue = LabelSection:AddLabel({Text = "Label True"})
local LabelFalse = LabelSection:AddLabel()
--
local TextboxSection = Page:AddSection("Textboxes")
local Textbox = TextboxSection:AddTextbox("Textbox", function(Value) end, {Text = ""})
--
local KeybindSection = Page:AddSection("Keybinds")
local KeybindString = KeybindSection:AddKeybind("Keybind String", function(Value) print("Called F") end, function(Value) end, {Key = nil})
local KeybindEnum = KeybindSection:AddKeybind("Keybind Enum", function(Value) print("Called G") end, function(Value) end, {Key = Enum.KeyCode.G})
--
local SliderSection = Page:AddSection("Sliders")
local SliderPositive = SliderSection:AddSlider("Slider Positive", function(Value) end, {Value = 3, Min = 1, Max = 10})
local SliderNegative = SliderSection:AddSlider("Slider Negative", function(Value) end, {Value = 0, Min = -10, Max = 10})
--
local DropdownSection = Page:AddSection("Dropdowns")
local DropdownList1 = DropdownSection:AddDropdown("Dropdown List 1", function(Value) end, {Options = {"Dirt"}, Value = "Dirt"})
local DropdownList2 = DropdownSection:AddDropdown("Dropdown List 2", function(Value) end, {Options = {"Dirt","Stone"}})
local DropdownList3 = DropdownSection:AddDropdown("Dropdown List 3", function(Value) end, {Options = {"Dirt","Stone","Wood"}})
local DropdownList4 = DropdownSection:AddDropdown("Dropdown List 4", function(Value) end, {Options = {"Dirt","Stone","Wood","Cobblestone"}})
local DropdownListMore = DropdownSection:AddDropdown("Dropdown List More", function(Value) end, {Options = {"Dirt","Stone","Wood","Cobblestone","Planks","Grass"}})
local DropdownListDisableSearch = DropdownSection:AddDropdown("Dropdown List Disable Search", function(Value) end, {Options = {"Dirt","Stone","Wood","Cobblestone","Planks","Grass"}})
--[[
local TimerSection = Page:AddSection("Timers")
local TimerNoDefault = TimerSection:AddTimer("Timer No Default", nil, nil, function(value) end)
local TimerYesDefault = TimerSection:AddTimer("Timer Yes Default", true, {HH = 0, MM = 1, SS = 20}, function(value) end)
--]]
local RadioSection = Page:AddSection("Radio")
local RadioWithoutItems = RadioSection:AddRadio("Radio Without Items", function(value) end, {Options = {}, Selected = nil})
local RadioWithSmallItems = RadioSection:AddRadio("Radio With Small Items", function(value) end, {Options = {"Item 1", "Item 2", "Item 3", "Item 4"}})
local RadioWithItems = RadioSection:AddRadio("Radio With Items", function(value) print(value) end, {Options = {"Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"}, Selected = "Item 2"})
--
local CheckboxSection = Page:AddSection("Checkbox")
local CheckboxWithoutItems = CheckboxSection:AddCheckbox("Checkbox Without Items", function(value) end, {Options = {}, Selected = {}})
local CheckboxWithItems = CheckboxSection:AddCheckbox("Checkbox With Items", function(value) end, {Options = {"Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"}, Selected = {"Item 2", "Item 5"}})
--[[
local ColorPickerSection = Page:AddSection("Color Pickers")
local ColorPickerWithDefault = ColorPickerSection:AddColorPicker("Color Picker With Default", Color3.fromRGB(150, 250, 50), function(value) end)
local ColorPickerWithoutDefault = ColorPickerSection:AddColorPicker("Color Picker Without Default", nil, function(value) end)
--
local ModelViewerSection = Page:AddSection("Model Viewer")

--]]
Window:SelectPage(Page, true)
Window.ToggleKey = Enum.KeyCode.P

local Page2 = Window:AddPage("Page 2")

wait(5)
Button1.Callback = function()
	print(Settings.FarmConfig and Settings.FarmConfig.FarmCategory or "Story Worlds")
	print("=========================")
	print(ToggleNotActive.Data.Active)
	print(Textbox.Data.Value)
	print(KeybindString.Data.Key)
	print(SliderPositive.Data.Value)
	print(DropdownList3.Data.Value)
	print(Settings.Toggle)
end