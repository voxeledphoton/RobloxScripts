local module = {}

function module.deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = module.deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

return module
