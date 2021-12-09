# JRService

[![CI Status](https://img.shields.io/travis/xj/JRService.svg?style=flat)](https://travis-ci.org/xj/JRService)
[![Version](https://img.shields.io/cocoapods/v/JRService.svg?style=flat)](https://cocoapods.org/pods/JRService)
[![License](https://img.shields.io/cocoapods/l/JRService.svg?style=flat)](https://cocoapods.org/pods/JRService)
[![Platform](https://img.shields.io/cocoapods/p/JRService.svg?style=flat)](https://cocoapods.org/pods/JRService)

## 介绍

利用 Swift 语法特点，结合 Moy + HandyJSON + RxSwift， 响应式网络框架

## 思路

借鉴 Moya.Target 的设计，仿造 MultiTarget 的方式，使得网络请求脱离单一的枚举，分配到各个模块中去。

缓存是通过Rx的方式，以完整成功请求数据直接存储在本地。 通过对 Moya.Target 的协议扩展，当同时遵守 CacheTarget 的时候，即可完成存储。并在进行网络请求时，优先取缓存数据，再更新数据。

因为 Rx 的机制，提供了两种信号方式：

```swift
// 传输 单一字符串 信号
NetworkService.rx_request(.target(Target.case))

// 传输 （HandyJSON模型， NetworkErrorCode）的信号 
NetworkService.requestHandle(NetworkTargetType.case)

// 另外提供一个 带有缓存功能的 （HandyJSON模型， NetworkErrorCode）的信号  
NetworkService.requestHandleOnCache(NetworkTargetType.case)
```

## 例子

Target 结构体

```swift

// 请求目标结构体
enum DemoTarget {
    
    case traceRecord
}
// 如果需要缓存，则需遵守 Cacheable 协议
extension DemoTarget: TargetType {
    // 通用的网络字符串
    var baseURL: URL {
        return URL(string: "http://adev.voiceseix.com/api/v1")!
    }
    
    // 各事例的路径
    var path: String {
        switch self {
        case .traceRecord:
            return "/trace/record/sendTraceRecord"
        }
    }
    
    // 请求方式
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 序列化方式
    var task: Task {
        return .requestParameters(parameters:parameters ?? [:],encoding: JSONEncoding.default)
    }
    
    // 请求头数据
    var headers: [String : String]? {
        return ["ver" : "1.0.0", "vcode" : "1", "did" : "xxxxxx", "dtype": "2", "timestamp" : "20211207135421", "productId" : "1001", "appId" : "100101", "channel" : "ios"]
    }
    
    
}

// 上传参数处理
extension DemoTarget {

    private var parameters: [String: Any]? {
        ["event" : "P00004", "type" : "load"]
    }
}

```

ViewModel 类

```swift
// 输入协议
protocol DemoViewModelInput {
    func trackRecord()
}

// 输出协议
protocol DemoViewModelOutput {
    var trackRecordResult: Observable<String> { get }
}


protocol DemoViewModelType {
    var inputs: DemoViewModelInput { get }
    var outputs: DemoViewModelOutput { get }
}


class DemoViewModel: DemoViewModelInput, DemoViewModelOutput, DemoViewModelType {
    
    
    init(){
        
        trackRecordResult = trackRecordRelay.flatMap({ _ -> Observable<String> in
            NetworkService.rx_request(.target(DemoTarget.traceRecord))
        })
    }
    
    
    func trackRecord() {
        trackRecordRelay.onNext(Void())
    }
    
    
    var inputs: DemoViewModelInput { return self }
    var outputs: DemoViewModelOutput { return self }
    
    var trackRecordResult: Observable<String>
    
    private let trackRecordRelay = PublishSubject<Void>()
    
}

```

ViewController 里的绑定和相应
```swift

extension ViewController {
    // 绑定模型
    func binding () {
        viewModel.outputs.trackRecordResult.subscribe { result in
            
        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
    
    // 触发事件
    func trackRecord(){
    
        viewModel.inputs.trackRecord()
    }
}

```



## Requirements
Swift 5.0

## Installation

JRService is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JRService'
```

## Author

jerry, jruijqx@163.com

## License

JRService is available under the MIT license. See the LICENSE file for more info.
