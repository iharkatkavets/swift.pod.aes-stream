//
//  AesInputStream.swift
//  AESStream
//
//  Created by Igor Kotkovets on 12/3/17.
//

import Foundation
import CCommonCrypto

//
//  KeeAesInputStream.swift
//  Pods
//
//  Created by Igor Kotkovets on 8/7/17.
//
//

import Foundation


public enum AesInputStreamError: Error {
    case cryptorCreate
    case decryptData
}

class AesInputStream: InputStream {
    static let aesBufferSize = 512*1024
    let inputStream: InputStream
    var cryptorRef: CCCryptorRef?
    var bufferSize: Int = 0
    var bufferOffset: Int = 0
    var eofReached = false
    var outputBuffer = Data(repeating: 0, count: aesBufferSize)

    init(with inputStream: InputStream, key: Data, initVector: Data) throws {
        self.inputStream = inputStream

        let keyPtr = key.withUnsafeBytes { UnsafeRawPointer($0) }
        let ivPtr = initVector.withUnsafeBytes { UnsafeRawPointer($0) }
        let result: CCCryptorStatus = CCCryptorCreate(CCOperation(kCCDecrypt),
                                                      CCAlgorithm(kCCAlgorithmAES),
                                                      CCOptions(kCCOptionPKCS7Padding),
                                                      keyPtr,
                                                      key.count,
                                                      ivPtr,
                                                      &cryptorRef)
        guard result == CCCryptorStatus(kCCSuccess) else {
            throw AesInputStreamError.cryptorCreate
        }
    }

    var hasBytesAvailable: Bool {
        return !eofReached
    }

    func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        var remaining = length
        var offset = 0
        var length = 0
        var outputData = Data()

        while remaining > 0 {
            if bufferOffset >= bufferSize {
                do {
                    let couldDecrypt = try decryptChunk()
                    if couldDecrypt == false {
                        return outputData
                    }
                } catch {}
            }

            length = min(remaining, bufferSize-bufferOffset)
            outputData.append(outputBuffer.subdata(in: bufferOffset..<bufferOffset+length))

            bufferOffset += length
            offset += length
            remaining -= length
        }

        return outputData
    }

    func decryptChunk() throws -> Bool {
        if eofReached == true {
            return false
        }

        bufferSize = 0
        bufferOffset = 0
        var decryptedBytes = 0

        let data = inputStream.readData(ofLength: AesInputStream.aesBufferSize)
        let dataLength = data.count
        let outputBufferPointer = outputBuffer.withUnsafeMutableBytes { UnsafeMutableRawPointer(mutating: $0) }
        if dataLength > 0 {
            let dataPointer = data.withUnsafeBytes { UnsafeRawPointer($0) }
            let cryptorStatus = CCCryptorUpdate(cryptorRef,
                                                dataPointer,
                                                dataLength,
                                                outputBufferPointer,
                                                AesInputStream.aesBufferSize,
                                                &decryptedBytes)
            guard cryptorStatus == CCCryptorStatus(kCCSuccess) else {
                throw AesInputStreamError.decryptData
            }

            bufferSize += decryptedBytes
        }

        if dataLength < AesInputStream.aesBufferSize {
            let cryptorStatus = CCCryptorFinal(cryptorRef,
                                               outputBufferPointer+decryptedBytes,
                                               AesInputStream.aesBufferSize - decryptedBytes,
                                               &decryptedBytes)
            guard cryptorStatus == CCCryptorStatus(kCCSuccess) else {
                throw AesInputStreamError.decryptData
            }

            eofReached = true
            bufferSize += decryptedBytes
        }

        return true
    }
}
