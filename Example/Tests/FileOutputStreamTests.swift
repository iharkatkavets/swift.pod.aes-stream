//
//  FileOutputStreamTests.swift
//  AESStream_Tests
//
//  Created by igork on 12/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import AESStream

class FileOutputStreamTests: XCTestCase {
    
    func testThatWriteToFile() {
        assertNoThrow ({
            if let documentsDirUrl = URL.applicationDocumentsDirectory() {
                let fileName = UUID().uuidString
                let fileUrl = documentsDirUrl.appendingPathComponent(fileName)
                let filePath = fileUrl.absoluteString
                print("path: \(fileUrl.absoluteString)")
                if !FileManager.default.fileExists(atPath: filePath) {
                    if !FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil) {
                        print("Unable to create file")
                    }
                }

                if let fileHandle = FileHandle(forUpdatingAtPath: filePath) {
                    let fileOutputStream = FileOutputStream(with: fileHandle)
                    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
                    buffer.initialize(to: 3, count: 100)
                    _ = try fileOutputStream.write(buffer, maxLength: 100)
                    buffer.deallocate(capacity: 100)
                }

                if let readFileHandle = FileHandle(forReadingAtPath: filePath) {
                    let readBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
                    let fileInputStream = FileInputStream(withFileHandle: readFileHandle)
                    let readLength = fileInputStream.read(readBuffer, maxLength: 100)

                    assertPairsEqual(expected: readLength, actual: 100)
                }
            }
        })
    }
}
