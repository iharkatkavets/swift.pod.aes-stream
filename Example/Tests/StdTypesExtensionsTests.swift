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
        assertPairsEqual(expected: "0x0f", actual: UInt8(15).hexString(withAdding: "0x"))
        assertPairsEqual(expected: "0x0f00", actual: UInt16(15).hexString(withAdding: "0x"))
        assertPairsEqual(expected: "0x0f000000", actual: UInt32(15).hexString(withAdding: "0x"))
        assertPairsEqual(expected: "0x0f00000000000000", actual: UInt(15).hexString(withAdding: "0x"))

        let data0 = Data(hex: "b99c32c6dd66a3ecd94d4bae80334ede90d4fa0e247de8a0587e72197e1561bb")!
        data0.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            assertPairsEqual(expected: "b99c32c6dd66a3ecd94d4bae80334ede90d4fa0e247de8a0587e72197e1561bb",
                             actual: bytes.hexString(ofLength: data0.count))
        }

    }

    func testThatReturnsTrueForEqualMemory() {
        let buffer1 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer1.initialize(to: 1, count: 100)
        let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer2.initialize(to: 1, count: 100)
        assertTrue(buffer1.isEqual(to: buffer2, ofLength: 100))
    }

    func testThatReturnsFalseForDifferentMemory() {
        let buffer1 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer1.initialize(to: 1, count: 100)
        let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
        buffer2.initialize(to: 2, count: 100)
        assertFalse(buffer1.isEqual(to: buffer2, ofLength: 100))
    }

    func testThatReturnsTrueForEqualMemoryDifferentTypes() {
        let data = Data(repeating: 1, count: 100)
        data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
            buffer2.initialize(to: 1, count: 100)
            assertTrue(bytes.isEqual(to: buffer2, ofLength: 100))
            assertTrue(buffer2.isEqual(to: bytes, ofLength: 100))
        }
    }

    func testThatReturnsFalseForDifferentMemoryDifferentTypes() {
        let data = Data(repeating: 2, count: 100)
        data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let buffer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
            buffer2.initialize(to: 1, count: 100)
            assertFalse(bytes.isEqual(to: buffer2, ofLength: 100))
            assertFalse(buffer2.isEqual(to: bytes, ofLength: 100))
        }
    }

    func testThatPrintValidHexString() {
        let zerosMutPtr = UnsafeMutablePointer<UInt64>.allocate(capacity: 2)
        zerosMutPtr.initialize(to: 0, count: 2)
        assertPairsEqual(expected: "0x00000000000000000000000000000000", actual: zerosMutPtr.hexString(ofLength: 2))
        let zerosPtr = UnsafePointer(zerosMutPtr)
        assertPairsEqual(expected: "0x00000000000000000000000000000000", actual: zerosPtr.hexString(ofLength: 2))

        let onesMutPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 2)
        onesMutPtr.initialize(to: 1, count: 2)
        assertPairsEqual(expected: "0x0100000001000000", actual: onesMutPtr.hexString(ofLength: 2))
        let onesPtr = UnsafePointer(onesMutPtr)
        assertPairsEqual(expected: "0x0100000001000000", actual: onesPtr.hexString(ofLength: 2))
    }
}
