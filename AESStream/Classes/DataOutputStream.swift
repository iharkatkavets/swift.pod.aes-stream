//
//  DataOutputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/4/17.
//

import Foundation

class DataOutputStream: OutputStream {
    public private(set) var data: Data = Data()

    var hasSpaceAvailable: Bool {
        return true
    }

    init() {
    }

    func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        data.append(buffer, count: len)
        return len
    }

    func close() {
    }
}
