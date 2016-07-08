--[[

Pretty rushed algorithm for a computer player to never lose in tic tac toe
Wrote this code fast for a friend who wanted a computer player to never lose for his game on ROBLOX

--]]

local function AI_Future(plr,mode,symbol,data)
	local aiSymbol = (symbol == "X" and "O" or "X")
	if mode == "Easy" then
		print("screw easy, you too bad cause you playing on easy")
	elseif mode == "Medium" then
	
	elseif mode == "Hard" then
		if data[5] == '' then
			game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P5",aiSymbol,code)
			return
		end
		local turn_num = (function()
			local n = 0
			for _,k in pairs (data) do
				n = n + (k == '' and 0 or 1)
			end
			return n
		end)()
		if turn_num == 1 then
			game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(({1,3,7,9})[math.random(4)]),aiSymbol,code)
			return
		end
		local odds = (function()
			local t = {}
			for i,k in pairs (data) do
				if k == symbol and i%2 == 1 and i ~= 5 then
					table.insert(t,i)
				end
			end
			return t
		end)()
		if turn_num == 2 then
			if #odds > 0 then
				local tt = {[1] = 9,[3] = 7,[7] = 3,[9] = 1}
				game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(tt[odds[1]]),aiSymbol,code)
				return
			else
				game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(({1,3,7,9})[math.random(4)]),aiSymbol,code)
				return
			end
		end
		local evens = (function()
			local t = {}
			for i,k in pairs (data) do
				if k == symbol and i%2 == 0 then
					table.insert(t,i)
				end
			end
			return t
		end)()
		local oddself = (function()
			local t = {}
			for i,k in pairs (data) do
				if k == aiSymbol and i%2 == 1 then
					table.insert(t,i)
				end
			end
			return t
		end)()
		if turn_num == 3 then
			if #evens > 0 then
				if #evens == 2 then
					local t1337 = {[1] = {2,4},[3] = {2,6},[7] = {4,8},[9] = {6,8}}
					for i,k in pairs (t1337) do
						if data[k[1] ] == symbol and data[k[2] ] == symbol then
							game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(i),aiSymbol,code)
							return
						end
					end
					game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P1",aiSymbol,code)
					return
				end
				if data[5] == symbol then
					local tt = {[2] = 8,[4] = 6,[6] = 4,[8] = 2}
					game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(tt[evens[1]]),aiSymbol,code)
					return
				else
					local t3 = {{1,2,3},{1,4,7},{7,8,9},{3,6,9}}
					for i,k in pairs (t3) do
						local t4 = {}
						for e,r in pairs (k) do
							if data[r] == symbol then
								t4[e] = true
							else
								t4[e] = false
							end
						end
						local n = (function() local nn = 0 for q,w in pairs (t4) do if w == true then nn = nn + 1 end end return nn end)()
						if n == 2 then
							for q,w in pairs (t4) do
								if w == false and data[k[q] ] == '' then
									game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(k[q]),aiSymbol,code)
									return
								end
							end
						end
					end
					local t1t = {[1] = {{3,4},{2,7}},[3] = {{2,9},{1,6}},[7] = {{4,9},{1,8}},[9] = {{6,7},{3,8}}}
					for e,r in pairs (t1t) do
						for q,w in pairs (r) do
							if data[w[1] ] == symbol and data[w[2] ] == symbol then
								game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(e),aiSymbol,code)
								return
							end
						end
					end
					for i = 1,9,2 do
						if data[i] == '' then
							game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(i),aiSymbol,code)
							return
						end
					end
				end
			elseif #oddself > 0 then
				local tt = {[1] = 9,[3] = 7,[7] = 3,[9] = 1}
				if tt[oddself[1]] == odds[1] then
					local t = {1,3,7,9}
					for e,r in pairs (odds) do
						for q,w in pairs (t) do
							if r == w then
								table.remove(t,q)
							end
						end
					end
					for e,r in pairs (oddself) do
						for q,w in pairs (t) do
							if r == w then
								table.remove(t,q)
							end
						end
					end
					game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(t[math.random(#t)]),aiSymbol,code)
				elseif #odds == 2 then
					local ttt = {[1] = {3,7},[3] = {1,9},[7] = {1,9},[9] = {3,7}}
					local findspot1 = (function() 
						for i,k in pairs (ttt) do
							if data[i] == symbol then
								if data[k[1] ]== symbol then
									return .5*(k[1]+i)
								elseif data[k[2] ]== symbol then
									return .5*(k[2]+i)
								end
							end
						end
					end)()
					if findspot1 then
						game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(findspot1),aiSymbol,code)
						return
					else
						local t2 = {[1] = 9,[3] = 7}
						for e,r in pairs (t2) do
							if data[e] == symbol and data[r] == symbol then
								game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(math.random(4)*2),aiSymbol,code)
								return
							end
						end
					end
				else
					game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(tt[odds[1] ]),aiSymbol,code)
					
					--[[local ttt = {[1] = {3,7},[3] = {1,9},[7] = {1,9},[9] = {3,7}}
					local findspot1 = (function() 
						for i,k in pairs (ttt) do
							if data[i] == symbol then
								if data[k[1] ]== symbol then
									return .5*(k[1]+i)
								elseif data[k[2] ]== symbol then
									return .5*(k[2]+i)
								end
							end
						end
					end)()
					if findspot1 then
						game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(findspot1),aiSymbol,code)
						return
					else
						local t2 = {[1] = 9,[3] = 7}
						for e,r in pairs (t2) do
							if data[e] == symbol and data[r] == symbol then
								game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(math.random(4)*2),aiSymbol,code)
								return
							end
						end
					end--]]
				end
				return
			else
				local t = {1,3,7,9}
				for e,r in pairs (odds) do
					for q,w in pairs (t) do
						if r == w then
							table.remove(t,q)
						end
					end
				end
				game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(t[math.random(#t)]),aiSymbol,code)
				return
			end
		end
		--local function find_possible_win()
			if data[5] == aiSymbol then
				local t,tt = {}
				for i=1,4 do
					if (data[i] == aiSymbol and data[10-i] == '') or (data[10-i] == aiSymbol and data[i] == '') then
						game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(data[i]=='' and i or 10-i),aiSymbol,code)
						return
					end
				end
			else
				local t3 = {{1,2,3},{1,4,7},{7,8,9},{3,6,9}}
				for i,k in pairs (t3) do
					local t4 = {}
					for e,r in pairs (k) do
						if data[r] == aiSymbol then
							t4[e] = true
						else
							t4[e] = false
						end
					end
					local n = (function() local nn = 0 for q,w in pairs (t4) do if w == true then nn = nn + 1 end end return nn end)()
					if n == 2 then
						for q,w in pairs (t4) do
							if w == false and data[k[q] ] == '' then
								game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(k[q]),aiSymbol,code)
								return
							end
						end
					end
				end
			end
		--end
		if turn_num == 4 then
			local ttt = {[1] = {3,7},[3] = {1,9},[7] = {1,9},[9] = {3,7}}
			local findspot1 = (function() 
				for i,k in pairs (ttt) do
					if data[i] == symbol then
						if data[k[1]] == symbol then
							return .5*(k[1]+i)
						elseif data[k[2]] == symbol then
							return .5*(k[2]+i)
						end
					end
				end
			end)()
			if findspot1 then
				game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(findspot1),aiSymbol,code)
				return
			end
			local tttt = {[1] = {2,4},[3] = {2,6},[7] = {4,8},[9] = {6,8}}
			local t5 = {[1] = {[2]=3,[4]=7},[3] = {[2]=1,[6]=9},[7] = {[4]=1,[8]=9},[9] = {[6]=3,[8]=7}}
			local findspot2 = (function() 
				for i,k in pairs (tttt) do
					if data[i] == symbol then
						if data[k[1]] == symbol then
							return t5[i][k[1]]
						elseif data[k[2]] == symbol then
							return t5[i][k[2]]
						end
					end
				end
			end)()
			if findspot2 then
				game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(findspot2),aiSymbol,code)
				return
			end
		end
		--defend like shit
			if data[5] == symbol then
				local t,tt = {}
				for i=1,4 do
					if (data[i] == symbol and data[10-i] == '') or (data[10-i] == symbol and data[i] == '') then
						game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(data[i]=='' and i or 10-i),aiSymbol,code)
						return
					end
				end
			else
				local t3 = {{1,2,3},{1,4,7},{7,8,9},{3,6,9}}
				for i,k in pairs (t3) do
					local t4 = {}
					for e,r in pairs (k) do
						if data[r] == symbol then
							t4[e] = true
						else
							t4[e] = false
						end
					end
					local n = (function() local nn = 0 for q,w in pairs (t4) do if w == true then nn = nn + 1 end end return nn end)()
					if n == 2 then
						for q,w in pairs (t4) do
							if w == false and data[k[q] ] == '' then
								game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(k[q]),aiSymbol,code)
								return
							end
						end
					end
				end
			end
		--select random cause it doesnt matter
		for i = 1,9 do
			if data[i] == '' then
				print("Random Guess")
				game.Workspace.RemoteEvent:FireClient(plr,"AddTicTacToeSpot","P"..tostring(i),aiSymbol,code)
				return
			end
		end
	end
end
