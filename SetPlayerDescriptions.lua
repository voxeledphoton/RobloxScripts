local Players = game:GetService("Players")


function PlayerJoined(Player)
	local function RemoveMeshes(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		wait()
		local CurrentDescription = Humanoid:GetAppliedDescription() 

		CurrentDescription.Head = 0
		CurrentDescription.Torso = 0
		CurrentDescription.LeftArm = 0
		CurrentDescription.RightArm  = 0
		CurrentDescription.LeftLeg = 0
		CurrentDescription.RightLeg = 0
		
		CurrentDescription.BodyTypeScale = 0.3
		CurrentDescription.DepthScale = 1
		CurrentDescription.HeadScale = 1
		CurrentDescription.HeightScale = 1
		CurrentDescription.ProportionScale = 1
		CurrentDescription.WidthScale = 1
		Humanoid:ApplyDescription(CurrentDescription) 

	end
	Player.CharacterAdded:Connect(RemoveMeshes)
end

Players.PlayerAdded:Connect(PlayerJoined)
for _,v in ipairs(Players:GetPlayers()) do
	PlayerJoined(v)
end
