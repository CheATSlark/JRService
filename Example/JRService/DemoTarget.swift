//
//  DemoTarget.swift
//  JRService_Example
//
//  Created by xj on 2021/12/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Moya

enum DemoTarget {
    
    case traceRecord
}

extension DemoTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://adev.voiceseix.com/api/v1")!
    }
    
    var path: String {
        switch self {
        case .traceRecord:
            return "/trace/record/sendTraceRecord"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestParameters(parameters:parameters ?? [:],encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["ver" : "1.0.0", "vcode" : "1", "did" : "712F8721-6006-4F43-9D5D-B6FCB7DD8E78", "dtype": "2", "timestamp" : "20211207135421", "productId" : "1001", "appId" : "100101", "channel" : "ios"]
    }
    
    
}

extension DemoTarget {

    private var parameters: [String: Any]? {
        ["event" : "P00004", "type" : "load"]
    }
}
