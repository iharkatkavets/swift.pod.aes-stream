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
        return Bundle(for: AesInputStreamTests.self).url(forResource: "loremipsum", withExtension: "txt")!
    }()
    static var cipherTextFileUrl: URL = {
        return Bundle(for: AesInputStreamTests.self).url(forResource: "encryptedtext", withExtension: "aes")!
    }()
    static var key: Data = Data(count: 32)
    static var vector: Data = Data(count: 16)
}
