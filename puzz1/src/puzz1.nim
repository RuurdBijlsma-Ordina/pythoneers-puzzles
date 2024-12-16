import os
import std/strformat
import std/strutils
import std/algorithm
import std/sequtils


func countKeywords(input: seq[string], reservedWords: seq[string]): int =
  for inWord in input:
    let sortedIn = inWord.toSeq.sorted().join("")
    for reserveWord in reservedWords:
      let sortedReserve = reserveWord.toSeq.sorted().join("")
      result += int(sortedIn == sortedReserve)

when isMainModule:
  const reservedWords = staticRead("reserved").splitLines()
  const inputWords = staticRead("input").splitLines()
  echo countKeywords(inputWords, reservedWords)
