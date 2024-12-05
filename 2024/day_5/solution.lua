local filename = "input"

function split_to_numbers(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, tonumber(str))
	end
	return t
end

local function get_rules_and_updates_from_file()
	local file = io.open(filename, "r")
	local rules = {}
	local updates = {}
	local rules_finished = false
	for line in file:lines("*l") do
		if not string.match(line, "%d") then
			rules_finished = true
		elseif not rules_finished then
			local rule = split_to_numbers(line, "|")
			table.insert(rules, rule)
		else
			local update = split_to_numbers(line, ",")
			table.insert(updates, update)
		end
	end
	return rules, updates
end

local function check_rule_for_rest_of_update(rule, number, rest_of_update)
	for _, other_number in pairs(rest_of_update) do
		if other_number == rule[1] and number == rule[2] then
			return false
		end
	end
	return true
end

local function check_for_current_number_and_get_wrong_position(rules, update, position)
	local index = position
	for _, other_number in pairs({ table.unpack(update, position) }) do
		for _, rule in pairs(rules) do
			if other_number == rule[1] and update[position] == rule[2] then
				return index
			end
		end
		index = index + 1
	end
	return 0
end

local function is_update_correct(rules, update)
	local update_index = 1
	for _, number in pairs(update) do
		for _, rule in pairs(rules) do
			if not check_rule_for_rest_of_update(rule, number, { table.unpack(update, update_index) }) then
				return false
			end
		end
		update_index = update_index + 1
	end
	return true
end

local function fix_order(rules, update)
	local fixed_update = { table.unpack(update) }
	while not is_update_correct(rules, fixed_update) do
		local current_position = 1
		for _, number in pairs(fixed_update) do
			local wrong_number_position =
				check_for_current_number_and_get_wrong_position(rules, fixed_update, current_position)
			if wrong_number_position ~= 0 then
				local current_number = number
				local other_number = fixed_update[wrong_number_position]
				fixed_update[current_position] = other_number
				fixed_update[wrong_number_position] = current_number
			end
			current_position = current_position + 1
		end
	end
	return fixed_update
end

local rules, updates = get_rules_and_updates_from_file()
local correct_sum = 0
local incorrect_sum = 0
local index = 1
for _, update in pairs(updates) do
	local update_is_correct = is_update_correct(rules, update)
	if update_is_correct then
		-- Part 1
		correct_sum = correct_sum + update[math.ceil(#update / 2)]
	else
		-- Part 2
		local fixed_update = fix_order(rules, update)
		incorrect_sum = incorrect_sum + fixed_update[math.ceil(#fixed_update / 2)]
	end
	index = index + 1
end

print("Part 1 Sum of all valid middle numbers: " .. correct_sum)
print("Part 2 Sum of all invalid middle numbers: " .. incorrect_sum)
