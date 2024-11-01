//
//  ConverterTest.swift
//  CurrencyConverterTests
//
//  Created by Hoang Khoa on 11/1/24.
//

import XCTest
@testable import CurrencyConverter

final class ConverterTest: XCTestCase {

    @MainActor func testConvert() {
        let converter = Converter()
        let usd = Currency(name: "United States Dollar", shortName: "USD", ratesOnUSD: 1)
        let vnd = Currency(name: "Vietnam Dong", shortName: "VND", ratesOnUSD: 23000)
        let result = converter.convert(5, from: usd, to: vnd)
        XCTAssertEqual(result, 115000)
    }
}
