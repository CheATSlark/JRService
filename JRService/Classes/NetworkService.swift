//
//  NetworkService.swift
//  JRService
//
//  Created by xj on 2021/12/7.
//

import Moya
import RxSwift
import HandyJSON

public struct NetworkService {
    
    static let provider = MoyaProvider<NetworkTargetType>()
    static let serviceTime = NetworkServiceTime()
    
    public static func rx_request(_ target: NetworkTargetType, _ retry: Int = 0) -> Observable<String> {
        
        var retryNum: Int = retry
        
        return Observable.create { (observer) -> Disposable in
            let cancellableToken = provider.request(target) { (result) in
                
                switch result {
                case .success(let res):
                    guard
                        let data = String(data: res.data, encoding: String.Encoding.utf8),
                        let response = JSONDeserializer<NetworkBaseResponse<AnyObject>>.deserializeFrom(json: data),
                        let code = response.code
                        else {
                            observer.onError(NetworkErrorCode.Predefined(code: "no data", displayMsg: "no data" , num: -1))
                            return;
                    }
                    
                    // 毫秒级别的整型 存储服务器时间
                    serviceTime.persistenceInfo(netTime: response.currTimestamp)
                 
                    // 由token问题导致的失败
                    guard code == "200" else {
                        if code == NetworkErrorCode.TOKEN_INVALID.code {

                            observer.onError(NetworkErrorCode.TOKEN_INVALID)
                        } else if code == NetworkErrorCode.TOKEN_EXPIRED.code {
                            /// 刷新toke
                            if retryNum > 2 {
                                observer.onError(NetworkErrorCode.Predefined(code: "tokenRefresh retry Max", displayMsg: "tokenRefresh retry Max", num: -1))
                            }else{
                                observer.onError(NetworkErrorCode.TOKEN_EXPIRED)
                                retryNum += 1
                            }
                        } else if code == NetworkErrorCode.REFRESH_TOKEN_INVALID.code {
                            
                            observer.onError(NetworkErrorCode.REFRESH_TOKEN_INVALID)
                        } else if code == NetworkErrorCode.REFRESH_TOKEN_EXPORED.code {
                            
                            observer.onError(NetworkErrorCode.REFRESH_TOKEN_EXPORED)
                        } else {
                            let num = response.num
                            let msg = response.displayMsg ?? (response.msg ?? "")
                            observer.onError(NetworkErrorCode.Predefined(code: code, displayMsg: msg, num: num ?? 0))
                        }
                        return;
                    }
                    
                    // 如果后台没有对应的data 默认提供一个空字符串
                    if response.data != nil {
                        observer.onNext(data)
                    } else {
                        observer.onNext("")
                    }
                    
                case .failure(let error):
                
                    observer.onError(NetworkErrorCode.ABNORMAL_DATA)
                }
            }
            
            return Disposables.create {
                cancellableToken.cancel()
            }
        }.retryWhen({ (error) -> Observable<String> in
            // 自动refresh 一次 token
            return  error.flatMap { (ero) -> Observable<String> in
//                if let err = ero as? NetworAPIkError {
//                    if err.displayMsg == NetworkErrorCode.TOKEN_EXPIRED.displayMsg {
//
//                        if let refreshToken = UDConfiguration.refreshToken {
//
//                            return  rx_request(.target(BddNetProvider.refreshToken(refreshToken))).map { (data) -> String in
//                                dPrint("result--->\(data)")
//                                return data
//                            }.do(onNext: { (string) in
//                                let toke =  JSONDeserializer<BaseResponse<TokenResponse>>.deserializeFrom(json: string)
//                                TokenService.setToken(accessToken: toke?.data?.accessToken, refreshToken: toke?.data?.refreshToken)
//                            }) .catchError { (error) -> Observable<String> in
//                                return .just("token refresh failed")
//                            }
//                        }else{
////                            TokenService.deleteAccessToken()
//                            return .just("token invalid")
//                        }
//                    }
//                }
                // 如果不是需要重试的直接透传出error
                return .error(ero)
            }
        }).observeOn(MainScheduler.instance).distinctUntilChanged()
        
    }
    
    
    public static func requestHandle<T>(_ target: NetworkTargetType) -> Observable<(T?, NetworkErrorCode?)> {
        NetworkService.rx_request(target).map { (dataSting) -> NetworkBaseResponse<T> in
            NetworkBaseResponse.deserialize(from: dataSting)!
        }.flatMap { reponse -> Observable<(T?, NetworkErrorCode?)> in
            .just((reponse.data, nil))
        }.catchError { error -> Observable<(T?, NetworkErrorCode?)> in
            .just((nil, error as? NetworkErrorCode))
        }
    }
    
    public typealias CacheTarget = TargetType & Cacheable
    
    public static func requestHandleOnCache<T>(_ target: CacheTarget ) -> Observable<(T?, Bool?, NetworkErrorCode?)> {
        target.onCache().map { (dataStr, isCached) -> (NetworkBaseResponse<T>, Bool) in
            (NetworkBaseResponse.deserialize(from: dataStr)!, isCached)
        }.flatMap { (response, isCahce) -> Observable<(T?, Bool?, NetworkErrorCode?)> in
            .just((response.data, isCahce, nil))
        }.catchError { error in
            .just((nil, false, error as? NetworkErrorCode))
        }
    }
}
