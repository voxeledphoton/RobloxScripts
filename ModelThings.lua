

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
