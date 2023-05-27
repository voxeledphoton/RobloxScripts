-- throw this in a character and add accessory ids to the accessoryTbl
local IS = game:GetService("InsertService")
local accessoryTbl = {
	13119506279,
	13200538205
}
for _,accessory in accessoryTbl do
	local loaded = IS:LoadAsset(accessory)
	if loaded:IsA("Model") then
		for _,v in loaded:GetChildren() do
			v.Parent = script.Parent
		end
		loaded:Destroy()
	end
end
