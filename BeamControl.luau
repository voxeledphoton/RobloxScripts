
-- USED TO CREATE HOLOGRAM EFFECT voxeledphoton
-- tutorial video: https://youtu.be/pGVUkl3lvqM?si=n2B9bnXP9Por6JbD

local RunService = game:GetService("RunService")

local beamTable = {}
local attachmentTable = {}
local beamCount = 10
local heightInc = script.Parent.Size.Y/beamCount
local heightOffset = script.Parent.Size.Y*.5 + heightInc

for i=1,beamCount do
	-- create two attachments and position them
	local width = script.Parent.Size.Z*.5
	local height = heightInc*i - heightOffset
	attachmentTable[i] = {}
	attachmentTable[i][1] = Instance.new("Attachment")
	attachmentTable[i][1].Position = Vector3.new(0,height,width)
	attachmentTable[i][3] = Vector3.new(0,height,width) -- original position
	attachmentTable[i][1].Parent = script.Parent
	attachmentTable[i][2] = Instance.new("Attachment")
	attachmentTable[i][2].Position = Vector3.new(0,height,-width)
	attachmentTable[i][4] = Vector3.new(0,height,-width) -- original position
	attachmentTable[i][2].Parent = script.Parent
	-- create beam and set attachments
	beamTable[i] = Instance.new("Beam")
	beamTable[i].Attachment0 = attachmentTable[i][1]
	beamTable[i].Attachment1 = attachmentTable[i][2]
	beamTable[i].Width0 = .2
	beamTable[i].Width1 = .2
	beamTable[i].Texture = "http://www.roblox.com/asset/?id=185021546"
	beamTable[i].Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color3.fromHSV(0.583333, 0.666667, 1)),
		ColorSequenceKeypoint.new(1,Color3.fromHSV(0.583333, 0.666667, 1))
	}
	beamTable[i].Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, .9), -- (time, value)
		NumberSequenceKeypoint.new(1, .9)
	}
	beamTable[i].LightEmission = 1
	beamTable[i].Parent = script.Parent.Beams
end



local RATE_PER_SECOND = .5
local incPos = 0

RunService.Heartbeat:Connect(function(step)
	local increment = RATE_PER_SECOND * step
	incPos = (incPos + increment)%(heightInc)
	for i=1,beamCount do
		attachmentTable[i][1].Position = attachmentTable[i][3] + Vector3.new(0,incPos,0)
		attachmentTable[i][2].Position = attachmentTable[i][4] + Vector3.new(0,incPos,0)
	end
end)
