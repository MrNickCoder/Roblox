local Freecam = {
	Enabled = false;
	INPUT_PRIORITY = Enum.ContextActionPriority.High.Value;

	NAV_GAIN = Vector3.new(1, 1, 1) * 64;
	PAN_GAIN = Vector2.new(0.75, 1) * 8;
	FOV_GAIN = 300;

	PITCH_LIMIT = math.rad(90);

	VEL_STIFFNESS = 1.5;
	PAN_STIFFNESS = 1.0;
	FOV_STIFFNESS = 4.0;
	
	IgnoreGUI = {};
}

------------------------------------------------------------------------
-- Freecam
-- Cinematic free camera for spectating and video production.
------------------------------------------------------------------------

local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local exp   = math.exp
local rad   = math.rad
local sign  = math.sign
local sqrt  = math.sqrt
local tan   = math.tan

local ContextActionService	= game:GetService("ContextActionService")
local Players				= game:GetService("Players")
local RunService			= game:GetService("RunService")
local StarterGui			= game:GetService("StarterGui")
local UserInputService		= game:GetService("UserInputService")
local GuiService			= game:GetService("GuiService")
local Workspace				= game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = Workspace.CurrentCamera
	if newCamera then
		Camera = newCamera
	end
end)

------------------------------------------------------------------------

local GUI = {} do
	local function Create(Name, Data)
		local Object = Instance.new(Name, Data.Parent);
		for Index, Value in next, Data do
			if Index ~= "Parent" then
				if typeof(Value) == "Instance" then Value.Parent = Object;
				else Object[Index] = Value; end
			end
		end
		return Object;
	end
	
	GUI.UI = Create("ScreenGui", {
		Name = "MobileFreecam";
		Parent = LocalPlayer.PlayerGui;
		Enabled = false;
		Create("Frame", {
			Name = "Controls";
			BackgroundTransparency = 1;
			Position = UDim2.new(0, 35, 1, -179);
			Size = UDim2.new(0, 155, 0, 155);
		});
	});
	GUI.Forward = Create("Frame", {
		Parent = GUI.UI["Controls"];
		BackgroundTransparency = 0.82;
		Position = UDim2.new(0.333, 0, 0, 0);
		Size = UDim2.new(0.333, 0, 0.333, 0);
		Create("UICorner", { CornerRadius = UDim.new(0, 4); });
		Create("TextButton", { BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); Text = ""; });
		Create("TextLabel", { BackgroundTransparency = 1; Rotation = 90; Size = UDim2.new(1, 0, 1, 0); Font = Enum.Font.FredokaOne; Text = "<"; TextScaled = true; TextStrokeTransparency = 0.8; })
	});
	GUI.Backward = Create("Frame", {
		Parent = GUI.UI["Controls"];
		BackgroundTransparency = 0.82;
		Position = UDim2.new(0.333, 0, 0.667, 0);
		Size = UDim2.new(0.333, 0, 0.333, 0);
		Create("UICorner", { CornerRadius = UDim.new(0, 4); });
		Create("TextButton", { BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); Text = ""; });
		Create("TextLabel", { BackgroundTransparency = 1; Rotation = -90; Size = UDim2.new(1, 0, 1, 0); Font = Enum.Font.FredokaOne; Text = "<"; TextScaled = true; TextStrokeTransparency = 0.8; })
	});
	GUI.Left = Create("Frame", {
		Parent = GUI.UI["Controls"];
		BackgroundTransparency = 0.82;
		Position = UDim2.new(0, 0, 0.333, 0);
		Size = UDim2.new(0.333, 0, 0.333, 0);
		Create("UICorner", { CornerRadius = UDim.new(0, 4); });
		Create("TextButton", { BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); Text = ""; });
		Create("TextLabel", { BackgroundTransparency = 1; Rotation = 0; Size = UDim2.new(1, 0, 1, 0); Font = Enum.Font.FredokaOne; Text = "<"; TextScaled = true; TextStrokeTransparency = 0.8; })
	});
	GUI.Right = Create("Frame", {
		Parent = GUI.UI["Controls"];
		BackgroundTransparency = 0.82;
		Position = UDim2.new(0.667, 0, 0.333, 0);
		Size = UDim2.new(0.333, 0, 0.333, 0);
		Create("UICorner", { CornerRadius = UDim.new(0, 4); });
		Create("TextButton", { BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); Text = ""; });
		Create("TextLabel", { BackgroundTransparency = 1; Rotation = 180; Size = UDim2.new(1, 0, 1, 0); Font = Enum.Font.FredokaOne; Text = "<"; TextScaled = true; TextStrokeTransparency = 0.8; })
	});
	
	if LocalPlayer.PlayerGui:FindFirstChild("TouchGui") then
		local TouchGUI = LocalPlayer.PlayerGui["TouchGui"];
		function GUI:Show() GUI.UI.Enabled = true; TouchGUI.Parent = nil end
		function GUI:Hide() GUI.UI.Enabled = false; TouchGUI.Parent = LocalPlayer.PlayerGui; end
	end
