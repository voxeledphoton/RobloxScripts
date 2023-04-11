-- this will select all the parent objects of the ones you currently have selected
local Selection = game:GetService("Selection")

local newSelect = {}
for _,v in Selection:Get() do
	table.insert(newSelect,v.Parent)
end
Selection:Set(newSelect)

