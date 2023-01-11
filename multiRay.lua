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
	local hitResult = workspace:Raycast(origin,direction,rParams)
	if hitResult then
		if ignoreNames == nil or not table.find(ignoreNames,hitResult.Instance.Name) then
			if ignoreMaterials == nil or not table.find(ignoreMaterials,hitResult.Instance.Material) then
				table.insert(rayHits,hitResult)
				-- add the instance to the ignoreTbl so it doesn't keep hitting it
				table.insert(ignoreTbl,hitResult.Instance)
				-- keep casting cause it found another thing
				return multiRay(origin,direction,ignoreTbl,ignoreNames,ignoreMaterials,rayHits,rParams)
			end
		end
	end
	return rayHits
end
