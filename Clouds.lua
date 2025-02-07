

local CS = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local cloudSpeed = .1
local cloudTravel = 128
local cloudBobSpeed = 5
local cloudBobTravel = .5

local clouds = {}
for i,cloud in ipairs(CS:GetTagged("Clouds")) do
	clouds[i] = {obj=cloud,startCF=cloud:WaitForChild("Collider").CFrame}
end
CS:GetInstanceAddedSignal("Clouds"):Connect(function(theCloud)
	table.insert(clouds,{obj=theCloud,startCF=theCloud:WaitForChild("Collider").CFrame})
end)

RunService.PreRender:Connect(function(dt)
	for _,cloudTbl in clouds do
		cloudTbl.obj:PivotTo(cloudTbl.startCF+
			Vector3.xAxis*math.sin(tick()*cloudSpeed+cloudTbl.startCF.Position.Z)*cloudTravel+
			Vector3.yAxis*math.sin(tick()*cloudBobSpeed+cloudTbl.startCF.Position.Z)*cloudBobTravel
		)
	end
end)


