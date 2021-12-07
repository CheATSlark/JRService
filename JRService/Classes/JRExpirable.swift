//
//  JRExpirable.swift
//  23
//
//  Created by 焦瑞洁 on 2020/7/23.
//  Copyright © 2020 ddcx. All rights reserved.
//

public protocol JRExpirable {
    
    /// 缓存过期的时间
    var expiry: JRExpiry { get }
}

extension JRExpirable {
    
    func update(expiry: JRExpiry, for key: JRStoringKey) {
        UserDefaults.standard.update(expiry: expiry.date, for: key.keyString)
    }
    
    func removeExpiry(for key: JRStoringKey) {
        UserDefaults.standard.removeExpiryDate(for: key.keyString)
    }
    
    func expiry(for key: JRStoringKey) throws -> JRExpiry {
        guard let date = UserDefaults.standard.expiryDate(for: key.keyString) else {
            throw JRExpiry.Error.noCache
        }
        
        return .date(date)
    }
}

private extension UserDefaults {
    
    static let expiryKey = "com.pircate.github.expiry.key"
    
    func expiryDate(for key: String) -> Date? {
        guard let object = object(forKey: UserDefaults.expiryKey) as? [String: Date] else { return nil }
        
        return object[key]
    }
    
    func update(expiry date: Date, for key: String) {
        guard var object = object(forKey: UserDefaults.expiryKey) as? [String: Date] else {
            set([key: date], forKey: UserDefaults.expiryKey)
            return
        }
        
        object.updateValue(date, forKey: key)
        set(object, forKey: UserDefaults.expiryKey)
    }
    
    func removeExpiryDate(for key: String) {
        guard var object = object(forKey: UserDefaults.expiryKey) as? [String: Date] else {
            return
        }
        
        object.removeValue(forKey: key)
        set(object, forKey: UserDefaults.expiryKey)
    }
}

