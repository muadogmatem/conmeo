local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentPro"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function CreateButton(ButtonName, Name, Size1, Size2, ScriptLogic, CircleMode)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = ButtonName
	screenGui.Parent = LocalPlayer.PlayerGui
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local frame = Instance.new("Frame")
	frame.Name = ButtonName
	frame.Size = UDim2.new(Size1, 0, Size2, 0)
	frame.Position = UDim2.new(0.5 - Size1 / 2, 0, 0.5 - Size2 / 2, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.Parent = screenGui

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 4)
	frameCorner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Transparency = 0.8
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = frame

	local innerFrame = Instance.new("Frame")
	innerFrame.Size = UDim2.new(1, 6, 1, 6)
	innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	innerFrame.BackgroundTransparency = 1
	innerFrame.Parent = frame

	local innerFrameCorner = Instance.new("UICorner")
	innerFrameCorner.CornerRadius = UDim.new(0, 4)
	innerFrameCorner.Parent = innerFrame

	local innerStroke = Instance.new("UIStroke")
	innerStroke.Thickness = 2
	innerStroke.Transparency = 0.6
	innerStroke.Color = Color3.fromRGB(0, 0, 0)
	innerStroke.Parent = innerFrame

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.8, 0, 0.8, 0)
	button.Position = UDim2.new(0.5, 0, 0.5, 0)
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.BackgroundTransparency = 1
	button.Text = Name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextTransparency = 0.7
	button.TextScaled = true
	button.Font = Enum.Font.GothamBold
	button.Parent = frame

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 28, 0, 28)
	toggle.Position = UDim2.new(1, 6, 0.5, -14)
	toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	toggle.Text = "○"
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Visible = false
	toggle.Parent = frame
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local originalSize = UDim2.new(Size1, 0, Size2, 0)
	local holding, holdStart, hideAt = false, 0, 0

	frame:SetAttribute("IsCircle", false)
	local isCircle = CircleMode ~= nil and CircleMode or frame:GetAttribute("IsCircle")

	local function applyShape(circle)
		frame:SetAttribute("IsCircle", circle)
		if circle then
			local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
			frame.Size = UDim2.new(0, s, 0, s)
			button.TextWrapped = true
			button.TextScaled = true
			button.TextSize = math.floor(s * 0.45)
			frameCorner.CornerRadius = UDim.new(1, 0)
			innerFrameCorner.CornerRadius = UDim.new(1, 0)
			toggle.Text = "▢"
		else
			frame.Size = originalSize
			button.TextWrapped = false
			button.TextScaled = true
			button.TextSize = 14
			frameCorner.CornerRadius = UDim.new(0, 4)
			innerFrameCorner.CornerRadius = UDim.new(0, 4)
			toggle.Text = "○"
		end
	end

	applyShape(isCircle)

	task.spawn(function()
		while task.wait(0.25) do
			if not frame.Parent then break end
			if toggle.Visible and tick() - hideAt >= 10 then toggle.Visible = false end
		end
	end)

	button.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			holding = true
			holdStart = tick()
		end
	end)

	button.InputEnded:Connect(function(i)
		if holding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
			holding = false
			if tick() - holdStart >= 0.6 then
				toggle.Visible = true
				hideAt = tick()
			end
		end
	end)

	toggle.MouseButton1Click:Connect(function()
		hideAt = tick()
		applyShape(not frame:GetAttribute("IsCircle"))
	end)

	if ScriptLogic then
		button.Activated:Connect(function()
			ScriptLogic(button)
		end)
	end

	local function MakeDraggable(topbar, obj)
		local dragging = false
		local dragInput = nil
		local dragStart = nil
		local startPos = nil
		local holdTime = 2
		local holdToken = 0
		local holding2 = false

		topbar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = obj.Position
				holding2 = true
				holdToken = holdToken + 1
				local token = holdToken
				task.delay(holdTime, function()
					if holding2 and token == holdToken then
						obj:SetAttribute("Locked", not obj:GetAttribute("Locked"))
						holding2 = false
					end
				end)
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						holding2 = false
					end
				end)
			end
		end)

		topbar.InputChanged:Connect(function(input)
			if not dragStart then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging and not obj:GetAttribute("Locked") then
				local delta = input.Position - dragStart
				obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	MakeDraggable(button, frame)

	return frame, button, applyShape
end

local floatingGui = nil
local floatingBtn = nil

Fluent:RegisterCustomTheme("NeonBlue", {
	Accent = Color3.fromRGB(0, 180, 255),
	AcrylicMain = Color3.fromRGB(10, 14, 28),
	AcrylicBorder = Color3.fromRGB(0, 100, 180),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(10, 14, 28), Color3.fromRGB(5, 8, 20)),
	AcrylicNoise = 0.75,
	TitleBarLine = Color3.fromRGB(0, 100, 180),
	Tab = Color3.fromRGB(15, 22, 48),
	Element = Color3.fromRGB(12, 18, 40),
	ElementBorder = Color3.fromRGB(0, 80, 160),
	InElementBorder = Color3.fromRGB(0, 120, 220),
	ElementTransparency = 0.82,
	ToggleSlider = Color3.fromRGB(20, 30, 70),
	ToggleToggled = Color3.fromRGB(0, 180, 255),
	SliderRail = Color3.fromRGB(20, 30, 70),
	DropdownFrame = Color3.fromRGB(10, 16, 36),
	DropdownHolder = Color3.fromRGB(6, 10, 24),
	DropdownBorder = Color3.fromRGB(0, 80, 160),
	DropdownOption = Color3.fromRGB(14, 22, 50),
	Keybind = Color3.fromRGB(14, 22, 50),
	Input = Color3.fromRGB(8, 14, 32),
	InputFocused = Color3.fromRGB(4, 8, 20),
	InputIndicator = Color3.fromRGB(0, 120, 220),
	Dialog = Color3.fromRGB(6, 10, 24),
	DialogHolder = Color3.fromRGB(4, 8, 20),
	DialogHolderLine = Color3.fromRGB(0, 70, 140),
	DialogButton = Color3.fromRGB(10, 16, 38),
	DialogButtonBorder = Color3.fromRGB(0, 80, 160),
	DialogBorder = Color3.fromRGB(0, 80, 160),
	DialogInput = Color3.fromRGB(8, 14, 32),
	DialogInputLine = Color3.fromRGB(0, 120, 220),
	Text = Color3.fromRGB(230, 245, 255),
	SubText = Color3.fromRGB(120, 170, 220),
	Hover = Color3.fromRGB(20, 36, 80),
	HoverChange = 0.05,
	ShineEnabled = true,
	StrokeShine = true,
	StrokeDark = Color3.fromRGB(0, 60, 130),
	Shine = {
		Speed = 0.5,
		RotationSpeed = 18,
		ColorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 160)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 180, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 160)),
		}),
	},
	ButtonGradient = {
		Background = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 30, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 10, 40)),
		}),
		Stroke = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 220)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 180, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 220)),
		}),
	},
})

