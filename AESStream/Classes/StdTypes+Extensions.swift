//
//  StdTypes+Extensions.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/8/17.
//

import Foundation

public protocol ByteRepresentable {}

public extension ByteRepresentable {
    func hexString(withAdding prefix: String? = "0x") -> String {
        var copy = self

        return withUnsafePointer(to: &copy) { ptr -> String in
            let count = MemoryLayout<Self>.size
            return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { (bytes) -> String in
                var str: String = prefix ?? ""
                for i in 0..<count {
                    str += String(format: "%02x", bytes[i])
                }
                return str
            }
        }
    }
}

extension UInt8: ByteRepresentable {}
extension Int8: ByteRepresentable {}
extension UInt16: ByteRepresentable {}
extension Int16: ByteRepresentable {}
extension UInt32: ByteRepresentable {}
extension Int32: ByteRepresentable {}
extension UInt64: ByteRepresentable {}
extension Int64: ByteRepresentable {}
extension Int: ByteRepresentable {}
extension UInt: ByteRepresentable {}
