local filename = "input"

local function create_position_hash(row, column)
	return "" .. row .. ":" .. column
end

local function get_map_and_start_pos_from_file()
	local file = io.open(filename, "r")
	local map = {}
	local starting_pos = {}
	local row_index = 1
	local column_index = 1
	for line in file:lines("*l") do
		local row = {}
		for char in string.gmatch(line, ".") do
			local is_start_pos = false
			if char == "^" then
				local position_hash = create_position_hash(row_index, column_index)
				starting_pos = { position_hash = position_hash, row = row_index, column = column_index }
				is_start_pos = true
			end
			table.insert(row, { character = char, already_visited = is_start_pos })
			column_index = column_index + 1
		end
		table.insert(map, row)
		column_index = 1
		row_index = row_index + 1
	end
	return map, starting_pos
end

local function get_next_direction(directions, current_direction_index)
	if current_direction_index >= #directions then
		return directions[1], 1
	end
	local new_index = current_direction_index + 1
	return directions[new_index], new_index
end

local function get_next_position(map, current_pos, direction)
	local new_position = { row = current_pos.row + direction.row, column = current_pos.column + direction.column }
	if new_position.row < 1 or new_position.row > #map or new_position.column < 1 or new_position.column > #map[1] then
		return nil
	end
	return new_position
end

local four_directions = {
	{ name = "up", row = -1, column = 0 },
	{ name = "right", row = 0, column = 1 },
	{ name = "down", row = 1, column = 0 },
	{ name = "left", row = 0, column = -1 },
}
local map, starting_pos = get_map_and_start_pos_from_file()

-- Part 1
local current_state = {
	position = { row = starting_pos.row, column = starting_pos.column },
	direction = four_directions[1],
	direction_index = 1,
}
local distinct_locations = {}
local number_of_disctinct_locations = 1
distinct_locations[starting_pos.position_hash] = { row = starting_pos.row, column = starting_pos.column }
local next_position = get_next_position(map, current_state.position, current_state.direction)
while next_position ~= nil do
	if map[next_position.row][next_position.column].character == "#" then
		local next_direction, next_direction_index = get_next_direction(four_directions, current_state.direction_index)
		current_state.direction = next_direction
		current_state.direction_index = next_direction_index
	else
		current_state.position = next_position
		local position_hash = create_position_hash(current_state.position.row, current_state.position.column)
		if distinct_locations[position_hash] == nil then
			distinct_locations[position_hash] = current_state.position
			number_of_disctinct_locations = number_of_disctinct_locations + 1
		end
	end
	next_position = get_next_position(map, current_state.position, current_state.direction)
end

print("Part 1 Distinct locations: " .. number_of_disctinct_locations)

-- Part 2
current_state = {
	position = { row = starting_pos.row, column = starting_pos.column },
	direction = four_directions[1],
	direction_index = 1,
}
local visited_locations = {}
visited_locations[starting_pos.position_hash] =
	{ position_hash = starting_pos.position_hash, row = starting_pos.row, column = starting_pos.column, step = 1 }
local visited_locations_count = 1
local possible_obstacle_pos_count = 0
local row_index = 1
local column_index = 1
for _, row in pairs(map) do
	for _, column in pairs(row) do
		if column.character ~= "." then
			goto continue
		end
		map[row_index][column_index] = { character = "#", already_visited = false }
		next_position = get_next_position(map, current_state.position, current_state.direction)
		while next_position ~= nil do
			local next_position_hash = create_position_hash(next_position.row, next_position.column)
			local current_position_hash =
				create_position_hash(current_state.position.row, current_state.position.column)
			local current_location = visited_locations[current_position_hash]
			local next_location = visited_locations[next_position_hash]
			if current_location ~= nil and next_location ~= nil and current_location.step == next_location.step - 1 then
				possible_obstacle_pos_count = possible_obstacle_pos_count + 1
				map[row_index][column_index] = { character = ".", already_visited = false }
				goto continue
			end
			if map[next_position.row][next_position.column].character == "#" then
				local next_direction, next_direction_index =
					get_next_direction(four_directions, current_state.direction_index)
				current_state.direction = next_direction
				current_state.direction_index = next_direction_index
			else
				visited_locations_count = visited_locations_count + 1
				current_state.position = next_position
				local position_hash = create_position_hash(current_state.position.row, current_state.position.column)
				local actual_step = visited_locations_count
				if visited_locations[position_hash] ~= nil then
					actual_step = visited_locations[position_hash].step
				end
				visited_locations[position_hash] = {
					position_hash = position_hash,
					row = current_state.position.row,
					column = current_state.position.column,
					step = actual_step,
				}
			end
			next_position = get_next_position(map, current_state.position, current_state.direction)
		end
		map[row_index][column_index] = { character = ".", already_visited = false }
		::continue::
		visited_locations_count = 1
		visited_locations =
			{ { position_hash = starting_pos.position_hash, row = starting_pos.row, column = starting_pos.column } }
		column_index = column_index + 1
		current_state = {
			position = { row = starting_pos.row, column = starting_pos.column },
			direction = four_directions[1],
			direction_index = 1,
		}
	end
	column_index = 1
	row_index = row_index + 1
end

print("Part 2 Possible obstacle locations: " .. possible_obstacle_pos_count)