local Window = Fluent:CreateWindow({
	Title            = "Ly Hoang Khang",
	SubTitle         = "con meo",
	TabWidth         = 130,
	Size             = UDim2.fromOffset(460, 430),
	Acrylic          = true,
	Theme            = "Midnight Blue",
	MinimizeKey      = Enum.KeyCode.LeftControl,
	Search           = true,
	TabLogo          = "solar/planet-bold",
	UserInfoTop      = true,
	UserInfoTitle    = "Welcome",
	UserInfoSubtitle = LocalPlayer.DisplayName,
	UserInfoColor    = Color3.fromRGB(0, 180, 255),
})

Fluent:SetErrorHandler(function(msg, fullErr)
	pcall(function() Fluent:Notify({ Title = "Error", Content = tostring(msg), Type = "Error", Duration = 5 }) end)
end)

local MainTab = Window:AddTab({ Title = "Main", Icon = "solar/layers-bold" })

--// Find Tycoon
local userTycoon = (function()
	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Folder") and v.Name:match("Tycoon%d") then
			if v:FindFirstChild("Owner") and v.Owner.Value == LocalPlayer then
				return v
			end
		end
	end
end)()

if not userTycoon then
	Fluent:Notify({ Title = "Error", Content = "m bi khung ha m", Type = "Error", Duration = 6 })
	return
