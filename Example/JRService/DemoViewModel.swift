//
//  DemoViewModel.swift
//  JRService_Example
//
//  Created by xj on 2021/12/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import RxSwift
import JRService

protocol DemoViewModelInput {
    func trackRecord()
}

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