end

------------------------------------------------------------------------

local Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

------------------------------------------------------------------------

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0

local velSpring = Spring.new(Freecam.VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(Freecam.PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(Freecam.FOV_STIFFNESS, 0)

------------------------------------------------------------------------

local Input = {} do
	local thumbstickCurve do
		local K_CURVATURE = 2.0
		local K_DEADZONE = 0.15

		local function fCurve(x)
			return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
		end

		local function fDeadzone(x)
			return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
		end

		function thumbstickCurve(x)
			return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
		end
	end

	local gamepad = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
	}

	local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		LeftShift = 0,
		RightShift = 0,
	}

	local mouse = {
		Delta = Vector2.new(),
		MouseWheel = 0,
	}

	local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
	local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
	local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
	local FOV_WHEEL_SPEED    = 1.0
	local FOV_GAMEPAD_SPEED  = 0.25
	local NAV_ADJ_SPEED      = 0.75
	local NAV_SHIFT_MUL      = 0.25

	local navSpeed = 1

	function Input.Vel(dt)
		navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

		local kGamepad = Vector3.new(
			thumbstickCurve(gamepad.Thumbstick1.X),
			thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
			thumbstickCurve(-gamepad.Thumbstick1.Y)
		)*NAV_GAMEPAD_SPEED

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A,
			keyboard.E - keyboard.Q,
			keyboard.S - keyboard.W
		)*NAV_KEYBOARD_SPEED

		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

		return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
			and not UserInputService.GamepadEnabled and not GuiService:IsTenFootInterface() then
			local x = -UserInputService:GetMouseDelta().X
			local y = -UserInputService:GetMouseDelta().Y
			local delta = Vector2.new(y, x)
			mouse.Delta = delta
		end
		local kGamepad = Vector2.new(
			thumbstickCurve(gamepad.Thumbstick2.Y),
			thumbstickCurve(-gamepad.Thumbstick2.X)
		)*PAN_GAMEPAD_SPEED
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse
	end

	function Input.Fov(dt)
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
		local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
		mouse.MouseWheel = 0
		return kGamepad + kMouse
	end

	do
		local function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function GpButton(action, state, input)
			gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		local function Thumb(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position
			return Enum.ContextActionResult.Sink
		end

		local function Trigger(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function MouseWheel(action, state, input)
			mouse[input.UserInputType.Name] = -input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, Freecam.INPUT_PRIORITY,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D
				--Enum.KeyCode.E,
				--Enum.KeyCode.Q,
				--Enum.KeyCode.Up, Enum.KeyCode.Down
			)
			ContextActionService:BindActionAtPriority("FreecamMousePan",          MousePan,   false, Freecam.INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
			ContextActionService:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, Freecam.INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
			ContextActionService:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, Freecam.INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
			ContextActionService:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, Freecam.INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
			ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, Freecam.INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(gamepad)
			Zero(keyboard)
			Zero(mouse)
			ContextActionService:UnbindAction("FreecamKeyboard")
			ContextActionService:UnbindAction("FreecamMousePan")
			ContextActionService:UnbindAction("FreecamMouseWheel")
			ContextActionService:UnbindAction("FreecamGamepadButton")
			ContextActionService:UnbindAction("FreecamGamepadTrigger")
			ContextActionService:UnbindAction("FreecamGamepadThumbstick")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = Camera.ViewportSize
	local projy = 2*tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = Workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end

------------------------------------------------------------------------

local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))
	local fov = fovSpring:Update(dt, Input.Fov(dt))

	local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))

	cameraFov = clamp(cameraFov + fov*Freecam.FOV_GAIN*(dt/zoomFactor), 1, 120)
	cameraRot = cameraRot + pan*Freecam.PAN_GAIN*(dt/zoomFactor)
	cameraRot = Vector2.new(clamp(cameraRot.x, -Freecam.PITCH_LIMIT, Freecam.PITCH_LIMIT), cameraRot.y%(2*pi))

	local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Freecam.NAV_GAIN*dt)
	cameraPos = cameraCFrame.p

	Camera.CFrame = cameraCFrame
	Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	Camera.FieldOfView = cameraFov
