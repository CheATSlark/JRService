//
//  APINetworkError.swift
//  23
//
//  Created by 焦瑞洁 on 2020/1/10.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation
/// 代表一个错误
 protocol NetworAPIkError: Error {
    /// 错误码
    var code: String { get }
    /// 错误信息
    var displayMsg: String { get }
    /// 错误代码
    var num: Int { get }
}

extension NetworAPIkError {
    /// Default implementation for `code` property
    public var code: String {
        return "200"
    }
}

fileprivate let networkErrorCodes = [URLError.timedOut.rawValue,
                                     URLError.cannotFindHost.rawValue,
                                     URLError.cannotConnectToHost.rawValue,
                                     URLError.notConnectedToInternet.rawValue]
extension NetworAPIkError {
    /// token是否过期
    public var isTokenExpired: Bool {
        return code == "TOKEN_EXPIRED"
    }
    
//    /// 是否是网络错误
//    public var isFailedByNetwork: Bool {
//        return networkErrorCodes.contains(code)
//    }
}