end

--// Variables
local AutoBuy = false
local AutoUpgrade = false
local AutoFruit = false
local AutoRebirth = false
local AutoEvolve = false
local AutoPowerLevel = false

local stats = { buys = 0, upgrades = 0, fruit = 0, rebirths = 0, evolves = 0 }

--// Auto Buy Logic
local function buyAllAffordable()
	for _, obj in ipairs(userTycoon.Purchases:GetDescendants()) do
		if obj:IsA("Model") then
			local shown = obj:GetAttribute("Shown")
			local purchased = obj:GetAttribute("Purchased")
			if shown == true and purchased ~= true then
				local purchase = obj:FindFirstChild("Purchase")
				if purchase and purchase:IsA("RemoteFunction") then
					pcall(function() purchase:InvokeServer() end)
					stats.buys = stats.buys + 1
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.05)
		if AutoBuy then
			pcall(buyAllAffordable)
		end
	end
end)

--// Auto Upgrade Logic
local upgradeRemotes  = {}
local upgradeLevel    = {}
local lastUpgradeScan = 0

local function refreshUpgradeRemotes()
	upgradeRemotes = {}
	upgradeLevel   = {}
	local purchases = userTycoon:FindFirstChild("Purchases")
	if not purchases then return end
	for _, obj in ipairs(purchases:GetDescendants()) do
		if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then
			upgradeRemotes[#upgradeRemotes + 1] = obj
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if AutoUpgrade then
			if tick() - lastUpgradeScan > 3 then
				refreshUpgradeRemotes()
				lastUpgradeScan = tick()
			end
			for _, remote in ipairs(upgradeRemotes) do
				if remote.Parent then
					local lvl = (upgradeLevel[remote] or 0) + 1
					while lvl <= 100 do
						local ok, res = pcall(function() return remote:InvokeServer(lvl) end)
						if (not ok) or res == false then break end
						upgradeLevel[remote] = lvl
						stats.upgrades = stats.upgrades + 1
						lvl = lvl + 1
					end
				end
			end
		end
	end
end)

--// Auto Power Level
local function getPowerLevelRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("UpgradePowerLevel")
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if AutoPowerLevel then
			local remote = getPowerLevelRemote()
			if remote then
				pcall(function() remote:InvokeServer() end)
			end
		end
	end
end)

--// Auto Rebirth
local RebirthGainMultiple = 1.0
local MinPotential        = 1
local RebirthCooldown     = 2
local RebirthTimeout      = 8
local rebirthBusy         = false

local function getRebirthRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Rebirth")
end

local function getRebirthedSignal()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Rebirthed")
end

local NUM_SCALE = {
	thousand=1e3, million=1e6, billion=1e9, trillion=1e12, quadrillion=1e15,
	quintillion=1e18, sextillion=1e21, septillion=1e24, octillion=1e27,
	nonillion=1e30, decillion=1e33, undecillion=1e36, duodecillion=1e39,
	tredecillion=1e42, quattuordecillion=1e45, quindecillion=1e48,
	sexdecillion=1e51, septendecillion=1e54, octodecillion=1e57,
	novemdecillion=1e60, vigintillion=1e63,
	k=1e3, m=1e6, b=1e9, t=1e12, qd=1e15, qn=1e18, sx=1e21, sp=1e24,
}
local function parseNumber(s)
	if not s then return nil end
	s = tostring(s):gsub(",", ""):lower()
	local num = s:match("[%d%.]+")
	local val = num and tonumber(num)
	if not val then return nil end
	local word = s:match("[%d%.%s]+([a-z]+)")
	if word and NUM_SCALE[word] then val = val * NUM_SCALE[word] end
	return val