end

------------------------------------------------------------------------

local PlayerState = {} do
	local mouseBehavior
	local mouseIconEnabled
	local cameraType
	local cameraFocus
	local cameraCFrame
	local cameraFieldOfView
	local screenGuis = {}
	local coreGuis = {
		Backpack = true,
		Chat = true,
		Health = true,
		PlayerList = true,
	}
	local setCores = {
		BadgesNotificationsActive = true,
		PointsNotificationsActive = true,
	}

	-- Save state and set up for freecam
	function PlayerState.Push()
		for name in pairs(coreGuis) do
			coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
		end
		for name in pairs(setCores) do
			setCores[name] = StarterGui:GetCore(name)
			StarterGui:SetCore(name, false)
		end
		local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if playergui then
			for _, gui in pairs(playergui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui.Enabled then
					if table.find(Freecam.IgnoreGUI, gui.Name) then continue end
					screenGuis[#screenGuis + 1] = gui
					gui.Enabled = false
				end
			end
		end

		cameraFieldOfView = Camera.FieldOfView
		Camera.FieldOfView = 70

		cameraType = Camera.CameraType
		Camera.CameraType = Enum.CameraType.Custom

		cameraCFrame = Camera.CFrame
		cameraFocus = Camera.Focus

		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = false

		mouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	-- Restore state
	function PlayerState.Pop()
		for name, isEnabled in pairs(coreGuis) do
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
		end
		for name, isEnabled in pairs(setCores) do
			StarterGui:SetCore(name, isEnabled)
		end
		for _, gui in pairs(screenGuis) do
			if gui.Parent then
				gui.Enabled = true
			end
		end

		Camera.FieldOfView = cameraFieldOfView
		cameraFieldOfView = nil

		Camera.CameraType = cameraType
		cameraType = nil

		Camera.CFrame = cameraCFrame
		cameraCFrame = nil

		Camera.Focus = cameraFocus
		cameraFocus = nil

		UserInputService.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil

		UserInputService.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end

------------------------------------------------------------------------

do
	function Freecam.StartFreecam()
		local cameraCFrame = Camera.CFrame
		cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
		cameraPos = cameraCFrame.p
		cameraFov = Camera.FieldOfView

		velSpring:Reset(Vector3.new())
		panSpring:Reset(Vector2.new())
		fovSpring:Reset(0)

		PlayerState.Push()
		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
			and not UserInputService.GamepadEnabled and not GuiService:IsTenFootInterface() then
			GUI:Show();
		end
		RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
		Input.StartCapture()
	end

	function Freecam.StopFreecam()
		Input.StopCapture()
		RunService:UnbindFromRenderStep("Freecam")
		PlayerState.Pop()
		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
			and not UserInputService.GamepadEnabled and not GuiService:IsTenFootInterface() then
			GUI:Hide();
		end
	end
	
	function Freecam.ToggleFreecam()
		if Freecam.Enabled then Freecam.StopFreecam()
		else Freecam.StartFreecam() end
		Freecam.Enabled = not Freecam.Enabled
	end
end

return Freecam
