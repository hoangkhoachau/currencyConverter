//
//  main.swift
//  challenge2.2
//
//  Created by Hoang Khoa on 11/1/24.
//

import Foundation

func findMissingNumber(from array: [Int]) -> Int{
    let sum = array.reduce(0, +)
    let expectedSum = (array.count + 1) * (array.count + 2) / 2
    let missingNumber = expectedSum - sum
    return missingNumber
}

let testCase1: [Int] = [3, 7, 1, 2, 6, 4]
print(findMissingNumber(from: testCase1))
