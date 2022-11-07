local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = script.Parent
local hum = char:WaitForChild("Humanoid")
local animator = hum:WaitForChild("Animator")
local hrp = char:WaitForChild("HumanoidRootPart")

local slide = script:WaitForChild("Slide")

local slideAnim = animator:LoadAnimation(slide)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local SlideRE = RS:WaitForChild("Remotes"):WaitForChild("Slide")

local weight = RS:WaitForChild("Parts"):WaitForChild("Weight")

local playerScripts = player:WaitForChild("PlayerScripts")
local PlayerModule = require(playerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()


local function Slide()
	SlideRE:FireServer(true)
	Controls:Disable()
	hum.PlatformStand = true
	hrp:ApplyImpulse(hrp.CFrame.LookVector*12000+Vector3.new(0,8000,0))
	slideAnim:Play()
	hrp.CanCollide = false
	if not char:FindFirstChild("Weight") then
		local newWeight = weight:Clone()
		newWeight.CFrame = hrp.CFrame * CFrame.new(0,-3,0)
		newWeight.WeldConstraint.Part1 = hrp
		newWeight.Parent = char
	end
end
local function StopSlide()
	SlideRE:FireServer(false)
	Controls:Enable()
	hum.PlatformStand = false
	slideAnim:Stop()
	hrp.CanCollide = true
	local theWeight = char:FindFirstChild("Weight")
	if theWeight then
		theWeight:Destroy()
	end
end




UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.E then
			Slide()
		end
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.E then
			StopSlide()
		end
	end
end)