end

local function investorBody()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local r  = pg and pg:FindFirstChild("Rebirth")
	local im = r and r:FindFirstChild("InvestorsMenu")
	return im and im:FindFirstChild("Body")
end
local function readQuantity(frameName)
	local body  = investorBody()
	local frame = body and body:FindFirstChild(frameName)
	local q     = frame and frame:FindFirstChild("Quantity")
	return q and parseNumber(q.Text)
end
local function getCurrentInvestors()   return readQuantity("Amount")    or 0 end
local function getPotentialInvestors() return readQuantity("Potential")       end

task.spawn(function()
	while true do
		task.wait(0.5)
		if AutoRebirth and not rebirthBusy then
			local remote    = getRebirthRemote()
			local potential = getPotentialInvestors()
			local current   = getCurrentInvestors()

			local worthIt = remote and potential
				and potential >= MinPotential
				and potential >= current * RebirthGainMultiple

			if worthIt then
				rebirthBusy = true
				pcall(function()
					local done   = false
					local signal = getRebirthedSignal()
					local conn
					if signal and signal:IsA("RemoteEvent") then
						conn = signal.OnClientEvent:Connect(function() done = true end)
					end

					remote:InvokeServer()
					stats.rebirths = stats.rebirths + 1

					local t = 0
					while not done and t < RebirthTimeout do
						task.wait(0.1)
						t = t + 0.1
					end
					if conn then conn:Disconnect() end
				end)

				task.wait(RebirthCooldown)
				rebirthBusy = false
			end
		end
	end
end)

--// Auto Evolve
local EvolveAt        = 100
local EvolveCooldown  = 2
local EvolveTimeout   = 8
local evolveBusy      = false

local function getEvolveRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Evolve")
end
local function getEvolvedSignal()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Evolved")
end
local function getEvolveProgress()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local r  = pg and pg:FindFirstChild("Rebirth")
	local em = r and r:FindFirstChild("EvolutionMenu")
	local body = em and em:FindFirstChild("Body")
	local p  = body and body:FindFirstChild("Progress")
	if not p then return nil end
	return tonumber(tostring(p.Text):match("[%d%.]+"))
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if AutoEvolve and not evolveBusy then
			local remote   = getEvolveRemote()
			local progress = getEvolveProgress()

			if remote and progress and progress >= EvolveAt then
				evolveBusy = true
				pcall(function()
					local done   = false
					local signal = getEvolvedSignal()
					local conn
					if signal and signal:IsA("RemoteEvent") then
						conn = signal.OnClientEvent:Connect(function() done = true end)
					end
					remote:InvokeServer()
					stats.evolves = stats.evolves + 1
					local t = 0
					while not done and t < EvolveTimeout do
						task.wait(0.1); t = t + 0.1
					end
					if conn then conn:Disconnect() end
				end)
				task.wait(EvolveCooldown)
				evolveBusy = false
			end
		end
	end
end)

--// Sewer Logics
local function pullAllLevers()
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return 0 end

	local map   = workspace:FindFirstChild("Map")
	local sewer = map and map:FindFirstChild("Sewer")
	local root  = sewer or workspace

	local pulled = 0
	for _, o in ipairs(root:GetDescendants()) do
		if o:IsA("BasePart") and (o.Name == "Lever" or string.find(string.lower(o.Name), "lever", 1, true)) then
			pcall(function()
				firetouchinterest(hrp, o, 0)
				firetouchinterest(hrp, o, 1)
			end)
			pulled = pulled + 1
		end
	end

	if sewer then
		for _, o in ipairs(sewer:GetDescendants()) do
			if o:IsA("BasePart") and (o.Name == "VineKey" or o.Name == "UFOKey") then
				pcall(function()
					firetouchinterest(hrp, o, 0)
					firetouchinterest(hrp, o, 1)
				end)
			end
		end
	end

	return pulled
