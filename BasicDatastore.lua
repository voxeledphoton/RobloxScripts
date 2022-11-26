--datastore service
local DSS = game:GetService("DataStoreService")
local PData = DSS:GetDataStore("PlayerData")
local http = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function onPlayerAdded(plr)
	local dataLoaded = PData:GetAsync(plr.UserId)
	if not dataLoaded then
		local data = {}
		-- first time data entry
		data.Name = plr.Name
		data.AccountAge = plr.AccountAge
		data.FirstTimeJoined = os.time()
		data.TimesJoined = 0
		data.LastTimeJoined = os.time()
		data.Dabloons = 0
		data.Version = 1 -- CHANGE THIS EVERYTIME YOU UPDATE THE DATA
		-- new in version 2

		dataLoaded = data
		PData:SetAsync(plr.UserId, http:JSONEncode(data))
	else
		-- data entry update
		dataLoaded = http:JSONDecode(dataLoaded)
		
		--[[
		if dataLoaded.Version == 1 then
			-- add keys that version 1 didn't have and update version
			dataLoaded.Version = 2
		end
		]]

		-- update some keys values
		dataLoaded.LastTimeJoined = os.time()
		dataLoaded.MembershipType = plr.MembershipType
		dataLoaded.AccountAge = plr.AccountAge
		dataLoaded.TimesJoined = dataLoaded.TimesJoined + 1

		PData:SetAsync(plr.UserId, http:JSONEncode(dataLoaded))
	end

	PData:UpdateAsync("PLAYER_INDEX", function(oldData)
		local data = oldData or {}
		data[plr.UserId] = true --so as to avoid duplicate entries
		return data
	end)

	-- add dabloons instance value to player
	local dabloons = Instance.new("IntValue")
	dabloons.Value = dataLoaded.Dabloons
	dabloons.Name = "Dabloons"
	dabloons.Parent = plr
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _,plr in ipairs(Players:GetPlayers()) do
	onPlayerAdded(plr)
end

local function save(plr)
	-- save unlocked blocks
	local dataLoaded = PData:GetAsync(plr.UserId)
	dataLoaded = http:JSONDecode(dataLoaded)
	dataLoaded.Dabloons = plr:WaitForChild("Dabloons").Value
	PData:SetAsync(plr.UserId, http:JSONEncode(dataLoaded))
end

Players.PlayerRemoving:Connect(function(plr)
	save(plr)
end)
