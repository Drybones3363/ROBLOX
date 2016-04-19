local module = {}

module.PCallGetAsync = function(ds,key)
	local val = nil
	repeat
		local s = pcall(function()
			val = ds:GetAsync(key)
		end)
		if not s then
			wait(.337)
		end
	until s
	return val
end

module.PCallSetAsync = function(ds,key,val)
	repeat
		local s = pcall(function()
			ds:SetAsync(key,val)
		end)
		if not s then
			wait(.337)
		end
	until s
	return true
end

module.PCallIncrementAsync = function(ds,key,inc)
	local async = 0
	repeat
		local s = pcall(function()
			async = ds:IncrementAsync(key,inc)
		end)
		if not s then
			wait(.337)
		end
	until s
	if async == 0 then
		return nil
	else
		return async
	end
end

return module
