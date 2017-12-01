//
//  StdTypesExtensionsTests.swift
//  AESStream_Tests
//
//  Created by Igor Kotkovets on 12/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import AESStream

class StdTypesExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatPrintHexStringForUnsignedIntegerTypes() {
        assertPairsEqual(expected: "0x0f", actual: UInt8(15).hexString())
        assertPairsEqual(expected: "0x0f00", actual: UInt16(15).hexString())
        assertPairsEqual(expected: "0x0f000000", actual: UInt32(15).hexString())
        assertPairsEqual(expected: "0x0f00000000000000", actual: UInt(15).hexString())

    }
    
}
