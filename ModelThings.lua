

-- throw this code snippet in a modulescript and name it "ModelThings"
-- make a folder in repstorage called "Modules" and throw the modulescript in there
local module = {}
local TS = game:GetService("TweenService")

function module.TweenModel(theModel, tweenInfo, propTable)
	if tweenInfo == nil then
		tweenInfo = TweenInfo.new(
			5, -- Time
			Enum.EasingStyle.Linear, -- EasingStyle
			Enum.EasingDirection.Out, -- EasingDirection
			0, -- RepeatCount (when less than zero the tween will loop indefinitely)
			false, -- Reverses (tween will reverse once reaching it's goal)
			0 -- DelayTime
		)
	end
	for k,v in pairs(theModel:GetDescendants()) do
		if v:IsA("BasePart") then
			local newTween = TS:Create(v,tweenInfo,propTable)
			newTween:Play()
		end
	end
end

-- this function is from https://devforum.roblox.com/t/is-this-the-best-way-to-scale-a-model/166021/26
function module.ScaleModelWithJoints(model, scale)
	local origin = model.PrimaryPart.Position

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Size = obj.Size*scale

			local distance = (obj.Position - model:GetPrimaryPartCFrame().p)
			local rotation = (obj.CFrame - obj.Position)
			obj.CFrame = (CFrame.new(model:GetPrimaryPartCFrame().p + distance*scale) * rotation)
		elseif obj:IsA("JointInstance") then
			local c0NewPos = obj.C0.p*scale
			local c0RotX, c0RotY, c0RotZ = obj.C0:ToEulerAnglesXYZ()
			
			local c1NewPos = obj.C1.p*scale
			local c1RotX, c1RotY, c1RotZ = obj.C1:ToEulerAnglesXYZ()

			obj.C0 = CFrame.new(c0NewPos)*CFrame.Angles(c0RotX, c0RotY, c0RotZ)
			obj.C1 = CFrame.new(c1NewPos)*CFrame.Angles(c1RotX, c1RotY, c1RotZ)
		end
	end
end


return module





-- then throw this in a server or localscript to test it (change TreeFade to your model name)
local RS = game:GetService("ReplicatedStorage")
local ModelThings = require(RS:WaitForChild("Modules"):WaitForChild("ModelThings"))
local theModel = workspace:WaitForChild("TreeFade")

while script.Parent do
	task.wait(10)
	ModelThings.TweenModel(theModel,nil,{Transparency = 1})

	task.wait(10)
	ModelThings.TweenModel(theModel,nil,{Transparency = 0})
end
