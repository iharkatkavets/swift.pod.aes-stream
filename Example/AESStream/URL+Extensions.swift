//
//  URL+Extensions.swift
//  AESStream_Example
//
//  Created by igork on 12/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

extension URL {
    static func applicationDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask).last
    }
}
