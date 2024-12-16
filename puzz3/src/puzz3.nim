import os
import std/strformat
import std/strutils
import std/algorithm
import std/sequtils
import std/tables
import sugar

func connectTowers(lines: seq[string]): string =
  var connections = initTable[char, seq[char]]()
  var reverseConnections = initTable[char, seq[char]]()

  for line in lines:
    let words = line.split(" ")
    let left = words[1][0]
    let right = words[words.len - 1][0]

    var connList = connections.getOrDefault(left, newSeq[char]())
    connList.add(right)
    connections[left] = connList

    var connList2 = reverseConnections.getOrDefault(right, newSeq[char]())
    connList2.add(left)
    reverseConnections[right] = connList2

  var queue = newSeq[char]()
  for tower in connections.keys:
    if tower notin reverseConnections:
      queue.addUnique(tower)
  queue.sort(order=Descending)

  var visited = newSeq[char]()
  while true:
    let tower = queue.pop()
    visited.add(tower)
    if tower notin connections:
      break
    for v in connections[tower]:
      var prereqsMet = true
      for prereq in reverseConnections[v]:
        if prereq notin visited:
          prereqsMet = false
          break
      if prereqsMet:
        queue.addUnique(v)
    queue.sort(order=Descending)

  return visited.join("")

when isMainModule:
  const lines = staticRead("input").splitLines()
  const result = connectTowers(lines)
  echo result