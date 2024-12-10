local filename = "input"

local function get_file_layout_from_file()
	local file = io.open(filename, "r")
	local file_layout = {}
	local id = 0
	for line in file:lines("*l") do
		local is_file = true
		for char in string.gmatch(line, ".") do
			local number = tonumber(char)
			local block = { is_file = is_file, id = nil }
			for _ = 1, number do
				if is_file then
					block.id = id
				end
				table.insert(file_layout, block)
			end
			if is_file then
				id = id + 1
			end
			is_file = not is_file
		end
	end
	return file_layout
end

local function get_first_free_space_index(blocks)
	local free_space = nil
	for i = 1, #blocks do
		if blocks[i].is_file == false then
			free_space = i
			break
		end
	end
	return free_space
end

local function move_blocks_in_file(blocks)
	for i = #blocks, 1, -1 do
		if blocks[i].is_file then
			local current_first_free_space_index = get_first_free_space_index(blocks)
			if current_first_free_space_index >= i then
				break
			end
			blocks[current_first_free_space_index] = { is_file = true, id = blocks[i].id }
			blocks[i] = { is_file = false, id = nil }
		end
	end
end

local function calculate_checksum(blocks)
	local sum = 0
	for i = 1, #blocks do
		if not blocks[i].is_file then
			return sum
		end
		sum = sum + (blocks[i].id * (i - 1))
	end
	return sum
end

local file_layout = get_file_layout_from_file()
move_blocks_in_file(file_layout)
local checksum = calculate_checksum(file_layout)

print("Part 1 Checksum of moved files: " .. checksum)

-- Part 2
local function get_start_index_for_free_space_for_whole_file(blocks, length_of_file, current_start_of_file)
	for i = 1, current_start_of_file do
		if blocks[i].is_file == false then
			local potential_start_index = i
			local length_of_free_space = 0
			local current_index = i
			while blocks[current_index].is_file == false or blocks[current_index] == nil do
				length_of_free_space = length_of_free_space + 1
				current_index = current_index + 1
			end
			if length_of_free_space >= length_of_file and current_index + length_of_file < current_start_of_file then
				return potential_start_index
			end
			i = current_index
		end
	end
	return nil
end

local function calculate_checksum_with_whole_files(blocks)
	local sum = 0
	for i = 1, #blocks do
		if blocks[i].is_file then
			sum = sum + (blocks[i].id * (i - 1))
		end
	end
	return sum
end

local function move_only_whole_blocks_in_file_(blocks)
	local next_checked_id = nil
	local i = #blocks
	while i >= 1 do
		if blocks[i].is_file == true then
			if next_checked_id == nil or next_checked_id == blocks[i].id + 1 then
				next_checked_id = blocks[i].id
			end
		end
		if blocks[i].is_file == true and blocks[i].id == next_checked_id and blocks[i].id ~= 0 then
			local current_id = blocks[i].id
			local current_index = i
			local length_of_file = 0
			while blocks[current_index].id == current_id do
				current_index = current_index - 1
				length_of_file = length_of_file + 1
			end
			local start_index_for_whole_file =
				get_start_index_for_free_space_for_whole_file(blocks, length_of_file, current_index + 1)
			if start_index_for_whole_file ~= nil then
				local copy_index = start_index_for_whole_file
				while copy_index < start_index_for_whole_file + length_of_file do
					blocks[copy_index] = { is_file = true, id = current_id }
					copy_index = copy_index + 1
				end
				for k = current_index + 1, current_index + length_of_file do
					blocks[k] = { is_file = false, id = nil }
				end
			end
			i = current_index
		else
			i = i - 1
		end
	end
end

file_layout = get_file_layout_from_file()
move_only_whole_blocks_in_file_(file_layout)
checksum = calculate_checksum_with_whole_files(file_layout)
local print_debug = ""
for _, file in pairs(file_layout) do
	print_debug = print_debug .. (file.id ~= nil and file.id or ".")
end
print(print_debug)

print("Part 2 Checksum of only fully moved files: " .. checksum)
