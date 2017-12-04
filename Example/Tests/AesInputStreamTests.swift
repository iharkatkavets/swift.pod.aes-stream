//
//  AesInputStreamTests.swift
//  AESStream_Tests
//
//  Created by Igor Kotkovets on 12/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import AESStream

class AesInputStreamTests: XCTestCase {
    func testThatReadAesStream() {
        assertNoThrow ({
            let fileHandle = try! FileHandle(forReadingFrom: Constants.cipherTextFileUrl)
            let fileInputStream = FileInputStream(withFileHandle: fileHandle)
            let aesStream = try AesInputStream(with: fileInputStream,
                                               key: Constants.key,
                                               vector: Constants.vector)
            let bufferSize = 1000000
            let stringBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            var readBytes = 0
            repeat {
                readBytes = aesStream.read(stringBytes, maxLength: bufferSize)
                let string = String(bytesNoCopy: stringBytes, length: readBytes, encoding: .utf8, freeWhenDone: false)
                print("string: \(String(describing: string)) ")

            } while aesStream.hasBytesAvailable
            stringBytes.deallocate(capacity: bufferSize)
        })
    }
}
