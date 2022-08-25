-- RUN THIS AFTER SELECTING THE MODEL OR OBJECT YOU WANT TO ALTER THE DESCENDANTS OF.

local Selection = game:GetService("Selection")
local selected = Selection:Get()[1]
for k,v in ipairs(selected:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Transparency = 1
    end
end
