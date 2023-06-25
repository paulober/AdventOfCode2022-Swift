//
//  main.swift
//  Day03
//
//  Created by Paul on 21.06.23.
//

import Foundation
import DayIO

let testInput = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""

// uint8 would be better but then conversion with unicodeScalar.value is needed
func charToPriority(char: Substring.Element?) -> UInt32? {
    guard let char = char else {
        return nil
    }
    
    guard let unicodeScalar = char.unicodeScalars.first else {
        return nil
    }
    //let isUppercase = unicodeScalar.value >= 97
    // - 27 because the upperacase pirority starts with A=27
    let sub: UInt32 = char.isUppercase ? 65 - 27 : 97 - 1
    
    return unicodeScalar.value - sub
}

struct Compartment {
    let items: Substring
    
    func commonItems(with comp2: Compartment) -> Set<Substring.Element> {
        let charSet1 = Set(items)
        return Set(comp2.items.filter { charSet1.contains($0) })
    }
}

struct Rucksack {
    let input: Substring
    let comp1: Compartment
    let comp2: Compartment
    
    init(input: Substring) {
        self.input = input
        let middleIndex = input.index(input.startIndex, offsetBy: input.count / 2)
        comp1 = Compartment(items: input.prefix(upTo: middleIndex))
        comp2 = Compartment(items: input.suffix(from: middleIndex))
    }
    
    func getPriority() -> UInt32 {
        let intersectingChars = self.comp1.commonItems(with: self.comp2)
        if intersectingChars.count != 1 {
            print("Error intersectingChars.count != 1")
            return 0
        }
        
        return charToPriority(char: intersectingChars.first) ?? 0
    }
    
    func getPriorityOfGroup(r1: Rucksack, r2: Rucksack) -> UInt32 {
        let set1 = Set(r1.input)
        let set2 = Set(r2.input)
        
        let intersectingChars = Set(input.filter { set1.contains($0) && set2.contains($0) })
        if intersectingChars.count != 1 {
            print("Error intersectingChars.count != 1")
            return 0
        }
        
        return charToPriority(char: intersectingChars.first) ?? 0
    }
}

struct Day03 {
    let input: String
    
    func run1() -> String {
        let rucksacks: [Rucksack] = input.split(separator: "\n").map(Rucksack.init(input:))
        
        let sum = rucksacks.reduce(0) { $0 + $1.getPriority() }
        
        return "Sum: \(sum)"
    }
    
    func run2() -> String {
        let rucksacks: [Rucksack] = input.split(separator: "\n").map(Rucksack.init(input:))
        
        let sum: UInt32 = stride(from: 0, to: rucksacks.count, by: 3).reduce(0) { result, startIndex in
            //let endIndex = min(startIndex+3, rucksacks.count)
            let endIndex = startIndex+3
            if endIndex > rucksacks.count {
                print("PANIC!!!")
                exit(2000)
            }
            let group = rucksacks[startIndex..<endIndex]
            let priority = group.first?.getPriorityOfGroup(r1: group[group.startIndex+1], r2: group[group.startIndex+2]) ?? 0
            return result + priority
        }
        
        return "Sum: \(sum)"
    }
}

let testDay03 = Day03(input: testInput)
print("Day03 test: \(testDay03.run1())")

let day03 = Day03(input: readFile("day03.txt"))
print("Day03 part1: \(day03.run1())")
print("Day03 part2: \(day03.run2())")
