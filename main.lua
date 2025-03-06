local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
function topos(cf)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end
function isFullMoon()
    local moon = Lighting:GetMoonPhase()
    return moon == Enum.MoonPhase.Full or moon == Enum.MoonPhase.WaningGibbous
end
function findHighestPoint()
    local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
    if mysticIsland then
        local highest = nil
        for _, part in pairs(mysticIsland:GetChildren()) do
            if part:IsA("BasePart") then
                if not highest or part.Position.Y > highest.Position.Y then
                    highest = part
                end
            end
        end
        return highest
    end
    return nil
end
---[Toggle = Race:AddToggle("Toggle", {Title = "Auto Pull Lever", Default = false})---]
Toggle:OnChanged(function(Value)
    getgenv().AutoPullLever = Value
end)
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoPullLever then
                if isFullMoon() then
                    local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
                    if mysticIsland then
                        topos(CFrame.new(mysticIsland.Center.Position.X, 500, mysticIsland.Center.Position.Z))
                        wait(2)
                        local highestPoint = findHighestPoint()
                        if highestPoint then
                            topos(highestPoint.CFrame * CFrame.new(0, 10, 0))
                        end
                        wait(2)
                        local moonDir = Lighting:GetMoonDirection()
                        local lookAtPos = Workspace.CurrentCamera.CFrame.p + moonDir * 100
                        Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.p, lookAtPos)
                        VirtualInputManager:SendKeyEvent(true, "T", false, game)
                        wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, "T", false, game)
                        wait(2)
                        for _, v in pairs(mysticIsland:GetChildren()) do
                            if v:IsA("MeshPart") and v.Material == Enum.Material.Neon then
                                topos(v.CFrame)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)
