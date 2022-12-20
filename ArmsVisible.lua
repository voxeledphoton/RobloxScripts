-- should work with both R15 and R6
-- make this a localscript in StarterCharacterScripts

local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")

local visibleParts = {
	"Left Arm",
	"Right Arm",
	"LeftUpperArm",
	"LeftLowerArm",
	"LeftHand",
	"RightUpperArm",
	"RightLowerArm",
	"RightHand",
}

function antiTrans(part)
	if part and part:IsA("BasePart") and table.find(visibleParts,part.Name) then
		part.LocalTransparencyModifier = part.Transparency
		part.Changed:Connect(function (property)    
			part.LocalTransparencyModifier = part.Transparency
		end)
	end
end

for _,v in pairs(char:GetChildren()) do
	antiTrans(v)
end
