//
//  CommonCryptorExtensions.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/3/17.
//

import Foundation
import CommonCryptoSwift

public extension CCCryptorStatus {
    func description() -> String {
        if self == CCCryptorStatus(kCCParamError) {
            return "Illegal parameter value."
        } else if self == CCCryptorStatus(kCCBufferTooSmall) {
            return "Insufficent buffer provided for specified operation."
        } else if self == CCCryptorStatus(kCCMemoryFailure) {
            return "Memory allocation failure."
        } else if self == CCCryptorStatus(kCCAlignmentError) {
            return "Input size was not aligned properly."
        } else if self == CCCryptorStatus(kCCDecodeError) {
            return "Input data did not decode or decrypt properly."
        } else if self == CCCryptorStatus(kCCUnimplemented) {
            return "Function not implemented for the current algorithm."
        } else if self == CCCryptorStatus(kCCOverflow) {
            return "kCCOverflow."
        } else if self == CCCryptorStatus(kCCRNGFailure) {
            return "kCCOverflow."
        } else if self == CCCryptorStatus(kCCUnspecifiedError) {
            return "kCCOverflow."
        } else if self == CCCryptorStatus(kCCCallSequenceError) {
            return "kCCOverflow."
        } else if self == CCCryptorStatus(kCCKeySizeError) {
            return "Invalid key size."
        }


        return "Undefined error \(self)."
    }
}
