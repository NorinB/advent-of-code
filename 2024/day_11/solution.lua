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

local function calc_length_of_stones(blinks, stones)
	local new = {}
	for _ = 1, blinks do
		for stone, count in pairs(stones) do
			if stone == 0 then
				if new["1"] == nil then
					new["1"] = 0 + count
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
						new[first] = 0 + count
					else
						new[first] = new[first] + count
					end
					if new[second] == nil then
						new[second] = 0 + count
					else
						new[second] = new[second] + count
					end
				else
					local new_number = stone * 2024
					if new[new_number] == nil then
						new[new_number] = 0 + count
					else
						new[new_number] = new[new_number] + count
					end
				end
			end
		end
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
current_stones = {}
for _, stone in pairs(original_stones) do
	current_stones[stone] = 1
end
result = calc_length_of_stones(75, current_stones)

print("Part 2 Number of stones after 75 blinks: " .. result)
