//
//  AesIOStreamTests.swift
//  AESStream_Tests
//
//  Created by Igor Kotkovets on 12/5/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import AESStream

class AesIOStreamTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEncryptingDecryptingData() {
        assertNoThrow({
            let originDataLength = 1000
            let originData = UnsafeMutablePointer<UInt8>.allocate(capacity: originDataLength)
            originData.initialize(to: 2, count: originDataLength)
            let key = Data(repeating: 1, count: 32)
            let vector = Data(repeating: 1, count: 16)

            let dataOutputStream = DataOutputStream()
            let aesOutputStream = try AesOutputStream(with: dataOutputStream, key: key, vector: vector)
            _ = try aesOutputStream.write(originData, maxLength: originDataLength)
            try aesOutputStream.close()

            let dataInputStream = DataInputStream(withData: dataOutputStream.data)
            let decryptedDataBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: originDataLength)
            let aesInputStream = try AesInputStream(with: dataInputStream, key: key, vector: vector)
            assertPairsEqual(expected: originDataLength, actual: aesInputStream.read(decryptedDataBuffer, maxLength: originDataLength))

            for i in 0..<originDataLength {
                assertPairsEqual(expected: originData[i], actual: decryptedDataBuffer[i])
            }
        })
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