end

local function touchPart(hrp, part)
	pcall(function()
		firetouchinterest(hrp, part, 0)
		firetouchinterest(hrp, part, 1)
	end)
end

local function doSewerRun()
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false, "no character" end

	local map   = workspace:FindFirstChild("Map")
	local sewer = map and map:FindFirstChild("Sewer")
	if not sewer then return false, "sewer not loaded" end

	for _, o in ipairs(sewer:GetDescendants()) do
		if o:IsA("BasePart") and string.find(string.lower(o.Name), "lever", 1, true) then
			touchPart(hrp, o)
		end
	end

	for _, folderName in ipairs({ "CashVine", "SewerAlien" }) do
		local folder = sewer:FindFirstChild(folderName)
		if folder then
			for _, o in ipairs(folder:GetDescendants()) do
				if o:IsA("BasePart") and (o.Name == "VineKey" or o.Name == "UFOKey") then
					touchPart(hrp, o)
				end
			end
		end
	end
	task.wait(0.3)

	local cashVine = sewer:FindFirstChild("CashVine")

	if cashVine then
		local vineDoor = cashVine:FindFirstChild("VineDoor")
		if vineDoor then
			for _, o in ipairs(vineDoor:GetDescendants()) do
				if o:IsA("BasePart") then touchPart(hrp, o) end
			end
		end
	end
	task.wait(0.3)

	if cashVine then
		local vineModel = cashVine:FindFirstChild("CashVine")
		if vineModel then
			local pivot = vineModel:GetPivot()
			pcall(function() hrp.CFrame = pivot + Vector3.new(0, 3, 0) end)
			task.wait(0.2)
			for _, o in ipairs(vineModel:GetDescendants()) do
				if o:IsA("BasePart") then touchPart(hrp, o) end
			end
		end
	end

	return true
end

local SEWER_ALIEN_POS = Vector3.new(-42, -41, 180)
local function teleportToAlien()
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false, "no character" end
	pcall(function() hrp.CFrame = CFrame.new(SEWER_ALIEN_POS) end)
	return true
end

--// Auto Fruit Logic
local Trees = {}

local function addTree(obj)
	if obj:IsA("Model") and obj.Name == "LemonTree" then
		if not table.find(Trees, obj) then
			table.insert(Trees, obj)
		end
	end
end

local function removeTree(obj)
	local index = table.find(Trees, obj)
	if index then
		table.remove(Trees, index)
	end
end

for _, v in ipairs(workspace:GetDescendants()) do
	addTree(v)
end

workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)

local function noCollisionTree(tree)
	for _, obj in ipairs(tree:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.CanCollide = false
		end
	end
end

local function teleportToTree(tree)
	local character = LocalPlayer.Character
	if not character then return false end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local cf = tree:GetPivot()
	hrp.CFrame = cf + Vector3.new(0, 5, 0)
	return true
end

local function collectFruit(tree)
	noCollisionTree(tree)
	local success = teleportToTree(tree)
	if not success then return end
	for _, obj in ipairs(tree:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Fruit" then
			obj.CanCollide = false
			local clickPart = obj:FindFirstChild("ClickPart")
			if clickPart then
				local detector = clickPart:FindFirstChildOfClass("ClickDetector")
				if detector then
					task.wait(0.45)
					pcall(function()
						fireclickdetector(detector)
					end)
					stats.fruit = stats.fruit + 1
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)
		if AutoFruit then
			for _, tree in ipairs(Trees) do
				if not AutoFruit then break end
				if tree and tree.Parent then
					pcall(function()
						collectFruit(tree)
					end)
				end
			end
		end
	end
end)

--// UI Integration
local secAuto = MainTab:AddSection("Auto Farms")
secAuto:AddToggle("AutoBuy", {
	Title = "Auto Buy",
	Icon = "solar/cart-large-bold",
	Default = false,
	Description = "Automatically buys all available items.",
	Callback = function(v)
		AutoBuy = v
		Fluent:Notify({ Title = "Auto Buy", Content = v and "Enabled" or "Disabled", Type = v and "Success" or "Info", Duration = 3 })
	end,
})

