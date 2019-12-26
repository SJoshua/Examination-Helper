function init()
	dofile("out.txt")
	math.randomseed(os.time())
	os.execute("@title Examination Helper @ History - Au: SJoshua")
	os.execute("@chcp 936")
end

function exam(chapt)
	local s
	if chapt == 0 then
		chapt = "All"
		local tmp = {}
		for k, v in pairs(index) do
			table.insert(tmp, source[v])
		end
		s = table.concat(tmp, "\n")
	else
		chapt = index[chapt]
		s = source[chapt]
	end
	local t, cnt = {}, {}
	for line in s:gmatch("([^\n]+)") do
		line = line:match("^%s*(.-)%s*$")
		if line:find("^%d+") then
			table.insert(t, line:match("^%d+.?(.-)$") .. "\n")
			table.insert(cnt, 0)
		else
			t[#t] = t[#t] .. "\n" .. line
		end
	end 
	while true do
		os.execute("@cls")
		
		io.write("Current Problem Set: ", chapt, "\nEnter EXIT to return to the directory.\n\n")
		local min = 0xffffff
		local cand = {}
		for k, v in pairs(cnt) do
			min = math.min(min, v)
		end
		for k, v in pairs(cnt) do
			if (v == min) then
				table.insert(cand, k)
			end
		end
		local id = cand[math.random(#cand)]
		cnt[id] = cnt[id] + 1
		ans = t[id]:match("%(%s*(.-)%s*%)") 
		if ans and (ans:find("^%s*$")) then
			ans = nil
		end
		if not ans then
			ans = t[id]:match("([ABCDEFGHIJKoxOXT]+)[ \t]*\n")
			if ans then
				t[id] = t[id]:gsub("([ABCDEFGHIJKoxOXT]+)[ \t]*\n", "\n")
			end
		end
		if not ans then
			ans = "[NOT FOUND]"
		end
		if ans == chars.wrong or ans == "x" or ans == "F" or ans == "X" then
			ans = "F"
		elseif ans == chars.right or ans == "o" or ans == "T" or ans == "O" then
			ans = "T"
		end
		if ans == "T" or ans == "F" then
			io.write("[True or False] ")
		elseif #ans == 1 then
			io.write("[Single Choice] ")
		else
			io.write("[Multiple Choice] ")
		end
		io.write(t[id]:gsub("%(%s*.-%s*%)", "(____)"), "\n\nYour Answer: ")
		local cmd = io.read()
		if (cmd == "EXIT") then
			break
		end
		io.write("Correct Answer: ", ans,"\n\n")
		--if (ans == "[NOT FOUND]") then for i = 1, 100 do io.read() end end
		os.execute("pause")
	end	
	return main()
end

function main()
	local n
	
	repeat
		os.execute("@cls")

		print("Welcome to Examination Helper.\n\nContents:\n")

		for k, v in ipairs(index) do
			print(string.format("  [#%2d] %s", k, v))
		end

		io.write("\nPlease specify the problem set number (0 for all): ")
		n = math.floor(tonumber(io.read()) or -1)
	until 0 <= n and n <= #index
	
	return exam(n)
end

init()
main()
