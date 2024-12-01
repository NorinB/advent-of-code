local function get_numbers_from_file(filename)
	local file = io.open(filename, "r")
	local first_list = {}
	local second_list = {}
	for line in file:lines("*l") do
		local numbers = {}
		for number in string.gmatch(line, "%S+") do
			table.insert(numbers, tonumber(number))
		end
		table.insert(first_list, numbers[1])
		table.insert(second_list, numbers[2])
	end
	return first_list, second_list
end

local function get_sorted(a, b)
	if a > b then
		return a, b
	end
	return b, a
end

local first_list, second_list = get_numbers_from_file("input")
table.sort(first_list)
table.sort(second_list)

-- First Half
local total_distance = 0
local index = 1
for _, _ in pairs(first_list) do
	local higher, lower = get_sorted(first_list[index], second_list[index])
	local difference = higher - lower
	total_distance = total_distance + difference
	index = index + 1
end

print("First Half:")
print("Total Distance: " .. total_distance)

-- Second Half
local function get_occurences(number, list)
	local occurences = 0
	local index = 1
	for _, value in pairs(list) do
		if number == value then
			occurences = occurences + 1
		end
		index = index + 1
	end
	return occurences
end

local total_similarity = 0
for _, value in pairs(first_list) do
	local occurences = get_occurences(value, second_list)
	total_similarity = total_similarity + (value * occurences)
end

print("")
print("Second Half:")
print("Similarity Score: " .. total_similarity)
