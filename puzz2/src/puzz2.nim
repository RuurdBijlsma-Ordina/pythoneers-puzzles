import os
import std/strformat
import std/strutils
import std/algorithm
import std/sequtils
import std/tables
import sugar

func countKeywords(input: seq[string], reservedWords: seq[string]): int =
  var dict = initTable[string, int]()

  for inWord in input:
    let sortedIn = inWord.toSeq.sorted().join("")
    for reserveWord in reservedWords:
      let sortedReserve = reserveWord.toSeq.sorted().join("")
      if sortedIn == sortedReserve:
        dict[reserveWord] = dict.getOrDefault(reserveWord, 0) + 1

  for word, value in dict.pairs:
    let asciiSum = word.toSeq.map((c) => ord(c)).foldl(a + b)
    result += asciiSum * value

when isMainModule:
  const reservedWords = staticRead("reserved").splitLines()
  const inputWords = staticRead("input").splitLines()
  echo countKeywords(inputWords, reservedWords)
