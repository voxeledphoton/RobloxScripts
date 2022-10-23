local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local speedGPID = 93773349
local jumpGPID = 93774655
local speedCoil = script:WaitForChild("SpeedCoil")
local jumpCoil = script:WaitForChild("JumpCoil")

local function GiveAbility(plr, theAbility)
	local newTool = nil
	if theAbility==speedGPID then
		newTool = speedCoil:Clone()
	elseif theAbility==jumpGPID then
		newTool = jumpCoil:Clone()
	end
	newTool.Parent = plr.Backpack
end

local function hasGamepass(plr, theAbility)
	local hasPass = false
	-- Check if the player already owns the game pass
	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(plr.UserId, theAbility)
	end)
	-- If there's an error, issue a warning and exit the function
	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		return false
	end
	if hasPass then
		print(plr.Name .. " owns the game pass with ID " .. theAbility)
		return true
	end
end

-- Function to handle a completed prompt and purchase
local function onPromptGamePassPurchaseFinished(player, purchasedPassID, purchaseSuccess)
	if purchaseSuccess then 
		if purchasedPassID == speedGPID then
			print(player.Name .. " purchased the game pass with ID " .. speedGPID)
			GiveAbility(player,speedGPID)
			player.HasSpeed.Value = true
		end
		if purchasedPassID == jumpGPID then
			print(player.Name .. " purchased the game pass with ID " .. jumpGPID)
			GiveAbility(player,jumpGPID)
			player.HasJump.Value = true
		end
	end
end
MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptGamePassPurchaseFinished)


local function onPlayerAdded(plr)
	local hasSpeed = Instance.new("BoolValue")
	hasSpeed.Name = "HasSpeed"
	hasSpeed.Value = hasGamepass(plr, speedGPID)
	hasSpeed.Parent = plr
	local hasJump = Instance.new("BoolValue")
	hasJump.Name = "HasJump"
	hasJump.Value = hasGamepass(plr, jumpGPID)
	hasJump.Parent = plr
	plr.CharacterAdded:Connect(function(char)
		-- giving tool to player if they have the gamepass
		if hasSpeed.Value then
			GiveAbility(plr, speedGPID)
		end
		if hasJump.Value then
			GiveAbility(plr, jumpGPID)
		end
	end)
end
Players.PlayerAdded:Connect(onPlayerAdded)
for _,plr in ipairs(Players:GetPlayers()) do
	onPlayerAdded(plr)
end
