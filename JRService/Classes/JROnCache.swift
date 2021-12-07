//
//  JROnCache.swift
//  23
//
//  Created by 焦瑞洁 on 2020/8/11.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct OnCache<Target: TargetType> where Target: Cacheable  {
    
    let target: Target
    let keyPath: String?
    
    init(target: Target, keyPath: String?) {
        self.target = target
        self.keyPath = keyPath
    }
    
    func request() -> Observable<(String, Bool)> {
        
        return target.request().jStoreCachedResponse(for: target).flatMap { (data) -> Observable<(String, Bool)> in
            .just((data, false))
        }
    }
}

extension TargetType {
    func request() -> Observable<String> {
        NetworkService.rx_request(.target(self))
    }
}
