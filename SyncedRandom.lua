local module = {}

--[[ 
NEEDS THESE OBJECTS INSIDE
-- REMOTE EVENTS
reGrabRandom
reSendRandom
reUpdatedRandom
-- BOOL OBJECT
RandomUpdate
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local reGrabRandom = script:WaitForChild("reGrabRandom")
local reSendRandom = script:WaitForChild("reSendRandom")
local reUpdatedRandom = script:WaitForChild("reUpdatedRandom")

local function otherPlayer(plr)
	local otherPlr = nil
	for _,oplr in Players:GetPlayers() do
		if oplr ~= plr then
			return oplr
		end
	end
	return nil
end

module.thisRandom = Random.new(1234)

if RunService:IsServer() then
	local RandomUpdate = script:WaitForChild("RandomUpdate")
	reSendRandom.OnServerEvent:Connect(function(plr, randomObject)
		module.thisRandom = randomObject
		RandomUpdate.Value = true
	end)
	local latestPlayer = nil
	Players.PlayerAdded:Connect(function(plr)
		-- grab random from other player already in the game
		latestPlayer = plr
		local otherPlr = otherPlayer(plr)
		if otherPlr then
			reGrabRandom:FireClient(otherPlr)
		end
	end)
	RandomUpdate.Changed:Connect(function()
		if RandomUpdate.Value then
			reUpdatedRandom:FireClient(latestPlayer,module.thisRandom)
			RandomUpdate.Value = false
		end
	end)
	-- make it so the same random object can be used on the server script too
	-- (call this function whenever you use one of Random's functions)
	function module.RefreshRandom()
		reUpdatedRandom:FireAllClients(module.thisRandom)
	end
end

if RunService:IsClient() then
	reGrabRandom.OnClientEvent:Connect(function()
		reSendRandom:FireServer(module.thisRandom)
	end)
	reUpdatedRandom.OnClientEvent:Connect(function(newRandom)
		module.thisRandom = newRandom
	end)
end

return module
