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

local function is_report_safe(report)
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
      return false
		end
    last_number = current
		::continue::
	end
  return true
end

-- Part 1
local safe_reports_counter = #reports
for _, report in pairs(reports) do
  if not is_report_safe(report) then
    safe_reports_counter = safe_reports_counter - 1
  end
end

print("Safe Reports: " .. safe_reports_counter)


-- Part 2
local safe_reports_counter_with_dampener = 0
for _, report in pairs(reports) do
  if is_report_safe(report) then
    safe_reports_counter_with_dampener = safe_reports_counter_with_dampener + 1
  else
    local index = 1
    for _, number in pairs(report) do
      local copied_report = {table.unpack(report)}
      table.remove(copied_report, index)
      if is_report_safe(copied_report) then
        safe_reports_counter_with_dampener = safe_reports_counter_with_dampener + 1
        break
      end
      index = index + 1
    end
  end
end

print("Dampened Safe Reports: " .. safe_reports_counter_with_dampener)