secAuto:AddToggle("AutoUpgrade", {
	Title = "Auto Upgrade",
	Icon = "solar/arrow-up-bold",
	Default = false,
	Description = "Automatically upgrades machines to max level.",
	Callback = function(v)
		AutoUpgrade = v
		Fluent:Notify({ Title = "Auto Upgrade", Content = v and "Enabled" or "Disabled", Type = v and "Success" or "Info", Duration = 3 })
	end,
})

secAuto:AddToggle("AutoFruit", {
	Title = "Auto Fruit",
	Icon = "solar/apple-bold",
	Default = false,
	Description = "Teleports & collects fruits from Lemon Trees.",
	Callback = function(v)
		AutoFruit = v
		Fluent:Notify({ Title = "Auto Fruit", Content = v and "Enabled" or "Disabled", Type = v and "Success" or "Info", Duration = 3 })
	end,
})

secAuto:AddToggle("AutoRebirth", {
	Title = "Auto Rebirth",
	Icon = "solar/restart-bold",
	Default = false,
	Description = "Rebirths automatically when optimal gain is reached.",
	Callback = function(v)
		AutoRebirth = v
		if v and not getRebirthRemote() then
			Fluent:Notify({ Title = "Auto Rebirth", Content = "Rebirth remote not found in your tycoon!", Type = "Error", Duration = 5 })
			return
		end
		Fluent:Notify({ Title = "Auto Rebirth", Content = v and "Enabled" or "Disabled", Type = v and "Success" or "Info", Duration = 3 })
	end,
})

secAuto:AddToggle("AutoEvolve", {
	Title = "Auto Evolve (x10 income)",
	Icon = "solar/star-bold",
	Default = false,
	Description = "Evolves automatically when progress bar hits 100%.",
	Callback = function(v)
		AutoEvolve = v
		if v and not getEvolveRemote() then
			Fluent:Notify({ Title = "Auto Evolve", Content = "Evolve remote not found in your tycoon!", Type = "Error", Duration = 5 })
			return
		end
		Fluent:Notify({ Title = "Auto Evolve", Content = v and "Enabled (evolves at full progress)" or "Disabled", Type = v and "Success" or "Info", Duration = 3 })
	end,
})

secAuto:AddToggle("AutoPowerLevel", {
	Title = "Auto Power Level",
	Icon = "solar/bolt-bold",
	Default = false,
	Description = "Increases Power Level automatically.",
	Callback = function(v)
		AutoPowerLevel = v
		Fluent:Notify({ Title = "Auto Power Level", Content = v and "Enabled" or "Disabled", Type = v and "Success" or "Info", Duration = 3 })
	end,
})
secAuto:AddDivider()

local secActions = MainTab:AddSection("Actions")
secActions:AddButton({
	Title = "Pull All Levers (sewer)",
	Icon = "solar/tuning-square-2-bold",
	Description = "Touches all sewer door levers and grabs keys.",
	Callback = function()
		local n = pullAllLevers()
		Fluent:Notify({
			Title = "Pull All Levers",
			Content = n > 0 and ("Pulled " .. n .. " lever(s) + grabbed sewer keys") or "No levers found (is the sewer loaded?)",
			Type = n > 0 and "Success" or "Warning",
			Duration = 4,
		})
	end,
})

secActions:AddButton({
	Title = "Vine Harvest",
	Icon = "solar/leaf-bold",
	Description = "Full sewer run: levers, keys, door, and harvest CashVine.",
	Callback = function()
		Fluent:Notify({ Title = "Vine Harvest", Content = "Running...", Type = "Info", Duration = 2 })
		task.spawn(function()
			local ok, err = doSewerRun()
			Fluent:Notify({
				Title = "Vine Harvest",
				Content = ok and "Done! Levers pulled, keys grabbed, vine harvested." or ("Failed: " .. tostring(err)),
				Type = ok and "Success" or "Error",
				Duration = 5,
			})
		end)
	end,
})

