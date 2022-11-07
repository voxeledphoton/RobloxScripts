local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")

local SlideRE = Remotes:WaitForChild("Slide")
local SoundGenerator = require(RS:WaitForChild("Modules"):WaitForChild("SoundGenerator"))

local SlideSnd = script:WaitForChild("SlideSnd")
local SlidingSnd = script:WaitForChild("SlidingSnd")
local SlideFallSnd = script:WaitForChild("SlideFallSnd")

local SlideClouds = RS:WaitForChild("Parts"):WaitForChild("SlideClouds")

local function onPlayerAdded(plr)
	local sliding = Instance.new("BoolValue")
	sliding.Name = "Sliding"
	sliding.Value = false
	sliding.Parent = plr
	plr.CharacterAdded:Connect(function(char)
		local newSsnd = SlidingSnd:Clone()
		newSsnd.Parent = char.PrimaryPart
		local newFallSnd = SlideFallSnd:Clone()
		newFallSnd.Parent = char.PrimaryPart
		local theClouds = SlideClouds:Clone()
		theClouds.Parent = char.Head
	end)
end
Players.PlayerAdded:Connect(onPlayerAdded)
for i,v in ipairs(Players:GetPlayers()) do
	onPlayerAdded(v)
end

Players.PlayerRemoving:Connect(function(plr)
	plr.Sliding.Value = false
end)

SlideRE.OnServerEvent:Connect(function(plr,isSliding)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = {plr.Character}
	raycastParams.IgnoreWater = true

	local pp = plr.Character.PrimaryPart
	local ph = plr.Character.Head
	
	local Ssnd = plr.Character.PrimaryPart:FindFirstChild("SlidingSnd")
	if isSliding then
		SoundGenerator.playSoundPos(plr.Character.PrimaryPart.Position,75,110,SlideSnd,1)
		--Ssnd:Play()
		plr:WaitForChild("Sliding").Value = true
	else	
		Ssnd:Stop()
		ph.SlideClouds.Enabled = false
		plr:WaitForChild("Sliding").Value = false
	end
	
	while plr:WaitForChild("Sliding").Value do
		local raycastResult = workspace:Raycast(pp.Position, -pp.CFrame.UpVector*50, raycastParams)
		if raycastResult then
			if (raycastResult.Position-pp.Position).Magnitude<4 then
				if not Ssnd.Playing then
					Ssnd:Play()
				end
				Ssnd.Volume = math.clamp(pp.AssemblyLinearVelocity.Magnitude/20,0,1)
				if Ssnd.Volume<.1 then
					ph.SlideClouds.Enabled = false
				else
					ph.SlideClouds.Enabled = true
				end
			else
				ph.SlideClouds.Enabled = false
				Ssnd:Stop()
			end
		else
			ph.SlideClouds.Enabled = false
			Ssnd:Stop()
		end
		task.wait(.01)
	end
	
end)
