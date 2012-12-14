board = {}
height = 8
width = 8
selectedCase1 = nil
selectedCase2 = nil
startedGame = false
score = 0

function Pos(x, y)
  return { x = x, y = y }
end

function Line(x, y, len)
  return { x = x, y = y, len = len}
end

function fillBoard()
   local i = 1
   while i <= height do
      local j = 1
      local tmp = {}
      while j <= width do
	 tmp[j] = math.random(0, 6)
	 j = j + 1
      end
      board[i] = tmp
      i = i + 1
   end
end

function printBoard()
   local i = 1
   while i <= height do
      local j = 1
      while j <= width do
	 io.write(board[i][j].." ")
	 j = j + 1
      end
      io.write("\n")
      i = i + 1
   end
end

function swapGem(pos1, pos2)
   board[pos1.y][pos1.x], board[pos2.y][pos2.x] = board[pos2.y][pos2.x], board[pos1.y][pos1.x]
end

function checkForLine()
   lineFound = {}
   local i = 1
   while i <= height do
      local j = 1
      local hcount = 0
      local hsave = -1
      local vcount = 0
      local vsave = -1
      while j <= width do
	 if hsave ~= board[i][j] then
	    if hcount >= 3 then
	       table.insert(lineFound, Line(Pos(i, j-hcount), Pos(i,j), hcount))
	    end
	    hcount = 1
	    hsave = board[i][j]
	 else
	    hcount = hcount + 1
	 end
	 if vsave ~= board[j][i] then
	    if vcount >= 3 then
	       table.insert(lineFound, Line(Pos(j-vcount, i), Pos(j,i), vcount))
	    end
	    vcount = 1
	    vsave = board[j][i]
	 else
	    vcount = vcount + 1
	 end
	 j = j + 1
      end
      if vcount >= 3 then
	 table.insert(lineFound, Line(Pos(j-vcount, i), Pos(j,i), vcount))
      end
      if hcount >= 3 then
	 table.insert(lineFound, Line(Pos(i, j-hcount), Pos(i,j), hcount))
      end
      i = i + 1
   end
   return lineFound
end

function printLine(line)
   print ("start line")
   print (line.x.x, line.x.y)
   print ("end line")
   print (line.y.x, line.y.y)
   print ("line look like")
   if line.x.x == line.y.x then
      local i = 0
      while line.x.y + i < line.y.y do
	 print (board[line.x.x][line.x.y + i])
	 i = i + 1
      end
   else
      local i = 0
      while line.x.x + i < line.y.x do
	 print (board[line.x.x + i][line.x.y])
	 i = i + 1
      end
   end
end

function checkMove(posAc, posFi)
   local count = 1
   local gemNb = board[posAc.y][posAc.x]
   local i = 1
   while posFi.x + i <= width and board[posFi.y][posFi.x + i] == gemNb do
      if posAc.x == posFi.x+1 and posAc.y == posFi.y then
	 break
      end
      count = count + 1
      if count >= 3 then
	 return true
      end
      i = i + 1
   end
   i = 1
   while posFi.x - i > 0 and board[posFi.y][posFi.x - i] == gemNb do
      if posAc.x == posFi.x-1 and posAc.y == posFi.y then
	 break
      end
      count = count + 1
      if count >= 3 then
	 return true
      end
      i = i + 1
   end
   i = 1
   count = 1
   while posFi.y - i > 0 and board[posFi.y - i][posFi.x] == gemNb do
      if posAc.x == posFi.x and posAc.y == posFi.y-i then
	 break
      end
      count = count + 1
      if count >= 3 then
	 return true
      end
      i = i + 1
   end
   i = 1
   while posFi.y + i <= height and board[posFi.y + i][posFi.x] == gemNb do
      if posAc.x == posFi.x and posAc.y == posFi.y+i then
	 break
      end
      count = count + 1
      if count >= 3 then
	 return true
      end
      i = i + 1
   end
   return false
end

function checkMoveAllDirection(pos)
   if pos.x + 1 <= width and checkMove(pos, Pos(pos.x + 1, pos.y)) == true then
      return true
   end
   if pos.y + 1 <= height and checkMove(pos, Pos(pos.x, pos.y + 1)) == true then
      return true
   end
   if pos.x - 1 > 0 and checkMove(pos, Pos(pos.x - 1, pos.y)) == true then
      return true
   end
   if pos.y - 1 > 0 and checkMove(pos, Pos(pos.x, pos.y - 1)) == true then
      return true
   end
   return false
