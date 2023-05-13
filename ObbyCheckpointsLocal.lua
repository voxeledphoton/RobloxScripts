-- throw this in starterplayerscripts
local Players = game:GetService("Players")
local player = Players.LocalPlayer

for k,v in pairs(workspace:WaitForChild("Checkpoints"):GetChildren()) do
	v.Touched:Connect(function(hit)
		if hit.Parent then
			local hitplr = Players:GetPlayerFromCharacter(hit.Parent)
			if hitplr then
				if hitplr==player then
					v.Color = Color3.fromHSV(0.3745, 0.666667, 1)
				end
			end
		end
	end)
end
