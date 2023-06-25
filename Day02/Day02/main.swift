//
//  main.swift
//  Day02
//
//  Created by Paul on 21.06.23.
//

import Foundation
import DayIO

let testInput = """
A Y
B X
C Z
"""

enum Move: UInt16 {
    case Rock = 1
    case Paper = 2
    case Scissors = 3
}

extension Move {
    static func fromCharacter(_ input: Character) -> Move {
        switch input {
        case "A":
            return .Rock
        case "B":
            return .Paper
        case "C":
            return .Scissors
        case "X":
            return .Rock
        case "Y":
            return .Paper
        case "Z":
            return .Scissors
        default:
            exit(1)
        }
    }
}

struct Game {
    let me: Move
    let opponent: Move

    
    /**
        Returns the score.
     */
    func result() -> UInt16 {
        let base = me.rawValue
        switch (me) {
        case .Rock:
            switch (opponent) {
            case .Rock:
                return base+3
            case .Paper:
                return base+0
            case .Scissors:
                return base+6
            }
        case .Paper:
            switch (opponent) {
            case .Rock:
                return base+6
            case .Paper:
                return base+3
            case .Scissors:
                return base+0
            }
        case .Scissors:
            switch (opponent) {
            case .Rock:
                return base+0
            case .Paper:
                return base+6
            case .Scissors:
                return base+3
            }
        }
    }
}

struct Day02 {
    let input: String
    
    private func calc() -> UInt16 {
        let rounds = input.split(separator: "\n").map {
            return Game(me: Move.fromCharacter($0.first!), opponent: Move.fromCharacter($0.last!))
        }
        
        return rounds.reduce(0) { $0 + $1.result() }
    }
    
    func run1() -> String {
        let result = self.calc()
        return "Score: \(result)"
    }
}

let testDay02 = Day02(input: testInput)
print("Day02 Test: \(testDay02.run1())")

// does not work
let day02 = Day02(input: readFile("day02.txt"))
print("Day02 Part1: \(day02.run1())")
