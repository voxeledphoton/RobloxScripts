

local wedge = Instance.new("WedgePart")
wedge.Anchored = true
wedge.Material = Enum.Material.Plastic
wedge.TopSurface = Enum.SurfaceType.Smooth
wedge.BottomSurface = Enum.SurfaceType.Smooth
wedge.Parent = game:GetService("ReplicatedStorage")

local THICKNESS = 1

local function draw3dTriangle(a, b, c, parent, w1, w2)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)

	if (abd > acd and abd > bcd) then
		c, a = a, c
	elseif (acd > bcd and acd > abd) then
		a, b = b, a
	end

	ab, ac, bc = b - a, c - a, c - b

	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit

	local height = math.abs(ab:Dot(up))

	w1 = w1 or wedge:Clone()
	w1.Size = Vector3.new(THICKNESS, height, math.abs(ab:Dot(back)))
	w1.CFrame = CFrame.fromMatrix((a + b)/2, right, up, back)

	w2 = w2 or wedge:Clone()
	w2.Size = Vector3.new(THICKNESS, height, math.abs(ac:Dot(back)))
	w2.CFrame = CFrame.fromMatrix((a + c)/2, -right, up, -back)

	local modifier = ((w1.CFrame * CFrame.new(-1,0,0)).Position.Y < w1.Position.Y) and 1 or -1

	w1.CFrame *= CFrame.new(modifier * -THICKNESS/2,0,0)
	w2.CFrame *= CFrame.new(modifier * THICKNESS/2,0,0)

	w1.Parent = parent
	w2.Parent = parent

	return w1, w2
end

for _, curve in pairs(script.parent:GetChildren()) do
	if curve:IsA("Model") then
		-- construct table for curve parts in order
		local orderedParts = {}
		for _, part in pairs(curve:GetChildren()) do
			local theIndex = string.split(part.Name,"-")
			orderedParts[tonumber(theIndex[2])] = part
		end
		
		local fixedCurve = Instance.new("Model")
		fixedCurve.Name = "Fixed Curve"
		fixedCurve.Parent = curve
		local partCount = #orderedParts
		for i, part in ipairs(orderedParts) do
			-- color parts in order if wanted
			local color = Color3.fromHSV(i/partCount,1,1)
			-- reshape parts
			if i~=partCount then
				part.Transparency = 1
				part.CanCollide = false
				local nextPart = orderedParts[i+1]
				local p1=part.Position-part.CFrame.RightVector*part.Size.X*.5-
					part.CFrame.LookVector*part.Size.Z*.5
				local p2=part.Position+part.CFrame.RightVector*part.Size.X*.5-
					part.CFrame.LookVector*part.Size.Z*.5
				local p3=nextPart.Position+nextPart.CFrame.RightVector*nextPart.Size.X*.5-
					nextPart.CFrame.LookVector*nextPart.Size.Z*.5
				local p4=nextPart.Position-nextPart.CFrame.RightVector*nextPart.Size.X*.5-
					nextPart.CFrame.LookVector*nextPart.Size.Z*.5
				w1,w2=draw3dTriangle(p1,p2,p3,fixedCurve)
				w3,w4=draw3dTriangle(p1,p3,p4,fixedCurve)
				w1.Color = color
				w2.Color = color
				w3.Color = color
				w4.Color = color
			else
				part.Position -= part.CFrame.UpVector*part.Size.Y*.5
				part.Color = color
				part.TopSurface = Enum.SurfaceType.Smooth
			end
		end
	end
end

