
-- [[ MONKEY CHEATS v1.3.2 - OFFICIAL ]]
-- Developer: onurlua
-- Yenilik: Slogan Geri Getirildi & Tüm Ayarlar Güncel

local lp = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- AYARLAR
local CORRECT_KEY = "MONKEY-2026-PRO"
local DISCORD_LINK = "https://discord.gg/mv9RVwbqWa"

_G.LiftActive = false
_G.LiftSpeed = 7
_G.BoxESP = false
_G.ShowNames = false
_G.ShowDistance = false
_G.ShowHealth = false

-- [[ SÜRÜKLEME FONKSİYONU ]]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ LIFT SİSTEMİ ]]
local function ApplyRainbowEffect(part)
    task.spawn(function()
        while part and part.Parent do
            local hue = (tick() % 5) / 5
            part.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.1)
        end
    end)
end

local function SpawnLift()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lp.Character.HumanoidRootPart
    local hum = lp.Character.Humanoid
    local part = Instance.new("Part")
    part.Name = "VisibleLift"
    part.Size = Vector3.new(10, 0.5, 10)
    part.CanCollide = true
    part.Parent = workspace
    ApplyRainbowEffect(part)
    part.Position = hrp.Position - Vector3.new(0, hum.HipHeight + 1.5, 0)
    
    local lv = Instance.new("LinearVelocity", part)
    local att = Instance.new("Attachment", part)
    lv.Attachment0 = att
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.new(0, _G.LiftSpeed, 0)
    task.wait(20); if part then part:Destroy() end
end

-- [[ LIFT KONTROL ]]
local function CreateLiftGui()
    local LiftGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", LiftGui); Frame.Size = UDim2.new(0, 160, 0, 100); Frame.Position = UDim2.new(0.5, 230, 0.5, -50); Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Frame)
    local Stroke = Instance.new("UIStroke", Frame); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2
    MakeDraggable(Frame)

    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1, 0, 0, 25); Title.Text = "LIFT SPEED"; Title.TextColor3 = Color3.new(1, 1, 1); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 10
    local SpeedLabel = Instance.new("TextLabel", Frame); SpeedLabel.Size = UDim2.new(1, 0, 0, 20); SpeedLabel.Position = UDim2.new(0,0,0.3,0); SpeedLabel.Text = "Speed: ".._G.LiftSpeed; SpeedLabel.TextColor3 = Color3.new(1,1,1); SpeedLabel.BackgroundTransparency = 1; SpeedLabel.Font = Enum.Font.Gotham
    
    local M = Instance.new("TextButton", Frame); M.Size = UDim2.new(0, 30, 0, 30); M.Position = UDim2.new(0.1, 0, 0.6, 0); M.Text = "-"; M.BackgroundColor3 = Color3.fromRGB(30, 30, 30); M.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", M)
    local P = Instance.new("TextButton", Frame); P.Size = UDim2.new(0, 30, 0, 30); P.Position = UDim2.new(0.35, 0, 0.6, 0); P.Text = "+"; P.BackgroundColor3 = Color3.fromRGB(30, 30, 30); P.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", P)
    local X = Instance.new("TextButton", Frame); X.Size = UDim2.new(0, 40, 0, 40); X.Position = UDim2.new(0.65, 0, 0.5, 0); X.Text = "X"; X.BackgroundColor3 = Color3.fromRGB(180, 0, 0); X.TextColor3 = Color3.new(1, 1, 1); X.Font = Enum.Font.GothamBold; X.TextSize = 20; Instance.new("UICorner", X).CornerRadius = UDim.new(1, 0)

    M.MouseButton1Click:Connect(function() _G.LiftSpeed = math.max(1, _G.LiftSpeed - 5); SpeedLabel.Text = "Speed: ".._G.LiftSpeed end)
    P.MouseButton1Click:Connect(function() _G.LiftSpeed = _G.LiftSpeed + 5; SpeedLabel.Text = "Speed: ".._G.LiftSpeed end)
    X.MouseButton1Click:Connect(function() SpawnLift() end)
    return LiftGui
end

