local filename = "input"

local function split_string(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function get_equations_from_file()
	local file = io.open(filename, "r")
	local equations = {}
	for line in file:lines("*l") do
		local equation = {}
		local test_and_equation = split_string(line, ":")
		equation.test = tonumber(test_and_equation[1])
		local number_strings = split_string(string.sub(test_and_equation[2], 2), "%s")
		local numbers = {}
		for _, number in pairs(number_strings) do
			table.insert(numbers, tonumber(number))
		end
		equation.numbers = numbers
		table.insert(equations, equation)
	end
	return equations
end

local function calculate_with_operator(operator, a, b)
	if operator == "*" then
		return a * b
	elseif operator == "+" then
		return a + b
	elseif operator == "||" then
		local a_string = tostring(a)
		local b_string = tostring(b)
		return tonumber(a_string .. b_string)
	end
	return nil
end

local function create_variation_from_number(number, elements, length)
	local base = #elements
	local rest = number - 1
	local variation = {}
	repeat
		local digit = (rest % base) + 1
		table.insert(variation, elements[digit])
		rest = rest // base
	until rest == 0
	if #variation < length then
		for _ = #variation + 1, length do
			table.insert(variation, elements[1])
		end
	end
	return variation
end

local function generate_variations(elements, length)
	local variations = {}
	for i = 1, (#elements) ^ length do
		local variation = create_variation_from_number(i, elements, length)
		table.insert(variations, variation)
	end
	return variations
end

local function calculate_equation(sum_or_product, numbers, operators)
	if #operators == 1 then
		return calculate_with_operator(operators[1], sum_or_product, numbers[#numbers])
	end
	return calculate_equation(
		calculate_with_operator(operators[1], sum_or_product, numbers[1]),
		{ table.unpack(numbers, 2) },
		{ table.unpack(operators, 2) }
	)
end

-- Part 1
local equations = get_equations_from_file()
local operators = { "*", "+" }
local sum = 0
for _, equation in pairs(equations) do
	local operator_count = #equation.numbers - 1
	local operator_variations = generate_variations(operators, operator_count)
	for _, variation in pairs(operator_variations) do
		local result = calculate_equation(0, equation.numbers, { "+", table.unpack(variation) })
		if result == equation.test then
			sum = sum + result
			break
		end
	end
end

print("Part 1 Sum of valid equations: " .. sum)

-- Part 2
equations = get_equations_from_file()
operators = { "*", "+", "||" }
sum = 0
for _, equation in pairs(equations) do
	local operator_count = #equation.numbers - 1
	local operator_variations = generate_variations(operators, operator_count)
	for _, variation in pairs(operator_variations) do
		local result = calculate_equation(0, equation.numbers, { "+", table.unpack(variation) })
		if result == equation.test then
			sum = sum + result
			break
		end
	end
end

print("Part 2 Sum of valid equations with third operator: " .. sum)
