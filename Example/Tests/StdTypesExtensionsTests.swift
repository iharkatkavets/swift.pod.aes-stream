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
    
    func testThatPrintHexStringForUnsignedIntegerTypes() {
        assertPairsEqual(expected: "0x0f", actual: UInt8(15).hexString())
        assertPairsEqual(expected: "0x0f00", actual: UInt16(15).hexString())
        assertPairsEqual(expected: "0x0f000000", actual: UInt32(15).hexString())
        assertPairsEqual(expected: "0x0f00000000000000", actual: UInt(15).hexString())
    }

    func testThatReturnsTrueForEqualMemory() {
        let buffer1 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer1.initialize(to: 1, count: 100)
        let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer2.initialize(to: 1, count: 100)
        assertTrue(buffer1.compare(with: buffer2, size: 100))
    }

    func testThatReturnsFalseForDifferentMemory() {
        let buffer1 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer1.initialize(to: 1, count: 100)
        let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer2.initialize(to: 2, count: 100)
        assertFalse(buffer1.compare(with: buffer2, size: 100))
    }

    func testThatReturnsTrueForEqualMemoryDifferentTypes() {
        let data = Data(repeating: 1, count: 100)
        data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
            buffer2.initialize(to: 1, count: 100)
            assertTrue(bytes.compare(with: buffer2, size: 100))
            assertTrue(buffer2.compare(with: bytes, size: 100))
        }
    }

    func testThatReturnsFalseForDifferentMemoryDifferentTypes() {
        let data = Data(repeating: 2, count: 100)
        data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
            buffer2.initialize(to: 1, count: 100)
            assertFalse(bytes.compare(with: buffer2, size: 100))
            assertFalse(buffer2.compare(with: bytes, size: 100))
        }
    }
}
