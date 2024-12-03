local function get_reports_from_file(filename)
	local file = io.open(filename, "r")
	local reports = {}
	for line in file:lines("*l") do
		local numbers = {}
		for number in string.gmatch(line, "%S+") do
			table.insert(numbers, tonumber(number))
		end
		table.insert(reports, numbers)
	end
	return reports
end

local reports = get_reports_from_file("input")

-- Part 1
local safe_reports_counter = #reports
for _, report in pairs(reports) do
	local mode = nil
	local last_number = nil
	for _, current in pairs(report) do
		if last_number == nil then
			last_number = current
			goto continue
		end
		local difference = current - last_number
		if difference < 0 and mode ~= "increasing" and difference >= -3 then
			mode = "decreasing"
		elseif difference > 0 and mode ~= "decreasing" and difference <= 3 then
			mode = "increasing"
		else
			safe_reports_counter = safe_reports_counter - 1
			break
		end
    last_number = current
		::continue::
	end
end

print("Safe Reports: " .. safe_reports_counter)


-- Part 2
local function is_list_safe_if_dampened(list, last, mode, removed_once)
  if #list == 0 then
    return true
  end

  local current = list[1]

  if last == nil then
    current = table.remove(list, 1)
    return is_list_safe_if_dampened(list, current, mode, removed_once)
  end

  local difference = current - last
  if (difference < 0 and difference >= -3 and (mode == nil or mode == "decreasing")) or (difference > 0 and difference <= 3 and (mode == nil or mode == "increasing")) then
    mode = difference < 0 and "decreasing" or "increasing"
    current = table.remove(list, 1)
    return is_list_safe_if_dampened(list, current, mode, removed_once)
  else
    if removed_once then
      return false
    end
    table.remove(list, 1)
    return is_list_safe_if_dampened(list, current, mode, true)
  end
end

local safe_reports_counter_with_dampener = 0
local unsafe_counter = 1
for _, report in pairs(reports) do
  if is_list_safe_if_dampened(report, nil, nil, false) then
    safe_reports_counter_with_dampener = safe_reports_counter_with_dampener + 1
  else
    local print_debug = ""
    for _, number in pairs(report) do
      print_debug = print_debug .. number .. " "
    end
    print(unsafe_counter .. "  " .. print_debug)
    unsafe_counter = unsafe_counter + 1
  end
end

print("Dampened Safe Reports: " .. safe_reports_counter_with_dampener)
