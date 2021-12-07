//
//  JRStoringKey+TargetType.swift
//  23
//
//  Created by 焦瑞洁 on 2020/8/11.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation
import Moya

extension JRExpirable {
    ///  默认 缓存不会失效
    var expiry: JRExpiry {
        return .never
    }
}

extension JRStoringKey where Self: TargetType {
    var keyString: String {
        return cachedKey + uniqueString
    }
    
    var uniqueString: String {
        return ""
    }
}

private extension TargetType {
    
    var cachedKey: String {
        if let urlRequest = try? endpoint.urlRequest(),
            let data = urlRequest.httpBody,
            let parameters = String(data: data, encoding: .utf8) {
            return "\(method.rawValue):\(endpoint.url)?\(parameters)"
        }
        return "\(method.rawValue):\(endpoint.url)"
    }
    
    var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, self.sampleData) },
                        method: method,
                        task: task,
                        httpHeaderFields: headers)
    }
}
