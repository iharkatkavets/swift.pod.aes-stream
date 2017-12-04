//
//  Constants.swift
//  AESStream_Tests
//
//  Created by Igor Kotkovets on 12/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct Constants {
    static var plainTextFileUrl: URL = {
        return Bundle(for: AesInputStreamTests.self).url(forResource: "plaintext", withExtension: "txt")!
    }()
    static var cipherTextFileUrl: URL = {
        return Bundle(for: AesInputStreamTests.self).url(forResource: "encryptedtext", withExtension: "aes")!
    }()
    static let keyString: String = "00000000000000000000000000000000"
    static var key: Data = keyString.data(using: .utf8)!
    static let vectorString: String = "0000000000000000"
    static var vector: Data = vectorString.data(using: .utf8)!
}
