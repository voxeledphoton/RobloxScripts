--datastore service
local DSS = game:GetService("DataStoreService")
local PData = DSS:GetDataStore("PlayerData")
local http = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- WHEN YOU ADD A VALUE TO "data"
--   UPDATE VERSION NUMBER
--   ADD IT IN THE VERSION CHECK UPDATER
--   Instance.new() AN ACTUAL OBJECT FOR IT
--   ADD IT IN THE SAVE FUNCTION

local function onPlayerAdded(plr)
	local dataLoaded = nil
	local success, updatedData = pcall(function()
		dataLoaded = PData:GetAsync(plr.UserId)
	end)
	if success then
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
			local success, updatedData = pcall(function()
				dataLoaded = http:JSONDecode(dataLoaded)
			end)

			-- update some keys values
			if success then
				--[[
				-- VERSION CHECK UPDATER
				if dataLoaded.Version == 1 then
					-- add keys that version 1 didn't have and update version
					dataLoaded.Version = 2
				end
				]]
				dataLoaded.LastTimeJoined = os.time()
				dataLoaded.MembershipType = plr.MembershipType
				dataLoaded.AccountAge = plr.AccountAge
				dataLoaded.TimesJoined = dataLoaded.TimesJoined + 1
				local success, updatedData = pcall(function()
					PData:SetAsync(plr.UserId, http:JSONEncode(dataLoaded))
				end)
			end
		end
		-- since keys hold 4mb this might fill after 400k players since each userId is approx 10 characters
		local success, updatedData = pcall(function()
			PData:UpdateAsync("PLAYER_INDEX", function(oldData)
				local data = oldData or {}
				data[plr.UserId] = true --so as to avoid duplicate entries
				return data
			end)
		end)
		-- ADD OBJECT DATA THAT WILL EVENTUALLY BE SAVED HERE
		-- add dabloons instance value to player
		local dabloons = Instance.new("IntValue")
		dabloons.Value = dataLoaded.Dabloons
		dabloons.Name = "Dabloons"
		dabloons.Parent = plr
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _,plr in ipairs(Players:GetPlayers()) do
	onPlayerAdded(plr)
end

local function save(plr)
	-- save unlocked blocks
	local dataLoaded = nil
	local success, updatedData = pcall(function()
		dataLoaded = PData:GetAsync(plr.UserId)
		dataLoaded = http:JSONDecode(dataLoaded)
	end)
	if success then
		-- GRAB OBJECT DATA TO SAVE HERE
		dataLoaded.Dabloons = plr:WaitForChild("Dabloons").Value
		PData:SetAsync(plr.UserId, http:JSONEncode(dataLoaded))
	end
end

Players.PlayerRemoving:Connect(function(plr)
	save(plr)
end)
