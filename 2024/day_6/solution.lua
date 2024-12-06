local filename = "input"

local function get_map_and_start_pos_from_file()
	local file = io.open(filename, "r")
	local map = {}
	local starting_pos = {}
	local row_index = 1
	local column_index = 1
	for line in file:lines("*l") do
		local row = {}
		for char in string.gmatch(line, ".") do
			table.insert(row, { char, false })
			if char == "^" then
				starting_pos = { row_index, column_index }
			end
			column_index = column_index + 1
		end
		table.insert(map, row)
		column_index = 1
		row_index = row_index + 1
	end
	return map, starting_pos
end

local map, starting_pos = get_map_and_start_pos_from_file()
for _, row in pairs(map) do
	local row_string = ""
	for _, column in pairs(row) do
		row_string = row_string .. column[1]
	end
	print(row_string)
end
print(#map)
print("Starting Position: " .. starting_pos[1] .. " " .. starting_pos[2])
