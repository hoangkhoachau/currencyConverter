//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Hoang Khoa on 11/1/24.
//

import XCTest
@testable import CurrencyConverter

final class CalculatorTest: XCTestCase {

    func testSimpleSum() {
        let calculator = Calculate()
        let result = try? calculator.evaluate("1+2+3")
        
        XCTAssertEqual(result, 6)
    }
    
    func testSimpleSubtraction() {
        let calculator = Calculate()
        let result = try? calculator.evaluate("1-2-3")
        
        XCTAssertEqual(result, -4)
    }
    
    func testMultipleOperations() {
        let calculator = Calculate()
        let result = try? calculator.evaluate("1+2*3")
        
        XCTAssertEqual(result, 7)
    }
    
    func testNumberWithDecimal() {
        let calculator = Calculate()
        let result = try? calculator.evaluate("1+2.3")
        
        XCTAssertEqual(result, 3.3)
    }
    
    func testDivideByZero() {
        let calculator = Calculate()
        let result = try? calculator.evaluate("1/0")
        
        XCTAssertNil(result)
    }
    
    func testNumberWithThousandsSeparator() {
        let calculator = Calculate()
        let result = try? calculator.evaluate("1+2,300")
        
        XCTAssertEqual(result, 2301)
    }

}
