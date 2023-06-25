//
//  main.swift
//  Day04
//
//  Created by Paul on 22.06.23.
//

import Foundation
import DayIO

let testInput = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

enum CustomError : Error {
    case inputError
}

struct Range {
    let start: UInt16
    let end: UInt16
    
    init(_ input: Substring) throws {
        let rangeComponents = input.split(separator: "-")
        
        if let start = UInt16(rangeComponents[0]), let end = UInt16(rangeComponents[1]) {
            self.start = start
            self.end = end
        } else {
            throw CustomError.inputError
        }
    }
    
    // the range must always start with the smaller number
    func containEachOther(with other: Range) -> Bool {
        return (start <= other.start && end >= other.end) || (other.start <= start && other.end >= end)
    }
    
    func intercept(with other: Range) -> Bool {
        /*if start < other.start {
            return end >= other.start
        } else if start > other.start {
            return other.end >= start
        } else {
            return true
        } */
        
        return start < other.start ? end >= other.start : (start > other.start ? other.end >= start : true)
    }
}

struct Pair {
    let r1: Range
    let r2: Range
    
    init(input: Substring) throws {
        let ranges = input.split(separator: ",")
        r1 = try Range(ranges[0])
        r2 = try Range(ranges[1])
    }
}

struct Day04 {
    let input: String
    
    func run1() -> String {
        do {
            let sum = try input.split(separator: "\n")
                .map(Pair.init(input:))
                .reduce(0) { $0 + ($1.r1.containEachOther(with: $1.r2) ? 1 : 0)}
            
            return "Sum: \(sum)"
        } catch CustomError.inputError {
            print("Strange input")
        } catch {}
        
        return "N/A"
    }
    
    func run2() -> String {
        do {
            let sum = try input.split(separator: "\n")
                .map(Pair.init(input:))
                .reduce(0) { $0 + ($1.r1.intercept(with: $1.r2) ? 1 : 0)}
            
            return "Sum: \(sum)"
        } catch CustomError.inputError {
            print("Strange input")
        } catch {}
        
        return "N/A"
    }
}

let testDay04 = Day04(input: testInput)
print("Day04 test: \(testDay04.run1())")

let day04 = Day04(input: readFile("day04.txt"))
print("Day04 part1: \(day04.run1())")
print("Day04 part2: \(day04.run2())")
