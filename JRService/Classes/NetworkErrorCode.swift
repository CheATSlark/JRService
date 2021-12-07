//
//  BddErrorCode.swift
//  23
//
//  Created by 焦瑞洁 on 2020/1/10.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation

//
// 错误码定义
//
public enum NetworkErrorCode {
    case TOKEN_INVALID
    case TOKEN_EXPIRED
    case REFRESH_TOKEN_EXPORED
    case REFRESH_TOKEN_INVALID
    case SYSTEM_ERROR
    case ABNORMAL_DATA
    case Predefined(code: String, displayMsg: String, num: Int)
}

extension NetworkErrorCode: NetworAPIkError {
    
    var displayMsg: String {
        switch self {
        case .TOKEN_INVALID:
            return "token不可用"
        case .TOKEN_EXPIRED:
            return "token失效"
        case .SYSTEM_ERROR:
            return "系统错误"
        case .ABNORMAL_DATA:
            return "数据异常"
        case .REFRESH_TOKEN_EXPORED:
            return "刷新token失效"
        case .REFRESH_TOKEN_INVALID:
            return "刷新token不可用"
        case .Predefined(_, let displayMsg, _):
            return displayMsg
        }
    }
     var code: String {
        switch self {
        case .TOKEN_INVALID:
            return "TOKEN_INVALID"
        case .TOKEN_EXPIRED:
            return "TOKEN_EXPIRED"
        case .REFRESH_TOKEN_INVALID:
            return "REFRESH_TOKEN_INVALID"
        case .REFRESH_TOKEN_EXPORED:
            return "REFRESH_TOKEN_EXPORED"
        case .SYSTEM_ERROR:
            return "SYSTEM_ERROR"
        case .ABNORMAL_DATA:
            return "ABNORMAL_DATA"
        case .Predefined(let code, _, _):
            return code
        }
    }
    
    var num: Int {
        switch self {
        case .Predefined(_, _, let num):
            return num
        default:
           return 0
        }
    }
}
