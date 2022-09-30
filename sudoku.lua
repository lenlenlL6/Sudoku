math.randomseed(os.time())

local function count(table, value)
  local countC = 0
  for k, v in pairs(table) do
    if type(v) == "table" then
      countC = (countC + count(v, value))
    else
      if v == value then
        countC = (countC + 1)
      end
    end
  end
  return countC
end

local function copyTable(table)
  local clone = {}
  for k, v in pairs(table) do
    if type(v) == "table" then
      clone[k] = copyTable(v)
    else
      clone[k] = v
    end
  end
  return clone
end

local function getBlock(matrix, x, y)
  local block = {}
  if x >= 1 and x <= 3 then
    x = 1
  end
  if x >= 4 and x <= 6 then
    x = 4
  end
  if x >= 7 and x <= 9 then
    x = 7
  end
  if y >= 1 and y <= 3 then
    y = 1
  end
  if y >= 4 and y <= 6 then
    y = 4
  end
  if y >= 7 and y <= 9 then
    y = 7
  end
  for i = y, y + 2 do
    for s = x, x + 2 do
      table.insert(block, matrix[i][s])
    end
  end
  return block
end

local function getCol(matrix, x)
  local col = {}
  for i = 1, 9 do
    table.insert(col, matrix[i][x])
  end
  return col
end

local function getRow(matrix, y)
  local row = {}
  for i = 1, 9 do
    table.insert(row, matrix[y][i])
  end
  return row
end

local matrix = {}
for i = 1, 9 do
  table.insert(matrix, {0, 0, 0, 0, 0, 0, 0, 0, 0})
end
local save = {}
local per = {}
local y = 1
while y <= 9 do
  local x = 1
  while x <= 9 do
    local tried = {}
    while true do
      if count(per, math.ceil(100 - (count(matrix, 0) / 81 * 100)) .. "%") <= 0 then
        print("Matrix initialization process: " .. math.ceil(100 - (count(matrix, 0) / 81 * 100)) .. "%")
        table.insert(per, math.ceil(100 - (count(matrix, 0) / 81 * 100)) .. "%")
      end
      if #save <= 0 then
        tried = {}
      end
      local poss = {1, 2, 3, 4, 5, 6, 7, 8, 9}
      local k = 1
      while k <= #poss do
        if count(tried, poss[k]) > 0 then
          table.remove(poss, k)
          k = (k - 1)
        end
        k = (k + 1)
      end
      local rand = poss[math.random(1, #poss)]
      matrix[y][x] = rand
      local block = getBlock(matrix, x, y)
      local col = getCol(matrix, x)
      local row = getRow(matrix, y)
      if count(tried, rand) <= 0 then
        table.insert(tried, rand)
      end
      if #tried >= 9 then
        matrix = save[#save]["matrix"]
        x = save[#save]["x"]
        y = save[#save]["y"]
        tried = save[#save]["tried"]
        table.remove(save, #save)
      else
        if count(block, rand) <= 1 and count(col, rand) <= 1 and count(row, rand) <= 1 then
        local clone = copyTable(matrix)
        clone[y][x] = 0
        table.insert(save, {["matrix"] = clone, ["tried"] = tried, ["x"] = x, ["y"] = y})
        break
      end
      end
    end
    x = (x + 1)
  end
  y = (y + 1)
end

print("Starting...")
local timeT = os.time() + 3
while true do
  if os.time() >= timeT then
    break
  end
end
os.execute("clear")
local cloneMatrix = copyTable(matrix)
local hide = math.random(25, 35)
while count(cloneMatrix, "*") < hide do
  local randX = math.random(1, 9)
  local randY = math.random(1, 9)
  if cloneMatrix[randY][randX] ~= "*" then
    cloneMatrix[randY][randX] = "*"
  end
end
local wrongStep = 0

while count(cloneMatrix, "*") > 0 do
os.execute("clear")
local y = 1
while y <= 19 do
  if y % 2 ~= 0 then
    for i = 1, 18 do
      io.write("__")
    end
    print()
  else
    local x = 1
    while x <= 9 do
      if y <= 1 then
        if x <= 1 then
          io.write("| " .. cloneMatrix[y / 2 + 1][x])
        elseif x >= 9 then
          io.write(" | " .. cloneMatrix[y / 2][x] .. " |")
        else
          io.write(" | " .. cloneMatrix[y / 2][x])
        end
      else
        if x <= 1 then
          io.write("| " .. cloneMatrix[y / 2][x])
        elseif x >= 9 then
          io.write(" | " .. cloneMatrix[y / 2][x] .. " |")
        else
          io.write(" | " .. cloneMatrix[y / 2][x])
        end
      end
      x = (x + 1)
    end
    print()
  end
  y = (y + 1)
end
print("Wrong step: " .. wrongStep)
io.write("Row: ")
local row = tonumber(io.read("*l"))
io.write("Col: ")
local col = tonumber(io.read("*l"))
io.write("Value: ")
local value = tonumber(io.read("*l"))
if cloneMatrix[row][col] == "*" then
  if matrix[row][col] == value then
    cloneMatrix[row][col] = value
  else
    wrongStep = (wrongStep + 1)
  end
end
end

print("Done, thanks for playing the game")