secActions:AddButton({
	Title = "Teleport to Sewer Alien",
	Icon = "solar/map-point-bold",
	Description = "Teleports you directly to the UFO Alien location.",
	Callback = function()
		local ok, err = teleportToAlien()
		Fluent:Notify({
			Title = "Teleport to Sewer Alien",
			Content = ok and "Teleported to the sewer alien (UFO)" or ("Failed: " .. tostring(err)),
			Type = ok and "Success" or "Error",
			Duration = 3,
		})
	end,
})
secActions:AddDivider()

--// LIVE STATUS PANEL
task.spawn(function()
	local parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not parent then
		local okh, hui = pcall(function() return gethui() end)
		parent = (okh and hui) or game:GetService("CoreGui")
	end
	pcall(function()
		local old = parent:FindFirstChild("AutoStatusGui")
		if old then old:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoStatusGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 9999
	gui.Parent = parent

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 168)
	frame.Position = UDim2.new(0, 10, 0, 90)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 24)
	title.BackgroundColor3 = Color3.fromRGB(38, 40, 54)
	title.BorderSizePixel = 0
	title.Text = "AUTO STATUS"
	title.TextColor3 = Color3.fromRGB(120, 235, 140)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.Parent = frame
	Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

	local body = Instance.new("TextLabel")
	body.Size = UDim2.new(1, -12, 1, -30)
	body.Position = UDim2.new(0, 8, 0, 28)
	body.BackgroundTransparency = 1
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.RichText = true
	body.Text = "starting..."
	body.TextColor3 = Color3.fromRGB(235, 235, 245)
	body.Font = Enum.Font.Code
	body.TextSize = 12
	body.Parent = frame

	local UIS = game:GetService("UserInputService")
	local dragging, ds, sp
	title.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, ds, sp = true, i.Position, frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - ds
			frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)

	local frames, fps, fpsT = 0, 0, tick()
	RunService.RenderStepped:Connect(function()
		frames = frames + 1
		if tick() - fpsT >= 1 then fps, frames, fpsT = frames, 0, tick() end
	end)

	local function on(b) return b and "<font color='#7CFF7C'>ON</font>" or "<font color='#777'>off</font>" end

	while gui.Parent do
		local cashStr = "?"
		local ls = LocalPlayer:FindFirstChild("leaderstats")
		local c  = ls and ls:FindFirstChild("Cash")
		if c then cashStr = tostring(c.Value) end

		body.Text = string.format(
			"FPS:  %d\nCash: %s\n"
			.. "Buys:  %d  %s\nUpgr:  %d  %s\nFruit: %d  %s\nReb:   %d  %s\nEvo:   %d  %s",
			fps, cashStr,
			stats.buys,     on(AutoBuy),
			stats.upgrades, on(AutoUpgrade),
			stats.fruit,    on(AutoFruit),
			stats.rebirths, on(AutoRebirth),
			stats.evolves,  on(AutoEvolve)
		)
		task.wait(0.25)
	end
end)

--// Settings & Managers Setup
local TabSettings = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })

MediaManager:SetFolder("LyHoangKhang/MediaCache")

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("LyHoangKhang")
InterfaceManager:BuildInterfaceSection(TabSettings)
InterfaceManager:LoadSettings()

SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("LyHoangKhang/Config")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(TabSettings)
SaveManager:LoadAutoloadConfig()

FloatingButtonManager:SetLibrary(Fluent)
FloatingButtonManager:SetFolder("LyHoangKhang/Floating")

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "OpenUi"
toggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.ResetOnSpawn = false

local mainBtn = Instance.new("TextButton")
mainBtn.Name = "OpenButton"
mainBtn.Parent = toggleGui
mainBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainBtn.BackgroundTransparency = 1
mainBtn.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
mainBtn.Size = UDim2.new(0, 64, 0, 42)
mainBtn.Text = ""
mainBtn.Visible = true
Instance.new("UICorner", mainBtn)

