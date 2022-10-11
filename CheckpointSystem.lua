-- serverscript (ServerScriptService)
-- make a folder called Checkpoints in workspace and name all the checkpoint parts a number in sequence
-- requires the SoundGenerator module here: https://github.com/vphoton/RobloxScripts/blob/main/SoundGenerator

local checkpointFolder = workspace:WaitForChild("Checkpoints")
local checkpoints = checkpointFolder:GetChildren()

local mods = {1296424630}


local RS = game:GetService("ReplicatedStorage")
local SG = require(RS:WaitForChild("Modules"):WaitForChild("SoundGenerator"))
local ParticleEmitter = script:WaitForChild("ParticleEmitter")

local Players = game:GetService("Players")
local function onPlayerAdded(plr)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = 1
	stage.Parent = leaderstats
	plr.CharacterAdded:Connect(function(char)
		-- teleport player to checkpoint
		task.wait()
		print("tried to tp player")
		char:SetPrimaryPartCFrame(
			checkpointFolder:WaitForChild(tostring(plr.leaderstats.Stage.Value)).CFrame+Vector3.new(0,10,0)
		)
	end)
	if table.find(mods,plr.UserId) then
		plr.Chatted:Connect(function(msg)
			local tpTo = tonumber(msg)
			if tpTo then
				if plr.Character then
					plr.Character:SetPrimaryPartCFrame(
						checkpointFolder:WaitForChild(tostring(tpTo)).CFrame+Vector3.new(0,10,0)
					)
				end
			end
		end)
	end
end
Players.PlayerAdded:Connect(onPlayerAdded)
for k,v in ipairs(Players:GetPlayers()) do
	onPlayerAdded(v)
end


for k,v in pairs(checkpoints) do
	local newEmitter = ParticleEmitter:Clone()
	newEmitter.Parent = v
	newEmitter.Enabled = false
	v.Touched:Connect(function(hit)
		if hit.Parent then
			local plr = Players:GetPlayerFromCharacter(hit.Parent)
			if plr then
				local leaderstats = plr:FindFirstChild("leaderstats")
				if leaderstats then
					local stage = leaderstats:FindFirstChild("Stage")
					if stage then
						if stage.Value < tonumber(v.Name) then
							stage.Value = tonumber(v.Name)
							SG.playSound(v,75,100,nil,1)
							newEmitter.Enabled = true
							spawn(function()
								task.wait(1)
								newEmitter.Enabled = false
							end)
						end
					end
				end
			end
		end
	end)
end



-- localscript (StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

for k,v in pairs(workspace:WaitForChild("Checkpoints"):GetChildren()) do
	v.Touched:Connect(function(hit)
		if hit.Parent then
			local hitplr = Players:GetPlayerFromCharacter(hit.Parent)
			if hitplr then
				if hitplr==player then
					v.Color = Color3.fromHSV(0.3745, 0.666667, 1)
				end
			end
		end
	end)
end



