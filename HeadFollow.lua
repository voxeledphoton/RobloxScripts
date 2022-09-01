local Players = game:GetService("Players")
local char = script.Parent
local Head = char:WaitForChild("Head")
local Neck = Head:WaitForChild("Neck")
local Torso = char:WaitForChild("UpperTorso")

local function GetCloseChar()
	local closeChar = nil
	local closeDist = 100
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local pHead = plr.Character:FindFirstChild("Head")
			if pHead then
				local pDist = (pHead.Position-Head.Position).Magnitude
				if pDist<closeDist then
					closeDist = pDist
					closeChar = plr.Character
				end
			end
		end
	end
	return closeChar
end

local cframe0 = Neck.C0
local targetRot = nil
while script.Parent do
	local target = GetCloseChar()
	if target then
		local unit = -(Head.Position - target.Head.Position).Unit
		if unit:Dot(Torso.CFrame.LookVector)>.2 then -- change decimal to alter rotation limit
			targetRot = cframe0 * CFrame.Angles(0, -math.rad(Torso.Orientation.Y), 0) * CFrame.new(Vector3.zero, unit)
		else
			targetRot = cframe0 * CFrame.Angles(0, -math.rad(Torso.Orientation.Y), 0) * CFrame.new(Vector3.zero, Torso.CFrame.LookVector)
		end
		Neck.C0 = Neck.C0:Lerp(targetRot,.1) -- change decimal to change how fast to look
	end
	task.wait()
end
