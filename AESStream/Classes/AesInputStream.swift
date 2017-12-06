//
//  AesInputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/3/17.
//

import Foundation
import CommonCryptoSwift

public enum AesInputStreamError: Error {
    case invalidKeySize
    case creatingCryptorError
    case decryptingDataError
    case finishingDecriptingError
}

public class AesInputStream: InputStream {
    static let aesBufferSize = 512*1024
    let inputStream: InputStream
    var cryptorRef: CCCryptorRef?
    var bufferSize: Int = 0
    var bufferOffset: Int = 0
    var eofReached = false
    var inputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: AesInputStream.aesBufferSize)
    var outputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: AesInputStream.aesBufferSize)

    public init(with inputStream: InputStream, key: Data, vector: Data) throws {
        guard key.count == 32 && vector.count == 16 else {
            throw AesInputStreamError.invalidKeySize
        }

        self.inputStream = inputStream

        let keyPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: key.count)
        key.copyBytes(to: keyPtr, count: key.count)

        let vectorPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: vector.count)
        vector.copyBytes(to: vectorPtr, count: vector.count)

        // CBC mode is selected by the absence of the kCCOptionECBMode bit in the options flags
        let result: CCCryptorStatus = CCCryptorCreate(CCOperation(kCCDecrypt),
                                                      CCAlgorithm(kCCAlgorithmAES128),
                                                      CCOptions(kCCOptionPKCS7Padding),
                                                      keyPtr,
                                                      key.count,
                                                      vectorPtr,
                                                      &cryptorRef)
        guard result == CCCryptorStatus(kCCSuccess) else {
            print(result.description())
            throw AesInputStreamError.creatingCryptorError
        }

        keyPtr.deallocate(capacity: key.count)
        vectorPtr.deallocate(capacity: vector.count)
    }

    deinit {
        inputBuffer.deallocate(capacity: AesInputStream.aesBufferSize)
        outputBuffer.deallocate(capacity: AesInputStream.aesBufferSize)
    }

    public var hasBytesAvailable: Bool {
        return !eofReached && bufferOffset < bufferSize
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        var remaining = len
        var offset = 0
        var actualLength = 0

        while remaining > 0 {
            if bufferOffset >= bufferSize {
                do {
                    let couldDecrypt = try decryptChunk()
                    if couldDecrypt == false {
                        return len - remaining
                    }
                } catch {}
            }

            actualLength = min(remaining, bufferSize-bufferOffset)
            (buffer+offset).initialize(from: outputBuffer+bufferOffset, count: actualLength)

            bufferOffset += actualLength
            offset += actualLength
            remaining -= actualLength
        }

        return offset
    }

    func decryptChunk() throws -> Bool {
        if eofReached == true {
            return false
        }

        bufferSize = 0
        bufferOffset = 0
        var decryptedBytes = 0
        let readLength = inputStream.read(inputBuffer, maxLength: AesInputStream.aesBufferSize)
        if readLength > 0 {
            let cryptorStatus = CCCryptorUpdate(cryptorRef,
                                                inputBuffer,
                                                readLength,
                                                outputBuffer,
                                                AesInputStream.aesBufferSize,
                                                &decryptedBytes)
            guard cryptorStatus == CCCryptorStatus(kCCSuccess) else {
                print(cryptorStatus.description())
                throw AesInputStreamError.decryptingDataError
            }

            bufferSize += decryptedBytes
        }

        if readLength < AesInputStream.aesBufferSize {
            let cryptorStatus = CCCryptorFinal(cryptorRef,
                                               outputBuffer+decryptedBytes,
                                               AesInputStream.aesBufferSize - decryptedBytes,
                                               &decryptedBytes)
            guard cryptorStatus == CCCryptorStatus(kCCSuccess) else {
                print(cryptorStatus.description())
                throw AesInputStreamError.finishingDecriptingError
            }

            eofReached = true
            bufferSize += decryptedBytes
        }

        return true
    }
}

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


