//
//  OutputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/3/17.
//

import Foundation

public protocol OutputStream {
    var hasSpaceAvailable: Bool { get }
    func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int
    func close()
}
