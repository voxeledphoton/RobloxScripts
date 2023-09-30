local module = {}

local TS = game:GetService("TweenService")

function module.spin(thePart : BasePart, seconds : number, rotAxis : Vector3, rotations : number, isClockwise : boolean)
	local startCF = thePart.CFrame
	local infoSeconds = seconds/3
	if rotations ~= -1 then
		infoSeconds = infoSeconds/rotations
	end
	local tweenInfo = TweenInfo.new(
		infoSeconds, -- Seconds.
		Enum.EasingStyle.Linear, -- EasingStyle.
		Enum.EasingDirection.Out, -- EasingDirection.
		0, -- Repeat count (numbers < 0 will repeat indefinitely)
		false, -- Reverses.
		0 -- Delay before repeating.
	)
	local clockMult = -1
	if isClockwise then clockMult = 1 end
	if rotations == -1 then
		while true do
			for i=1,3 do
				if not thePart then return end
				local newTween = TS:Create(thePart,tweenInfo,{
					CFrame=thePart.CFrame*CFrame.fromAxisAngle(rotAxis,120*clockMult)
				})
				newTween:Play()
				newTween.Completed:Wait()
			end
		end
	else
		for j=1,rotations do
			for i=1,3 do
				if not thePart then return false end
				local newTween = TS:Create(thePart,tweenInfo,{
					CFrame=startCF*CFrame.fromAxisAngle(rotAxis,math.pi*2/3*i*clockMult)
				})
				newTween:Play()
				newTween.Completed:Wait()
			end
		end
		return true
	end
end

return module
