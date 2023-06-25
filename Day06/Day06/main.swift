//
//  main.swift
//  Day06
//
//  Created by Paul on 25.06.23.
//

import Foundation
import DayIO

let testInput = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
let testInput2 = "bvwbjplbgvbhsrlpgdmjqwftvncz"
let testInput3 = "nppdvjthqldpwncqszvftbrmjlhg"
let testInput4 = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
let testInput5 = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

extension Array where Element == Character {
    func containsDuplicates() -> Bool {
        var seenCharacters = Set<Character>()
        
        for char in self {
            if seenCharacters.contains(char) {
                return true
            }
            seenCharacters.insert(char)
        }
        
        return false
    }
}

struct Day06 {
    let input: String
    
    func run1() -> Int {
        var result = ""
        var currentPackage: [Character] = []
       
        for char in input {
            result.append(char)
            
            if currentPackage.count == 3 {
                if !currentPackage.contains(char) && !currentPackage.containsDuplicates() {
                    break
                }
                currentPackage.removeFirst()
            }
            
            currentPackage.append(char)
        }
        
        return result.count
    }
    
    func run2() -> Int {
        var result = ""
        var currentPackage: [Character] = []
       
        for char in input {
            result.append(char)
            
            if currentPackage.count == 13 {
                if !currentPackage.contains(char) && !currentPackage.containsDuplicates() {
                    break
                }
                currentPackage.removeFirst()
            }
            
            currentPackage.append(char)
        }
        
        return result.count
    }
}

let test1Day06 = Day06(input: testInput)
let test1Result1 = test1Day06.run1()
print("Day06 test1 part1: \(test1Result1)")
assert(test1Result1 == 7)
let test1Result2 = test1Day06.run2()
print("Day06 test1 part2: \(test1Result2)")
assert(test1Result2 == 19)

let test2Day06 = Day06(input: testInput2)
let test2Result1 = test2Day06.run1()
print("Day06 test2 part1: \(test2Result1)")
assert(test2Result1 == 5)
let test2Result2 = test2Day06.run2()
print("Day06 test2 part2: \(test2Result2)")
assert(test2Result2 == 23)

let test3Day06 = Day06(input: testInput3)
let test3Result1 = test3Day06.run1()
print("Day06 test3 part1: \(test3Result1)")
assert(test3Result1 == 6)
let test3Result2 = test3Day06.run2()
print("Day06 test3 part2: \(test3Result2)")
assert(test3Result2 == 23)

let test4Day06 = Day06(input: testInput4)
let test4Result1 = test4Day06.run1()
print("Day06 test4 part1: \(test4Result1)")
assert(test4Result1 == 10)
let test4Result2 = test4Day06.run2()
print("Day06 test4 part2: \(test4Result2)")
assert(test4Result2 == 29)

let test5Day06 = Day06(input: testInput5)
let test5Result1 = test5Day06.run1()
print("Day06 test5 part1: \(test5Result1)")
assert(test5Result1 == 11)
let test5Result2 = test5Day06.run2()
print("Day06 test5 part2: \(test5Result2)")
assert(test5Result2 == 26)

print("ALL TESTS PASSED SUCCESSFULLY\n")

let day06 = Day06(input: readFile("day06.txt"))
print("Day06 part1: \(day06.run1())")
print("Day06 part2: \(day06.run2())")
