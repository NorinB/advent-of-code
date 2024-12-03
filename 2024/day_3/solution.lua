local filename = "input"

local function get_muls_from_file()
	local file = io.open(filename, "r")
	local muls = {}
	for line in file:lines("*l") do
		for found_mul in string.gmatch(line, "mul%(%d%d?%d?,%d%d?%d?%)") do
			table.insert(muls, found_mul)
		end
	end
	return muls
end

local function calculate_mul(mul)
	local numbers = {}
	for number in string.gmatch(mul, "%d%d?%d?") do
		table.insert(numbers, number)
	end
	return tonumber(numbers[1]) * tonumber(numbers[2])
end

-- Part 1
local muls = get_muls_from_file()
print(#muls)
local sum_everything = 0
for _, mul in pairs(muls) do
	sum_everything = sum_everything + calculate_mul(mul)
end

print("Sum of all muls: " .. sum_everything .. "\n")

-- Part 2
local function get_nearest(next_mul, next_do, next_dont)
	local comparables = {}
	if next_mul[1] then
		table.insert(comparables, { "mul", next_mul[1], next_mul[2] })
	end
	if next_do[1] then
		table.insert(comparables, { "do", next_do[1], next_do[2] })
	end
	if next_dont[1] then
		table.insert(comparables, { "dont", next_dont[1], next_dont[2] })
	end
	if #comparables == 0 then
		return nil
	end
	table.sort(comparables, function(a, b)
		return a[2] < b[2]
	end)
	return comparables[1]
end

local function get_muls_from_file_with_toggle()
	local file = io.open(filename, "r")
	local muls_with_toggle = {}
	local enabled = true
	for line in file:lines("*l") do
		local rest = line
		while #rest ~= 0 do
			local next_mul_start, next_mul_end = string.find(rest, "mul%(%d%d?%d?,%d%d?%d?%)")
			local next_do_start, next_do_end = string.find(rest, "do%(%)")
			local next_dont_start, next_dont_end = string.find(rest, "don%'t%(%)")
			local nearest = get_nearest(
				{ next_mul_start, next_mul_end },
				{ next_do_start, next_do_end },
				{ next_dont_start, next_dont_end }
			)
			if nearest == nil then
				break
			end
			if nearest[1] == "mul" and enabled then
				table.insert(muls_with_toggle, string.sub(rest, next_mul_start, next_mul_end))
			end
			if nearest[1] == "do" then
				enabled = true
			end
			if nearest[1] == "dont" then
				enabled = false
			end
			rest = string.sub(rest, nearest[3], #rest)
		end
	end
	return muls_with_toggle
end

local muls_with_toggle = get_muls_from_file_with_toggle()

print(#muls_with_toggle)
local sum_toggle = 0
for _, mul in pairs(muls_with_toggle) do
	sum_toggle = sum_toggle + calculate_mul(mul)
end

print("Sum with toggles: " .. sum_toggle)
