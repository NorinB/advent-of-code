local filename = "input"

function split_string(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, tonumber(str))
	end
	return t
end

local function get_equations_from_file()
	local file = io.open(filename, "r")
	local equations = {}
	for line in file:lines("*l") do
		local equation = {}
		local test_and_equation = split_string(line, ": ")
		equation.test = test_and_equation[1]
		equation.numbers = split_string(test_and_equation[2], " ")
		table.insert(equations, equation)
	end
	return equations
end

local equations = get_equations_from_file()
print(#equations)
local number_string = ""
for _, number in pairs(equations[1].numbers) do
	number_string = number_string .. number
end
print("" .. equations[1].test .. ": " .. number_string)
