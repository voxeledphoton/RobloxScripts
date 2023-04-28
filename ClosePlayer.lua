local module = {}

local Players = game:GetService("Players")

function module.FindNear(thePosition : Vector3)
	local nearestMag = 100000
	local nearPlr = nil
	local nearChar = nil
	local nearPos = nil
	for _,plr in Players:GetPlayers() do
		if plr.Character then
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local thisMag = (hrp.Position-thePosition).Magnitude
				if thisMag < nearestMag then
					nearestMag = thisMag
					nearChar = plr.Character
					nearPlr = Players:GetPlayerFromCharacter(nearChar)
					nearPos = hrp.Position
				end
			end
		end
	end
	return nearPlr,nearChar,nearPos
end



return module
