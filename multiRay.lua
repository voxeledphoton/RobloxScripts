local function multiRay(origin,direction,ignoreTbl,ignoreNames,ignoreMaterials,rayHits,rParams)
	-- ignoreNames and ignoreMaterials are both tables
	-- just pass nil for them if you want all objects it hits
	if not rayHits then
		rayHits = {}
		rParams = RaycastParams.new()
		rParams.FilterType = Enum.RaycastFilterType.Blacklist
		rParams.IgnoreWater = true
	end
	rParams.FilterDescendantsInstances = ignoreTbl
	--print("oof")
	local hitResult = workspace:Raycast(origin,direction,rParams)
	if hitResult then
		--print(hitResult)
		if ignoreNames == nil or not table.find(ignoreNames,hitResult.Instance.Name) then
			if ignoreMaterials == nil or not table.find(ignoreMaterials,hitResult.Instance.Material) then
				--print("found thing")
				table.insert(rayHits,hitResult)
				-- add the instance to the ignoreTbl so it doesn't keep hitting it
				table.insert(ignoreTbl,hitResult.Instance)
				-- keep casting cause it found another thing
				if hitResult.Instance.Name == "Glass" then
					return multiRay(origin,direction,ignoreTbl,ignoreNames,ignoreMaterials,rayHits,rParams)
				end
			end
		end
	end
	return rayHits
end
local function closestRayHit(origin,rayHitTbl,ignoreName)
	local closest = nil
	local closestDist = math.huge
	for _,ray in ipairs(rayHitTbl) do
		if ray.Instance.Name ~= ignoreName then
			local thisDist = (origin-ray.Instance.Position).Magnitude
			if thisDist < closestDist then
				closest = ray
				closestDist = thisDist
			end
		end
	end
	return closest
end
