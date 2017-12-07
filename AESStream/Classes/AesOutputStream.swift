//
//  AesOutputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/3/17.
//

import Foundation
import CommonCryptoSwift

public enum AesOutputStreamError: Error {
    case invalidKeySize
    case creatingCryptorError
    case decryptingDataError
    case finishingDecriptingError
}

public class AesOutputStream: OutputStream {
    var bufferSize = 0
    var cryptorRef: CCCryptorRef?
    var cryptorBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
    let outputStream: OutputStream

    public init(with outputStream: OutputStream, key: Data, vector: Data) throws {
        guard key.count == 32 && vector.count == 16 else {
            throw AesInputStreamError.invalidKeySize
        }

        self.outputStream = outputStream

        let keyPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: key.count)
        key.copyBytes(to: keyPtr, count: key.count)

        let vectorPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: vector.count)
        vector.copyBytes(to: vectorPtr, count: vector.count)

        // CBC mode is selected by the absence of the kCCOptionECBMode bit in the options flags
        let result: CCCryptorStatus = CCCryptorCreate(CCOperation(kCCEncrypt),
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
        cryptorBuffer.deallocate(capacity: bufferSize)
    }

    public var hasSpaceAvailable: Bool {
        return outputStream.hasSpaceAvailable
    }

    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        validateBufferSizeForEncryptingData(ofLength: len)

        var encryptedBytes = 0
        let cryptorStatus = CCCryptorUpdate(cryptorRef,
                                            buffer,
                                            len,
                                            cryptorBuffer,
                                            bufferSize,
                                            &encryptedBytes)
        guard cryptorStatus == CCCryptorStatus(kCCSuccess) else {
            print(cryptorStatus.description())
            return 0
        }

        return outputStream.write(cryptorBuffer, maxLength:encryptedBytes)
    }

    public func close() {
        var encryptedBytes = 0
        let cryptorStatus = CCCryptorFinal(cryptorRef,
                                           cryptorBuffer,
                                           bufferSize,
                                           &encryptedBytes)
        guard cryptorStatus == CCCryptorStatus(kCCSuccess) else {
            print(cryptorStatus.description())
            return
        }

        _ = outputStream.write(cryptorBuffer, maxLength:encryptedBytes)
    }

    func validateBufferSizeForEncryptingData(ofLength: Int) {
        if bufferSize < ofLength {
            cryptorBuffer.deallocate(capacity: bufferSize)
            cryptorBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ofLength)
            bufferSize = ofLength
        }
    }
}
