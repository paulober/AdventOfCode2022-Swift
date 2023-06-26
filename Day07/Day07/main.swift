//
//  main.swift
//  Day07
//
//  Created by Paul on 26.06.23.
//

import Foundation
import DayIO

let testInput = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

enum FSItemType: UInt8 {
    case File
    case Directory
}

protocol FSItem {
    var name: String { get }
    var size: Int { get }
    var type: FSItemType { get }
}

struct File: FSItem {
    let name: String
    
    let size: Int
    private(set) var type: FSItemType = .File
}

struct Directory: FSItem {
    let name: String
    var children: [FSItem] = []
    
    var size: Int {
        return children.compactMap { $0.size }.reduce(0, +)
    }
    private(set) var type: FSItemType = .Directory
    
    func getSizesOfSubdirectories() -> [Int] {
        /*let subDirs = children.filter { $0.type == .Directory }
        let subDirSizes = subDirs.compactMap { ($0 as? Directory)?.getSizesOfSubdirectories() }.flatMap { $0 }
        var sizes = subDirs.compactMap { $0.size }
        sizes.append(contentsOf: subDirSizes)*/
        
        var sizes: [Int] = []
        
        for child in children {
            if let directory = child as? Directory {
                sizes.append(directory.size)
                sizes.append(contentsOf: directory.getSizesOfSubdirectories())
            }
        }
        
        return sizes
    }
    
    mutating func addDirectory(_ path: String) {
        let paths = path.split(separator: "/")
        if paths.count == 1 {
            self.children.append(Directory(name: String(paths[0])))
        } else {
            if let dirIdx = self.children.firstIndex(where: { $0.name == paths[0] }) {
                if var dir = self.children[dirIdx] as? Directory {
                    dir.addDirectory(paths.dropFirst().joined(separator: "/"))
                    self.children[dirIdx] = dir
                }
            } else {
                print("PANIC")
                exit(2)
            }
        }
    }
    
    mutating func addFile(_ path: String, size: Int) {
        let paths = path.split(separator: "/")
        if paths.count == 1 {
            self.children.append(File(name: String(paths[0]), size: size))
        } else {
            if let dirIdx = self.children.firstIndex(where: { $0.name == paths[0] }) {
                if var dir = self.children[dirIdx] as? Directory {
                    dir.addFile(paths.dropFirst().joined(separator: "/"), size: size)
                    self.children[dirIdx] = dir
                }
            } else {
                print("PANIC")
                exit(3)
            }
        }
    }
}

struct Day07 {
    let input: String
    var root: Directory = Directory(name: "/", children: [])
    
    private mutating func setupMemFs() {
        self.root = Directory(name: "/", children: [])
        var currentPath = ""
        for line in input.split(separator: "\n") {
            if (line.starts(with: "$")) {
                if line.contains("cd ..") {
                    currentPath = String(currentPath.prefix(upTo: currentPath.lastIndex(of: "/")!))
                } else if line.contains("cd") {
                    currentPath += "/" + line.split(separator: " ").last!
                }
                continue
            }
            // must be ls output
            
            let data = line.split(separator: " ")
            if line.starts(with: "dir") {
                root.addDirectory(currentPath + "/" + data[1])
            } else {
                root.addFile(currentPath + "/" + data[1], size: Int(data[0])!)
            }
        }
    }
    
    mutating func run1() -> Int {
        setupMemFs()
        
        // maybe append root.size
        return root.getSizesOfSubdirectories().filter { $0 <= 100000 }.reduce(0, +)
    }
    
    mutating func run2() -> Int {
        setupMemFs()
        
        // calc used space
        let usedBytes = root.size
        let requiredFreeSpace = 30000000
        let totalSpace = 70000000
        let freeSpace = totalSpace-usedBytes
        assert(requiredFreeSpace>freeSpace)
        let requiredAdditionalSpace = requiredFreeSpace-freeSpace
        
        // get directory sizes which would free up enough space if deleted(ascending)
        let dirs = root.getSizesOfSubdirectories().filter { $0 >= requiredAdditionalSpace }.sorted()
        
        return dirs.first ?? -1
    }
}

var testDay07 = Day07(input: testInput)
print("Day07 test part1: \(testDay07.run1())")

var day07 = Day07(input: readFile("day07.txt"))
print("Day07 part1: \(day07.run1())")
print("Day07 part2: \(day07.run2())")
