//
//  Single+JRCache.swift
//  23
//
//  Created by 焦瑞洁 on 2020/7/22.
//  Copyright © 2020 ddcx. All rights reserved.
//

import RxSwift
import Moya

public typealias CachingKey = JRStoringKey

public typealias Cacheable = JRStorable & JRStoringKey & JRExpirable

extension Observable where Element == String {
    func jStoreCachedResponse<Target>(for target: Target) -> Observable<Element>
        where Target: TargetType, Target: Cacheable {
            return map { (response) -> Element in
                if target.allowsStorage(response) {
                    // 如果允许 读取缓存
                    try? target.cachedResponse(response)
                }
                return response
            }
    }
}

extension TargetType where Self: Cacheable {
    func onCache(atKeyPath keyPath: String? = nil) -> Observable<(String, Bool)> {
        var observer1 = Observable<(String, Bool)>.empty()
        if let object = try? cachedResponse() {
            observer1 =  Observable<(String, Bool)>.just((object, true))
            /// 不需要立即刷新的，则直接返回缓存
            if updateImmediate == false  {
                return observer1
            }
        }
        let observer2 = OnCache(target: self, keyPath: keyPath).request()
        return Observable.of(observer1, observer2).merge()
        
//        let observer1 = PublishSubject<String>()
//        if let object = try? cachedResponse(){
//            observer1.onNext(object)
//        }
//        
//        let observer2 = OnCache(target: self, keyPath: keyPath).request()
//        return Observable.of(observer1, observer2).merge()
    }
}


extension TargetType where Self: Cacheable {
    
    var cache: Observable<Self>{
        return Observable.just(self)
    }
    
    func cachedResponse() throws -> String {
        let expiry = try self.expiry(for: self)
        
        guard expiry.isExpired else {
            // 如果没有明确失效时间，则每次都会尝试从缓存中读取
            let response = try cachedResponse(for: self)
            return response
//            return Response(statusCode: response.statusCode, data: response.data)
        }
        throw JRExpiry.Error.expired(expiry.date)
    }
    
    func cachedResponse(_ cachedResponse: String) throws {
        try storeCachedResponse(cachedResponse, for: self)
        // 更新本地存储时间
        update(expiry: expiry, for: self)
    }
    
    func removeCacheResponse() throws {
        try removeCachedResponse(for: self)
        
        removeExpiry(for: self)
    }
    
}

