import os
import std/strformat
import std/strutils
import std/algorithm
import std/sequtils
import std/tables
import std/sets
import sugar

func processLine(line: string): int =
  let values = line.split(" ").map((c) => parseInt(c))
  var level = 1
  var area = 0
  while true:
    let higher = values.map((v) => v >= level)
    let leftIndex = higher.find(true)
    if leftIndex == -1:
      break
    let rightIndex = higher.len - higher.reversed.find(true)
    let length = rightIndex - leftIndex
    area += length
    level += 1
  return area - values.foldl(a + b)


when isMainModule:
  const lines = staticRead("input").splitLines()
  const result = lines.map(processLine).foldl(a + b)
  echo fmt"Result = {result}"