-- [[ ESP SİSTEMİ ]]
local function CreateESP(plr)
    local Box = Drawing.new("Square"); Box.Visible = false; Box.Color = Color3.new(1, 1, 1); Box.Thickness = 1; Box.Transparency = 1; Box.Filled = false
    local Name = Drawing.new("Text"); Name.Visible = false; Name.Color = Color3.new(1, 1, 1); Name.Size = 14; Name.Center = true; Name.Outline = true
    local Distance = Drawing.new("Text"); Distance.Visible = false; Distance.Color = Color3.new(1, 1, 1); Distance.Size = 12; Distance.Center = true; Distance.Outline = true
    local HealthBar = Drawing.new("Square"); HealthBar.Visible = false; HealthBar.Thickness = 1; HealthBar.Filled = true

    RunService.RenderStepped:Connect(function()
        if _G.BoxESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr ~= lp then
            local hrp = plr.Character.HumanoidRootPart; local hum = plr.Character.Humanoid; local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local sizeX = 2000 / pos.Z; local sizeY = 3000 / pos.Z
                Box.Size = Vector2.new(sizeX, sizeY); Box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2); Box.Visible = true; Box.Color = (plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife")) and Color3.new(1,0,0) or Color3.new(0,1,0)
                if _G.ShowNames then Name.Visible = true; Name.Text = plr.Name; Name.Position = Vector2.new(pos.X, pos.Y - sizeY / 2 - 15) else Name.Visible = false end
                if _G.ShowDistance then Distance.Visible = true; local dist = math.floor((lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude); Distance.Text = "["..dist.."m]"; Distance.Position = Vector2.new(pos.X, pos.Y + sizeY / 2 + 5) else Distance.Visible = false end
                if _G.ShowHealth then HealthBar.Visible = true; HealthBar.Color = Color3.fromHSV(hum.Health/100 * 0.3, 1, 1); HealthBar.Size = Vector2.new(2, -(sizeY * (hum.Health / hum.MaxHealth))); HealthBar.Position = Vector2.new(pos.X - sizeX / 2 - 5, pos.Y + sizeY / 2) else HealthBar.Visible = false end
            else Box.Visible = false; Name.Visible = false; Distance.Visible = false; HealthBar.Visible = false end
        else
            Box.Visible = false; Name.Visible = false; Distance.Visible = false; HealthBar.Visible = false
        end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do CreateESP(v) end
game.Players.PlayerAdded:Connect(CreateESP)

-- [[ KEY SYSTEM ]]
local function ShowKeySystem()
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    local Blur = Instance.new("BlurEffect", Lighting); Blur.Size = 20
    local KeyFrame = Instance.new("Frame", KeyGui); KeyFrame.Size = UDim2.new(0, 320, 0, 180); KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0); KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5); KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Instance.new("UICorner", KeyFrame)
    local KeyStroke = Instance.new("UIStroke", KeyFrame); KeyStroke.Thickness = 3
    task.spawn(function() local h = 0 while KeyGui.Parent do h = h + (1/150); KeyStroke.Color = Color3.fromHSV(h, 1, 1); task.wait() end end)
    local KeyTitle = Instance.new("TextLabel", KeyFrame); KeyTitle.Size = UDim2.new(1, 0, 0, 45); KeyTitle.TextColor3 = Color3.fromRGB(255, 0, 0); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 18; KeyTitle.BackgroundTransparency = 1
    task.spawn(function() local fullText = "MONKEY KEY SYSTEM" while KeyGui.Parent do for i = 1, #fullText do KeyTitle.Text = string.sub(fullText, 1, i); task.wait(0.1) end task.wait(1); KeyTitle.Text = "" end end)
    local Input = Instance.new("TextBox", KeyFrame); Input.Size = UDim2.new(0.8, 0, 0, 35); Input.Position = UDim2.new(0.1, 0, 0.45, 0); Input.Text = ""; Input.PlaceholderText = "Enter Key..."; Input.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Input.TextColor3 = Color3.new(1,1,1); Input.Font = 3; Instance.new("UICorner", Input)
    local Submit = Instance.new("TextButton", KeyFrame); Submit.Size = UDim2.new(0.35, 0, 0, 35); Submit.Position = UDim2.new(0.1, 0, 0.75, 0); Submit.Text = "CHECK"; Submit.BackgroundColor3 = Color3.fromRGB(150, 0, 0); Submit.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Submit)
    local GetKey = Instance.new("TextButton", KeyFrame); GetKey.Size = UDim2.new(0.4, 0, 0, 35); GetKey.Position = UDim2.new(0.5, 0, 0.75, 0); GetKey.Text = "GET KEY"; GetKey.BackgroundColor3 = Color3.fromRGB(30, 30, 30); GetKey.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", GetKey)
    Submit.MouseButton1Click:Connect(function() if Input.Text == CORRECT_KEY then Submit.Text = "SUCCESS!"; Submit.BackgroundColor3 = Color3.fromRGB(0, 150, 0); task.wait(0.5); KeyGui:Destroy(); Blur:Destroy(); RunIntro() else Submit.Text = "INVALID!"; Submit.BackgroundColor3 = Color3.fromRGB(80, 0, 0); task.wait(1.5); Submit.Text = "CHECK"; Submit.BackgroundColor3 = Color3.fromRGB(150, 0, 0) end end)
    GetKey.MouseButton1Click:Connect(function() setclipboard(DISCORD_LINK); GetKey.Text = "COPIED!"; task.wait(1); GetKey.Text = "GET KEY" end)
