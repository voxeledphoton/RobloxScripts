-- works with moveObject being a part or model as well

local function placeRandom(onPart,moveObject)
	local offset = onPart.Size*.5
	local newCF = onPart.CFrame:ToWorldSpace(
		CFrame.new(offset-Vector3.new(
			math.random()*offset.X*2,
			0,
			math.random()*offset.Z*2
			)
		)
	)
	if moveObject:IsA("Model") then
		moveObject:PivotTo(newCF)
	else
		moveObject.CFrame = newCF
	end
end

for i=1,32 do
	local newModel = Instance.new("Model")
	local newPart = Instance.new("Part")
	newPart.Anchored = true
	newPart.Parent = newModel
	newModel.Parent = workspace
	placeRandom(script.Parent,newModel)
end
