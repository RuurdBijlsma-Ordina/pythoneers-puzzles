import os
import std/strformat
import std/strutils
import std/algorithm
import std/sequtils
import std/tables
import std/sets
import sugar

proc processLines(lines: seq[string]): int =
  let grid = lines.map((line)=>line.split(" ").map((c) => parseInt(c)))
  let maxLevel = max(grid.map((r) => max(r)))
  var level = 1
  var volume = 0
  while true:
    var queue = newSeq[(int, int)]()
    var levelArea = 0
    for col in 0..<grid.len:
      for row in 0..<grid[0].len:
        queue.add((row, col))

    # echo fmt"InitQueue = {queue}"

    while queue.len > 0:

      var innerValidVolume = true
      var innerQueue = @[queue.pop()]
      var innerVisited = newSeq[(int, int)]()
      var innerVisitedNotWall = newSeq[(int, int)]()

      while true:
        let (row, col) = innerQueue.pop()
        let pos = (row, col)
        # echo fmt"Considering {pos}"
        innerVisited.add(pos)
        let queueIndex = queue.find(pos)
        if queueIndex > 0:
          queue.delete(queueIndex)

        if grid[col][row] >= level: #muur
          break
        innerVisitedNotWall.addUnique(pos)
        # Check if from this pos it drips out
        let neighbours = @[
          (row + 1, col),
          (row - 1, col),
          (row, col + 1),
          (row, col - 1),
        ]
        for (nRow, nCol) in neighbours:
          if nCol >= grid.len or nRow >= grid[0].len or nRow < 0 or nCol < 0: #buitenkant map
            innerValidVolume = false
            # echo fmt"{pos} not valid because a direct neighbour is open"
            continue

          if grid[nCol][nRow] >= level: #muur
            continue
        
          let nPos = (nRow, nCol)
          if nPos notin innerVisited:
            innerQueue.add(nPos)

        if innerQueue.len == 0:
          if innerValidVolume:
            # echo fmt"This area was valid: {innerVisitedNotWall}"
            levelArea += innerVisitedNotWall.len
          # else: 
          #   echo fmt"This area was not valid: {innerVisitedNotWall}"
          break
    
    # echo queue
    volume += levelArea
    # break

    level += 1
    if level > maxLevel:
      break

  return volume


  


when isMainModule:
  const lines = staticRead("input").splitLines()
  let result = processLines(lines)
  echo fmt"Result = {result}"