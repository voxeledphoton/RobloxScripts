local RunService = game:GetService("RunService")

local rayCube = workspace:WaitForChild("RayCube")


-- this will cast the rayCube to a new CF shown by the ghosted castedPart

local RunService = game:GetService("RunService")

local rayCube = workspace:WaitForChild("RayCube")

local greenPart = Instance.new("Part")
greenPart.Anchored = true
greenPart.Size = Vector3.one*.4
greenPart.Color = Color3.fromHSV(0.277778, 1, 1)
greenPart.Parent = workspace

local yellowPart = Instance.new("Part")
yellowPart.Anchored = true
yellowPart.Size = Vector3.one*.4
yellowPart.Color = Color3.fromHSV(0.166667, 1, 1)
yellowPart.Parent = workspace

local castedPart = Instance.new("Part")
castedPart.Anchored = true
castedPart.Size = rayCube.Size
castedPart.Color = Color3.fromHSV(0.166667, 1, 1)
castedPart.Transparency = .8
castedPart.CastShadow = false
castedPart.Parent = workspace

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {rayCube,yellowPart,greenPart,castedPart}

local castDist = 200

RunService.PreRender:Connect(function(dt)
	local d = rayCube.CFrame.LookVector*castDist
	local castResult = workspace:Blockcast(rayCube.CFrame,rayCube.Size,rayCube.CFrame.LookVector*castDist,rayParams)
	if castResult then
		yellowPart:PivotTo(rayCube.CFrame.Rotation+castResult.Position)
		local v = yellowPart.Position-rayCube.Position
		local projV = (d:Dot(v)/d:Dot(d))*d
		greenPart:PivotTo(rayCube.CFrame+projV)
		castedPart:PivotTo(greenPart.CFrame-greenPart.CFrame.LookVector*rayCube.Size.Z*.5)
	end
end)
