//
//  JRExpiry.swift
//  23
//
//  Created by 焦瑞洁 on 2020/7/23.
//  Copyright © 2020 ddcx. All rights reserved.
//
public enum JRExpiry {
    /// Object will be expired in the nearest future
    case never
    /// Object will be expired in the specified amount of seconds
    case seconds(TimeInterval)
    /// Object will be expired on the specified date
    case date(Date)
    
    /// Returns the appropriate date object
    public var date: Date {
        switch self {
        case .never:
            // 60 * 60 * 24 * 365 * 68
            return Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 365 * 24 * 60 * 60)
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .date(let date):
            return date
        }
    }
    
    /// Checks if cached object is expired according to expiration date
    public var isExpired: Bool {
        return date.timeIntervalSince1970 < Date().timeIntervalSince1970
    }
}

public extension JRExpiry {
    
    enum Error: Swift.Error {
        case noCache
        case expired(Date)
    }
}

