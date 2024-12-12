local filename = "input"

local function split_string(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function get_stones_from_file()
	local file = io.open(filename, "r")
	local stones = {}
	for line in file:lines("*l") do
		local found_stones = split_string(line, "%s")
		for stone_index = 1, #found_stones do
			table.insert(stones, tonumber(found_stones[stone_index]))
		end
	end
	return stones
end

local function calc_length_of_stones_old(blinks, stones)
	for blink = 1, blinks do
		print("Current blink: " .. blink)
		local new_stones = {}
		for stone, count in pairs(stones) do
			for _ = 1, count do
				local stone_as_number = tonumber(stone)
				if stone_as_number == 0 then
					table.insert(new_stones, 1)
				else
					local length = #stone
					if length % 2 == 0 then
						local first = tonumber(string.sub(stone, 1, math.floor(length / 2)))
						local second = tonumber(string.sub(stone, math.floor(length / 2) + 1, #stone))
						table.insert(new_stones, first)
						table.insert(new_stones, second)
					else
						table.insert(new_stones, stone_as_number * 2024)
					end
				end
			end
		end
		local new_map = {}
		for _, stone in pairs(new_stones) do
			local string_stone = tostring(stone)
			if new_map[string_stone] == nil then
				new_map[string_stone] = 1
			else
				new_map[string_stone] = new_map[string_stone] + 1
			end
		end
		stones = new_map
	end

	local total_length = 0
	for _, length in pairs(stones) do
		total_length = total_length + length
	end
	return total_length
end

local function calc_length_of_stones(blinks, stones)
	local new = {}
	for blink = 1, blinks do
		local index = 0
		local print_debug = ""
		for stone, _ in pairs(stones) do
			index = index + 1
			print_debug = print_debug .. stone .. " "
		end
		-- print("Length of stones: " .. index)
		-- print("After blink " .. blink .. ": " .. print_debug)
		for stone, count in pairs(stones) do
			if stone == 0 then
				if new["1"] == nil then
					new["1"] = 1
				else
					new["1"] = new["1"] + count
				end
			else
				local stone_as_string = tostring(stone)
				local length = #stone_as_string
				if length % 2 == 0 then
					local first = tonumber(string.sub(stone_as_string, 1, math.floor(length / 2)))
					local second = tonumber(string.sub(stone_as_string, math.floor(length / 2) + 1, length))
					if new[first] == nil then
						new[first] = 1
					else
						new[first] = new[first] + count
					end
					if new[second] == nil then
						new[second] = 1
					else
						new[second] = new[second] + count
					end
				else
					local new_number = stone * 2024
					if new[new_number] == nil then
						new[new_number] = 1
					else
						new[new_number] = new[new_number] + count
					end
				end
			end
		end
		index = 0
		print_debug = ""
		for stone, _ in pairs(stones) do
			index = index + 1
			print_debug = print_debug .. stone .. " "
		end
		print("Length of stones: " .. index)
		index = 0
		print_debug = ""
		for stone, _ in pairs(new) do
			index = index + 1
			print_debug = print_debug .. stone .. " "
		end
		print("Length of new: " .. index)
		stones = new
		new = {}
	end

	local total_length = 0
	for _, length in pairs(stones) do
		total_length = total_length + length
	end
	return total_length
end

local original_stones = get_stones_from_file()
-- Part 1
local current_stones = {}
for _, stone in pairs(original_stones) do
	current_stones[stone] = 1
end
local result = calc_length_of_stones(25, current_stones)

print("Part 1 Number of stones after 25 blinks: " .. result)
print("")

-- Part 2
-- current_stones = {}
-- for _, stone in pairs(original_stones) do
-- 	current_stones[tostring(stone)] = 1
-- end
-- result = calc_length_of_stones(75, current_stones)
--
-- print("Part 2 Number of stones after 75 blinks: " .. result)
