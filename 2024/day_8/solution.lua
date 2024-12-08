local filename = "input"

local function get_map_from_file()
	local file = io.open(filename, "r")
	local map = {}
	local row_index = 1
	local column_index = 1
	for line in file:lines("*l") do
		local row = {}
		for char in string.gmatch(line, ".") do
			table.insert(row, { char = char, contains_antinode = false, row = row_index, column = column_index })
			column_index = column_index + 1
		end
		table.insert(map, row)
		column_index = 1
		row_index = row_index + 1
	end
	return map
end

-- Part 1
local function get_distinct_antinode_locations_from_this_antenna(current_map, current_position_info)
	local distinct_antinode_locations = 0
	for row_index = 1, #current_map do
		for column_index = 1, #current_map[row_index] do
			if
				current_position_info.char == current_map[row_index][column_index].char
				and row_index ~= current_position_info.row
				and column_index ~= current_position_info.column
			then
				local x_distance = row_index - current_position_info.row
				local y_distance = column_index - current_position_info.column
				local first_position = { row = row_index + x_distance, column = column_index + y_distance }
				if
					first_position.row >= 1
					and first_position.row <= #current_map
					and first_position.column >= 1
					and first_position.column <= #current_map[row_index]
					and not current_map[first_position.row][first_position.column].contains_antinode
				then
					current_map[first_position.row][first_position.column].contains_antinode = true
					distinct_antinode_locations = distinct_antinode_locations + 1
				end
				local second_position =
					{ row = current_position_info.row - x_distance, column = current_position_info.column - y_distance }
				if
					second_position.row >= 1
					and second_position.row <= #current_map
					and second_position.column >= 1
					and second_position.column <= #current_map[row_index]
					and not current_map[second_position.row][second_position.column].contains_antinode
				then
					current_map[second_position.row][second_position.column].contains_antinode = true
					distinct_antinode_locations = distinct_antinode_locations + 1
				end
			end
		end
	end
	return distinct_antinode_locations
end

local map = get_map_from_file()
local distinct_antinode_locations = 0
for row_index = 1, #map do
	for column_index = 1, #map[row_index] do
		local current_char = map[row_index][column_index].char
		if string.match(current_char, "[%d%l%u]") then
			distinct_antinode_locations = distinct_antinode_locations
				+ get_distinct_antinode_locations_from_this_antenna(map, map[row_index][column_index])
		end
	end
end

print("Part 1 Distinct antinode locations: " .. distinct_antinode_locations)

-- Part 2
local function get_distinct_antinode_locations_from_this_antenna_with_resonance(current_map, current_position_info)
	local distinct_antinode_locations_with_resonance = 0
	for row_index = 1, #current_map do
		for column_index = 1, #current_map[row_index] do
			if
				current_position_info.char == current_map[row_index][column_index].char
				and row_index ~= current_position_info.row
				and column_index ~= current_position_info.column
			then
				local x_distance = row_index - current_position_info.row
				local y_distance = column_index - current_position_info.column
				local current_position = { row = current_position_info.row, column = current_position_info.column }
				while
					current_position.row >= 1
					and current_position.row <= #current_map
					and current_position.column >= 1
					and current_position.column <= #current_map[row_index]
				do
					if not current_map[current_position.row][current_position.column].contains_antinode then
						current_map[current_position.row][current_position.column].contains_antinode = true
						distinct_antinode_locations_with_resonance = distinct_antinode_locations_with_resonance + 1
					end
					current_position =
						{ row = current_position.row + x_distance, column = current_position.column + y_distance }
				end
				current_position =
					{ row = current_position_info.row - x_distance, column = current_position_info.column - y_distance }
				while
					current_position.row >= 1
					and current_position.row <= #current_map
					and current_position.column >= 1
					and current_position.column <= #current_map[row_index]
				do
					if not current_map[current_position.row][current_position.column].contains_antinode then
						current_map[current_position.row][current_position.column].contains_antinode = true
						distinct_antinode_locations_with_resonance = distinct_antinode_locations_with_resonance + 1
					end
					current_position =
						{ row = current_position.row - x_distance, column = current_position.column - y_distance }
				end
			end
		end
	end
	return distinct_antinode_locations_with_resonance
end

map = get_map_from_file()
local distinct_antinode_locations_with_resonance = 0
for row_index = 1, #map do
	for column_index = 1, #map[row_index] do
		local current_char = map[row_index][column_index].char
		if string.match(current_char, "[%d%l%u]") then
			distinct_antinode_locations_with_resonance = distinct_antinode_locations_with_resonance
				+ get_distinct_antinode_locations_from_this_antenna_with_resonance(map, map[row_index][column_index])
		end
	end
end

print("Part 2 Distinct antinode locations with resonance: " .. distinct_antinode_locations_with_resonance)