end

function RunIntro()
    local IntroGui = Instance.new("ScreenGui", CoreGui); local Blur = Instance.new("BlurEffect", Lighting); Blur.Size = 25
    local Title = Instance.new("TextLabel", IntroGui); Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.Code; Title.TextSize = 65; Title.Text = ""
    local h = 0; local r = RunService.RenderStepped:Connect(function() h = h + (1/220); Title.TextColor3 = Color3.fromHSV(h, 0.8, 1) end)
    local txt = "Monkey Cheats..."
    for i = 1, #txt do Title.Text = string.sub(txt, 1, i); task.wait(0.06) end
    task.wait(1.5); r:Disconnect(); Blur:Destroy(); IntroGui:Destroy(); CreateHub()
end

-- [[ MAIN HUB ]]
function CreateHub()
    local MainGui = Instance.new("ScreenGui", CoreGui); local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 420, 0, 270); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12); MainFrame.ClipsDescendants = true; Instance.new("UICorner", MainFrame)
    local BorderStroke = Instance.new("UIStroke", MainFrame); BorderStroke.Thickness = 3
    task.spawn(function() local h = 0 while task.wait() do h = h + (1/150); BorderStroke.Color = Color3.fromHSV(h, 1, 1) end end)
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0); MainFrame.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 270), BackgroundTransparency = 0}):Play()
    MakeDraggable(MainFrame)

    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", Sidebar)
    local TitleFrame = Instance.new("Frame", Sidebar); TitleFrame.Size = UDim2.new(1, 0, 0, 60); TitleFrame.BackgroundTransparency = 1
    
    -- BAŞLIK VE SLOGAN (Geri Geldi!)
    local ShineLabel = Instance.new("TextLabel", TitleFrame); ShineLabel.Size = UDim2.new(1, 0, 0, 40); ShineLabel.Position = UDim2.new(0,0,0,5); ShineLabel.Text = "MONKEY CHEATS"; ShineLabel.Font = Enum.Font.GothamBold; ShineLabel.TextSize = 15; ShineLabel.TextColor3 = Color3.fromRGB(180, 180, 180); ShineLabel.BackgroundTransparency = 1
    local SubTitleLabel = Instance.new("TextLabel", TitleFrame); SubTitleLabel.Size = UDim2.new(1, 0, 0, 20); SubTitleLabel.Position = UDim2.new(0, 0, 0, 35); SubTitleLabel.Text = "Steal a Brainrot"; SubTitleLabel.Font = Enum.Font.GothamBold; SubTitleLabel.TextSize = 10; SubTitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150); SubTitleLabel.BackgroundTransparency = 1
    task.spawn(function() local h = 0 while task.wait() do h = h + 0.02; local brightness = (math.sin(h * 5) + 1) / 2; ShineLabel.TextColor3 = Color3.fromRGB(180 + (75 * brightness), 180 + (75 * brightness), 0); ShineLabel.TextSize = 15 + (1 * brightness) end end)

    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -145, 1, -20); Container.Position = UDim2.new(0, 135, 0, 10); Container.BackgroundTransparency = 1
    
    local Pages = {}
    local CurrentPage = nil

    local function CreatePage(name) 
        local p = Instance.new("ScrollingFrame", Container)
        p.Size = UDim2.new(0.95, 0, 0.95, 0); p.Position = UDim2.new(0.5, 0, 0.5, 0); p.AnchorPoint = Vector2.new(0.5, 0.5)
        p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0; p.CanvasSize = UDim2.new(0,0,0,0)
        local l = Instance.new("UIListLayout", p); l.Padding = UDim.new(0, 5)
        Pages[name] = p
        return p 
    end

    local function ShowPage(name)
        if CurrentPage == Pages[name] then return end
        if CurrentPage then
            local old = CurrentPage
            TweenService:Create(old, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(0.8, 0, 0.8, 0)}):Play()
            task.delay(0.1, function() old.Visible = false end)
        end
        local new = Pages[name]
        new.Visible = true; new.Size = UDim2.new(0.8, 0, 0.8, 0)
        TweenService:Create(new, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        CurrentPage = new
    end

    local MainP = CreatePage("Main"); local EspP = CreatePage("ESP"); local MiscP = CreatePage("Misc"); local CreditsP = CreatePage("Credits")
    ShowPage("Main")

    -- [[ MAIN ]]
    local liftBtn = Instance.new("TextButton", MainP); liftBtn.Size = UDim2.new(1, 0, 0, 38); liftBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); liftBtn.Text = "ACTIVATE LIFT: OFF"; liftBtn.TextColor3 = Color3.new(1, 1, 1); liftBtn.Font = Enum.Font.GothamBold; liftBtn.TextSize = 11; Instance.new("UICorner", liftBtn)
    local activeLiftGui = nil
    liftBtn.MouseButton1Click:Connect(function()
        _G.LiftActive = not _G.LiftActive
        if _G.LiftActive then liftBtn.Text = "ACTIVATE LIFT: ON"; liftBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0); activeLiftGui = CreateLiftGui()
        else liftBtn.Text = "ACTIVATE LIFT: OFF"; liftBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); if activeLiftGui then activeLiftGui:Destroy() end end
    end)

    -- [[ ESP ]]
    local function AddToggle(name, var, parent)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = name .. ": OFF"; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() _G[var] = not _G[var]; b.Text = name .. ": " .. (_G[var] and "ON" or "OFF"); b.BackgroundColor3 = _G[var] and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(25, 25, 25) end)
    end
    AddToggle("BOX ESP", "BoxESP", EspP); AddToggle("SHOW NAMES", "ShowNames", EspP); AddToggle("SHOW DISTANCE", "ShowDistance", EspP); AddToggle("SHOW HEALTH", "ShowHealth", EspP)

    -- [[ MISC ]]
    local function AddBtn(name, parent, fn)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = name; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(fn)
    end
    AddBtn("Full Bright", MiscP, function() Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000 end)
    AddBtn("Speed (Click)", MiscP, function() lp.Character.Humanoid.WalkSpeed = 50 end)
    AddBtn("Infinite Jump", MiscP, function() UserInputService.JumpRequest:Connect(function() lp.Character.Humanoid:ChangeState("Jumping") end) end)

    -- [[ CREDITS ]]
    local devL = Instance.new("TextLabel", CreditsP); devL.Size = UDim2.new(1, 0, 0, 35); devL.BackgroundTransparency = 1; devL.Text = "Developer: onurlua"; devL.Font = Enum.Font.GothamBold; devL.TextSize = 16
    task.spawn(function() local h = 0 while task.wait() do h = h + (1/100); devL.TextColor3 = Color3.fromHSV(h, 0.7, 1) end end) -- Rainbow

    local userL = Instance.new("TextLabel", CreditsP); userL.Size = UDim2.new(1, 0, 0, 30); userL.BackgroundTransparency = 1; userL.Text = "discord user = usfn"; userL.TextColor3 = Color3.fromRGB(200, 200, 200); userL.Font = Enum.Font.Gotham; userL.TextSize = 14

    -- [[ TABS ]]
    local TabButtons = {}
    local function AddTab(name, pos)
        local btn = Instance.new("TextButton", Sidebar); btn.Size = UDim2.new(0.85, 0, 0, 38); btn.Position = UDim2.new(0.07, 0, 0, pos); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); btn.BackgroundTransparency = (name == "Main" and 0.4 or 1); btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; Instance.new("UICorner", btn)
        TabButtons[name] = btn
        btn.MouseButton1Click:Connect(function() 
            ShowPage(name)
            for n, b in pairs(TabButtons) do TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = (n == name) and 0.4 or 1}):Play() end
        end)
    end
    AddTab("Main", 65); AddTab("ESP", 108); AddTab("Misc", 151); AddTab("Credits", 194)

    -- [[ MOB KONTROL İKONU ]]
    local Mob = Instance.new("TextButton", MainGui); Mob.Size = UDim2.new(0, 50, 0, 50); Mob.Position = UDim2.new(0, 15, 0.5, -25); Mob.Text = "🐵"; Mob.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Mob).CornerRadius = UDim.new(1, 0)
    local MobStroke = Instance.new("UIStroke", Mob); MobStroke.Thickness = 2
    task.spawn(function() local h = 0 while task.wait() do h = h + (1/150); MobStroke.Color = Color3.fromHSV(h, 1, 1) end end)
    MakeDraggable(Mob)
    Mob.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

ShowKeySystem()
