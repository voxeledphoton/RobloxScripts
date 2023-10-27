local module = {}

function module.SnapGrid(thePos:Vector3,gridSize:Vector3?,offset:Vector3?)
	local gs = gridSize or Vector3.one
	local off = offset or Vector3.zero
	local gx = math.round(thePos.X/gs.X)*gs.X
	local gy = math.round(thePos.Y/gs.Y)*gs.Y
	local gz = math.round(thePos.Z/gs.Z)*gs.Z
	return Vector3.new(gx,gy,gz)+off
end


function module.generateVoxelLine(endPos:Vector3,startPos:Vector3,gridSize:Vector3?)
	local gs = gridSize or Vector3.one
	local positionTable = {}
	table.insert(positionTable,startPos)
	local x1,y1,z1,x0,y0,z0 = endPos.X,endPos.Y,endPos.Z,startPos.X,startPos.Y,startPos.Z
	local dx = math.abs(x1-x0)
	local dy = math.abs(y1-y0)
	local dz = math.abs(z1-z0)
	local stepX,stepY,stepZ
	if x0 < x1 then stepX = gs.X else stepX = -gs.X end
	if y0 < y1 then stepY = gs.Y else stepY = -gs.Y end
	if z0 < z1 then stepZ = gs.Z else stepZ = -gs.Z end
	local hypotenuse = math.sqrt(math.pow(dx,2) + math.pow(dy,2) + math.pow(dz,2))
	local hhyp = hypotenuse*.5
	local tMaxX = hhyp/dx
	local tMaxY = hhyp/dy
	local tMaxZ = hhyp/dz
	local tDeltaX = hypotenuse/dx
	local tDeltaY = hypotenuse/dy
	local tDeltaZ = hypotenuse/dz
	while x0~=x1 or y0~=y1 or z0~=z1 do
		if tMaxX < tMaxY then
			if tMaxX < tMaxZ then
				x0 += stepX
				tMaxX += tDeltaX
			elseif tMaxX > tMaxZ then
				z0 += stepZ
				tMaxZ += tDeltaZ
			else
				x0 += stepX
				tMaxX += tDeltaX
				z0 += stepZ
				tMaxZ += tDeltaZ
			end
		elseif tMaxX > tMaxY then
			if tMaxY < tMaxZ then
				y0 += stepY
				tMaxY += tDeltaY
			elseif tMaxY > tMaxZ then
				z0 += stepZ
				tMaxZ += tDeltaZ
			else
				y0 += stepY
				tMaxY += tDeltaY
				z0 += stepZ
				tMaxZ += tDeltaZ
			end
		else
			if tMaxY < tMaxZ then
				y0 += stepY
				tMaxY += tDeltaY
				x0 += stepX
				tMaxX += tDeltaX
			elseif tMaxY > tMaxZ then
				z0 += stepZ
				tMaxZ += tDeltaZ
			else
				x0 += stepX
				tMaxX += tDeltaX
				y0 += stepY
				tMaxY += tDeltaY
				z0 += stepZ
				tMaxZ += tDeltaZ
			end
		end
		table.insert(positionTable,Vector3.new(x0,y0,z0))
	end
	table.insert(positionTable,endPos)
	return positionTable
end

return module
