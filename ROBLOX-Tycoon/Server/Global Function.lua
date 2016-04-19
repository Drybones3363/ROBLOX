local m = {}

m.Format_Number = function(n)
	if not n then return end
	local t = {"K","M","B","T","Q","Qu"}
	if n > 10^((#t+1)*3) then return end
	local s = ""
	local i = 0
	while n >= 10^3 do
		n = n/(10^3)
		i = i + 1
	end
	local dec = n
	n = math.floor(n)
	local s = tostring(n)
	if i > 0 then s = s..t[i] end
	if not(i == 0 or dec == n) then s = s.."+" end
	return s
end












return m