end

function checkForResetBoard()
   local i = 1
   while i <= height do
      local j = 1
      while j <= width do
	 if checkMoveAllDirection(Pos(j, i)) == true then
	    return false
	 end
	 j = j + 1
      end
      i = i + 1
   end 
   return true
end

function updateBoard()
   local i = 1
   while i <= height do
      local j = 1
      while j <= width do
	 if board[i][j] == -1 then
	    local tmp = 0
	    while i - tmp ~= 1 do
	       swapGem(Pos(j, i-tmp), Pos(j, i-tmp-1))
	       tmp = tmp + 1
	    end
	    board[1][j] = math.random(0, 6)
	 end
	 j = j + 1
      end
      i = i + 1
   end
end

function cleanBoard(lineFound)
   local index = 1
   while index <= #lineFound do
      local line = lineFound[index]
      if line.x.x == line.y.x then
	 local i = 0
	 while line.x.y + i < line.y.y do
	    board[line.x.x][line.x.y + i] = -1
	    i = i + 1
	 end
      else
	 local i = 0
	 while line.x.x + i < line.y.x do
	    board[line.x.x + i][line.x.y] = -1
	    i = i + 1
	 end
      end
      index = index + 1
   end
end

function checkIfSwap(pos1, pos2)
   if (pos1.x == pos2.x and (pos1.y - pos2.y == -1 or pos1.y - pos2.y == 1)) or (pos1.y == pos2.y and (pos1.x - pos2.x == -1 or pos1.x - pos2.x == 1)) then
      if checkMove(pos1, pos2) == true then
	 return true
      else
	 return checkMove(pos2, pos1)
      end
   end
   return false
end

function getScoreAndTime(lineFound)
   local index = 1
   while index <= #lineFound do
      score = score + 50 * math.pow(3, lineFound[index].len - 3)
      index = index + 1
   end
end

function love.load()
   fillBoard()
end

function love.mousereleased(x, y, button)
   if button == 'l' then
      if selectedCase1 == nil then
	 selectedCase1 = Pos(math.ceil(x/40), math.ceil(y/40))
	 startedGame = true
      else
	 selectedCase2 = Pos(math.ceil(x/40), math.ceil(y/40))
      end 
   end
end

function love.update(dt)
   local lineFound = checkForLine()
   cleanBoard(lineFound)
   updateBoard()
   if startedGame == true then
      getScoreAndTime(lineFound)
   end
   if checkForResetBoard() == true then
      board = {}
      height = 8
      width = 8
      selectedCase1 = nil
      selectedCase2 = nil
      startedGame = false
      fillBoard()
   end
   if selectedCase1 ~= nil and selectedCase2 ~= nil then
      if checkIfSwap(selectedCase1, selectedCase2) == true then
	 swapGem(selectedCase1, selectedCase2)
      end
      selectedCase1 = nil
      selectedCase2 = nil
   end
end

function love.draw()
   love.graphics.clear()
   local i = 1
   while i <= height do
      local j = 1
      while j <= width do
	 if (board[i][j] == 0) then
	    love.graphics.setColor(0, 255, 0)
	 elseif (board[i][j] == 1) then
	    love.graphics.setColor(255, 255, 0)
	 elseif (board[i][j] == 2) then
	    love.graphics.setColor(255, 255, 255)
	 elseif (board[i][j] == 3) then
	    love.graphics.setColor(255, 0, 255)
	 elseif (board[i][j] == 4) then
	    love.graphics.setColor(0, 0, 255)
	 elseif (board[i][j] == 5) then
	    love.graphics.setColor(255, 0, 0)
	 elseif (board[i][j] == 6) then
	    love.graphics.setColor(0, 255, 255)
	 end
	 if (selectedCase1 ~= nil and j == selectedCase1.x and i == selectedCase1.y) or (selectedCase2 ~= nil and j == selectedCase1.x and i == selectedCase1.y) then
	    love.graphics.rectangle("fill", (j-1) * 40+5, (i-1) * 40+5, 30, 30)
	 else
	    love.graphics.rectangle("fill", (j-1) * 40, (i-1) * 40, 40, 40)
	 end
	 j = j + 1
      end
      i = i + 1
   end
   love.graphics.setColor(255, 255, 255)
   love.graphics.print("Score:", 5, 325, 0, 1.5, 1.5)
   love.graphics.print(score, 70, 325, 0, 1.5, 1.5)
end
