//
//  DataOutputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/4/17.
//

import Foundation

public class DataOutputStream: OutputStream {
    public private(set) var data: Data = Data()

    public var hasSpaceAvailable: Bool {
        return true
    }

    public init() {
    }

    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        data.append(buffer, count: len)
        return len
    }

    public func close() {
    }
}
