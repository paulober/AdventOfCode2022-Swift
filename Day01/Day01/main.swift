//
//  main.swift
//  Day01
//
//  Created by Paul on 21.06.23.
//

import Foundation
import DayIO

let inputExample = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

struct Day01 {
    let input: String
    
    private func calc() -> [UInt32] {
        // faster could be to separate by \n\n so you already have the elfs separated
        let lines = self.input.split(separator: "\n", omittingEmptySubsequences: false)

        //var elfs: [UInt32] = []

        let elfs = lines.reduce(into: [UInt32]()) { acc, line in
            if acc.isEmpty || line.isEmpty {
                acc.append(0)
            }
            
            if let cals = UInt32(line) {
                acc[acc.count-1] += cals
            }
        }
        
        /*
        var i = 0
        for line in lines {
            if line.isEmpty {
                i += 1
                continue
            }
            if elfs.count < i+1 {
                elfs.append(0)
            }
            
            elfs[i] += UInt32(line) ?? 0
        }*/
        return elfs
    }
    
    func run() -> String {
        let elfs = self.calc()
        
        return "Max: \(elfs.max() ?? 0)"
    }
    
    func run2() -> String {
        let elfs = self.calc().sorted()
        let maxIdx = elfs.count - 1
        return "Sum: \(elfs[maxIdx]+elfs[maxIdx-1]+elfs[maxIdx-2])"
    }
}

let maxTest = Day01(input: inputExample).run()
print("Day 01 test result: \(maxTest)")

let day01 = Day01(input: readFile("day01.txt"))
let max = day01.run()
print("Day 01 part 1 result: \(max)")

let sum = day01.run2()
print("Day 01 part 2 result: \(sum)")
