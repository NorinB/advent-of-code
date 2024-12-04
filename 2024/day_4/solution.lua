local filename = "input"

local function get_rows_from_file()
	local file = io.open(filename, "r")
	local rows = {}
	for line in file:lines("*l") do
		table.insert(rows, line)
	end
	return rows
end

local directions = {
	up = { -1, 0 },
	upright = { -1, 1 },
	right = { 0, 1 },
	downright = { 1, 1 },
	down = { 1, 0 },
	downleft = { 1, -1 },
	left = { 0, -1 },
	upleft = { -1, -1 },
}

local letter_order_after_x = { "M", "A", "S" }

local function check_for_xmas(all_rows, row, column, direction_coords, remaining_letters)
	if #remaining_letters == 0 then
		return true
	end
	local next_row = row + direction_coords[1]
	local next_column = column + direction_coords[2]
	if next_row < 1 or next_row > #all_rows or next_column < 0 or next_column > all_rows[1]:len() then
		return false
	end
	if all_rows[next_row]:sub(next_column, next_column) == remaining_letters[1] then
		return check_for_xmas(all_rows, next_row, next_column, direction_coords, { table.unpack(remaining_letters, 2) })
	else
		return false
	end
end

local rows = get_rows_from_file()

-- Part 1
local xmas_counter = 0
local current_row = 1
local current_column = 1
for _, row in pairs(rows) do
	for column in row:gmatch(".") do
		if column ~= "X" then
			goto continue
		end
		for _, direction_coords in pairs(directions) do
			if check_for_xmas(rows, current_row, current_column, direction_coords, letter_order_after_x) then
				xmas_counter = xmas_counter + 1
			end
		end
		::continue::
		current_column = current_column + 1
	end
	current_column = 1
	current_row = current_row + 1
end

print("Part 1: Found XMAS: " .. xmas_counter .. "\n")

-- Part 2
local function check_for_x_mas(all_rows, row, column)
	if row + 1 > #all_rows or row - 1 < 1 or column + 1 > all_rows[1]:len() or column - 1 < 1 then
		return false
	end
	local first_pair = {
		upleft = all_rows[row - 1]:sub(column - 1, column - 1),
		downright = all_rows[row + 1]:sub(column + 1, column + 1),
	}
	local second_pair = {
		downleft = all_rows[row + 1]:sub(column - 1, column - 1),
		upright = all_rows[row - 1]:sub(column + 1, column + 1),
	}
	local first_pair_works = (first_pair.upleft == "M" and first_pair.downright == "S")
		or (first_pair.upleft == "S" and first_pair.downright == "M")
	local second_pair_works = (second_pair.downleft == "M" and second_pair.upright == "S")
		or (second_pair.downleft == "S" and second_pair.upright == "M")
	return first_pair_works and second_pair_works
end

local x_mas_counter = 0
current_row = 1
current_column = 1
for _, row in pairs(rows) do
	for column in row:gmatch(".") do
		if column ~= "A" then
			goto continue
		end
		if check_for_x_mas(rows, current_row, current_column) then
			x_mas_counter = x_mas_counter + 1
		end
		::continue::
		current_column = current_column + 1
	end
	current_column = 1
	current_row = current_row + 1
end

print("Part 2: Found X-MAS: " .. x_mas_counter)
