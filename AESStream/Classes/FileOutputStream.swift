//
//  FileOutputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/4/17.
//

import Foundation

public class FileOutputStream: OutputStream {
    let fileHandle: FileHandle

    public var hasSpaceAvailable: Bool {
        return true
    }

    public init(with fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }

    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        let data = Data(bytes: buffer, count: len)
        fileHandle.write(data)
        return len
    }

    public func close() { }
}
