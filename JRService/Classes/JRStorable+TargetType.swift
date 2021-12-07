//
//  JRStorable+TargetType.swift
//  23
//
//  Created by 焦瑞洁 on 2020/8/11.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation
import Moya
import CommonCrypto

extension JRStorable where Self: TargetType {
    
    private var cachedURL: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory,
            .userDomainMask,
            true).last
            else {
                fatalError("Couldn't search cache's directory.")
        }
        
        return URL(fileURLWithPath: path)
    }
    
    /// 默认 储存请求的缓存
    var allowsStorage: (String) -> Bool {
        return { _ in true }
    }
    
    /// 默认 需要读取缓存的
    var needCached: Bool {
        return true
    }
    
    /// 默认 立即刷新缓存数据
    var updateImmediate: Bool {
        return true
    }
    
    func cachedResponse(for key: CachingKey) throws -> String {
        let data = try Data(contentsOf: md5Key(key))
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    
    func storeCachedResponse(_ cachedResponse: String, for key: CachingKey) throws {
        if needCached ==  true {
            try cachedResponse.data(using: .utf8)?.write(to: md5Key(key))
        }
    }
    
    func removeCachedResponse(for key: CachingKey) throws {
        try FileManager.default.removeItem(at: md5Key(key))
    }
    
    func removeAllCachedResponses() throws {
        try FileManager.default.removeItem(at: cachedURL)
    }
    
    func md5Key(_ key: CachingKey) -> URL {
        return cachedURL.appendingPathComponent(key.keyString.toMD5)
    }
}

private extension String {
    
    var toMD5: String {
        let str = cString(using: .utf8)
        let strLen = CUnsignedInt(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        defer { free(result) }
        
        CC_MD5(str!, strLen, result)
        
        return (0..<digestLen).reduce("") { $0 + String(format: "%02x", result[$1]) }
    }
}
