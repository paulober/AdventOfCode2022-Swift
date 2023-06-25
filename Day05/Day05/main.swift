//
//  main.swift
//  Day05
//
//  Created by Paul on 22.06.23.
//

import Foundation
import DayIO

let testInput = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

enum CustomError: Error {
    case regexInputError
}

struct Move {
    // could be UInt8 but cause many conversions as they are only used as indices which are required to be of type Int
    let count: Int
    let from: Int
    let to: Int
    
    init(input: Substring) throws {
        let pattern = /\b\d{1,2}\b/
        let matches = input.matches(of: pattern)
        if matches.count != 3 {
            throw CustomError.regexInputError
        }
        guard let count = Int(matches[0].0) else {
            throw CustomError.regexInputError
        }
        self.count = count
        // -1 so they can be used as indices
        guard let from = Int(matches[1].0) else {
            throw CustomError.regexInputError
        }
        self.from = from - 1
        guard let to = Int(matches[2].0) else {
            throw CustomError.regexInputError
        }
        self.to = to - 1
    }
}

struct Crate {
    let letter: Character
}

struct Stack {
    var crates: [Crate] = []
    
    func getLast() -> Character? {
        return crates.last?.letter
    }
}

struct Ship {
    var stacks: [Stack]
    
    init(input: Substring) {
        var lines = String(input).split(separator: "\n")
        let stacksCount = String(lines.last!).split(separator: " ")
            .filter { !$0.isEmpty }.compactMap { Int($0) }.max() ?? 0
        assert(stacksCount > 0 && stacksCount < 254)
        
        self.stacks = Array(repeating: Stack(), count: stacksCount)
        lines.removeLast()
        lines = lines.reversed()
        for line in lines {
            var stack = -1
            // +1 because "to" is excluded => [from; to[
            for i in stride(from: 1, to: (stacksCount*3)+stacksCount-3+1, by: 4) {
                stack += 1
                if line.count <= i {
                    // only for debug
                    //print("Last stacks empty at this level")
                    break
                }
                // alloc line
                let lineStr = String(line)
                guard let idx = lineStr.index(lineStr.startIndex, offsetBy: i, limitedBy: lineStr.endIndex) else {
                    break
                }
                
                let crate = lineStr[idx]
                if crate.isWhitespace {
                    continue
                }
                
                self.stacks[stack].crates.append(Crate(letter: crate))
            }
        }
    }
    
    mutating func executeMove(_ move: Move, is9001Instruction: Bool = false) {
        let crates = self.stacks[move.from].crates.suffix(move.count)
        // use max if move tries to move more items than available
        self.stacks[move.from].crates.removeLast([move.count, crates.count].max() ?? 0)
        if is9001Instruction {
            // because it can pick multiple crates at once
            self.stacks[move.to].crates.append(contentsOf: crates)
        } else {
            self.stacks[move.to].crates.append(contentsOf: crates.reversed())
        }
    }
}

struct Day05 {
    let input: String
    
    func run1(is9001: Bool = false) -> String {
        let inputParts = input.split(separator: "\n\n")
        assert(inputParts.count == 2)
        var ship = Ship(input: inputParts[0])
        let moves = try! inputParts[1].split(separator: "\n").compactMap(Move.init)
        
        moves.forEach { ship.executeMove($0, is9001Instruction: is9001) }
        let resultWord = ship.stacks.compactMap { $0.getLast() }.reduce("") { (result, char) in
            return result + String(char)
        }
        
        return "Word: \(resultWord)"
    }
    
    func run2() -> String {
        return self.run1(is9001: true)
    }
}

let testDay05 = Day05(input: testInput)
print("Day05 test: \(testDay05.run1())")

let day05 = Day05(input: readFile("day05.txt"))
print("Day05 part1: \(day05.run1())")
print("Day05 part2: \(day05.run2())")
