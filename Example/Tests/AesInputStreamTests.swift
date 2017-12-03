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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatCreateAesStream() {
        assertNoThrow ({
            let fileHandle = try! FileHandle(forReadingFrom: Constants.cipherTextFileUrl)
            let fileInputStream = FileInputStream(withFileHandle: fileHandle)
            let aesStream = try AesInputStream(with: fileInputStream, key: Constants.key, vector: Constants.vector)
            let bufferSize = 1000000
            var stringBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            var readBytes = 0
            repeat {
                readBytes = aesStream.read(stringBytes, maxLength: bufferSize)
                let data = Data(bytes: stringBytes, count: readBytes)
                let string = String(data: data, encoding: .utf8)
                print("string: \(string)")

            } while aesStream.hasBytesAvailable
            stringBytes.deallocate(capacity: bufferSize)
        })

    }
    
}