local sizeBackMulti = 0.3
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "RotatingBackground"
backgroundImage.Parent = mainBtn
backgroundImage.Size = UDim2.new(1.5 + sizeBackMulti, 0, 1.5 + sizeBackMulti, 0)
backgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
backgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = "rbxassetid://92062295706713"
backgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
backgroundImage.ZIndex = 0

local frontImage = Instance.new("ImageLabel")
frontImage.Name = "StaticIcon"
frontImage.Parent = mainBtn
frontImage.Size = UDim2.fromOffset(55, 55)
frontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
frontImage.AnchorPoint = Vector2.new(0.5, 0.5)
frontImage.BackgroundTransparency = 1
frontImage.Image = "rbxassetid://126113649238951"
frontImage.ZIndex = 1
Instance.new("UICorner", frontImage).CornerRadius = UDim.new(0.2, 0)

local rotation = 0
local rotSpeed = 90
local lastTime = tick()
task.spawn(function()
	while true do
		local now = tick()
		local delta = now - lastTime
		lastTime = now
		rotation = (rotation + rotSpeed * delta) % 360
		backgroundImage.Rotation = rotation
		task.wait()
	end
end)

local function MakeDraggableOpenUi(topbar, obj)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	local holdingDrag, holdToken = false, 0
	obj:SetAttribute("Locked", false)
	local function Update(input)
		if obj:GetAttribute("Locked") then return end
		local delta = input.Position - dragStart
		obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	local function ToggleLock()
		local newState = not obj:GetAttribute("Locked")
		obj:SetAttribute("Locked", newState)
		Fluent:Notify({ Title = newState and "Locked" or "Unlocked", Content = newState and "Locked in place." or "Can be moved.", Duration = 2 })
	end
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		dragging = not obj:GetAttribute("Locked")
		holdingDrag = true
		dragStart = input.Position
		startPos = obj.Position
		holdToken += 1
		local token = holdToken
		task.delay(1.0, function() if holdingDrag and token == holdToken then ToggleLock() end end)
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false holdingDrag = false end
		end)
	end)
	topbar.InputChanged:Connect(function(input)
		if not dragStart then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if (input.Position - dragStart).Magnitude > 6 then holdingDrag = false end
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then Update(input) end
	end)
end
MakeDraggableOpenUi(mainBtn, mainBtn)

local uiOpen = true
local function playSound(soundId)
	local sound = Instance.new("Sound")
	pcall(function() sound.SoundId = "rbxassetid://" .. soundId end)
	sound.Parent = game:GetService("SoundService")
	pcall(function() sound:Play() end)
	sound.Ended:Connect(function() sound:Destroy() end)
end

mainBtn.MouseButton1Click:Connect(function()
	local sounds = { "7127123605", "438666542" }
	playSound(sounds[math.random(#sounds)])
	uiOpen = not uiOpen
	if uiOpen then Window:Show() else Window:Hide() end
	local function smoothSpeed(target, dur)
		local start = rotSpeed
		local steps = 30
		for i = 1, steps do
			rotSpeed = start + (target - start) * (i / steps)
			task.wait(dur / steps)
		end
		rotSpeed = target
	end
	task.spawn(function()
		smoothSpeed(360, 0.4)
		task.wait(0.5)
		smoothSpeed(180, 0.4)
		task.wait(0.3)
		smoothSpeed(90, 0.4)
	end)
end)

FloatingButtonManager:AddButton("OpenUiBtn", mainBtn, false, false, nil, mainBtn)
FloatingButtonManager:BuildConfigSection(TabSettings)
FloatingButtonManager:LoadAutoloadConfig()

Fluent:Notify({ Title = "Ly Hoang Khang", Content = "da tung co 1 con meo", Type = "Success", Duration = 5 })
task.delay(0.5, function()
	Window:SelectTab(1)
end)
