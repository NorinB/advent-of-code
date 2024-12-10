local filename = "input"

local function get_map_from_file()
	local file = io.open(filename, "r")
	local map = {}
	local row_index = 1
	local column_index = 1
	for line in file:lines("*l") do
		local row = {}
		for height in string.gmatch(line, ".") do
			table.insert(row, { height = tonumber(height), row = row_index, column = column_index })
			column_index = column_index + 1
		end
		table.insert(map, row)
		column_index = 1
		row_index = row_index + 1
	end
	return map
end

local directions = {
	{ name = "up", row = -1, column = 0 },
	-- { name = "upright", row = -1, column = 1 },
	{ name = "right", row = 0, column = 1 },
	-- { name = "downright", row = 1, column = 1 },
	{ name = "down", row = 1, column = 0 },
	-- { name = "downleft", row = 1, column = -1 },
	{ name = "left", row = 0, column = -1 },
	-- { name = "upleft", row = -1, column = -1 },
}

local function compare_trail_ends(a, b)
	return a[#a].row == b[#b].row and a[#a].column == b[#b].column
end

local function get_possible_directions(current_position, map)
	local possible_directions = {}
	for _, direction in pairs(directions) do
		local new_coords = {
			height = current_position.height + 1,
			row = current_position.row + direction.row,
			column = current_position.column + direction.column,
		}
		if
			new_coords.row >= 1
			and new_coords.row <= #map
			and new_coords.column >= 1
			and new_coords.column <= #map[1]
			and new_coords.height == map[new_coords.row][new_coords.column].height
		then
			table.insert(possible_directions, new_coords)
		end
	end
	return possible_directions
end

local function get_all_trails_from(current_trail, map)
	if current_trail[#current_trail].height == 9 then
		local complete_trail = { { table.unpack(current_trail) } }
		return complete_trail
	end
	local possible_next_positions = get_possible_directions(current_trail[#current_trail], map)
	local found_trails = {}
	for _, possible_next_position in pairs(possible_next_positions) do
		local updated_trail = { table.unpack(current_trail) }
		table.insert(updated_trail, possible_next_position)
		local possible_trails = get_all_trails_from(updated_trail, map)
		for _, trail in pairs(possible_trails) do
			if #trail == 10 then
				table.insert(found_trails, trail)
			end
		end
	end
	return found_trails
end

local map = get_map_from_file()
local sum_of_trailhead_scores = 0
local sum_of_trailhead_ratings = 0
for row = 1, #map do
	for column = 1, #map[row] do
		if map[row][column].height == 0 then
			local found_trails = get_all_trails_from({ map[row][column] }, map)
			-- Part 2
			sum_of_trailhead_ratings = sum_of_trailhead_ratings + #found_trails

			-- Part 1
			local actual_trails = {}
			for _, trail in pairs(found_trails) do
				local already_exists = false
				for _, existing_trail in pairs(actual_trails) do
					if compare_trail_ends(existing_trail, trail) then
						already_exists = true
						break
					end
				end
				if not already_exists then
					table.insert(actual_trails, trail)
				end
			end

			for _, trail in pairs(actual_trails) do
				local print_debug = ""
				for _, step in pairs(trail) do
					print_debug = print_debug .. " -> " .. step.row .. " : " .. step.column
				end
			end
			sum_of_trailhead_scores = sum_of_trailhead_scores + #actual_trails
		end
	end
end

print("Part 1 Sum of all trails: " .. sum_of_trailhead_scores)
print("Part 2 Rating of all trailheads: " .. sum_of_trailhead_ratings)
